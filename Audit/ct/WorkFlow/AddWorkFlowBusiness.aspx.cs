using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AuditEntity.WorkFlow;
using AuditService.WorkFlow;
using CtTool;

namespace Audit.ct.WorkFlow
{
    public partial class AddWorkFlowBusiness : System.Web.UI.Page
    {
        public  WorkFlowBusinessEntity wfbe = new WorkFlowBusinessEntity();
        protected void Page_Load(object sender, EventArgs e)
        {
            wfbe = ActionTool.DeserializeParameters<WorkFlowBusinessEntity>(Context, "get");
            if (!StringUtil.IsNullOrEmpty(wfbe.Id))
            {
                WorkFlowDefinitionService wfs = new WorkFlowDefinitionService();
                wfbe = wfs.GetBusinessEntity(wfbe);
            }
        }
    }
}