using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditSPI.ReportData;
using AuditEntity.ReportState;

namespace AuditSPI.ReportState
{
    public interface IReportLock
    {
        void AddLock(ReportDataParameterStruct rdps);
        void RemoveLock(ReportDataParameterStruct rdps);
        List<ReportLockEntity> ReportLockList(ReportDataParameterStruct rdps);
        bool AllowWrite(ReportDataParameterStruct rdps);
        DataGrid<ReportLockEntity> GetReportLockEntiesDataGrid(DataGrid<ReportLockEntity> dataGrid, ReportLockEntity rle);
        void RemoveLocks(string ids);
    }
}
