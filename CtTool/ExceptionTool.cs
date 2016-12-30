using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditSPI;

namespace CtTool
{
    public class ExceptionTool
    {
        /// <summary>
        /// 获取异常类型
        /// 1为是否判断提示
        /// 2为警告提示
        /// 3为错误提示
        /// </summary>
        /// <param name="ex"></param>
        /// <returns></returns>
        public static string GetExceptionRank(Exception ex)
        {
            if (ex is MyException)
            {
                return (ex as MyException).Rank;
            }
            return "";
        }
    }
}
