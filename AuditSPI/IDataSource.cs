using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity;

namespace AuditSPI
{
    public  interface IDataSource
    {
        void Save(DataSourceEntity dse);
        void Edit(DataSourceEntity dse);
        void Delete(DataSourceEntity dse);
        DataGrid<DataSourceEntity> DataGrid(DataGrid<DataSourceEntity> dg, DataSourceEntity dse);
        List<NameValueStruct> DataSourceInstances(DataSourceEntity dse);
        void TestDataSource(DataSourceEntity dse);
        DataSourceEntity Get(DataSourceEntity dse);
        void SetDefault(DataSourceEntity dse);
    }
}
