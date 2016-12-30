using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AuditSPI.ReportAudit;
using AuditService.ReportAudit;
using AuditService;
using AuditEntity.ReportAudit;
using CtTool;

namespace Audit.ct.ReportAudit
{
    public partial class CustomerReportLink : System.Web.UI.Page
    {
        ReportAuditCellIndexData reportService = new ReportAuditCellIndexData();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                string param = Convert.ToString(ActionTool.DeserializeParameter("data", Context));
                param = Base64.Decode64(param);
                string des = Convert.ToString(ActionTool.DeserializeParameter("des", Context));
                des = Base64.Decode64(des);
                ReportAuditCellConclusion reportAuditCellConclusion = JsonTool.DeserializeObject<ReportAuditCellConclusion>(param);
                CustomerJoinStruct CustomerJoinStruct = JsonTool.DeserializeObject<CustomerJoinStruct>(des);
                CustomerGridDataStruct data = reportService.GetCustomerReportLinkData(reportAuditCellConclusion, CustomerJoinStruct);
                Response.Write("<script>var para={data:" + JsonTool.WriteJsonStr<CustomerGridDataStruct>(data) + "}</script>");
            }
            catch (Exception ex)
            {
                Response.Write("<script>var para={data:{},error:'"+Server.UrlEncode(ex.Message)+"'}</script>");
            }
        }
    }
}