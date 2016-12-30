using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.AuditPaper;

namespace AuditSPI.AuditPaper
{
    public  interface IReportTemplate
    {
       void Save(ReportTemplateEntity reportTemplate);
       void Edit(ReportTemplateEntity reportTemplate);
       void  Delete(ReportTemplateEntity reportTemplate);
       DataGrid<ReportTemplateEntity> getDataGrid(DataGrid<ReportTemplateEntity> dataGrid,ReportTemplateEntity rte);
       ReportTemplateEntity Get(string id);
    }
}
