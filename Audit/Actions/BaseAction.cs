using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Audit.Actions
{
   abstract public class BaseAction
    {
        public HttpContext context;
        public string actionType;
        abstract public  void GoToMethod(string methodName);
    }
}