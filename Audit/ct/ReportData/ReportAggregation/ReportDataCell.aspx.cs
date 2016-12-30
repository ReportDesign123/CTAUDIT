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
    public partial class ReportDataCell : System.Web.UI.Page
    {
        public string param;
        protected void Page_Load(object sender, EventArgs e)
        {
            param = Convert.ToString(ActionTool.DeserializeParameter("para", Context));
            if (!StringUtil.IsNullOrEmpty(param))
            {
                param =  Base64.Encode64(param);
            }
        }
    }
}