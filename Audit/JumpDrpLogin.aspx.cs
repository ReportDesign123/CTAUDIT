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
            string p_Reurl = Request.QueryString["p_Reurl"].ToString().Trim();
            string p_User = CtTool.SessoinUtil.GetCurrentUser().Code;
            string str3 = p_Reurl.Replace("^", "&");
            StringBuilder url = new StringBuilder();
            string Drp_Token = "1901B71DA48798005FBD60F78A7DD3A7";//haijf010
                                                                  // string Drp_Token = System.Web.Security.FormsAuthentication.HashPasswordForStoringInConfigFile("tjinspurok", "MD5");


            url.AppendFormat("http://{0}/DrpLogin/GenerSoftErpLogin.aspx?Drp_Token={2}&dbid=0001&userId={3}&pass=&logdate=&logintype=1&logad=&FuncNo={4}"
                                         , serverlogin
                                         , Drp_Token
                                         , p_User
                                         , p_Reurl
                                         );
            Response.Redirect(url.ToString());


        }
    }
}