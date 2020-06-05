using RestSharp;
using System;
using System.Collections.Generic;
using System.Text;
using TechTalk.SpecFlow;
using TweetBook.Tests.CommonClasses.Extensions;
using TweetBook.Tests.CommonClasses;
using TechTalk.SpecFlow.Assist;
using FluentAssertions;
using Tweetbook.Tests.CommonClasses.Extensions;
using Tweetbook.Tests.CommonClasses;

namespace Tweetbook.E2E_Tests.StepDefinitions
{
    [Binding]
    public class UserActionsSteps
    {
        private readonly RestClient _restClient;
        public UserActionsSteps(RestClient restClient)
        {
            _restClient = restClient;
        }

        [When(@"Create new ""(.*)"" object")]
        public void WhenCreateNewObject(string createdType, Table objectTable)
        {
            var objectType = createdType.ConvertToType();
            var endpoint = Constants.TweetbookEndpoints[createdType.ToLower()];

            var objectToCreate = objectTable.CreateDynamicInstance();

            var request = new RestRequest(endpoint, Method.POST);
            request.AddJsonBody(objectToCreate);

            var response = _restClient.Execute(request);

            response.StatusCode.Should().Be("Created");

        }

    }
}
