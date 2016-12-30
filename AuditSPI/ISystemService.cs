using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity;


namespace AuditSPI
{
  public    interface ISystemService
    {
      void Save(ConfigEntity config);
        void Edit(ConfigEntity config);
        ConfigEntity Get(string id);
        DataGrid<ConfigEntity> DataGrid(ConfigEntity config,DataGrid<ConfigEntity>dg);
        ConfigEntity GetConfigByName(string Name);
        List<ConfigEntity> GetWorkFlows();

        void SaveLog(LogEntity le);
        DataGrid<LogEntity> LogDataGrid(LogEntity lg, DataGrid<LogEntity> dg);

    }
}
