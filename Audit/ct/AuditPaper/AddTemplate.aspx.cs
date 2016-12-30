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
    public partial class AddTemplate : System.Web.UI.Page
    {
       public   ReportTemplateEntity rte = new ReportTemplateEntity();
        protected void Page_Load(object sender, EventArgs e)
        {
            object obj = ActionTool.DeserializeParameter("Id", Context);
            if (obj!=null&&obj.ToString()!="")
            {
                string id = obj.ToString();
                ReportTemplateService rts = new ReportTemplateService();
                rte = rts.Get(id);
            }
        }
    }
}