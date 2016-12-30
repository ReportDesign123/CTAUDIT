using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.Common;
using AuditSPI;
using AuditEntity;
using AuditService;
using DbManager;
using CtTool;


namespace AuditService
{
    public  class RoleService:IRole
    {
        private IDbManager dbManager;
        private ILinqDataManager linqManager;

        public RoleService()
        {
            dbManager = new CTDbManager();
            linqManager = new LinqDataManager();           
        }
        /// <summary>
        /// 获取数据列表
        /// </summary>
        /// <param name="dataGrid"></param>
        public DataGrid<RoleEntity> GetDataGrid(DataGrid<AuditEntity.RoleEntity> dataGrid,RoleEntity roleEntity)
        {
            DataGrid<RoleEntity> dg = new DataGrid<RoleEntity>();
            string sql = "SELECT * FROM CT_BASIC_ROLE WHERE 1=1";
            string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<RoleEntity>(roleEntity);
            Dictionary<string ,string >maps=BeanUtil.ConvertObjectToMaps<RoleEntity>();
            string countSql="SELECT COUNT(*) FROM CT_BASIC_ROLE WHERE 1=1 ";
            string sortName=maps[dataGrid.sort];
            sql = AddWhereSql(sql, whereSql);
            countSql = AddWhereSql(countSql, whereSql);
            dg.rows = dbManager.ExecuteSqlReturnTType<RoleEntity>(sql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
            dg.total = dbManager.Count(countSql);
            return dg;
        }
        private string AddWhereSql(string sql, string whereSql)
        {
            try
            {
                if (!StringUtil.IsNullOrEmpty(whereSql))
                {
                    sql +=" AND "+ whereSql;
                }
                return sql;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void Save(RoleEntity roleEntity)
        {
            try
            {
                if (StringUtil.IsNullOrEmpty(roleEntity.Id))
                {
                    roleEntity.Id = Guid.NewGuid().ToString();
                }
                linqManager.InsertEntity<RoleEntity>(roleEntity);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void Edit(RoleEntity roleEdity)
        {
            try
            {
                RoleEntity re = linqManager.GetEntity<RoleEntity>(r => r.Id == roleEdity.Id);
                BeanUtil.CopyBeanToBean(roleEdity, re);
                linqManager.UpdateEntity<RoleEntity>(roleEdity);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void Delete(RoleEntity roleEdit)
        {
            try
            {
                string sql = "DELETE FROM CT_BASIC_ROLE WHERE ROLE_ID='"+roleEdit.Id+"'";
                dbManager.ExecuteSql(sql);
                sql = "DELETE FROM CT_BASIC_ROLEANDFUNCTIONS WHERE ROLEANDFUNCTIONS_ROLEID='"+roleEdit.Id+"'";
                dbManager.ExecuteSql(sql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public RoleEntity get(string id)
        {
            try
            {
                RoleEntity re = linqManager.GetEntity<RoleEntity>(r => r.Id == id);
                return re;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public void BatchUpdate(List<RoleAndFunctionsEntity> roleEntities)
        {
            DbConnection connection = dbManager.GetDbConnection();
            try
            {
                using (connection)
                {
                    DbCommand command = dbManager.getDbCommand();

                    dbManager.Open();
                    DbTransaction tr= connection.BeginTransaction();
                    if (roleEntities.Count > 0)
                    {
                        try
                        {

                            string deleteSql = "DELETE FROM CT_BASIC_ROLEANDFUNCTIONS WHERE ROLEANDFUNCTIONS_ROLEID='" + roleEntities[0].RoleId + "'";
                            command.CommandType = CommandType.Text;
                            command.CommandText = deleteSql;
                            command.Transaction = tr;
                            command.ExecuteNonQuery();
                            string sql = BeanUtil.ConvertBeanToInsertCommandSql<RoleAndFunctionsEntity>();
                            foreach (RoleAndFunctionsEntity re in roleEntities)
                            {
                                if (StringUtil.IsNullOrEmpty(re.Id))
                                {
                                    re.Id = Guid.NewGuid().ToString();
                                }

                                string tempString = String.Format(sql, re.Id, re.RoleId, re.FunctionId,re.State);
                                command.CommandText = tempString;
                                command.ExecuteNonQuery();
                            }
                            tr.Commit();
                        }
                        catch (Exception ex)
                        {
                            tr.Rollback();
                            throw ex;
                        }
                    }
                   
                  
                }
            }
            catch (Exception ex)
            {
                
                throw ex;
            }
        }





        public List<RoleEntity> GetList()
        {
            try
            {
                string sql = "SELECT * FROM CT_BASIC_ROLE";
                List<RoleEntity> lists = dbManager.ExecuteSqlReturnTType<RoleEntity>(sql);
                return lists;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
