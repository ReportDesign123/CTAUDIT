using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Audit.TransportDataClass
{
    /// <summary>
    /// 基本的参数接收对象
    /// </summary>
    public class RequestGeneralParameters
    {
        private string actionName;//action名
        private string className;//类名
        private string methodName;//方法名
        private Dictionary<string, object> parameters = new Dictionary<string, object>();//参数名称


        public string ActionName
        {
            get { return actionName; }
            set { actionName = value; }
        }

        public string ClassName
        {
            get { return className; }
            set { className = value; }
        }

        public string MethodName
        {
            get { return methodName; }
            set { methodName = value; }
        }

        public Dictionary<string, object> Parameters
        {
            get { return parameters; }
            set { parameters = value; }
        }

    }
}