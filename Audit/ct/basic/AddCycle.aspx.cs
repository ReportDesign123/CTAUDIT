using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AuditSPI;
using AuditService;
using AuditEntity;
using CtTool;

namespace Audit.ct.basic
{
    public partial class AddCycle : System.Web.UI.Page
    {
        public  CycleEntity de = new CycleEntity();
        protected void Page_Load(object sender, EventArgs e)
        {
            CycleEntity temp = ActionTool.DeserializeParameters<CycleEntity>(Context, GlobalConst.BasicGlobalConst.POSTTYPE_GET);
            if (!StringUtil.IsNullOrEmpty(temp.Id))
            {
                CycleService ats = new CycleService();
                de = ats.GetCycle(temp);
                
            }
        }
    }
}