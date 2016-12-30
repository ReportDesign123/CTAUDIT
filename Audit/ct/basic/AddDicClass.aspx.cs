using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AuditEntity;
using AuditService;
using AuditSPI;
using CtTool;

namespace Audit.ct.basic
{
    public partial class AddDicClass : System.Web.UI.Page
    {
        public DictionaryClassificationEntity dce = new DictionaryClassificationEntity();
        protected void Page_Load(object sender, EventArgs e)
        {
            DictionaryClassificationEntity temp=ActionTool.DeserializeParameters<DictionaryClassificationEntity>(Context,GlobalConst.BasicGlobalConst.POSTTYPE_GET);
            if (!StringUtil.IsNullOrEmpty(temp.Id))
            {
                DictionaryService ds = new DictionaryService();
                dce = ds.GetDictionaryClassify(temp);
            }
        }
    }
}