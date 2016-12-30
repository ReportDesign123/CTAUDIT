using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AuditEntity;
using AuditService;
using CtTool;

namespace Audit.ct.basic
{
    public partial class ReportClassifyManager : System.Web.UI.Page
    {
        ReportClassifyService rcs = new ReportClassifyService();
        protected void Page_Load(object sender, EventArgs e)
        {
            ReportClassifyEntity rce = new ReportClassifyEntity();
            Response.Write("<script>var rows={Rows:" + JsonTool.WriteJsonStr<List<ReportClassifyEntity>>(rcs.GetClassifiesList(rce)) + "}</script>");
        }
    }
}