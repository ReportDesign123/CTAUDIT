using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CtTool;
using AuditSPI;
using Audit.Actions;
using Audit.TransportDataClass;
using System.Web.SessionState;
using Audit.Actions.WorkFlow;

namespace Audit.handler
{
    /// <summary>
    /// Summary description for WorkFlowHandler
    /// </summary>
    public class WorkFlowHandler : IHttpHandler, IRequiresSessionState
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
              
                case "WorkFlow":
                    action = new WorkFlowAction();
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