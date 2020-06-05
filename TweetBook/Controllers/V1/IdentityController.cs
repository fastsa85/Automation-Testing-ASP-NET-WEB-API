using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TweetBook.Contracts;
using TweetBook.Contracts.V1.Requests;
using TweetBook.Contracts.V1.Responses;
using TweetBook.Repositories;

namespace TweetBook.Controllers.V1
{
    public class IdentityController : Controller
    {
        private readonly IIdentityRepository _identityRepository;

        public IdentityController(IIdentityRepository identityRepository)
        {
            _identityRepository = identityRepository;
        }

        [HttpPost(ApiRoutes.Identity.Register)]
        public async Task<IActionResult> Register([FromBody] UserRegistrationRequest request)
        {
            var authResponse = await _identityRepository.RegisterAsync(request.Email, request.Password);

            if (!authResponse.Success)
                return BadRequest(new AuthFailResponse
                {
                    Errors = authResponse.Errors
                });

            return Ok(new AuthSuccessResponse 
            { 
                Token = authResponse.Token,
                RefreshToken = authResponse.RefreshToken
            });
        }

        [HttpPost(ApiRoutes.Identity.Login)]
        public async Task<IActionResult> Login([FromBody] UserLoginRequest request)
        {
            var authResponse = await _identityRepository.LoginAsync(request.Email, request.Password);

            if (!authResponse.Success)
                return BadRequest(new AuthFailResponse
                {
                    Errors = authResponse.Errors
                });

            return Ok(new AuthSuccessResponse
            {
                Token = authResponse.Token,
                RefreshToken = authResponse.RefreshToken
            });
        }

        [HttpPost(ApiRoutes.Identity.Refresh)]
        public async Task<IActionResult> Refresh([FromBody] TokenRefreshRequest request)
        {
            var authResponse = await _identityRepository.RefreshTokenAsync(request.Token, request.RefreshToken);

            if (!authResponse.Success)
                return BadRequest(new AuthFailResponse
                {
                    Errors = authResponse.Errors
                });

            return Ok(new AuthSuccessResponse
            {
                Token = authResponse.Token,
                RefreshToken = authResponse.RefreshToken
            });
        }
    }
}
