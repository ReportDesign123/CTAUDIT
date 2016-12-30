using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Audit.Module;
using AuditSPI;
using AuditService;
using CtTool;

namespace Audit
{
    public partial class Index:SessionFilterPage
    {
        //存储一级菜单
        public List<FunctionStruct> functions = new List<FunctionStruct>();
        protected void Page_Load(object sender, EventArgs e)
        {
            IFunctionService functionService = new FunctionService();
            functions = functionService.getFirstFunctions();
        }
    }
}