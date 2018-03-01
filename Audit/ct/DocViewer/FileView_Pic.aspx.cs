using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Audit.ct.DocViewer
{
    public partial class FileView_Pic : System.Web.UI.Page
    {
        public string FileId = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            FileId = Request.QueryString["fileId"];

           
           

        }
    }
}