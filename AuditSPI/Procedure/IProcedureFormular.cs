using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditSPI;
using AuditEntity.Procedure;

namespace AuditSPI.Procedure
{
   public  interface IProcedureFormular
    {
       DataGrid<ProcedureFormularEntity> DataGridProcedureFormularEntities(DataGrid<ProcedureFormularEntity>dataGrid,ProcedureFormularEntity pfe);
       void AddProcedureFormularEntity(ProcedureFormularEntity pfe);
       void EditProcedureFormularEntity(ProcedureFormularEntity pfe);
       void DeleteProcedureFormularEntity(ProcedureFormularEntity pfe);
       ProcedureFormularEntity GetProcedureFormularEntity(string id);
    }
}
