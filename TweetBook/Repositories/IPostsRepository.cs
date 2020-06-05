using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TweetBook.Domain;

namespace TweetBook.Repositories
{
    public interface IPostsRepository
    {
        Task<List<Post>> GetPostsAsync();

        Task<Post> GetPostByIdAsync(Guid postId);

        Task<bool> CreatePostAsync(Post post);

        Task<bool> UpdatePostAsync(Post postToUpdate);

        Task<bool> DeletePostAsync(Guid postId);

        Task<bool> IsUserOwnerOfPostAsync(Guid postId, string userId);
    }
}
