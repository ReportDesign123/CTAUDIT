using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AuditService.ExportReport;
using AuditEntity.ExportReport;
using AuditSPI.ExportReport;
using AuditSPI;
using CtTool;
namespace Audit.ct.ExportReport
{
    public partial class AddBookmarkTemplate : System.Web.UI.Page
    {
        public BookmarkTemplateEntity bte = new BookmarkTemplateEntity();
        IBookmarkTemplate BookmarkTemplateService = new BookmarkTemplateService();
        protected void Page_Load(object sender, EventArgs e)
        {
            BookmarkTemplateEntity temp = ActionTool.DeserializeParameters<BookmarkTemplateEntity>(Context, GlobalConst.BasicGlobalConst.POSTTYPE_GET);
            if (!StringUtil.IsNullOrEmpty(temp.Id))
            {
                bte = BookmarkTemplateService.GetBookmarkTemplateEntity(temp);
            }
        }
    }
}