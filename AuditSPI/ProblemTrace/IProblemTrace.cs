using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.ReportProblem;


namespace AuditSPI.ProblemTrace
{
    public  interface IProblemTrace
    {
        DataGrid<ReportProblemEntity> DataGridReportProblemEntity(DataGrid<ReportProblemEntity> dataGrid, ReportProblemEntity rpe);
        void AddProblem(ReportProblemEntity reportProblemEntity);
        void EditProblem(ReportProblemEntity reportProblemEntiy);
        void Delete(string ids);
        ReportProblemEntity GetProblem(ReportProblemEntity reportProblemEntity);
        void ChangeReportProblemState(ReportProblemEntity reportProblemEntiy);      
        void AddReportProblemReturn(ReportProblemEntity reportProblemEntiy);
    }
}
