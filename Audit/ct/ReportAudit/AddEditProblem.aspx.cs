using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AuditService.ReportProblem;
using AuditEntity.ReportProblem;
using CtTool;

namespace Audit.ct.ReportAudit
{
    public partial class AddEditProblem : System.Web.UI.Page
    {

        public ReportProblemEntity rpe = new ReportProblemEntity();
        
        protected void Page_Load(object sender, EventArgs e)
        {
            ReportProblemEntity temp = ActionTool.DeserializeParameters<ReportProblemEntity>(Context, GlobalConst.BasicGlobalConst.POSTTYPE_GET);
            if (!StringUtil.IsNullOrEmpty(temp.Id))
            {
                ReportProblemServicecs res = new ReportProblemServicecs();
                rpe = res.Get(temp);
            }
            if (rpe.Rank == 0) { rpe.Rank = 1; }

        }
    }
}