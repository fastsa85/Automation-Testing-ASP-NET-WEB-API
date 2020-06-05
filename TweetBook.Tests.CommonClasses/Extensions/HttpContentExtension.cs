using System.IO;
using System.Net.Http;
using System.Threading.Tasks;

namespace TweetBook.Tests.CommonClasses.Extensions
{
    public static class HttpContentExtension
    {
        public static async Task<T> GetContentAsAsync<T>(this HttpContent httpContent)
        {
            var toReturn = await httpContent.ReadAsAsync<T>();
            var stream = await httpContent.ReadAsStreamAsync();
            stream.Seek(0, SeekOrigin.Begin);

            return toReturn;
        }
    }
}
