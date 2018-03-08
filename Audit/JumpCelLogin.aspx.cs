using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CtTool;

namespace Audit
{
    public partial class JumpCelLogin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            string Userid = "", Pass = "", _href = "";// 
            string Vloginkey = !string.IsNullOrEmpty(Request.QueryString["loginkey"]) ? Request.QueryString["loginkey"].ToString() : "";
            Vloginkey = CtTool.Security.Decrypt(Vloginkey, "kbtech");
            //进行登录加密处理  "9D689EDA-81C1-44C9-A691-2A34F3569DB6";
            string VReturnUrl = !string.IsNullOrEmpty(Request.QueryString["ReturnUrl"]) ? Request.QueryString["ReturnUrl"] : "";
            if (Vloginkey != "")
            {
                Userid = get_token(ref Vloginkey, "^");
                Pass = Vloginkey;
            }
            if (VReturnUrl != "")
            {
                _href = VReturnUrl;
            }

            Response.Write("<Script>var _href='" + _href + "';var _Userid='" + Userid + "';var  _Password='" + Pass + "';</Script>");
           // Response.Write("<Script>var _href='Index.aspx';var _Userid='9999';var  _Password='!QAZ#EDCa';</Script>");
        }

        private string get_token(ref string p_string, string p_seperator)
        {
            int length = 0;
            string str = "";
            length = p_string.IndexOf(p_seperator);
            if (length >= 0)
            {
                str = p_string.Substring(0, length);
                p_string = p_string.Substring(length + p_seperator.Length);
                return str;
            }
            str = p_string;
            p_string = "";
            return str;
        }
    }
}