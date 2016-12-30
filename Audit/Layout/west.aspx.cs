using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AuditSPI;
using AuditService;
using CtTool;


namespace Audit.Layout
{
    public partial class west : System.Web.UI.Page
    {
        //存储一级菜单
        public List<FunctionStruct> functions = new List<FunctionStruct>();
        protected void Page_Load(object sender, EventArgs e)
        {
            IFunctionService functionService = new FunctionService();
            functions= functionService.getFirstFunctions();
           
        }
    }
}