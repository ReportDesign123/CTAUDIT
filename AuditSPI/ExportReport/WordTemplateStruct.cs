using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.ExportReport;

namespace AuditSPI.ExportReport
{
    public  class WordTemplateStruct
    {
        public List<BookmarkEntity> Bookmarks = new List<BookmarkEntity>();
        public string wordContent = "";
        public ReportTemplateEntity reportTemplate = new ReportTemplateEntity();
        
    }
}
