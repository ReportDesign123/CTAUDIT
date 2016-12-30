using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AuditSPI;
using AuditService;
using AuditEntity;

namespace Audit.ct.basic
{
    
    public partial class AddRole : System.Web.UI.Page
    {
        public RoleEntity roleEntity = new RoleEntity();
        protected void Page_Load(object sender, EventArgs e)
        {
            string Id = Convert.ToString(Request.QueryString["Id"]);
            if (Id != null)
            {
                RoleService rs = new RoleService();
                roleEntity = rs.get(Id);
            }

        }
    }
}