using FluentAssertions;
using KellermanSoftware.CompareNetObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;

namespace Tweetbook.Tests.CommonClasses.Extensions
{
    public static class SpecFlowTableExtensions
    {
        public static List<Dictionary<string, dynamic>> ConvertToDynamicDictionaryList(this Table table, Type type)
        {
            var lstDict = new List<Dictionary<string, dynamic>>();

            if (table != null)
            {
                var headers = table.Header;

                foreach (var row in table.Rows)
                {
                    var dict = new Dictionary<string, dynamic>();
                    foreach (var header in headers)
                    {
                        var propertyType = type.GetTypeInfo().GetProperty(header, BindingFlags.IgnoreCase | BindingFlags.Public | BindingFlags.Instance).PropertyType;

                        switch (propertyType.Name)
                        {
                            case nameof(Guid): 
                                dict.Add(header, Convert.ChangeType(new Guid(row[header]), propertyType)); 
                                break;
                            default: 
                                dict.Add(header, Convert.ChangeType(row[header], propertyType)); 
                                break;
                        }
                    }

                    lstDict.Add(dict);
                }
            }

            return lstDict;
        }

        public static void CompareToInstance(this Table table, Object instance, Type type)
        {
            MethodInfo method = typeof(InstanceComparisonExtensionMethods).GetMethod("CompareToInstance");
            MethodInfo genericMethod = method.MakeGenericMethod(type);
            genericMethod.Invoke(table, new object[] { table, instance });
        }

        public static void CompareToSet(this Table table, Object instance, Type type)
        {
            var listType = typeof(List<>);
            var targetType = listType.MakeGenericType(type);
            MethodInfo method = typeof(SetComparisonExtensionMethods).GetMethod("CompareToSet");
            MethodInfo genericMethod = method.MakeGenericMethod(targetType);
            genericMethod.Invoke(table, new object[] { table, instance, false });
        }

        public static void CompareToDynamicList(this Table table, List<Dictionary<string, dynamic>> dynamicList, Type type)
        {
            var expected = table.ConvertToDynamicDictionaryList(type);

            CompareLogic compareLogic = new CompareLogic();

            compareLogic.Config.MembersToInclude.AddRange(table.Header.ToList());
            compareLogic.Config.MembersToIgnore.AddRange(new List<string> { "Count" });
            compareLogic.Config.IgnoreCollectionOrder = true;
            ComparisonResult result = compareLogic.Compare(expected, dynamicList);

            result.Should().Be(true, result.DifferencesString);

        }

        public static object CreateInstance(this Table table, Type type)
        {
            MethodInfo method = typeof(TableHelperExtensionMethods).GetMethod("CreateInstance", new Type[] { typeof(Table) });
            MethodInfo genericMethod = method.MakeGenericMethod(type);

            return genericMethod.Invoke(table, new object[] { table });
        }


        public static object CreateSet(this Table table, Type type)
        {
            MethodInfo method = typeof(TableHelperExtensionMethods).GetMethod("CreateSet", new Type[] { typeof(Table) });
            MethodInfo genericMethod = method.MakeGenericMethod(type);

            return genericMethod.Invoke(table, new object[] { table });
        }
    }
}
