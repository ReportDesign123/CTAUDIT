using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AuditEntity.AuditPaper;
using AuditService.AuditPaper;
using CtTool;

namespace Audit.ct.AuditPaper
{
    public partial class AddAuditPaper : System.Web.UI.Page
    {
        public AuditPaperEntity ape = new AuditPaperEntity();
        protected void Page_Load(object sender, EventArgs e)
        {
            object obj = ActionTool.DeserializeParameter("Id", Context);
            if (obj != null && obj.ToString() != "")
            {
                AuditPaperService aps = new AuditPaperService();
                ape = aps.Get(obj.ToString());
                ReportTemplateService rts = new ReportTemplateService();
                if (!StringUtil.IsNullOrEmpty(ape.TemplateId))
                {
                    ape.TemplateName = rts.Get(ape.TemplateId).Name;
                }
                

            }
        }
    }
}