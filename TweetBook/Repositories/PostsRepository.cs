using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TweetBook.Data;
using TweetBook.Domain;

namespace TweetBook.Repositories
{
    public class PostsRepository : IPostsRepository
    {
        private readonly AppDbContext _appDbContext;

        public PostsRepository(AppDbContext appDbContext)
        {
            _appDbContext = appDbContext;
        }

        public async Task<bool> CreatePostAsync(Post post)
        {
            await _appDbContext.Posts.AddAsync(post);
            var created = await _appDbContext.SaveChangesAsync();
            return created > 0;
        }

        public async Task<bool> DeletePostAsync(Guid postId)
        {
            var post = await GetPostByIdAsync(postId);

            if (post == null)
                return false;

            _appDbContext.Posts.Remove(post);
            var deleted = await _appDbContext.SaveChangesAsync();
            return deleted > 0;
        }

        public async Task<Post> GetPostByIdAsync(Guid postId)
        {
            return await _appDbContext.Posts.SingleOrDefaultAsync<Post>(x => x.Id == postId);
        }

        public async Task<List<Post>> GetPostsAsync()
        {
            return await _appDbContext.Posts.ToListAsync();
        }

        public async Task<bool> UpdatePostAsync(Post postToUpdate)
        {
            var exists = await _appDbContext.Posts.ContainsAsync(postToUpdate);

            if (!exists)
                return false;

             _appDbContext.Posts.Update(postToUpdate);             
            var updated = await _appDbContext.SaveChangesAsync();
            return updated > 0;
        }

        public async Task<bool> IsUserOwnerOfPostAsync(Guid postId, string userId)
        {
            var post = await _appDbContext.Posts.AsNoTracking().SingleOrDefaultAsync(x => x.Id == postId);

            if (post == null)
                return false;

            return post.UserId == userId;
        }
    }
}
