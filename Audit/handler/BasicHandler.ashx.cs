
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Audit.TransportDataClass;
using CtTool;
using AuditSPI;
using Audit.Actions;
using System.Web.SessionState;
using Audit.Actions.ThirdPart.AccountBalance;
using Audit.Actions.Authority;





namespace Audit.handler
{
    /// <summary>
    /// 基本框架处理方式
    /// 参数中含有：
    /// ActionType:代表的是不同的Actio
    /// FunctionName:代表功能菜单名称
    /// MethodName:代表服务的方法
    /// Parameters:具体的参数列表
    /// </summary>
    public class BasicHandler :IHttpHandler,IRequiresSessionState
    {

        public  void ProcessRequest(HttpContext context)
        {

            context.Response.ContentType = "text/plain";
            string ActionType = HandlerTool.GetParam("ActionType", context);
            string functionName = HandlerTool.GetParam("FunctionName", context);
            string methodName = HandlerTool.GetParam("MethodName", context);
            BaseAction action = null;
            
            switch (functionName)
            {
                    //功能菜单
                case "FunctionsMenu":
                    action =new  FunctionsMenuAction();
                    break;
                case "Role":
                    action = new RoleAction();
                    break;
                case "UserManager":
                    action = new UserAction();
                    break;
                case "DictionaryManager":
                    action = new DicAction();
                    break;
                case "CycleManager":
                    action = new CycleDicAction();
                    break;
                case "CparasManager":
                    action = new CparaAction();
                    break;
                case "CompanyManager":
                    action = new CompanyAction();
                    break;
                case "PositionManager":
                    action = new PositionAction();
                    break;
                case "SIMA":
                    action = new SimaAction();
                    break;
                case "PROCEDURE":
                    action = new ProcedureAction();
                    break;
                case "LoginOut":
                    context.Response.Write("<script type='text/javascript'>window.location.href='../Login.aspx';</script>");
                    return;    
                case "DataSource":
                    action = new DataSourceAction();
                    break ;
                case "System":
                    action = new SystemAction();
                    break;
                case "AccountBalance":
                    action = new AccountBalanceAction();
                    break;
                case "Authority":
                    action = new AuthorityAction();
                    break;
                case "BackUpAction":
                    action = new BackUpAction();
                    break;
                    
            }
            action.context = context;
            action.actionType = ActionType;
            action.GoToMethod(methodName);

        }

        public  bool IsReusable
        {
            get
            {
                return false;
            }
        }
        private string getParam(string param,HttpContext context)
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