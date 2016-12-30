using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AuditService.ProblemTrace;
using AuditEntity.ReportProblem;
using CtTool;
namespace Audit.ct.ProblemTrace
{
    public partial class AddProblem : System.Web.UI.Page
    {
        public ReportProblemEntity rpe = new ReportProblemEntity();
        protected void Page_Load(object sender, EventArgs e)
        {
            ReportProblemEntity temp = ActionTool.DeserializeParameters<ReportProblemEntity>(Context, GlobalConst.BasicGlobalConst.POSTTYPE_GET);
            if (!StringUtil.IsNullOrEmpty(temp.Id))
            {
                AuditService.ProblemTrace.ProblemTrace problemService = new AuditService.ProblemTrace.ProblemTrace();
                rpe = problemService.GetProblem(temp);
            }
            if (rpe.Rank == 0) { rpe.Rank = 1; }
        }
    }
}