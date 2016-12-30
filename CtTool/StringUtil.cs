using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace CtTool
{
    public  class StringUtil
    {
        /// <summary>
        /// 判断对象是否为空
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static bool IsNullOrEmpty(object value)
        {
            if (Convert.IsDBNull(value))
            {
                return true;
            }
            if (value == null)
            {
                return true;
            }
            if (value.ToString() == "")
            {
                return true;
            }
            return false;
        }
        public static string ConvertStringToInSql(string str)
        {
            try
            {

                string result = "";
                string[] strArr = str.Split(',');
                foreach (string st in strArr)
                {
                    result += "'" + st + "'" + ",";
                }
                if (result.Length > 0)
                {
                    result = result.Substring(0, result.Length - 1);
                }

                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 将String数组转化为InSql语句
        /// </summary>
        /// <param name="strArr"></param>
        /// <returns></returns>
        public static string ConvertArrayStringToInSql(string[] strArr)
        {
            try
            {
                string result = "";
                foreach (string st in strArr)
                {
                    result += "'" + st + "'" + ",";
                }
                if (result.Length > 0)
                {
                    result = result.Substring(0, result.Length - 1);
                }

                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public static bool IsOrNotNumber(string str)
        {
            try
            {
                Regex regex = new Regex(@"^[-]?\d+[.]?\d*$");
                if (regex.IsMatch(str))
                {
                    return true;
                }
                else
                {
                    return false;
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
