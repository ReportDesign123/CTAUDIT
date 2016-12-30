using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.ExportReport;

namespace AuditSPI.ExportReport
{
    public  interface IReportTemplateBookmark
    {
        WordTemplateStruct GetWordTemplateStruct(ReportTemplateEntity reportTemplate);
        void SaveWordTemplateStruct(WordTemplateStruct wordTemplate);
        List<BookmarkEntity> GetBookmarksByTemplateId(string templateId);
    }
}
