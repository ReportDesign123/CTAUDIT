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
    public partial class ProblemsManager : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string param = Convert.ToString(ActionTool.DeserializeParameter("para", Context));
            param = HttpUtility.UrlDecode(param);
            ReportAuditEntity temp = JsonTool.DeserializeObject<ReportAuditEntity>(param);
            Response.Write("<script>var reportParam=" + JsonTool.WriteJsonStr(temp) + ";</script>");
        }
    }
}