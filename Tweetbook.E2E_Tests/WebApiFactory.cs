using Microsoft.Extensions.Configuration;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Net;
using System.Text;

namespace Tweetbook.E2E_Tests
{
    public class WebApiFactory
    {
        public RestClient CreateWebApiClient(IConfiguration configuration)
        {
            var baseUrl = new Uri(configuration["BaseUrl"]);            
            var ignoreCertificates = Boolean.Parse(configuration.GetSection("IgnoreCertificates").Value);

            RestClient webApiClient = new RestClient()
            {
                BaseUrl = baseUrl                
            };

            if (ignoreCertificates)
            {
                ServicePointManager.ServerCertificateValidationCallback +=
       (sender, certificate, chain, sslPolicyErrors) => true;
            }

            return webApiClient;
        }
    }
}
