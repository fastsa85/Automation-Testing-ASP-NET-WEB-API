using Newtonsoft.Json;
using RestSharp;
using System;
using System.Threading.Tasks;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;
using TweetBook.Contracts;

namespace Tweetbook.E2E_Tests.StepDefinitions
{
    [Binding]
    public class IdentitySteps
    {
        private readonly RestClient _restClient;
        public IdentitySteps(RestClient restClient)
        {
            _restClient = restClient;
        }

        [Given(@"Register user")]
        public async Task GivenRegisterUser(Table table)
        {
            var request = new RestRequest(ApiRoutes.Identity.Register, Method.POST);
            var body = table.CreateDynamicInstance();
            request.AddJsonBody(body);
            var response = await _restClient.ExecuteAsync(request);
        }

        [Given(@"Login as")]
        public async Task GivenLoginAs(Table table)
        {
            var request = new RestRequest(ApiRoutes.Identity.Login, Method.POST);
            var body = table.CreateDynamicInstance();
            request.AddJsonBody(body);
            var response = await _restClient.ExecuteAsync(request);

            var token = JsonConvert.DeserializeObject<dynamic>(response.Content).token;
            _restClient.AddDefaultHeader("Authorization", $"bearer {token}");
        }

    }
}
