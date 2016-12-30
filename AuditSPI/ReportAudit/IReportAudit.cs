using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.ReportAudit;
using AuditSPI.ReportData;

namespace AuditSPI.ReportAudit
{
    public  interface IReportAudit
    {
        DataGrid<ReportAuditEntity> DataGridReportAuditEntity(DataGrid<ReportAuditEntity> dataGrid, ReportAuditEntity rae);
        void Save(ReportAuditEntity rae);
        void Update(ReportAuditEntity rae);
        void Delete(ReportAuditEntity rae);
         void InsertReportAudit(ReportAuditEntity rae);
         ReportAuditEntity GetReportAudit(ReportAuditEntity rae);
         void AuditClose(string ids,bool isOrNotClose);
        
  
    }
}
