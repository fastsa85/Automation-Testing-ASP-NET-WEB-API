using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace TweetBook.Contracts.V1.Responses
{
    public class PostResponse
    {
        public Guid Id { get; set; }
        public string PostTitle { get; set; }
        public string PostContent { get; set; }
        public string UserId { get; set; }
    }
}
