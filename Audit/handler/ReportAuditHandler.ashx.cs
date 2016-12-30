using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Audit.Actions;
using Audit.Actions.ReportAudit;
using CtTool;
using System.Web.SessionState;

namespace Audit.handler
{
    /// <summary>
    /// Summary description for ReportAuditHandler
    /// </summary>
    public class ReportAuditHandler : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string ActionType = HandlerTool.GetParam("ActionType", context);
            string functionName = HandlerTool.GetParam("FunctionName", context);
            string methodName = HandlerTool.GetParam("MethodName", context);
            BaseAction action = null;

            switch (functionName)
            {
                //功能菜单
                case "ReportAudit":
                    action = new ReportAuditAction();
                    break;

            }
            action.context = context;
            action.actionType = ActionType;
            action.GoToMethod(methodName);
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
     
    }
}