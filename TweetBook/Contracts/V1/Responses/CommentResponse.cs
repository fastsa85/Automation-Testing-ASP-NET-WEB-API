using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace TweetBook.Contracts.V1.Responses
{
    public class CommentResponse
    {
        public Guid Id { get; set; }
        public Guid PostId { get; set; }
        public string UserId;
        public string CommentContent { get; set; }
    }
}
