using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CtTool;


namespace Audit.ct.ReportData
{
    public partial class FillReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string curCompany = CtTool.SessoinUtil.GetCurrentCompanyId();
            Response.Write("<Script>var curCompany='"+curCompany+"';</Script>");
        }
    }
}