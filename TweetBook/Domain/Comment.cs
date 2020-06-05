using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Runtime.Serialization;
using System.Threading.Tasks;

namespace TweetBook.Domain
{
    public class Comment
    {
        [Key]
        public Guid Id { get; set; }

        public string CommentContent { get; set; }

        public Guid PostId { get; set; }
        [ForeignKey(nameof(PostId))]
        [IgnoreDataMember]
        public Post Post { get; set; }

        public string UserId { get; set; }
        [ForeignKey(nameof(UserId))]
        [IgnoreDataMember]
        public IdentityUser User { get; set; }
    }
}
