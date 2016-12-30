using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;


namespace CtTool
{
    public  class HandlerTool
    {

        public  static string GetParam(string param, HttpContext context)
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
