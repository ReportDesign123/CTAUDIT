using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AuditSPI;
using AuditService.ExportReport;
using AuditEntity.ExportReport;
using CtTool;
namespace Audit.ct.ExportReport
{
    public partial class TemplateDesign : System.Web.UI.Page
    {
        public ReportTemplateEntity rte = new ReportTemplateEntity();
        protected void Page_Load(object sender, EventArgs e)
        {
            ReportTemplateEntity temp = ActionTool.DeserializeParameters<ReportTemplateEntity>(Context, GlobalConst.BasicGlobalConst.POSTTYPE_GET);
            if (!StringUtil.IsNullOrEmpty(temp.Id))
            {
                ReportTemplateService reportTemplateService = new ReportTemplateService();
                rte = reportTemplateService.GetReportTemplate(temp);
            }
        }
    }
}