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
using TweetBook.Repositories;
using TweetBook.Extensions;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using AutoMapper;

namespace TweetBook.Controllers
{
    [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
    public class PostsController : Controller
    {
        private readonly IPostsRepository _postRepository;
        private readonly IMapper _mapper;

        public PostsController(IPostsRepository postRepository, IMapper mapper)
        {
            _postRepository = postRepository;
            _mapper = mapper;
        }

        [HttpGet(ApiRoutes.Posts.GetAll)]
        public async Task<IActionResult> GetAll()
        {
            var posts = await _postRepository.GetPostsAsync();
            return Ok(_mapper.Map<List<PostResponse>>(posts));
        }

        [HttpGet(ApiRoutes.Posts.Get)]
        public async Task<IActionResult> Get([FromRoute] Guid postId)
        {
            var post = await _postRepository.GetPostByIdAsync(postId);

            if (post == null)
                return NotFound();

            return Ok(_mapper.Map<PostResponse>(post));
        }

        [HttpPost(ApiRoutes.Posts.Create)]
        public async Task<IActionResult> Create([FromBody] CreatePostRequest postRequest)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var post = _mapper.Map<Post>(postRequest);
            post.UserId = HttpContext.GetUserId();

            var created = await _postRepository.CreatePostAsync(post);

            if (created)
            {
                var baseUrl = $"{HttpContext.Request.Scheme}://{HttpContext.Request.Host.ToUriComponent()}";
                var locationUri = baseUrl + "/" + ApiRoutes.Posts.Get.Replace("{postId}", post.Id.ToString());

                return Created(locationUri, _mapper.Map<PostResponse>(post));
            }

            return NotFound();
        }

        [HttpPut(ApiRoutes.Posts.Update)]
        public async Task<IActionResult> Update([FromRoute] Guid postId, [FromBody] UpdatePostRequest updateRequest)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var isUserOwnerOfPost = await _postRepository.IsUserOwnerOfPostAsync(postId, HttpContext.GetUserId());

            if (!isUserOwnerOfPost)
                return BadRequest(new { error = $"User can not update post {postId}"});

            var post = await _postRepository.GetPostByIdAsync(postId);
            
            var updated = await _postRepository.UpdatePostAsync(_mapper.Map(updateRequest, post));

            if (updated)
            {
                return Ok(_mapper.Map<PostResponse>(post));
            }
            
            return NotFound();
        }

        [HttpDelete(ApiRoutes.Posts.Delete)]
        public async Task<IActionResult> Delete([FromRoute] Guid postId)
        {
            var isUserOwnerOfPost = await _postRepository.IsUserOwnerOfPostAsync(postId, HttpContext.GetUserId());

            if (!isUserOwnerOfPost)
                return BadRequest(new { error = $"User can not delete post {postId}" });

            var deleted = await _postRepository.DeletePostAsync(postId);

            if (deleted)
                return NoContent();

            return NotFound();
        }
    }
}
