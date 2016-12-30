using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AuditService.ProblemTrace;
using AuditEntity.ReportProblem;
using Audit.Actions;
using AuditEntity;
using CtTool;
using AuditService;
using System.Web.SessionState;
using AuditSPI.Session;
using GlobalConst;
namespace Audit.ct.ProblemTrace
{
    public partial class ProblemReturnDetail : System.Web.UI.Page
    {
        public ReportProblemEntity rpe = new ReportProblemEntity();
        public UserEntity user = new UserEntity();
        protected void Page_Load(object sender, EventArgs e)
        {
            ReportProblemEntity temp = ActionTool.DeserializeParameters<ReportProblemEntity>(Context, GlobalConst.BasicGlobalConst.POSTTYPE_GET);
            if (!StringUtil.IsNullOrEmpty(temp.Id))
            {
                AuditService.ProblemTrace.ProblemTrace problemService = new AuditService.ProblemTrace.ProblemTrace();
                rpe = problemService.GetProblem(temp);
                UserEntity tempUser = CtTool.SessoinUtil.GetCurrentUser();
                user.Name = tempUser.Name;
            }
            if (rpe.Rank == 0) { rpe.Rank = 1; }
        }
    }
}