using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.WorkFlow;

namespace AuditSPI.WorkFlow
{
    public  interface IWorkFlowBusinessDefinition
    {
        void EditBusinessEntity(WorkFlowBusinessEntity wfbe);
        WorkFlowBusinessEntity GetBusinessEntity(WorkFlowBusinessEntity wfbe);
        DataGrid<WorkFlowBusinessEntity> DataGridBusinessEntity(WorkFlowBusinessEntity wfbe, DataGrid<WorkFlowBusinessEntity> dataGrid);
        void DeleteBusinessEntity(WorkFlowBusinessEntity wfbe);
        void AddBusinessEntity(WorkFlowBusinessEntity wfbe);
    }
}
