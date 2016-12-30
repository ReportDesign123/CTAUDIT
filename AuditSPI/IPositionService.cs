using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity;


namespace AuditSPI
{
    public  interface IPositionService
    {
        List<PositionEntity> GetPositionList(PositionEntity position);
        void Save(PositionEntity position);
        void Edit(PositionEntity position);
        void Delete(PositionEntity position);
        PositionEntity get(PositionEntity position);
        List<TreeNode> ParentCombo();
        List<TreeNode> WorkFlowCombo();
        DataGrid<PositionEntity> GetPositionDataGrid(DataGrid<PositionEntity> dataGrid, PositionEntity pe);
    }
}
