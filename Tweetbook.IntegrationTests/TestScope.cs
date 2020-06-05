using System;
using System.Net.Http;
using System.Threading.Tasks;
using System.Net.Http.Headers;
using TweetBook.Contracts;
using TweetBook.Contracts.V1.Requests;
using TweetBook.Contracts.V1.Responses;
using TweetBook;
using Microsoft.AspNetCore.Mvc.Testing;
using TweetBook.Data;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using NUnit.Framework;

namespace Tweetbook.IntegrationTests
{
    public class TestScope : IDisposable
    {
        public HttpClient HttpClient;        
        public AppDbContext DataContext;

        private IServiceScope ServiceScope;

        public TestScope()
        {
            var appFactory = new WebApplicationFactory<Startup>()
            .WithWebHostBuilder(builder =>
            {
                builder.ConfigureServices(services =>
                {
                    var serviceDescriptor = services.FirstOrDefault(descriptor => descriptor.ServiceType == typeof(AppDbContext));
                    services.Remove(serviceDescriptor);                    

                    services.AddDbContext<AppDbContext>(options =>
                    {
                        options.UseInMemoryDatabase("InMemoryDb_" + TestContext.CurrentContext.Test.ClassName);
                    });
                });
            });

            HttpClient = appFactory.CreateClient();
            ServiceScope = appFactory.Server.Host.Services.CreateScope();
            DataContext = ServiceScope.ServiceProvider.GetRequiredService<AppDbContext>();
        }

        public void Dispose()
        {
            HttpClient.Dispose();
            ServiceScope.Dispose();
            DataContext.Dispose();
        }

        public async Task AuthenticateAsync(string email, string password)
        {
            HttpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", await GetJwtAsync(email, password));
        }

        public async Task RegisterAsync(string email, string password)
        {
            var response = await HttpClient.PostAsJsonAsync(ApiRoutes.Identity.Register, new UserRegistrationRequest
            {
                Email = email,
                Password = password
            });
        }

        public async Task LoginAsync(string email, string password)
        {
            var response = await HttpClient.PostAsJsonAsync(ApiRoutes.Identity.Login, new UserLoginRequest
            {
                Email = email,
                Password = password
            });

            var loginResponse = await response.Content.ReadAsAsync<AuthSuccessResponse>();

            HttpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", loginResponse.Token);
        }

        private async Task<string> GetJwtAsync(string email, string password)
        {
            var response = await HttpClient.PostAsJsonAsync(ApiRoutes.Identity.Register, new UserRegistrationRequest
            {
                Email = email,
                Password = password
            });

            var registrationResponse = await response.Content.ReadAsAsync<AuthSuccessResponse>();
            return registrationResponse.Token;
        }
    }
}

