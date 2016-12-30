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
    public partial class DataSourceAdd : System.Web.UI.Page
    {
        public DataSourceEntity dse = new DataSourceEntity();
        protected void Page_Load(object sender, EventArgs e)
        {
            DataSourceEntity temp = ActionTool.DeserializeParameters<DataSourceEntity>(Context, "get");
            if (!StringUtil.IsNullOrEmpty(temp.Id))
            {
                DataSourceService dss = new DataSourceService();
                dse = dss.Get(temp);
            }
        }
    }
}