using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using GlobalConst;
using System.Web.SessionState;
using AuditEntity;
using AuditSPI.Session;
using CtTool;

namespace CtTool
{
    public  class SessoinUtil
    {
        /// <summary>
        /// 路径过滤
        /// </summary>
        /// <param name="url"></param>
        /// <returns></returns>
        public static bool ExcludeContainUrl(string url)
        {
            Dictionary<string, string> excludeUrls = new Dictionary<string, string>();
            excludeUrls.Add("/Login.aspx", "/Login.aspx");
            excludeUrls.Add("/Default.aspx", "/Default.axps");
            if (excludeUrls.ContainsKey(url))
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        /// <summary>
        /// 特定路径下的方法过滤
        /// </summary>
        /// <param name="url"></param>
        /// <param name="method"></param>
        /// <returns></returns>
        public static bool ContainMethod(string url, string method)
        {
            Dictionary<string, string> excludeUrls = new Dictionary<string, string>();
            excludeUrls.Add("/handler/BasicHandler.ashxLogin", "/handler/BasicHandler.ashxLogin");
            if (excludeUrls.ContainsKey(url+method)&&excludeUrls[url+method]==url+method)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public static  string getParam(string param, HttpContext context)
        {
            string value = Convert.ToString(context.Request.QueryString[param]);
            if (value == null)
            {
                value = Convert.ToString(context.Request.Form[param]);
            }
            return value;
        }
        /// <summary>
        /// 获取当前Session信息
        /// </summary>
        /// <returns></returns>
        public static SessionInfo GetCurrentSession()
        {
            try
            {
                HttpSessionState hss = HttpContext.Current.Session;
                if (hss == null) return new SessionInfo();
                SessionInfo si = (SessionInfo) hss[BasicGlobalConst.CT_SESSION];
                if (si == null)
                {
                    return new SessionInfo();
                }
                else
                {
                    return si;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static UserEntity GetCurrentUser()
        {
            try
            {
                HttpSessionState hss = HttpContext.Current.Session;
                if (hss == null) return new UserEntity();
                SessionInfo si = (SessionInfo)hss[BasicGlobalConst.CT_SESSION];
                if (si != null)
                {
                    return si.userEntity;
                }
                else
                {
                    return new UserEntity();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public static DateTime GetDateTime()
        {
            try
            {
                return DateTime.Now;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public static string GetCurrentDateTime()
        {
            try
            {
                return DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public static string GetTimeTicks()
        {
            try
            {
                return DateTime.Now.Ticks.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public static int  GetCurrentYear()
        {
            try
            {
                return DateTime.Now.Year;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static string GetSystemYear()
        {
            try
            {
                return DateTime.Now.Year.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public static string GetSystemMonth()
        {
            try
            {
               int month=  DateTime.Now.Month;
               return month < 10 ? "0" + month.ToString() : month.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public static string GetSystemDay()
        {
            try
            {
                int day = DateTime.Now.Day;
                return day < 10 ? "0" + day.ToString() : day.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public static string GetSystemDate()
        {
            try
            {
                return DateTime.Now.ToString("yyyy-MM-dd");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static string GetCwYYYY(string auditDate)
        {
            try
            {
                return auditDate.Substring(0, 4);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static string GetCwMonth(string auditDate)
        {
            try
            {
              
                return auditDate.Substring(5, 2); ;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public static string GetCwQuarter(string auditDate)
        {
            try
            {
                int month=Convert.ToInt32(GetCwMonth(auditDate));
                return "0" + ((month - 1) / 3 + 1).ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static string GetCwMmLastDay(string auditDate)
        {
            try
            {
                int yyyy = Convert.ToInt32(GetCwYYYY(auditDate));
                int month =Convert.ToInt32(GetCwMonth(auditDate));
               
                DateTime dt = new DateTime(yyyy, month, 1);
                DateTime dt2=  dt.AddMonths(1).AddDays(-1);
                int day = dt2.Day;
                return day < 10 ? "0" + day.ToString() : day.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static string GetCwMmLastDay(string YYYY,string MM)
        {
            try
            {
                int yyyy = Convert.ToInt32(YYYY);
                int month = Convert.ToInt32(MM);
                if (month < 12)
                {
                    month = month + 1;
                }
                else
                {
                    month = 1;
                    yyyy = yyyy + 1;
                }

                DateTime dt = new DateTime(yyyy, month, 1);
                DateTime dt2 = dt.AddDays(-1);
                int day = dt2.Day;
                return day < 10 ? "0" + day.ToString() : day.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
     
        public static string GetCurrentCompanyId()
        {
            try
            {
                HttpSessionState hss = HttpContext.Current.Session;
                if (hss == null) return "";
                SessionInfo si = (SessionInfo)hss[BasicGlobalConst.CT_SESSION]; 
                if (si != null)
                {
                    return si.userEntity.OrgnizationId;
                }
                else
                {
                    return "ff8ecd62-cefa-4f12-b564-0ca0f45b975d";
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static string GetCurrentCompanyName()
        {
            try
            {
                HttpSessionState hss = HttpContext.Current.Session;
                if (hss == null) return "";
                SessionInfo si = (SessionInfo)hss[BasicGlobalConst.CT_SESSION];
                if (si != null)
                {
                    return si.companyEntity.Name;
                }
                else
                {
                    return "";
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static string GetCurrentPostionId()
        {
            try
            {
                HttpSessionState hss = HttpContext.Current.Session;
                if (hss == null) return "";
                SessionInfo si = (SessionInfo)hss[BasicGlobalConst.CT_SESSION];
                if (si != null)
                {
                    return si.userEntity.ResponsibilityId;
                }
                else
                {
                    return "";
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static string GetCurrentPositionCodeSql()
        {
            try
            {
                HttpSessionState hss = HttpContext.Current.Session;
                if (hss == null)
                    return " ='' ";
                SessionInfo si = (SessionInfo)hss[BasicGlobalConst.CT_SESSION];
                if (si != null)
                {
                    string sql = " IN( ";
                    foreach (PositionEntity pe in si.userEntity.Positions)
                    {
                        sql+="'";
                        sql += pe.Code;
                        sql += "'";
                        sql += ",";
                    }
                    sql = sql.Substring(0, sql.Length - 1);
                    sql += ")";
                    return sql;
                }
                else
                {
                    return " ='' ";
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public static string GetCwLastMMDate(string auditDate)
        {
            try
            {
                return GetCwYYYY(auditDate)+"-"+GetCwMonth(auditDate)+"-"+GetCwMmLastDay(auditDate);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public static string GetCwLastMMDate(string YYYY,string MM)
        {
            try
            {
                return YYYY  + "-" + MM + "-" + GetCwMmLastDay(YYYY,MM);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        
    }
}
