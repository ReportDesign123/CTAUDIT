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
    public partial class AddDic : System.Web.UI.Page
    {
        public DictionaryEntity de = new DictionaryEntity();
        protected void Page_Load(object sender, EventArgs e)
        {
            DictionaryEntity    temp = ActionTool.DeserializeParameters<DictionaryEntity>(Context, GlobalConst.BasicGlobalConst.POSTTYPE_GET);
            if (!StringUtil.IsNullOrEmpty(temp.Id))
            {
                DictionaryService ds = new DictionaryService();
                de = ds.GetDictionary(temp);
            }
        }
    }
}