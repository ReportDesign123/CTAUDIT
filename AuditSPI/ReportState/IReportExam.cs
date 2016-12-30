using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditSPI.ReportData;
using AuditEntity.ReportState;
using AuditEntity;

namespace AuditSPI.ReportState
{
    public interface IReportExam
    {
        DataGrid<ReportStateEntity> GetExamOrCancelReportStateDataGrid(DataGrid<ReportStateEntity> dataGrid, ReportStateEntity rse,bool flag);
        void ExamReportState(ReportStateEntity rse);
        DataGrid<ReportStateDetailEntity> GetMyExamReportHistoryGrid(DataGrid<ReportStateDetailEntity> dataGrid, ReportStateDetailEntity rsde);
        DataGrid<ReportStateDetailEntity> GetAllHistoryGrid(DataGrid<ReportStateDetailEntity> dataGrid, ReportStateDetailEntity rsde);
        DataGrid<ReportStateEntity> GetAllReportsStateDataGrid(DataGrid<ReportStateEntity> dataGrid, ReportStateEntity rse);
        void ReportExamineWorkFlowPublish(ConfigEntity ce);
    }
}
