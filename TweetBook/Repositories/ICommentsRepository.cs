using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TweetBook.Domain;

namespace TweetBook.Repositories
{
    public interface ICommentsRepository
    {
        Task<List<Comment>> GetCommentsAsync();
        Task<bool> CreateCommentAsync(Comment comment);
        Task<Comment> GetCommentByIdAsync(Guid commentId);
        Task<bool> IsUserOwnerOfCommentAsync(Guid commentId, string userId);
        Task<bool> UpdateCommentAsync(Comment commentToUpdate);
        Task<bool> DeletePostAsync(Guid commentId);
    }
}
