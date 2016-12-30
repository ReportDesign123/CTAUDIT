using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AuditEntity.AuditTask;
using AuditService.AuditTask;
using CtTool;

namespace Audit.ct.AuditTask
{
    public partial class AuditTaskAndAuditPapers : System.Web.UI.Page
    {
        AuditTaskService ats = new AuditTaskService();
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Write("<script>var rows={Rows:" + JsonTool.WriteJsonStr<List<AuditTaskEntity>>(ats.GetAuditTaskLists()) + "}</script>");
        }
    }
}