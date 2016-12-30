using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AuditService.ReportAudit;
using AuditEntity.ReportAudit;
using CtTool;

namespace Audit.ct.ReportAudit
{
    public partial class ProblemsFind : System.Web.UI.Page
    {
        public ReportAuditEntity rae = new ReportAuditEntity();
        protected void Page_Load(object sender, EventArgs e)
        {
            ReportAuditEntity temp = ActionTool.DeserializeParameters<ReportAuditEntity>(Context, GlobalConst.BasicGlobalConst.POSTTYPE_GET);
            ReportAuditService ras = new ReportAuditService();
            if (temp.Id != null && temp.Id != "")
            {
                rae = temp;
            }
        }
    }
}