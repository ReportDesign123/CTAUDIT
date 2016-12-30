using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.ReportProblem;

namespace AuditSPI.ReportProblem
{
    public  interface IReportProblem
    {
        void Add(ReportProblemEntity rpe);
        void Edit(ReportProblemEntity rpe);
        void Delete(ReportProblemEntity rpe);
        DataGrid<ReportProblemEntity> DataGridReportProblemEntity(DataGrid<ReportProblemEntity> dataGrid, ReportProblemEntity rpe);
        ReportProblemEntity Get(ReportProblemEntity rpe);
        List<ReportProblemEntity> GetReportProblems(string ReportAuditId);
        List<ReportProblemEntity> ExportReportProblems(string AuditId);
        Dictionary<string, int> GetProblemProcessData(ReportProblemEntity reportProblemEntity);
    }
}
