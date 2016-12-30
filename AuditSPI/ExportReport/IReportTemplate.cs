using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.ExportReport;

namespace AuditSPI.ExportReport
{
    public  interface IReportTemplate
    {
        DataGrid<ReportTemplateEntity> GetReportTemplateDataGrid(DataGrid<ReportTemplateEntity> dataGrid, ReportTemplateEntity reportTemplate);
        void SaveReportTemplate(ReportTemplateEntity reportTemplate);
        void EditReportTemplate(ReportTemplateEntity reportTemplate);
        void DeleteReportTemplate(ReportTemplateEntity reportTemplate);
        ReportTemplateEntity GetReportTemplate(ReportTemplateEntity reportTemplate);
        void UpdateReportTemplateBookmarks(ReportTemplateEntity reportTemplate,List<string> bookmarks);
    }
}
