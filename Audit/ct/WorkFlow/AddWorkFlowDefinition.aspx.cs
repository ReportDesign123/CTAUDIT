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
    public partial class AddWorkFlowDefinition : System.Web.UI.Page
    {
        public WorkFlowDefinition wfd = new WorkFlowDefinition();

        protected void Page_Load(object sender, EventArgs e)
        {
            wfd = ActionTool.DeserializeParameters<WorkFlowDefinition>(Context, "get");
            if (!StringUtil.IsNullOrEmpty(wfd.Id))
            {
                WorkFlowDefinitionService wfs = new WorkFlowDefinitionService();
                wfd = wfs.GetWorkFlow(wfd);
            }
        }
    }
}