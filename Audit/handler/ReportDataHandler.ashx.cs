using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CtTool;
using Audit.Actions;
using Audit.Actions.ReportData;
using System.Web.SessionState;
using Audit.Actions.ReportAggregation;
using Audit.Actions.ReportAnalysis;


namespace Audit.handler
{
    /// <summary>
    /// Summary description for ReportDataHandler
    /// </summary>
    public class ReportDataHandler : IHttpHandler, IRequiresSessionState
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
                case "FillReport":
                    action = new FillReportAction();
                    break;
                case "ReportAggregation":
                    action = new ReportAggregationAction();
                    break;
                case "ReportReadWriteLockAction":
                    action = new ReportReadWriteLockAction();
                    break;
                case "ReportStateAggregation":
                    action = new ReportStateAggregationAction();
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