using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.ReportState;

namespace AuditSPI.ReportState
{
    /// <summary>
    /// 上级审核接口
    /// </summary>
    public  interface IReportHigherExamine
    {
        DataGrid<ReportStateEntity> GetHigherExamOrCancelReportStateDataGrid(DataGrid<ReportStateEntity> dataGrid, ReportStateEntity rse, bool flag);
        void HigherExamReportState(ReportStateEntity rse);
      
    }
}
