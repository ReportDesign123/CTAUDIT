using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AuditService.WorkFlow;
using AuditEntity.WorkFlow;
using CtTool;
using AuditService;
using AuditEntity;
using GlobalConst;

namespace Audit.ct.ReportData.ReportExamine
{
    public partial class ReportExamManager : System.Web.UI.Page
    {
   
        protected void Page_Load(object sender, EventArgs e)
        {
           WorkFlowDefinition wfd = new WorkFlowDefinition();
            SystemService ss = new SystemService();
            ConfigEntity ce = ss.GetConfigByName(ReportGlobalConst.REPORTEXAM_CONFIGNAME);
            wfd.Code = ce.Value;
            WorkFlowDefinitionService wfds = new WorkFlowDefinitionService();
            wfd = wfds.GetWorkFlow(wfd);
            if (wfd != null)
            {
                Response.Write("<script>var workflowConten='" + wfd.WorkFlowOrder + "';</script>");
            }
            else
            {
                Response.Write("<script>var workflowConten='';</script>");
            }
        }
    }
}