using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TweetBook.Contracts.V1.Requests;
using TweetBook.Contracts.V1.Responses;
using TweetBook.Domain;

namespace TweetBook.Mapping
{
    public class DomainToContractsMapping : Profile
    {
        public DomainToContractsMapping()
        {
            CreateMap<Post, PostResponse>();
            CreateMap<CreatePostRequest, Post>();
            CreateMap<UpdatePostRequest, Post>()
                .ForMember(dest => dest.UserId, opt => opt.Ignore())
                .ForMember(dest => dest.User, opt => opt.Ignore());

            CreateMap<Comment, CommentResponse>();
            CreateMap<CreateCommentRequest, Comment>();
            CreateMap<UpdateCommentRequest, Comment>()
                .ForMember(dest => dest.UserId, opt => opt.Ignore())
                .ForMember(dest => dest.User, opt => opt.Ignore())
                .ForMember(dest => dest.Post, opt => opt.Ignore());
        }
    }
}
