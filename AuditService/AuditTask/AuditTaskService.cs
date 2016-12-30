using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Common;
using System.Data;


using AuditSPI.AuditTask;
using AuditSPI;
using DbManager;
using AuditEntity.AuditTask;
using CtTool;
using GlobalConst;
using AuditEntity;
using AuditEntity.AuditPaper;
using AuditService.AuditPaper;

namespace AuditService.AuditTask
{
    
     public  class AuditTaskService:IAuditTask,IAuditTaskCompany,IAuditTaskAndAuditPaper
    {
         IDbManager dbManager;
         ILinqDataManager linqDbManager;
         CompanyService companyService;
         AuditPaperService auditPaperService;
         public AuditTaskService()
         {
             dbManager = new CTDbManager();
             linqDbManager = new LinqDataManager();
             companyService = new CompanyService();
             auditPaperService = new AuditPaperService();
         }
        public void Save(AuditEntity.AuditTask.AuditTaskEntity ate)
        {
            try
            {
                if (StringUtil.IsNullOrEmpty(ate.Id))
                {
                    ate.Id = Guid.NewGuid().ToString();
                }
                ate.CreateTime = SessoinUtil.GetCurrentDateTime();
                ate.Creater = SessoinUtil.GetCurrentUser().Id;
                ate.State = AuditTaskGloblaConst.TaskEnableState;
                linqDbManager.InsertEntity<AuditTaskEntity>(ate);

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void Edit(AuditEntity.AuditTask.AuditTaskEntity ate)
        {
            try
            {
                AuditTaskEntity temp = Get(ate.Id);
                BeanUtil.CopyBeanToBean(ate, temp);
                linqDbManager.UpdateEntity<AuditTaskEntity>(temp);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void Delete(AuditEntity.AuditTask.AuditTaskEntity ate)
        {
            try
            {
                AuditTaskEntity temp = Get(ate.Id);
                linqDbManager.Delete<AuditTaskEntity>(temp);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public AuditEntity.AuditTask.AuditTaskEntity Get(string Id)
        {
            try
            {
                AuditTaskEntity ate = linqDbManager.GetEntity<AuditTaskEntity>(r => r.Id == Id);
                return ate;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public AuditSPI.DataGrid<AuditEntity.AuditTask.AuditTaskEntity> GetDataGrid(AuditSPI.DataGrid<AuditEntity.AuditTask.AuditTaskEntity> dg,AuditTaskEntity ate)
        {
            try
            {
                DataGrid<AuditTaskEntity> datagrid = new DataGrid<AuditTaskEntity>();
                string sql = "SELECT * FROM CT_TASK_AUDITTASK  WHERE 1=1 ";
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<AuditTaskEntity>();
                string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<AuditTaskEntity>(ate);
                if (whereSql != "")
                {
                    whereSql = " and " + whereSql;
                }
              
               

                string sortName = maps[dg.sort];
                List<AuditTaskEntity> lists = dbManager.ExecuteSqlReturnTType<AuditTaskEntity>(sql, dg.page, dg.pageNumber, sortName + " " + dg.order, maps);

                sql = "SELECT COUNT(*) FROM CT_TASK_AUDITTASK WHERE 1=1";
                if (whereSql != "")
                {
                    whereSql = " and " + whereSql;
                }
              
                int count = dbManager.Count(sql);
                datagrid.rows = lists;
                datagrid.total = count;
                return datagrid;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

         /// <summary>
         /// 获取有权限的任务列表
         /// </summary>
         /// <param name="dg"></param>
         /// <param name="ate"></param>
         /// <returns></returns>
        public AuditSPI.DataGrid<AuditEntity.AuditTask.AuditTaskEntity> GetAuthorityDataGrid(AuditSPI.DataGrid<AuditEntity.AuditTask.AuditTaskEntity> dg, AuditTaskEntity ate)
        {
            try
            {
                DataGrid<AuditTaskEntity> datagrid = new DataGrid<AuditTaskEntity>();
                string sql = "SELECT * FROM CT_TASK_AUDITTASK INNER JOIN CT_TASK_AUDITTASKCOMPANYS ON  AUDITTASK_ID=AUDITTASKCOMPANYS_TASKID WHERE 1=1 ";
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<AuditTaskEntity>();
                string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<AuditTaskEntity>(ate);
                if (whereSql != "")
                {
                    whereSql = " and " + whereSql;
                }
                sql += whereSql;
                string authorSql = "  AND AUDITTASKCOMPANYS_COMPANYID= '" + SessoinUtil.GetCurrentCompanyId() + "'";
                sql += authorSql;

                string sortName = maps[dg.sort];
                List<AuditTaskEntity> lists = dbManager.ExecuteSqlReturnTType<AuditTaskEntity>(sql, dg.page, dg.pageNumber, sortName + " " + dg.order, maps);
                sql = "SELECT COUNT(*) FROM CT_TASK_AUDITTASK INNER JOIN CT_TASK_AUDITTASKCOMPANYS ON  AUDITTASK_ID=AUDITTASKCOMPANYS_TASKID WHERE 1=1";
                sql += whereSql;
                sql += authorSql;
                int count = dbManager.Count(sql);
                datagrid.rows = lists;
                datagrid.total = count;
                return datagrid;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #region 审计任务与组织机构
        public List<TreeNode> TreeNodesAuditTaskAuthorities(AuditTaskEntity ate)
        {
            try
            {
                CompanyEntity ce = new CompanyEntity();
                List<CompanyEntity> allCompanies = companyService.GetAllCompanys();


                List<AuditTaskAndCompanyEntity> atacs = linqDbManager.getList<AuditTaskAndCompanyEntity>(r =>r.TaskId==ate.Id);
                foreach (AuditTaskAndCompanyEntity atace in atacs)
                {
                    foreach (CompanyEntity c in allCompanies)
                    {
                        if (atace.CompanyId == c.Id&&atace.State=="1")
                        {
                            c.isOrNotChecked = true;
                        }
                    }
                }
                List<TreeNode> nodes = new List<TreeNode>();
                BeanUtil.ConvertTTypeToTreeNode<CompanyEntity>(allCompanies, nodes, "Id", "Name", "ParentId");
                return nodes;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void BatchUpdate(List<AuditTaskAndCompanyEntity> ataces, string AuditTaskId)
        {
            DbConnection connection = dbManager.GetDbConnection();
            try
            {
                using (connection)
                {
                    DbCommand command = dbManager.getDbCommand();
                    dbManager.Open();
                    DbTransaction tr = connection.BeginTransaction();
                    try
                    {
                        string deleteSql = "DELETE FROM CT_TASK_AUDITTASKCOMPANYS WHERE AUDITTASKCOMPANYS_TASKID='"+AuditTaskId+"'";
                        command.CommandType = CommandType.Text;
                        command.CommandText = deleteSql;
                        command.Transaction = tr;
                        command.ExecuteNonQuery();

                        if (ataces.Count > 0)
                        {

                            string sql = BeanUtil.ConvertBeanToInsertCommandSql<AuditTaskAndCompanyEntity>();
                            foreach (AuditTaskAndCompanyEntity ap in ataces)
                            {
                                if (StringUtil.IsNullOrEmpty(ap.Id))
                                {
                                    ap.Id = Guid.NewGuid().ToString();
                                }
                                string tempString = String.Format(sql, ap.Id, ap.TaskId, ap.CompanyId,ap.State);
                                command.CommandText = tempString;
                                command.ExecuteNonQuery();
                            }

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
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion
        #region 审计任务和审计底稿
        public List<AuditTaskEntity> GetAuditTaskLists()
        {
            try
            {
                string sql = "SELECT * FROM CT_TASK_AUDITTASK WHERE AUDITTASK_STATE='"+AuditTaskGloblaConst.TaskEnableState+"'";
                return dbManager.ExecuteSqlReturnTType<AuditTaskEntity>(sql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public Dictionary<string, List<AuditEntity.AuditPaper.AuditPaperEntity>> GetAuditTaskAuditPapers(string AuditTaskId)
        {
            try
            {
                Dictionary<string, List<AuditPaperEntity>> dics = new Dictionary<string, List<AuditPaperEntity>>();
                //获取所有报表列表
                List<AuditPaperEntity> allPapers = auditPaperService.GetAuditPaperLists();

                string sql = "SELECT * FROM CT_TASK_AUDITTASKANDAUDITPAPER WHERE AUDITTASKANDAUDITPAPER_TASKID='"+AuditTaskId+"'";
                List<AuditTaskAndAuditPaperEntity> relationsReports = dbManager.ExecuteSqlReturnTType<AuditTaskAndAuditPaperEntity>(sql);


                List<AuditPaperEntity> selectPapers = new List<AuditPaperEntity>();
                List<AuditPaperEntity> unSelectPapers = new List<AuditPaperEntity>();
                foreach (AuditPaperEntity rfde in allPapers)
                {
                    bool flag = false;
                    foreach (AuditTaskAndAuditPaperEntity apare in relationsReports)
                    {
                        if (rfde.Id == apare.PaperId)
                        {
                            flag = true;
                            selectPapers.Add(rfde);
                            break;
                        }
                    }
                    if (!flag)
                    {
                        unSelectPapers.Add(rfde);
                    }
                }

                dics.Add("Select", selectPapers);
                dics.Add("UnSelect", unSelectPapers);
                return dics;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void BatchUpdataTaskAndPaper(string AuditTaskId, List<AuditTaskAndAuditPaperEntity> apares)
        {
            DbConnection connection = dbManager.GetDbConnection();
            try
            {
                using (connection)
                {
                    DbCommand command = dbManager.getDbCommand();
                    dbManager.Open();
                    DbTransaction tr = connection.BeginTransaction();
                    try
                    {
                        string deleteSql = "DELETE FROM CT_TASK_AUDITTASKANDAUDITPAPER WHERE AUDITTASKANDAUDITPAPER_TASKID='"+AuditTaskId+"'";
                        command.CommandType = CommandType.Text;
                        command.CommandText = deleteSql;
                        command.Transaction = tr;
                        command.ExecuteNonQuery();

                        if (apares.Count > 0)
                        {

                            string sql = BeanUtil.ConvertBeanToInsertCommandSql<AuditTaskAndAuditPaperEntity>();
                            foreach (AuditTaskAndAuditPaperEntity ap in apares)
                            {
                                if (StringUtil.IsNullOrEmpty(ap.Id))
                                {
                                    ap.Id = Guid.NewGuid().ToString();
                                }
                                string tempString = String.Format(sql, ap.Id, ap.TaskId, ap.PaperId);
                                command.CommandText = tempString;
                                command.ExecuteNonQuery();
                            }

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
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataGrid<AuditPaperEntity> GetDataGridByTaskCode(DataGrid<AuditPaperEntity> dg, string TaskCode, AuditPaperEntity ape)
        {
            try
            {
                DataGrid<AuditPaperEntity> datagrid = new DataGrid<AuditPaperEntity>();
                string sql = "SELECT AUDITPAPER_ID,AUDITPAPER_CODE,AUDITPAPER_NAME FROM CT_PAPER_AUDITPAPER  P INNER JOIN CT_TASK_AUDITTASKANDAUDITPAPER R ON P.AUDITPAPER_ID=R.AUDITTASKANDAUDITPAPER_PAPERID " +
" INNER JOIN CT_TASK_AUDITTASK  ON AUDITTASKANDAUDITPAPER_TASKID=AUDITTASK_ID WHERE AUDITTASK_CODE='"+TaskCode+"'";
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<AuditPaperEntity>();
                string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<AuditPaperEntity>(ape);
                if (whereSql != "")
                {
                    whereSql = " and " + whereSql;
                }
                sql += " " + whereSql;

                string sortName = maps[dg.sort];
                List<AuditPaperEntity> lists = dbManager.ExecuteSqlReturnTType<AuditPaperEntity>(sql, dg.page, dg.pageNumber, sortName + " " + dg.order, maps);
                sql = "SELECT COUNT(*) FROM CT_PAPER_AUDITPAPER  P INNER JOIN CT_TASK_AUDITTASKANDAUDITPAPER R ON P.AUDITPAPER_ID=R.AUDITTASKANDAUDITPAPER_PAPERID "+
                    " INNER JOIN CT_TASK_AUDITTASK  ON AUDITTASKANDAUDITPAPER_TASKID=AUDITTASK_ID WHERE AUDITTASK_CODE='" + TaskCode + "'";
                sql += " " + whereSql;
                int count = dbManager.Count(sql);
                datagrid.rows = lists;
                datagrid.total = count;
                return datagrid;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataGrid<AuditPaperEntity> GetDataGridByTaskId(DataGrid<AuditPaperEntity> dg, string TaskId)
        {
            try
            {
                DataGrid<AuditPaperEntity> datagrid = new DataGrid<AuditPaperEntity>();
                string sql = "SELECT AUDITPAPER_ID,AUDITPAPER_CODE,AUDITPAPER_NAME FROM CT_PAPER_AUDITPAPER  P INNER JOIN CT_TASK_AUDITTASKANDAUDITPAPER R ON P.AUDITPAPER_ID=R.AUDITTASKANDAUDITPAPER_PAPERID WHERE R.AUDITTASKANDAUDITPAPER_TASKID='" + TaskId + "'";
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<AuditPaperEntity>();
               

                string sortName = maps[dg.sort];
                List<AuditPaperEntity> lists = dbManager.ExecuteSqlReturnTType<AuditPaperEntity>(sql, dg.page, dg.pageNumber, sortName + " " + dg.order, maps);
                sql = "SELECT COUNT(*) FROM CT_PAPER_AUDITPAPER  P INNER JOIN CT_TASK_AUDITTASKANDAUDITPAPER R ON P.AUDITPAPER_ID=R.AUDITTASKANDAUDITPAPER_PAPERID WHERE R.AUDITTASKANDAUDITPAPER_TASKID='" + TaskId + "'";
                int count = dbManager.Count(sql);
                datagrid.rows = lists;
                datagrid.total = count;
                return datagrid;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion

         /// <summary>
         /// 根据审计类型、审计日期选择和当前用户选择审计任务；
         /// </summary>
         /// <param name="AuditTyoe"></param>
         /// <param name="AuditDate"></param>
         /// <param name="dg"></param>
         /// <returns></returns>
        public DataGrid<AuditTaskEntity> GetDataGrid(string AuditType, string AuditDate, DataGrid<AuditTaskEntity> dg)
        {
            try
            {
                string sql = "SELECT * FROM CT_TASK_AUDITTASK WHERE AUDITTASK_TYPE='" + AuditType + "' AND AUDITTASK_BEGIONDATE<='" + AuditDate + "' AND AUDITTASK_ENDDATE>='" + AuditDate + "' AND AUDITTASK_STATE='" + AuditPaperGlobalConst.AuditPaperStart + "' AND AUDITTASK_ID IN (SELECT AUDITTASKCOMPANYS_TASKID FROM CT_TASK_AUDITTASKCOMPANYS  WHERE AUDITTASKCOMPANYS_COMPANYID "+ companyService.GetFillReportAuthorityCompaniesIdSql() +")";
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<AuditTaskEntity>();

                string sortName = maps[dg.sort];
                List<AuditTaskEntity> lists = dbManager.ExecuteSqlReturnTType<AuditTaskEntity>(sql, dg.page, dg.pageNumber, sortName + " " + dg.order, maps);
                sql = "SELECT COUNT(*) FROM CT_TASK_AUDITTASK WHERE AUDITTASK_TYPE='" + AuditType + "' AND AUDITTASK_BEGIONDATE<='" + AuditDate + "' AND AUDITTASK_ENDDATE>='" + AuditDate + "' AND AUDITTASK_STATE='" + AuditPaperGlobalConst.AuditPaperStart + "'AND AUDITTASK_ID IN (SELECT AUDITTASKCOMPANYS_TASKID FROM CT_TASK_AUDITTASKCOMPANYS  WHERE AUDITTASKCOMPANYS_COMPANYID " + companyService.GetFillReportAuthorityCompaniesIdSql() + ")";
                int count = dbManager.Count(sql);

                DataGrid<AuditTaskEntity> dataGrid = new DataGrid<AuditTaskEntity>();
                dataGrid.rows = lists;
                dataGrid.total = count;
                return dataGrid;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }




     
    }
}
