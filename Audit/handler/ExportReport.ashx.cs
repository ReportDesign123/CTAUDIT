using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using CtTool;
using Audit.Actions;
using Audit.Actions.ExportReport;

namespace Audit.handler
{
    /// <summary>
    /// Summary description for ExportReport
    /// </summary>
    public class ExportReport : IHttpHandler,IRequiresSessionState
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

                case "ReportTemplate":
                    action = new ReportTemplateAction();
                    break;
                case "CreateReport":
                    action = new CreateReportAction();
                    break;
                case "ReportTempalteInstanceState":
                    action = new ReportTempalteInstanceStateAction();
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