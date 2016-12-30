using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AuditSPI;
using AuditService;
using AuditEntity;

namespace Audit.ct.basic
{
    public partial class AddFunction : System.Web.UI.Page
    {
     
        public FunctionEntity function = new FunctionEntity();
        protected void Page_Load(object sender, EventArgs e)
        {
            string type = Request.QueryString["type"];
            if (type == "add")
            {
                string parent=Request.QueryString["Parent"];
                function.Parent = parent;
            }else if(type=="edit"){
                string Id = Request.QueryString["Id"];
                IFunctionService fs = new FunctionService();
                function = fs.Get(Id);
            }
        }
    }
}