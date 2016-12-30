using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.AuditTask;

namespace AuditSPI.AuditTask
{
   public   interface IAuditTask
    {
      void  Save(AuditTaskEntity ate);
      void   Edit(AuditTaskEntity ate);
      void   Delete(AuditTaskEntity ate);
       AuditTaskEntity Get(string Id);
       DataGrid<AuditTaskEntity> GetDataGrid(DataGrid<AuditTaskEntity> dg,AuditTaskEntity ate);
       DataGrid<AuditTaskEntity> GetDataGrid(string AuditType, string AuditDate, DataGrid<AuditTaskEntity> dg);
       AuditSPI.DataGrid<AuditEntity.AuditTask.AuditTaskEntity> GetAuthorityDataGrid(AuditSPI.DataGrid<AuditEntity.AuditTask.AuditTaskEntity> dg, AuditTaskEntity ate);
    }
}
