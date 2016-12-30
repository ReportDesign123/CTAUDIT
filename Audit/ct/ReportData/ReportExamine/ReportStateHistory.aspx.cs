using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AuditEntity.ReportState;
using CtTool;

namespace Audit.ct.ReportData.ReportExamine
{
    public partial class ReportStateHistory : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            ReportStateDetailEntity rsde = ActionTool.DeserializeParameters<ReportStateDetailEntity>(Context, GlobalConst.BasicGlobalConst.POSTTYPE_GET);
            Response.Write("<script>var rsde = "+JsonTool.WriteJsonStr<ReportStateDetailEntity>(rsde)+"</script>");
        }
    }
}