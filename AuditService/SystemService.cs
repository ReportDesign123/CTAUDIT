using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditSPI;
using CtTool;
using DbManager;
using AuditEntity;
using GlobalConst;

namespace AuditService
{
   public class SystemService:ISystemService
    {
       LinqDataManager linqDbManager;
       CTDbManager dbManager;
       public SystemService()
       {
           if (linqDbManager == null)
           {
               linqDbManager = new LinqDataManager();
           }
           if (dbManager == null)
           {
               dbManager = new CTDbManager();
           }
       }
       public void Save(ConfigEntity config)
       {
           try
           {
               if (StringUtil.IsNullOrEmpty(config.Id))
               {
                   config.Id = Guid.NewGuid().ToString();
               }
               linqDbManager.InsertEntity<ConfigEntity>(config);
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }

        public void Edit(AuditEntity.ConfigEntity config)
        {
            try
            {
                ConfigEntity ce = Get(config.Id);
                BeanUtil.CopyBeanToBean(config, ce);
                linqDbManager.UpdateEntity<ConfigEntity>(ce);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public AuditEntity.ConfigEntity Get(string id)
        {
            try
            {
               
                return linqDbManager.GetEntity<ConfigEntity>(r => r.Id == id);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }




        public DataGrid<ConfigEntity> DataGrid(ConfigEntity config, DataGrid<ConfigEntity> dataGrid)
        {
            try
            {
                string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<ConfigEntity>(config);
                if(!StringUtil.IsNullOrEmpty(whereSql)){
                    whereSql=" WHERE "+whereSql;
                }

                DataGrid<ConfigEntity> dg = new DataGrid<ConfigEntity>();
                string sql = "SELECT * FROM CT_BASIC_CONFIG   "+whereSql;
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<ConfigEntity>();
                string countSql = "SELECT COUNT(*) FROM CT_BASIC_CONFIG  " + whereSql;
                string sortName = maps[dataGrid.sort];
                dg.rows = dbManager.ExecuteSqlReturnTType<ConfigEntity>(sql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
                dg.total = dbManager.Count(countSql);
                return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public ConfigEntity GetConfigByName(string Name)
        {
            try
            {
                ConfigEntity ce = linqDbManager.GetEntity<ConfigEntity>(r => r.Name == Name);
                return ce;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public List<ConfigEntity> GetWorkFlows()
        {
            try
            {
                string sql = "SELECT * FROM CT_BASIC_CONFIG WHERE CONFIG_NAME IN ('"+ReportGlobalConst.REPORTEXAM_CONFIGNAME +"')";
                return dbManager.ExecuteSqlReturnTType<ConfigEntity>(sql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public void SaveLog(LogEntity le)
        {
            try
            {
                if (StringUtil.IsNullOrEmpty(le.Id))
                {
                    le.Id = Guid.NewGuid().ToString();
                }
                le.CreateTime = SessoinUtil.GetCurrentDateTime();
                linqDbManager.InsertEntity<LogEntity>(le);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataGrid<LogEntity> LogDataGrid(LogEntity le, DataGrid<LogEntity> dataGrid)
        {
            try
            {
                string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<LogEntity>(le);
                if (!StringUtil.IsNullOrEmpty(whereSql))
                {
                    whereSql = " WHERE " + whereSql;
                }

                DataGrid<LogEntity> dg = new DataGrid<LogEntity>();
                string sql = "SELECT * FROM CT_BASIC_LOG   " + whereSql;
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<LogEntity>();
                string countSql = "SELECT COUNT(*) FROM CT_BASIC_LOG  " + whereSql;
                string sortName = maps[dataGrid.sort];
                dg.rows = dbManager.ExecuteSqlReturnTType<LogEntity>(sql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
                dg.total = dbManager.Count(countSql);
                return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
