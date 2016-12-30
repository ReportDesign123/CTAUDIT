using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Audit.Actions;
using Audit.Actions.AuditTask;
using CtTool;
using System.Web.SessionState;


namespace Audit.handler
{
    /// <summary>
    /// Summary description for AuditTaskHandler
    /// </summary>
    public class AuditTaskHandler : IHttpHandler, IRequiresSessionState
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
                case "AuditTaskManager":
                    action = new AuditTaskAction();
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