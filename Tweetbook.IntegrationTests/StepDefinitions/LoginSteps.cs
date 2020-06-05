using System;
using System.Threading.Tasks;
using TechTalk.SpecFlow;
using SpecFlow.Assist.Dynamic;
using TechTalk.SpecFlow.Assist;
using System.Linq;

namespace Tweetbook.IntegrationTests.StepDefinitions
{
    [Binding]
    public class CommentsSteps
    {
        private readonly TestScope _testScope;

        public CommentsSteps(TestScope testScope)
        {
            _testScope = testScope;
        }

        [Given(@"Register User")]
        public async Task UserIsRegistered(Table table)
        {
            dynamic user = table.CreateDynamicInstance();
            await _testScope.RegisterAsync(user.Email, user.Password);
        }

        [Given(@"Register Users")]
        public async Task RegisterUsers(Table table)
        {
            dynamic users = table.CreateDynamicSet();

            foreach (var user in users)
            {
                await _testScope.RegisterAsync(user.Email, user.Password);
            }
        }

        [When(@"Login as")]
        public async Task LoginAs(Table table)
        {
            dynamic user = table.CreateDynamicInstance();
            await _testScope.LoginAsync(user.Email, user.Password);            
        }
    }
}
