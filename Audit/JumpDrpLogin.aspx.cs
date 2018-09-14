using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
namespace Audit
{
    public partial class JumpDrpLogin : System.Web.UI.Page
    {
        public string Jump = "", Url = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            string serverlogin = ConfigurationManager.AppSettings["Drplogin"].ToString();
           // string p_Reurl = Request.QueryString["p_Reurl"].ToString().Trim();
            string s_url = HttpContext.Current.Request.Url.Query;


            string[] strArray = s_url.Split(new string[] { "p_Reurl=", "QueryID=" }, StringSplitOptions.RemoveEmptyEntries);
            string p_Reurl = strArray[1].ToString();
            string p_fn = strArray[2].ToString();
            p_Reurl = p_Reurl + "QueryID=" + p_fn.Replace("&", "^");
            string p_User = CtTool.SessoinUtil.GetCurrentUser().Code;
            string str3 = p_Reurl.Replace("^", "&");
            StringBuilder url = new StringBuilder();
            string Drp_Token = "50DB4CA826107A0C69A19D2EE7F54228";//haijf010
                                                                  // string Drp_Token = System.Web.Security.FormsAuthentication.HashPasswordForStoringInConfigFile("tjinspurok", "MD5");


            url.AppendFormat("{0}/DrpLogin/GenerSoftErpLogin.aspx?Drp_Token={1}&dbid=0001&userId={2}&pass=&logdate=&logintype=1&logad=&FuncNo={3}"
                                         , serverlogin
                                         , Drp_Token
                                         , p_User
                                         , p_Reurl
                                         );
            Response.Redirect(url.ToString());


        }
    }
}