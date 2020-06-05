using BoDi;
using FluentAssertions;
using KellermanSoftware.CompareNetObjects;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;
using Tweetbook.Tests.CommonClasses.Extensions;
using Tweetbook.Tests.CommonClasses;

namespace Tweetbook.IntegrationTests.StepDefinitions
{
    [Binding]
    public class UserActionsSteps
    {
        private readonly TestScope _testScope;
        private readonly IObjectContainer _objectContainer;

        public UserActionsSteps(TestScope testScope, IObjectContainer objectContainer)
        {
            _testScope = testScope;
            _objectContainer = objectContainer;
        }

        [Then(@"Assert get all ""(.*)"" returns list of objects")]        
        public async Task GetAllContainsListOfObjects(string expectedType, Table expectedTable)
        {
            var objectType = expectedType.ConvertToType();
            var objectListType = typeof(List<>).MakeGenericType(objectType);

            var expectedData = expectedTable.CreateSet(objectType);

            var endpoint = Constants.TweetbookEndpoints[expectedType.ToLower()];
            var request = new HttpRequestMessage();
            request.Method = HttpMethod.Get;
            request.RequestUri = new Uri(_testScope.HttpClient.BaseAddress + endpoint);
            var response = await (_testScope.HttpClient.SendAsync(request));
            var actualData = await (response.Content.ReadAsAsync(objectListType));

            CompareLogic compareLogic = new CompareLogic();

            var propertiesToIgnore = new List<string>();
            foreach (var property in objectType.GetProperties())
            {
                var propertyName = property.Name;
                if (!expectedTable.Header.Contains(propertyName))
                    propertiesToIgnore.Add(propertyName);
            }

            compareLogic.Config.MembersToIgnore.AddRange(propertiesToIgnore);
            compareLogic.Config.IgnoreCollectionOrder = true;
            ComparisonResult result = compareLogic.Compare(expectedData, actualData);

            result.AreEqual.Should().Be(true, result.DifferencesString);
        }

        [When(@"Create new ""(.*)"" object")]
        public async Task WhenPostToEndpointNewObject(string createdType, Table objectTable)
        {
            var objectType = createdType.ConvertToType();
            var endpoint = Constants.TweetbookEndpoints[createdType.ToLower()];

            var objectToCreate = objectTable.CreateInstance(objectType);

            var request = new HttpRequestMessage();
            request.Method = HttpMethod.Post;
            request.Content = new StringContent(JsonConvert.SerializeObject(objectToCreate), Encoding.UTF8, "application/json");
            request.RequestUri = new Uri(_testScope.HttpClient.BaseAddress + endpoint);

            var response = await (_testScope.HttpClient.SendAsync(request));
        }

        [When(@"Update ""(.*)"" object where ""(.*)"" is ""(.*)""")]
        public async Task WhenUpdateWhereIs(string objectType, string propertyName, string propertValue, Table objectTable)
        {
            var type = objectType.ConvertToType();
            var objectUpdates = objectTable.CreateInstance(type);
            
            var propertiesDictionary = new Dictionary<string, dynamic>();
            propertiesDictionary.Add(propertyName, propertValue);

            RefreshDataContext(type);
            var existedRecord = _testScope.DataContext.FindByProperties(propertiesDictionary, type)[0];
            var objectId = existedRecord.GetType().GetProperty("Id").GetValue(existedRecord, null);
            var endpoint = Constants.TweetbookEndpoints[objectType.ToLower()] + "/" + objectId;

            var request = new HttpRequestMessage();
            request.Method = HttpMethod.Put;
            request.Content = new StringContent(JsonConvert.SerializeObject(objectUpdates), Encoding.UTF8, "application/json");
            request.RequestUri = new Uri(_testScope.HttpClient.BaseAddress + endpoint);

            await(_testScope.HttpClient.SendAsync(request));
        }

        [When(@"Delete ""(.*)"" object where ""(.*)"" is ""(.*)""")]
        public async Task WhenDeleteObjectWhereIs(string objectType, string propertyName, string propertyValue)
        {
            var type = objectType.ConvertToType();

            var propertiesDictionary = new Dictionary<string, dynamic>();
            propertiesDictionary.Add(propertyName, propertyValue);

            RefreshDataContext(type);
            var existedRecord = _testScope.DataContext.FindByProperties(propertiesDictionary, type)[0];            
            var objectId = existedRecord.GetType().GetProperty("Id").GetValue(existedRecord, null);            
            var endpoint = Constants.TweetbookEndpoints[objectType.ToLower()] + "/" + objectId;

            var request = new HttpRequestMessage();
            request.Method = HttpMethod.Delete;            
            request.RequestUri = new Uri(_testScope.HttpClient.BaseAddress + endpoint);

            await(_testScope.HttpClient.SendAsync(request));
        }

        void RefreshDataContext(Type type)
        {
            foreach (var record in _testScope.DataContext.GetDbSet(type))
            {
                _testScope.DataContext.Entry(record).Reload();
            }
        }

        async Task<string> GetIdByProperty(string propertyName, string propertyValue, string objectType)
        {
            var type = objectType.ConvertToType();
            var objectListType = typeof(List<>).MakeGenericType(type);

            var request = new HttpRequestMessage();
            request.Method = HttpMethod.Get;
            request.RequestUri = new Uri(_testScope.HttpClient.BaseAddress + Constants.TweetbookEndpoints[objectType.ToLower()]);

            var response = await _testScope.HttpClient.SendAsync(request);
            var actualData = await response.Content.ReadAsAsync(objectListType);

            return "";
        }


        
    }
}
