using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using AuditEntity;
using AuditSPI;
using CtTool;
using AuditSPI.Session;
using GlobalConst;
using System.Web.SessionState;

namespace Audit.Module
{
    public class SessionFilterPage:Page
    {
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            HttpSessionState session = Context.Session;
            object SessionInfo =  session[BasicGlobalConst.CT_SESSION];
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