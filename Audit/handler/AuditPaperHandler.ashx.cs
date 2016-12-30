using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Audit.handler;
using Audit.Actions.AuditPaper;
using Audit.Actions;
using CtTool;
using System.Web.SessionState;

namespace Audit.handler
{
    /// <summary>
    /// Summary description for AuditPaperHandler
    /// </summary>
    public class AuditPaperHandler : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            string ActionType = HandlerTool.GetParam("ActionType", context);
            string functionName = HandlerTool.GetParam("FunctionName", context);
            string methodName = HandlerTool.GetParam("MethodName", context);
            BaseAction action = null;

            switch (functionName)
            {
                //功能菜单
                case "AuditPaperMenu":
                    action = new AuditPaperAction();
                    break;
                case "AuditPaperManagerMenu":
                    action = new AuditPaperManagerAction();
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