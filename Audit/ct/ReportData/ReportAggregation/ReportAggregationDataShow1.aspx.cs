using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CtTool;

namespace Audit.ct.ReportData.ReportAggregation
{

    public partial class ReportAggregationDataShow1 : System.Web.UI.Page
    {
        public string parame = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            parame = Convert.ToString(ActionTool.DeserializeParameter("para", Context));
            parame = Base64.Encode64(parame);
        }

    }
}