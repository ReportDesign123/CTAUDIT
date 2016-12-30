using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CtTool
{
    public  class Base64
    {
        public static string Decode64(string source){
            byte[] bytes = Convert.FromBase64String(source);
            return  System.Text.Encoding.UTF8.GetString(bytes);
        }

        public static string Encode64(string source)
        {
            byte[] bytes = System.Text.Encoding.UTF8.GetBytes(source);
            return Convert.ToBase64String(bytes);
        }
        /// <summary>
        /// 通过UTF8的编码方式进行解码
        /// </summary>
        /// <param name="source"></param>
        /// <returns></returns>
        public static string Decode64ByUtf8(string source)
        {
            try
            {
                byte[] bytes = Convert.FromBase64String(source);
                return Encoding.UTF8.GetString(bytes);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
