using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CtTool;
namespace Audit.ct.ReportData
{
    public partial class ReportXmShow : System.Web.UI.Page
    {
        public string parame = "", p_title="";
        protected void Page_Load(object sender, EventArgs e)
        {
            parame = Convert.ToString(ActionTool.DeserializeParameter("para", Context));
            parame = Base64.Encode64(parame);
            p_title = "报表联查";
            string curCompany = CtTool.SessoinUtil.GetCurrentCompanyId();
            string curRoleId = CtTool.SessoinUtil.GetCurrentUser().RoleId;
            Response.Write("<Script>var curCompany='" + curCompany + "';var curRoleId='" + curRoleId + "';</Script>");
        }
    }
}