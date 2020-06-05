using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TweetBook.Data;
using TweetBook.Domain;

namespace TweetBook.Repositories
{
    public class CommentsRepository : ICommentsRepository
    {
        private readonly AppDbContext _appDbContext;

        public CommentsRepository(AppDbContext appDbContext)
        {
            _appDbContext = appDbContext;
        }

        public async Task<List<Comment>> GetCommentsAsync()
        {
            return await _appDbContext.Comments.ToListAsync();
        }

        public async Task<bool> CreateCommentAsync(Comment comment)
        {
            var post = await _appDbContext.Posts.SingleOrDefaultAsync(x => x.Id == comment.PostId);
            if (post == null)
                return false;
            await _appDbContext.Comments.AddAsync(comment);
            var created = await _appDbContext.SaveChangesAsync();
            return created > 0;
        }

        public async Task<Comment> GetCommentByIdAsync(Guid commentId)
        {            
            return await _appDbContext.Comments.SingleOrDefaultAsync<Comment>(x => x.Id == commentId);
        }

        public async Task<bool> UpdateCommentAsync(Comment commentToUpdate)
        {
            var exists = await _appDbContext.Comments.ContainsAsync(commentToUpdate);

            if (!exists)
                return false;

            _appDbContext.Comments.Update(commentToUpdate);
            var updated = await _appDbContext.SaveChangesAsync();
            return updated > 0;
        }

        public async Task<bool> IsUserOwnerOfCommentAsync(Guid commentId, string userId)
        {
            var comment = await _appDbContext.Comments.AsNoTracking().SingleOrDefaultAsync(x => x.Id == commentId);

            if (comment == null)
                return false;

            return comment.UserId == userId;
        }

        public async Task<bool> DeletePostAsync(Guid commentId)
        {
            var comment = await GetCommentByIdAsync(commentId);

            if (comment == null)
                return false;

            _appDbContext.Comments.Remove(comment);
            var deleted = await _appDbContext.SaveChangesAsync();
            return deleted > 0;
        }
    }
}