using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AuditService.ReportAggregation;
using AuditEntity.ReportAggregation;
using CtTool;


namespace Audit.ct.ReportData.ReportAggregation
{
    public partial class ReportList : System.Web.UI.Page
    {
        AggregationTemplateEntity ate = new AggregationTemplateEntity();
        protected void Page_Load(object sender, EventArgs e)
        {
            AggregationLogEntity temp = ActionTool.DeserializeParameters<AggregationLogEntity>(Context, GlobalConst.BasicGlobalConst.POSTTYPE_GET);
            ate.Id = temp.TemplateId;
            ReportAggregationService ras = new ReportAggregationService();
            Response.Write("<script>var para={logEntity:" + JsonTool.WriteJsonStr<AggregationLogEntity>(temp) + ",template:" + JsonTool.WriteJsonStr<AggregationTemplateEntity>(ras.GetAggregationTemplate(ate)) + "}</script>");
        }
    }
}