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
    public partial class AddConfig : System.Web.UI.Page
    {
      public   ConfigEntity config = new ConfigEntity();
        protected void Page_Load(object sender, EventArgs e)
        {
            object id = ActionTool.DeserializeParameter("Id", Context);
            if (!StringUtil.IsNullOrEmpty(id))
            {
                SystemService ss=new SystemService();
                config = ss.Get(id.ToString());
            }
        }
    }
}