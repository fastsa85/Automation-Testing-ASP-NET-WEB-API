using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using TweetBook.Contracts;
using TweetBook.Data;
using TweetBook.Domain;
using TweetBook.Options;

namespace TweetBook.Repositories
{
    public class IdentityRepository : IIdentityRepository
    {
        private readonly UserManager<IdentityUser> _userManager;
        private readonly JwtSettings _jwtSettings;
        private readonly TokenValidationParameters _validationParameters;
        private readonly AppDbContext _appDbContext;

        public IdentityRepository(UserManager<IdentityUser> userManager, 
            JwtSettings jwtSettings, 
            TokenValidationParameters validationParameters,
            AppDbContext appDbContext)
        {
            _userManager = userManager;
            _jwtSettings = jwtSettings;
            _validationParameters = validationParameters;
            _appDbContext = appDbContext;
        }

        public async Task<AuthenticationResult> LoginAsync(string email, string password)
        {
            var user = await _userManager.FindByEmailAsync(email);

            if (user == null)
                return new AuthenticationResult
                {
                    Errors = new[] { $"User login failed" }
                };

            var isPasswordValid = await _userManager.CheckPasswordAsync(user, password);

            if (!isPasswordValid)
                return new AuthenticationResult
                {
                    Errors = new[] { $"User login failed" }
                };

            return await GenerateAuthenticationResult(user);            
        }

        public async Task<AuthenticationResult> RefreshTokenAsync(string token, string refreshToken)
        {
            var validatedToken = GetPrincipalFromToken(token);

            if (validatedToken == null)
                return new AuthenticationResult { Errors = new[] { "Invalid Token" }};

            var expiryDateUnix = long.Parse(validatedToken.Claims.Single(x => x.Type == JwtRegisteredClaimNames.Exp).Value);
            var expiryDateTimeUtc = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc).AddSeconds(expiryDateUnix);
                

            if (expiryDateTimeUtc > DateTime.UtcNow)
            {
                return new AuthenticationResult { Errors = new[] { "Token has not expired yet" } };
            }

            var jti = validatedToken.Claims.Single(x => x.Type == JwtRegisteredClaimNames.Jti).Value;

            var storedRefreshToken = await _appDbContext.RefreshTokens.SingleOrDefaultAsync(x => x.Token == refreshToken);

            if (storedRefreshToken == null)
                return new AuthenticationResult { Errors = new[] { "Refresh token does not exists" } };

            if (DateTime.UtcNow > storedRefreshToken.ExpiryDate)
                return new AuthenticationResult { Errors = new[] { "Refresh token expired" } };

            if (storedRefreshToken.Invalidated)
                return new AuthenticationResult { Errors = new[] { "Refresh token has been invalidated" } };

            if (storedRefreshToken.IsUsed)
                return new AuthenticationResult { Errors = new[] { "Refresh token has been used" } };

            if (storedRefreshToken.JwtId != jti)
                return new AuthenticationResult { Errors = new[] { "Refresh token does not match this JWT" } };

            storedRefreshToken.IsUsed = true;
            _appDbContext.RefreshTokens.Update(storedRefreshToken);
            await _appDbContext.SaveChangesAsync();

            var user = await _userManager.FindByIdAsync(validatedToken.Claims.Single(x => x.Type == "id").Value);

            return await GenerateAuthenticationResult(user);
        }        

        public async Task<AuthenticationResult> RegisterAsync(string email, string password)
        {
            var existingUser = await _userManager.FindByEmailAsync(email);

            if (existingUser != null)
                return new AuthenticationResult
                {
                    Errors = new[] { $"User with email {email} already exists" }
                };

            var newUser = new IdentityUser
            {
                Email = email,
                UserName = email               
            };

            var createdUser = await _userManager.CreateAsync(newUser, password);

            if (!createdUser.Succeeded)
                return new AuthenticationResult
                {
                    Success = false,
                    Errors = createdUser.Errors.Select(x => x.Description)
                };

            return await GenerateAuthenticationResult(newUser);
        }

        private ClaimsPrincipal GetPrincipalFromToken(string token)
        {
            var tokenHandler = new JwtSecurityTokenHandler();

            try
            {
                var principal = tokenHandler.ValidateToken(token, _validationParameters, out var validatedToken);
                if (!IsJwtWithValidSecureAlgorithms(validatedToken))
                    return null;
                return principal;
            }
            catch (Exception)
            {
                return null;
            }
        }

        private bool IsJwtWithValidSecureAlgorithms(SecurityToken securityToken)
        {
            return (securityToken is JwtSecurityToken jwtSecurityToken) &&
                jwtSecurityToken.Header.Alg.Equals(SecurityAlgorithms.HmacSha256, StringComparison.InvariantCultureIgnoreCase);
        }

        private async Task<AuthenticationResult> GenerateAuthenticationResult(IdentityUser user)
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes(_jwtSettings.Secret);
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new[]
                {
                    new Claim(JwtRegisteredClaimNames.Sub, user.Email),
                    new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                    new Claim(JwtRegisteredClaimNames.Email, user.Email),
                    new Claim("id", user.Id),
                }),
                Expires = DateTime.UtcNow.Add(_jwtSettings.TokenLifeTime),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
            };

            var token = tokenHandler.CreateToken(tokenDescriptor);

            var refreshToken = new RefreshToken
            {
                JwtId = token.Id,
                UserId = user.Id,
                CreationDate = DateTime.UtcNow,
                ExpiryDate = DateTime.UtcNow.AddMonths(_jwtSettings.RefreshTokenLifeTimeInMonths)
            };

            await _appDbContext.RefreshTokens.AddAsync(refreshToken);
            await _appDbContext.SaveChangesAsync();

            return new AuthenticationResult
            {
                Token = tokenHandler.WriteToken(token),
                RefreshToken = refreshToken.Token,
                Success = true
            };            
        }
    }
}
