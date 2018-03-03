using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using sys;
using System.Data;
using DbManager;
namespace Audit
{
    public partial class JumpOaLogin : System.Web.UI.Page
    {
        public static string DBName = "db1";
        public string Jump = "", Url = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            string p_Reurl = Request.QueryString["p_Reurl"].ToString().Trim();
            string p_User = CtTool.SessoinUtil.GetCurrentUser().Code;
            string str3 = p_Reurl.Replace("^", "&");
            string str2 = HttpUtility.UrlEncode(str3);
            string Oaur = ConfigurationManager.AppSettings["Oalogin"].ToString();
            //加入用户转换
            CTDbManager dbManager = new CTDbManager();
            var sql = "select top 1 zgbh  from   v_oa_userzz   where  lx='1' and   gsuser= '" + p_User + "' ";
            DataTable datelist = dbManager.ExecuteSqlReturnDataTable(sql);
            if (datelist.Rows.Count > 0)
            {
                p_User= datelist.Rows[0]["zgbh"].ToString();
                string str1 = CtTool.Security.EncryptStr("u=" + p_User + "&t=" + DateTime.Now.Ticks.ToString() + "", "kbtech"); // 加密
                p_Reurl = ("loginkey=" + str1 + "&ReturnUrl=" + str2).Replace("&amp;", "&");
                Url = Oaur + "?" + p_Reurl;
                Response.Redirect(Url.ToString());
            }
            else
            {
                Jump = "没有关联协同用户";
               // Response.Write("<Script> $('#divWait').text('" + Jump + "'); </Script>");
                return;
            }
           
          //  Response.Write("<Script>var Url='" + Oaur +"?"+ p_Reurl + "';Jump='" + Jump + "' </Script>");
        }
    }
}