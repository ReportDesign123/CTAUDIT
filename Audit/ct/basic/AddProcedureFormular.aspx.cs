using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AuditEntity.Procedure;
using CtTool;
using AuditSPI.Procedure;
using AuditService.Procedure;

namespace Audit.ct.basic
{
    public partial class AddProcedureFormular : System.Web.UI.Page
    {
        public ProcedureFormularEntity pfe = new ProcedureFormularEntity();
        protected void Page_Load(object sender, EventArgs e)
        {
            string id = Convert.ToString(ActionTool.DeserializeParameter("Id",Context));
            if (!StringUtil.IsNullOrEmpty(id))
            {
                IProcedureFormular procedure = new ProcedureService();
                pfe = procedure.GetProcedureFormularEntity(id);
              
            }
        }
    }
}