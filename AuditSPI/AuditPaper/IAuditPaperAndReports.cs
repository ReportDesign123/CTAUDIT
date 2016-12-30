using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.AuditPaper;
using AuditEntity;

namespace AuditSPI.AuditPaper
{
    public  interface IAuditPaperAndReports
    {
        List<AuditPaperEntity> GetAuditPaperLists();
        Dictionary<string, List<ReportFormatDicEntity>> GetAuditPaperReports(string AuditPaperId);
        void BatchUpdataReports(string AuditPaperId,List<AuditPaperAndReportEntity> apares);
        DataGrid<ReportFormatDicEntity> GetReportsByPaperId(DataGrid<ReportFormatDicEntity> dg, string PaperCode,ReportFormatDicEntity rfe);
        DataGrid<ReportFormatDicEntity> GetReportsByPaperId2(DataGrid<ReportFormatDicEntity> dataGrid, string PaperId, ReportFormatDicEntity rfde);
    }
}
