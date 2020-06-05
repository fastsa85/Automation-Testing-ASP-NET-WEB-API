using BoDi;
using Microsoft.Extensions.Configuration;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Text;
using TechTalk.SpecFlow;

namespace Tweetbook.E2E_Tests.StepDefinitions
{
    [Binding]
    public class Hooks
    {
        private readonly IObjectContainer _objectContainer;
        private static IConfiguration _configuration;

        public Hooks(IObjectContainer objectContainer) 
        {
            _objectContainer = objectContainer;
        }

        [BeforeTestRun]
        public static void BeforeTestRunSetup()
        {
            InitializeConfiguration();
        }

        [BeforeScenario]
        public void BeforeScenarioSetup()
        {
            InitializeWebApiClient();
            //InitializeSqlconnection();
        }

        private static void InitializeConfiguration()
        {
            _configuration = new ConfigurationBuilder()
                .AddJsonFile("appsettings.json")
                .Build();
        }

        private void InitializeWebApiClient()
        {
            var webApiClient = new WebApiFactory().CreateWebApiClient(_configuration.GetSection("WebApiClientSettings"));
            _objectContainer.RegisterInstanceAs<RestClient>(webApiClient);
        }
    }
}
