using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using AuditSPI.Session;
using GlobalConst;
namespace Audit.UiBase
{
    public class PageBase : System.Web.UI.Page
    {


        protected override void OnLoad(EventArgs e)
        {
            CheckUserLogin();

            base.OnLoad(e);
        }


        /// <summary>
        /// 检查是否登录
        /// </summary>
        private void CheckUserLogin()
        {

            HttpSessionState session = Context.Session;
            object SessionInfo = session[BasicGlobalConst.CT_SESSION];
            if (SessionInfo != null)
            {

            }
            else
            {
                Response.Redirect("~/Login.aspx");
            }

        }

    }
}