using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace TweetBook.Contracts.V1.Requests
{
    public class UpdateCommentRequest
    {
        [Required]
        public string CommentContent { get; set; }
    }
}
