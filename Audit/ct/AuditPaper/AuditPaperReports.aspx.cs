using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AuditService.AuditPaper;
using AuditEntity.AuditPaper;
using CtTool;

namespace Audit.ct.AuditPaper
{
    public partial class AuditPaperReports : System.Web.UI.Page
    {
        AuditPaperService aps = new AuditPaperService();
        
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Write("<script>var rows={Rows:"+JsonTool.WriteJsonStr<List<AuditPaperEntity>>(aps.GetAuditPaperLists())+"}</script>");
        }
    }
}