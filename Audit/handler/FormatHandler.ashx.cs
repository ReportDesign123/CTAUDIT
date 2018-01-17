using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Audit.Actions.Formats;
using Audit.Actions;
using System.Web.SessionState;
using CtTool;
using Audit.Actions.ReportLink;

namespace Audit.handler
{
    /// <summary>
    /// Summary description for FormatHandler
    /// </summary>
    public class FormatHandler : IHttpHandler, IRequiresSessionState
    {
        
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string ActionType = getParam("ActionType", context);
            string functionName = getParam("FunctionName", context);
            string methodName = getParam("MethodName", context);
            BaseAction action = null;



            switch (functionName)
            {
                //功能菜单
                case "ReportFormatMenu":
                    action = new ReportFormatAction();
                    break;
                case "FormularMenu":
                    action = new FormularAction();
                    break;
                case "ReportClassify":
                    action = new ReportClassifyAction();
                    break;
                case "ReportLinkAction":
                    action = new ReportLinkAction();
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
        private string getParam(string param, HttpContext context)
        {
            string value = Convert.ToString(context.Request.QueryString[param]);
            if (value == null)
            {
                value = Convert.ToString(context.Request.Form[param]);
            }
            return value;
        }
    }
}