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
    public partial class AddCpara : System.Web.UI.Page
    {
        public CparaEntity cparaEntity = new CparaEntity();

        public string ParaName = "";
       protected void Page_Load(object sender, EventArgs e)
       {
           string Id = Convert.ToString(Request.QueryString["Id"]);
            if (Id != null)
            {
                
                CparaService rs = new CparaService();
                cparaEntity = rs.Get(Id);
                
               
            }
              
           
       }
    }
}