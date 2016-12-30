using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AuditEntity.ReportAttatch;
using CtTool;

namespace Audit.ct.ReportData
{
    public partial class UploadMiddle : System.Web.UI.Page
    {
        public ReportAttatchEntity rae = new ReportAttatchEntity();
        protected void Page_Load(object sender, EventArgs e)
        {
            rae = ActionTool.DeserializeParameters<ReportAttatchEntity>(Context, "get");
        }
    }
}