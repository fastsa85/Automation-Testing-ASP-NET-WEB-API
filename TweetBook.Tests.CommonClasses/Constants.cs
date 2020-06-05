using System;
using System.Collections.Generic;
using System.Text;

namespace Tweetbook.Tests.CommonClasses
{
    public class Constants
    {
        public static Dictionary<string, string> TweetbookEndpoints = new Dictionary<string, string>()
        {
            { "post",       "api/v1/posts" },
            { "comment",    "api/v1/comments" }
        };
    }
}
