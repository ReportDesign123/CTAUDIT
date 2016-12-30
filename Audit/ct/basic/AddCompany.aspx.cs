using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AuditService;
using AuditEntity;
using AuditSPI;
using CtTool;

namespace Audit.ct.basic
{
    public partial class AddCompany : System.Web.UI.Page
    {
      public   CompanyEntity company = new CompanyEntity();
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyEntity temp = ActionTool.DeserializeParameters<CompanyEntity>(Context, GlobalConst.BasicGlobalConst.POSTTYPE_GET);
            if (!StringUtil.IsNullOrEmpty(temp.Id))
            {
                CompanyService ds = new CompanyService();
                company = ds.get(temp);
            }
        }
    }
}