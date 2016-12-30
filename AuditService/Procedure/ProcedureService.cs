using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Common;
using System.Data;
using AuditSPI.Procedure;
using AuditSPI;
using AuditService;
using DbManager;
using AuditEntity.Procedure;
using CtTool;
using AuditEntity;


namespace AuditService.Procedure
{
    public class ProcedureService : IProcedure, IProcedureFormular
    {
        IDbManager dbManager;
        LinqDataManager linqDbManager;
        public ProcedureService()
        {
            if (dbManager == null)
            {
                dbManager = new CTDbManager();
            }
            if (linqDbManager == null)
            {
                linqDbManager = new LinqDataManager();
            }
        }
        /// <summary>
        /// 获取数据库存储过程列表；
        /// 此方法需要区分SQLSERVER和ORACLE
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="pe"></param>
        /// <returns></returns>
        public AuditSPI.DataGrid<AuditEntity.Procedure.ProcedureEntity> GetProcedureDataGrid(AuditSPI.DataGrid<AuditEntity.Procedure.ProcedureEntity> dataGrid, AuditEntity.Procedure.ProcedureEntity pe)
        {
            try
            {
                DataGrid<ProcedureEntity> dg=new DataGrid<ProcedureEntity>();
                if (dbManager.GetDbType() == CTDbType.SQLSERVER)
                {
                    string sql = "SELECT name,object_id FROM SYS.OBJECTS WHERE TYPE='P' ";
                    string countSql = "SELECT count(*) FROM SYS.OBJECTS WHERE TYPE='P'";

                    if (!StringUtil.IsNullOrEmpty(pe.Name))
                    {
                        sql += " AND name like '%"+pe.Name+"%'";
                        countSql += " AND name like '%" + pe.Name + "%'";
                    }
                    if (!StringUtil.IsNullOrEmpty(pe.Id))
                    {
                        if (pe.Id != 0)
                        {
                            sql += " AND object_id like '%" + pe.Id + "%'";
                            countSql += " AND object_id like '%" + pe.Id + "%'";
                        }
                    }
                    Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<ProcedureEntity>();
                    string sortName = maps[dataGrid.sort];


                     DbDataSourceInstance ddsi =DBTool.GetDataSource(pe.DataSourceId,dbManager);
                    if(ddsi!=null){
                        dg.rows = ddsi.ExecuteSqlReturnTType<ProcedureEntity>(sql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
                        dg.total = ddsi.Count(countSql);
                    }
                }
                else if (dbManager.GetDbType() == CTDbType.ORACLE)
                {

                }
                    return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public List<ProcedureParameterEntity> GetParametersByProcedure(int procedureId, string DataSourceId)
        {
            try
            {
                List<ProcedureParameterEntity> parameters = new List<ProcedureParameterEntity>();
                if (dbManager.GetDbType() == CTDbType.SQLSERVER)
                {
                    string sql = "SELECT p.parameter_id,p.name as pname,t.name as ptype FROM SYS.PARAMETERS p INNER JOIN SYS.TYPES t ON p.system_type_id=t.system_type_id WHERE object_id={0} order by parameter_id";
                    Dictionary<string, string> maps = new Dictionary<string, string>();
                    maps.Add("Id", "parameter_id");
                    maps.Add("Name", "pname");
                    maps.Add("Type", "ptype");
                    List<DbParameter> dbPs=new List<DbParameter>();
                    DbParameter p=dbManager.GetDbParameter();
                    p.ParameterName="objid";
                    p.Value=procedureId;
                    p.DbType=DbType.Int32;
                    dbPs.Add(p);
                        DbDataSourceInstance ddsi =DBTool.GetDataSource(DataSourceId,dbManager);
                        if (ddsi != null)
                        {
                            parameters = ddsi.ExecuteSqlReturnTType<ProcedureParameterEntity>(sql, dbPs, maps);
                        }
                   
                    
                }
                else if (dbManager.GetDbType() == CTDbType.ORACLE)
                {

                }

                return parameters;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #region 存储过程公式接口
        public DataGrid<ProcedureFormularEntity> DataGridProcedureFormularEntities(DataGrid<ProcedureFormularEntity> dataGrid, ProcedureFormularEntity pfe)
        {
            try
            {
                DataGrid<ProcedureFormularEntity> dg = new DataGrid<ProcedureFormularEntity>();
                string csql = "SELECT * FROM CT_BASIC_PROCEDURE ";
                string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<ProcedureFormularEntity>(pfe);
                if (!StringUtil.IsNullOrEmpty(whereSql))
                {
                    whereSql = " WHERE 1=1 AND " + whereSql;
                }
                else
                {
                    whereSql = "";
                }
                csql += whereSql;
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<ProcedureFormularEntity>();
                string countSql = "SELECT COUNT(*) FROM CT_BASIC_PROCEDURE ";
                countSql += whereSql;
                string sortName = maps[dataGrid.sort];
                dg.rows = dbManager.ExecuteSqlReturnTType<ProcedureFormularEntity>(csql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
                dg.total = dbManager.Count(countSql);
                return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void AddProcedureFormularEntity(ProcedureFormularEntity pfe)
        {
            try
            {
                if (StringUtil.IsNullOrEmpty(pfe.Id))
                {
                    pfe.Id = Guid.NewGuid().ToString();
                }
                pfe.Creater = SessoinUtil.GetCurrentUser().Id;
                pfe.CreateTime = SessoinUtil.GetCurrentDateTime();
                linqDbManager.InsertEntity<ProcedureFormularEntity>(pfe);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void EditProcedureFormularEntity(ProcedureFormularEntity pfe)
        {
            try
            {
                ProcedureFormularEntity temp = GetProcedureFormularEntity(pfe.Id);
                BeanUtil.CopyBeanToBean(pfe, temp);
                linqDbManager.UpdateEntity<ProcedureFormularEntity>(temp);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void DeleteProcedureFormularEntity(ProcedureFormularEntity pfe)
        {
            try
            {
                ProcedureFormularEntity temp = GetProcedureFormularEntity(pfe.Id);
                linqDbManager.Delete<ProcedureFormularEntity>(temp);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public ProcedureFormularEntity GetProcedureFormularEntity(string id)
        {
            try
            {
                return linqDbManager.GetEntity<ProcedureFormularEntity>(r => r.Id == id);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion
    }
}
