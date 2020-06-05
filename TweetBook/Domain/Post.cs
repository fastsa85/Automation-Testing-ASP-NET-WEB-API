using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Runtime.Serialization;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace TweetBook.Domain
{
    public class Post
    {
        [Key]        
        public Guid Id { get; set; }
        
        public string PostTitle { get; set; }
        
        public string PostContent { get; set; }

        public string UserId { get; set; }
        [ForeignKey(nameof(UserId))]
        [IgnoreDataMember]
        public IdentityUser User { get; set; }
    }
}
