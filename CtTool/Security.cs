using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Security.Cryptography;
using System.Text;
using System.IO;
namespace CtTool
{
    public class Security
    {
        #region MyRegion




        public static string GetUrlPara(string paraStr, string paraName)
        {
            paraStr = paraStr.Replace("&nbsp;", " ");
            if (paraStr.StartsWith("&"))
            {
                paraStr = paraStr.Remove(0, 1);
            }
            if (paraStr.EndsWith("&"))
            {
                paraStr = paraStr.Remove(paraStr.Length - 1, 1);
            }
            string[] strArray = paraStr.Split("&".ToCharArray());
            for (int i = 0; i < strArray.Length; i++)
            {
                if (strArray[i].Length == 0)
                    continue;
                int index = strArray[i].IndexOf("=", 0);
                if (index > -1)
                {
                    if (strArray[i].Substring(0, index).Trim().ToLower() == paraName.Trim().ToLower())
                    {
                        return strArray[i].Substring(index + 1, (strArray[i].Length - index) - 1);
                    }
                }
            }
            return "";
        }

        /// <summary>
        /// 加密密码
        /// </summary>
        /// <param name="str">密码明文</param>
        /// <returns>加密后的密码</returns>
        public static string Encrypt(string str)
        {
            MD5CryptoServiceProvider provider = new MD5CryptoServiceProvider();
            return Convert.ToBase64String(provider.ComputeHash(Encoding.UTF8.GetBytes(str)));
        }

        /// <summary>
        /// 解密字符串
        /// </summary>
        /// <param name="strText">密文（Base64编码）</param>
        /// <param name="userName">钥匙</param>
        /// <returns></returns>
        public static string Decrypt(string strText, string userName)
        {
            byte[] rgbKey = new byte[8];
            byte[] rgbIV = new byte[] {
                0x75, 0x30, 0x26, 0x40, 0x21, 0xac, 190, 0xcd, 0xad, 0x1a, 60, 0x7b, 0x33, 0x65, 0x23, 0x2d,
                0x4f, 30, 0x2b, 0x98, 1, 10, 0x26, 0x7c, 0x98, 0x97, 0x71, 0x6d, 0xe1, 0xf2, 0xc4, 0xd6
             };
            byte[] buffer = new byte[strText.Length];
            string str = "";
            string key = "";
            try
            {
                key = GetKey(userName);
                byte[] rgbKey2 = Encoding.UTF8.GetBytes(key.Substring(0, 8));
                Array.Copy(rgbKey2, rgbKey, 8);
                DESCryptoServiceProvider provider = new DESCryptoServiceProvider();
                buffer = Convert.FromBase64String(strText.Replace(".", "+").Replace("_", "/"));
                MemoryStream stream = new MemoryStream();
                CryptoStream stream2 = new CryptoStream(stream, provider.CreateDecryptor(rgbKey, rgbIV), CryptoStreamMode.Write);
                stream2.Write(buffer, 0, buffer.Length);
                stream2.FlushFinalBlock();
                str = new UTF8Encoding().GetString(stream.ToArray());
                return str;
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        /// <summary>
        /// 根据userName产生一个固定长度的Key
        /// </summary>
        /// <param name="userName"></param>
        /// <returns></returns>
        private static string GetKey(string userName)
        {
            string str = "zh0XagBHUdDmDgEvJj9rhA1NAW4L070y";
            return (userName + str.Substring(userName.Length, 0x20 - userName.Length));
        }

        /// <summary>
        /// 加密字符串，返回加密后的Base64编码
        /// </summary>
        /// <param name="strText">明文</param>
        /// <param name="userName">加密钥匙，长度小于32</param>
        /// <returns>密文</returns>
        public static string EncryptStr(string strText, string userName)
        {
            if (userName.Length >= 0x20)
            {
                throw new Exception("钥匙长度不能超过32");
            }
            byte[] rgbKey = new byte[8];
            byte[] rgbIV = new byte[] {
                0x75, 0x30, 0x26, 0x40, 0x21, 0xac, 190, 0xcd, 0xad, 0x1a, 60, 0x7b, 0x33, 0x65, 0x23, 0x2d,
                0x4f, 30, 0x2b, 0x98, 1, 10, 0x26, 0x7c, 0x98, 0x97, 0x71, 0x6d, 0xe1, 0xf2, 0xc4, 0xd6
             };
            string key = "";
            try
            {
                key = GetKey(userName);
                byte[] rgbKey2 = Encoding.UTF8.GetBytes(key.Substring(0, 8));
                Array.Copy(rgbKey2, rgbKey, 8);

                DESCryptoServiceProvider provider = new DESCryptoServiceProvider();
                byte[] bytes = Encoding.UTF8.GetBytes(strText);
                MemoryStream stream = new MemoryStream();
                CryptoStream stream2 = new CryptoStream(stream, provider.CreateEncryptor(rgbKey, rgbIV), CryptoStreamMode.Write);
                stream2.Write(bytes, 0, bytes.Length);
                stream2.FlushFinalBlock();
                return Convert.ToBase64String(stream.ToArray()).Replace("+", ".").Replace("/", "_");
            }
            catch (Exception e)
            {
                throw e;
            }
        }
        #endregion
    }
}
