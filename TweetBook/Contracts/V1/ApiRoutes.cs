﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace TweetBook.Contracts
{
    public static class ApiRoutes
    {
        public const string Root = "api";
        public const string Version = "v1";        
        public const string Base = Root + "/" + Version;               

        public static class Identity
        {
            public const string Login = Base + "/identity/login";

            public const string Register = Base + "/identity/register";

            public const string Refresh = Base + "/identity/refresh";
        }

        public static class Posts
        {
            public const string GetAll = Base + "/posts";

            public const string Get = Base + "/posts/{postId}";

            public const string Delete = Base + "/posts/{postId}";

            public const string Create = Base + "/posts";

            public const string Update = Base + "/posts/{postId}";
        }

        public static class Comments
        {
            public const string GetAll = Base + "/comments";

            public const string Get = Base + "/comments/{commentId}";

            public const string Create = Base + "/comments";

            public const string Update = Base + "/comments/{commentId}";

            public const string Delete = Base + "/comments/{commentId}";
        }
    }
}
