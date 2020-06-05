using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace TweetBook.Contracts.V1.Requests
{
    public class UpdatePostRequest
    {        
        [Required]
        public string PostTitle { get; set; }
        [Required]
        public string PostContent { get; set; }
    }
}
