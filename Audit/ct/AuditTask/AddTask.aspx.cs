using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AuditEntity.AuditTask;
using AuditService.AuditTask;
using CtTool;

namespace Audit.ct.AuditTask
{
    public partial class AddTask : System.Web.UI.Page
    {
        public AuditTaskEntity ate = new AuditTaskEntity();
        protected void Page_Load(object sender, EventArgs e)
        {
            object IdObj = ActionTool.DeserializeParameter("Id", Context);
            if (!StringUtil.IsNullOrEmpty(IdObj))
            {
                AuditTaskService ats=new AuditTaskService();
                string id = IdObj.ToString();
                ate = ats.Get(id);

            }
        }
    }
}