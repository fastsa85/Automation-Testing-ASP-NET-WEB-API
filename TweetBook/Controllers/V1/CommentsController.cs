using AutoMapper;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TweetBook.Contracts;
using TweetBook.Contracts.V1.Requests;
using TweetBook.Contracts.V1.Responses;
using TweetBook.Domain;
using TweetBook.Extensions;
using TweetBook.Repositories;

namespace TweetBook.Controllers.V1
{
    [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
    public class CommentsController : Controller
    {
        private readonly ICommentsRepository _commentsRepository;
        private readonly IPostsRepository _postsRepository;
        private readonly IMapper _mapper;

        public CommentsController(ICommentsRepository commentsRepository, IPostsRepository postsRepository, IMapper mapper)
        {
            _commentsRepository = commentsRepository;
            _postsRepository = postsRepository;
            _mapper = mapper;
        }

        [HttpGet(ApiRoutes.Comments.GetAll)]
        public async Task<IActionResult> GetAll()
        {
            var comments = await _commentsRepository.GetCommentsAsync();
            return Ok(_mapper.Map<List<Comment>>(comments));
        }

        [HttpGet(ApiRoutes.Comments.Get)]
        public async Task<IActionResult> Get([FromRoute] Guid commentId)
        {
            var comment = await _commentsRepository.GetCommentByIdAsync(commentId);

            if (comment == null)
                return NotFound();

            return Ok(_mapper.Map<CommentResponse>(comment));
        }

        [HttpPost(ApiRoutes.Comments.Create)]
        public async Task<IActionResult> Create([FromBody] CreateCommentRequest commentRequest)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var existedPost = await _postsRepository.GetPostByIdAsync(commentRequest.PostId.Value);
            if (existedPost == null)
                return BadRequest(new { error = $"Post with Id {commentRequest.PostId} does not exist" });

            var comment = _mapper.Map<Comment>(commentRequest);
            comment.UserId = HttpContext.GetUserId();

            var created = await _commentsRepository.CreateCommentAsync(comment);

            if (created)
            {
                var baseUrl = $"{HttpContext.Request.Scheme}://{HttpContext.Request.Host.ToUriComponent()}";
                var locationUri = baseUrl + "/" + ApiRoutes.Comments.Get.Replace("{commentId}", comment.Id.ToString());

                return Created(locationUri, _mapper.Map<CommentResponse>(comment));
            }

            return NotFound();
        }

        [HttpPut(ApiRoutes.Comments.Update)]
        public async Task<IActionResult> Update([FromRoute] Guid commentId, [FromBody] UpdateCommentRequest updateRequest)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var isUserOwnerOfComment = await _commentsRepository.IsUserOwnerOfCommentAsync(commentId, HttpContext.GetUserId());

            if (!isUserOwnerOfComment)
                return BadRequest(new { error = $"User can not update comment {commentId}" });

            var comment = await _commentsRepository.GetCommentByIdAsync(commentId);

            var updated = await _commentsRepository.UpdateCommentAsync(_mapper.Map(updateRequest, comment));

            if (updated)
            {
                return Ok(_mapper.Map<CommentResponse>(comment));
            }

            return NotFound();
        }

        [HttpDelete(ApiRoutes.Comments.Delete)]
        public async Task<IActionResult> Delete([FromRoute] Guid commentId)
        {
            var isUserOwnerOfPost = await _commentsRepository.IsUserOwnerOfCommentAsync(commentId, HttpContext.GetUserId());

            if (!isUserOwnerOfPost)
                return BadRequest(new { error = $"User can not delete comment {commentId}" });

            var deleted = await _commentsRepository.DeletePostAsync(commentId);

            if (deleted)
                return NoContent();

            return NotFound();
        }
    }
}
