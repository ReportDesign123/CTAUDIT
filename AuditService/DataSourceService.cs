using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity;
using AuditSPI;
using DbManager;
using CtTool;
using System.Data.Common;

namespace AuditService
{
    public   class DataSourceService:IDataSource
    {
        ILinqDataManager linqDbManager;
        IDbManager dbManager;
        public DataSourceService()
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
        public void Save(DataSourceEntity dse)
        {
            try
            {
                if(StringUtil.IsNullOrEmpty(dse.Id)){
                    dse.Id = Guid.NewGuid().ToString();
                }
                dse.Default = "0";
                dse.State = "1";
                CTDbType type = DBTool.GetDbType(dse.DbType);
                dse.DbConnection = DBTool.CreateSqlConnection(dse.UserName, dse.UserPassword, dse.Server, dse.Db, type);
                dse.DbProvider = DBTool.CreateDbProvider(type);
                linqDbManager.InsertEntity<DataSourceEntity>(dse);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataSourceEntity Get(DataSourceEntity dse)
        {
            try
            {
                DataSourceEntity temp = linqDbManager.GetEntity<DataSourceEntity>(r => r.Id == dse.Id);
                return temp;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void Edit(DataSourceEntity dse)
        {
            try
            {
                DataSourceEntity te = linqDbManager.GetEntity<DataSourceEntity>(r=>r.Id==dse.Id);
                BeanUtil.CopyBeanToBean(dse, te);
                CTDbType type = DBTool.GetDbType(dse.DbType);
                te.DbConnection = DBTool.CreateSqlConnection(dse.UserName, dse.UserPassword, dse.Server, dse.Db, type);
                te.DbProvider = DBTool.CreateDbProvider(type);
                linqDbManager.UpdateEntity<DataSourceEntity>(te);

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void Delete(DataSourceEntity dse)
        {
            try
            {
                DataSourceEntity te = linqDbManager.GetEntity<DataSourceEntity>(r => r.Id == dse.Id);
                linqDbManager.Delete<DataSourceEntity>(te);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataGrid<DataSourceEntity> DataGrid(DataGrid<DataSourceEntity> dg, DataSourceEntity dse)
        {
            try
            {
                DataGrid<DataSourceEntity> dataGrid = new DataGrid<DataSourceEntity>();
                string whereSql = BeanUtil.ConvertObjectToWhereSqls<DataSourceEntity>(dse);
                string sql = "SELECT * FROM CT_BASIC_DATASOURCE WHERE 1=1 " + whereSql;

                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<DataSourceEntity>();

                List<DataSourceEntity> lists = dbManager.ExecuteSqlReturnTType<DataSourceEntity>(sql);
                string count = "SELECT COUNT(*) FROM CT_BASIC_DATASOURCE WHERE 1=1 " + whereSql;
                string sortName = maps[dg.sort];

                dataGrid.rows = dbManager.ExecuteSqlReturnTType<DataSourceEntity>(sql, dg.page, dg.pageNumber, sortName + " " + dg.order, maps);
                dataGrid.total = dbManager.Count(count);
                return dataGrid;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void SetDefault(DataSourceEntity dse)
        {
            try
            {
                string updateSql = "UPDATE CT_BASIC_DATASOURCE SET DATASOURCE_DEFAULT='1' WHERE DATASOURCE_ID='"+dse.Id+"'";
                dbManager.ExecuteSql(updateSql);
                updateSql = "UPDATE CT_BASIC_DATASOURCE SET DATASOURCE_DEFAULT='0' WHERE DATASOURCE_ID!='" + dse.Id + "'";
                dbManager.ExecuteSql(updateSql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 获取数据库实例列表
        /// </summary>
        /// <param name="dse"></param>
        /// <returns></returns>
        public List<NameValueStruct> DataSourceInstances(DataSourceEntity dse)
        {
            try
            {
                string sql = "SELECT NAME AS name ,NAME AS value FROM master..sysdatabases";
                DataSource ds = new DataSource();
                CTDbType type = DBTool.GetDbType(dse.DbType);
                ds.ConnectionString = DBTool.CreateMasterConnection(dse.UserName, dse.UserPassword,dse.Server,type);
                ds.DataProviderName = DBTool.CreateDbProvider(type);
                ds.DbType = dse.DbType;
                DbDataSourceInstance dsi = new DbDataSourceInstance(ds);
                Dictionary<string, string> maps = new Dictionary<string, string>();
                maps.Add("name","name");
                maps.Add("value","value");

                List<NameValueStruct> lists = dsi.ExecuteSqlReturnTTypeByFields<NameValueStruct>(sql, maps);
                return lists;
                
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void TestDataSource(DataSourceEntity dse)
        {
            try
            {
                DataSource ds = new DataSource();
                CTDbType type = DBTool.GetDbType(dse.DbType);
                ds.ConnectionString = DBTool.CreateSqlConnection(dse.UserName, dse.UserPassword, dse.Server,dse.Db, type);
                ds.DataProviderName = DBTool.CreateDbProvider(type);
                DbDataSourceInstance dsi = new DbDataSourceInstance(ds);

                dsi.Open();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
