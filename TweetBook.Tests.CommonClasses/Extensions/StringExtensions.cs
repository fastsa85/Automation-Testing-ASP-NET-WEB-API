using System;
using System.Linq;


namespace Tweetbook.Tests.CommonClasses.Extensions
{
    public static class StringExtensions
    {
        public static Type ConvertToType(this string thisString)
        {
            return AppDomain.CurrentDomain.GetAssemblies().SelectMany(x => x.GetTypes()).First(x => x.Name == thisString);
        }
    }
}
