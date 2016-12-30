using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity;

namespace AuditSPI
{
    public interface ICpara
    {
        void Save(CparaEntity cparaEntity);
        void Edit(CparaEntity cparaEntity);
        void Delete(CparaEntity cparaEntity);
        CparaEntity Get(string id);
        DataGrid<CparaEntity> GetDataGrid(DataGrid<CparaEntity> dataGrid, CparaEntity cparaEntity);
   
        List<CparaEntity> GetList();
    }
}
