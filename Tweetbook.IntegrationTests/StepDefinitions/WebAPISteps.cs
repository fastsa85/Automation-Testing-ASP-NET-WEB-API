using BoDi;
using FluentAssertions;
using KellermanSoftware.CompareNetObjects;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using TechTalk.SpecFlow;
using FluentAssertions.Json;
using Google.Protobuf.WellKnownTypes;
using TechTalk.SpecFlow.Assist;
using TweetBook.Domain;
using System.Collections;
using Microsoft.AspNetCore.Server.Kestrel.Transport.Abstractions.Internal;
using Gherkin.Stream;
using TweetBook.Tests.CommonClasses.Extensions;

namespace Tweetbook.IntegrationTests.StepDefinitions
{
    [Binding]
    public class WebAPISteps
    {
        private readonly TestScope _testScope;
        private readonly IObjectContainer _objectContainer;

        public WebAPISteps(TestScope testScope, IObjectContainer objectContainer)
        {
            _testScope = testScope;
            _objectContainer = objectContainer;
        }        

        [When(@"Execute ""(.*)"" requst to ""(.*)""")]
        public async Task ExecuteRequstTo(string method, string endpoint, string jsonBody)
        {
            var request = new HttpRequestMessage();
            request.Method = new HttpMethod(method);
            request.RequestUri = new Uri(_testScope.HttpClient.BaseAddress + endpoint);
            if (!string.IsNullOrEmpty(jsonBody))
                request.Content = new StringContent(jsonBody, Encoding.UTF8, "application/json");

            var response = await (_testScope.HttpClient.SendAsync(request));

            _objectContainer.RegisterInstanceAs<HttpResponseMessage>(response, method + endpoint);
        }

        [Then(@"Assert Status Code of Response from ""(.*)"" ""(.*)"" is ""(.*)""")]
        public void AssertStatusCodeOfResponseIs(string method, string endpoint, string expectedstatusCode)
        {
            var actualResponse = _objectContainer.Resolve<HttpResponseMessage>(method + endpoint);

            actualResponse.StatusCode.Should().Be(System.Enum.Parse(typeof(HttpStatusCode), expectedstatusCode));
        }

        [Then(@"Assert Body of Response from ""(.*)"" ""(.*)"" contains property ""(.*)"" as valid GUID")]
        public async Task AssertBodyOfResponseFromContainsPropertyAsValidGUID(string method, string endpoint, string propertyName)
        {
            string GUID_PATTERN = @"[({]?[a-fA-F0-9]{8}[-]?([a-fA-F0-9]{4}[-]?){3}[a-fA-F0-9]{12}[})]?";

            var actualResponse = _objectContainer.Resolve<HttpResponseMessage>(method + endpoint);
            var actualData = await (actualResponse.Content.GetContentAsAsync<Dictionary<string, dynamic>>());
            var actualValue = (string)actualData[propertyName];

            actualValue.Should().NotBeNullOrEmpty();
            actualValue.Should().MatchRegex(GUID_PATTERN);
        }


        [Then(@"Assert Body of Response from ""(.*)"" ""(.*)"" contains object")]
        public async Task AssertBodyOfResponseFromContainsObject(string method, string endpoint, string expectedJson)
        {
            var actualResponse = _objectContainer.Resolve<HttpResponseMessage>(method + endpoint);
            var actualData = JToken.Parse(await actualResponse.Content.ReadAsStringAsync());
            
            var expectedData = JToken.Parse(expectedJson);

            actualData.Should().BeEquivalentTo(expectedData);  
        }

        [Then(@"Assert Body of Response from ""(.*)"" ""(.*)"" is empty")]
        public async Task AssertBodyOfResponseFromIsEmpty(string method, string endpoint)
        {
            var actualResponse = _objectContainer.Resolve<HttpResponseMessage>(method + endpoint);
            var actualJson = await actualResponse.Content.ReadAsStringAsync();

            actualJson.Should().BeNullOrEmpty();
        }

        [Then(@"Assert Body of Response from ""(.*)"" ""(.*)"" contains object, ignoring properties ""(.*)""")]
        public async Task AssertBodyOfResponseFromContains(string method, string endpoint, string propertiesToIgnore, string expectedJson)
        {
            var SPLIT_CHAR = ',';

            var actualResponse = _objectContainer.Resolve<HttpResponseMessage>(method + endpoint);            
            var actualData = await (actualResponse.Content.GetContentAsAsync<Dictionary<string, dynamic>>());

            var expectedData = JsonConvert.DeserializeObject<Dictionary<string, dynamic>>(expectedJson);

            foreach(var propertyToIgnore in propertiesToIgnore.Split(SPLIT_CHAR))
            {
                actualData.Remove(propertyToIgnore);
                expectedData.Remove(propertyToIgnore);
            }

            expectedData.Should().BeEquivalentTo(actualData);
        }        
    }
}
