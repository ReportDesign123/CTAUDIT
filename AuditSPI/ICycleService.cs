using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity;

namespace AuditSPI
{
    public interface ICycleService
    {

        DataGrid<CycleEntity> GetCycleList(DataGrid<CycleEntity> dataGrid, CycleEntity de);
        
        void SaveCycle(CycleEntity de);

        void UpdateCycle(CycleEntity de);
        void DeleteCycle(CycleEntity de);

        CycleEntity GetCycle(CycleEntity de);

        CycleEntity GetCycleInfor(string YWRQ);
    }
}
