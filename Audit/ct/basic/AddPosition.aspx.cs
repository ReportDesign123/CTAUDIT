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
    public partial class AddPosition : System.Web.UI.Page
    {
        public PositionEntity position = new PositionEntity();
        protected void Page_Load(object sender, EventArgs e)
        {
            PositionEntity temp = ActionTool.DeserializeParameters<PositionEntity>(Context, GlobalConst.BasicGlobalConst.POSTTYPE_GET);
            if (!StringUtil.IsNullOrEmpty(temp.Id))
            {
                PositionService ds = new PositionService();
                position = ds.get(temp);
            }
        }
    }
}