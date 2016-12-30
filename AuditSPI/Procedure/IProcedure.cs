using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.Procedure;

namespace AuditSPI.Procedure
{
   public   interface IProcedure
    {
       DataGrid<ProcedureEntity> GetProcedureDataGrid(DataGrid<ProcedureEntity> dataGrid, ProcedureEntity pe);
       List<ProcedureParameterEntity> GetParametersByProcedure(int procedureId, string DataSourceId);
    }
}
