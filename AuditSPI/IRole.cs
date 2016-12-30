using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity;

namespace AuditSPI
{
    public  interface IRole
    {
        /// <summary>
        /// 获取数据分页列表
        /// </summary>
        /// <param name="dataGrid"></param>
        DataGrid<RoleEntity> GetDataGrid(DataGrid<RoleEntity> dataGrid,RoleEntity roleEntity);
        void Save(RoleEntity roleEntity);
        void Edit(RoleEntity roleEdity);
        void Delete(RoleEntity roleEdit);
        RoleEntity get(string id);
        void BatchUpdate(List<RoleAndFunctionsEntity> roleEntities);
        List<RoleEntity> GetList();
        
      
    }
}
