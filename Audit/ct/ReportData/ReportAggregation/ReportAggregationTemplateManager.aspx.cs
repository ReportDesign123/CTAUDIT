using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AuditEntity.ReportAggregation;
using AuditService.ReportAggregation;
using CtTool;


namespace Audit.ct.ReportData.ReportAggregation
{
    public partial class ReportAggregationTemplateManager : System.Web.UI.Page
    {
        ReportAggregationService ras = new ReportAggregationService();
        protected void Page_Load(object sender, EventArgs e)
        {
            AggregationClassifyEntity rce = new AggregationClassifyEntity();
            Response.Write("<script>var rows={Rows:" + JsonTool.WriteJsonStr<List<AggregationClassifyEntity>>(ras.GetAggregationClassifys(rce)) + "}</script>");
        }
    }
}