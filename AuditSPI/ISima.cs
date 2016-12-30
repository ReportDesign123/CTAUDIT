using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity;

namespace AuditSPI
{
    public  interface ISima
    {
        DataGrid<SimaEntity> GetSimaList(DataGrid<SimaEntity> dataGrid,SimaEntity se);
    }
}
