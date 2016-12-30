using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using Audit.Actions;
using Audit.Actions.ReportProblem;
using CtTool;
using Audit.Actions.ProblemTrace;

namespace Audit.handler
{
    /// <summary>
    /// Summary description for ProblemTraceHandler
    /// </summary>
    public class ProblemTraceHandler : IHttpHandler,IRequiresSessionState
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
                case "ProblemTraceAction":
                    action = new ProblemTraceAction();
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