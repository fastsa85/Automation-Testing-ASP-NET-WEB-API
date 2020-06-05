using Dynamitey.DynamicObjects;
using FluentAssertions;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;
using TweetBook.Domain;
using System.Linq.Dynamic.Core;
using Tweetbook.Tests.CommonClasses.Extensions;

namespace Tweetbook.IntegrationTests.StepDefinitions
{
    [Binding]
    public class DatabaseSteps
    {
        private readonly TestScope _testScope;

        public DatabaseSteps(TestScope testScope)
        {
            _testScope = testScope;
        }

        [Given(@"""(.*)"" records exist in database")]
        public async Task GivenRecordsExistInDatabase(string recordType, Table recordsTable)
        {
            var type = recordType.ConvertToType();

            await _testScope.DataContext.InsertInstanceSet(recordsTable.ConvertToDynamicDictionaryList(type), type);
        }

        [Then(@"Assert ""(.*)"" records exist in database")]
        public void ThenAssertRecordsExistInDatabase(string recordType, Table expectedRecordsTable)
        {
            var type = recordType.ConvertToType();

            var actualRecordsList = new List<dynamic>();
            foreach (var expectedRecordProperties in expectedRecordsTable.ConvertToDynamicDictionaryList(type))
            {
                var actualRecord = _testScope.DataContext.FindByProperties(expectedRecordProperties, type);
                actualRecord.Should().NotBeEmpty($"Because {recordType} record {expectedRecordProperties} was not found.");
                actualRecordsList.AddRange(actualRecord);
            }

            actualRecordsList.Count.Should().Be(expectedRecordsTable.Rows.Count, 
                $"Because expected {recordType} records {expectedRecordsTable} does not match with actual records {actualRecordsList}");
        }

        [Then(@"Assert ""(.*)"" records do not exist in database")]
        public void ThenAssertRecordsDoNotExistInDatabase(string recordType, Table recordsTable)
        {
            var type = recordType.ConvertToType();
            foreach (var expectedRecordProperties in recordsTable.ConvertToDynamicDictionaryList(type))
            {
                var actualRecord = _testScope.DataContext.FindByProperties(expectedRecordProperties, type);
                actualRecord.Should().BeEmpty($"Because unexpected {recordType} record {expectedRecordProperties} was found.");                
            }
        }

        [Then(@"Reload from database all ""(.*)"" records by properties")]
        public async Task ThenReloadFromDatabaseAllRecordsByProperties(string recordType, Table recordsTable)
        {
            var type = recordType.ConvertToType();

            foreach (var expectedRecordProperties in recordsTable.ConvertToDynamicDictionaryList(type))
            {
                var actualRecords = _testScope.DataContext.FindByProperties(expectedRecordProperties, type);

                foreach (var record in actualRecords)
                {
                    await _testScope.DataContext.Entry(record).ReloadAsync();
                }
            }
        }
    }
}
