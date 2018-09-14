using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.ReportState;
using AuditSPI.ReportState;
using DbManager;
using AuditSPI.ReportData;
using GlobalConst;
using CtTool;
using AuditSPI;

namespace AuditService.ReportState
{
    public class  ReportLockService : IReportLock
    {
        CTDbManager dbManager;
        LinqDataManager linqDbManager;
        CompanyService companyService;
        public ReportLockService()
        {
            if (dbManager == null)
            {
                dbManager = new CTDbManager();
            }
            if (linqDbManager == null)
            {
                linqDbManager = new LinqDataManager();
            }
            if (companyService == null)
            {
                companyService = new CompanyService();
            }
        }
        /// <summary>
        /// 加锁
        /// </summary>
        /// <param name="rdps"></param>
        public void AddLock(AuditSPI.ReportData.ReportDataParameterStruct rdps)
        {
            try
            {
                string sql = "DELETE FROM CT_STATE_LOCK WHERE LOCK_CREATER='" + SessoinUtil.GetCurrentUser().Id + "'";
                dbManager.ExecuteSql(sql);
                ReportLockEntity rle = ConvertReportParameterStructToReportLock(rdps);
                rle.Id = Guid.NewGuid().ToString();
                rle.Creater = SessoinUtil.GetCurrentUser().Id;
                rle.CreateTime = SessoinUtil.GetCurrentDateTime();
                rle.IsOrNotLock = true; 
                linqDbManager.InsertEntity<ReportLockEntity>(rle);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 去除锁
        /// </summary>
        /// <param name="rdps"></param>
        public void RemoveLock(AuditSPI.ReportData.ReportDataParameterStruct rdps)
        {
            try
            {
                ReportLockEntity rle = ConvertReportParameterStructToReportLock(rdps);
                StringBuilder deleteSql = new StringBuilder();
                deleteSql.Append(" DELETE FROM ");
                deleteSql.Append(" CT_STATE_LOCK ");
                deleteSql.Append(CreateWhereSql(rdps,true));
                dbManager.ExecuteSql(deleteSql.ToString());
               
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 获取特定条件下的所有报表的锁
        /// </summary>
        /// <param name="rdps"></param>
        /// <returns></returns>
        public List<ReportLockEntity> ReportLockList(AuditSPI.ReportData.ReportDataParameterStruct rdps)
        {
            try
            {
                StringBuilder selectSql = new StringBuilder();
                selectSql.Append("SELECT * FROM CT_STATE_LOCK ");
                selectSql.Append(CreateWhereSql(rdps,false));
                return dbManager.ExecuteSqlReturnTType<ReportLockEntity>(selectSql.ToString());
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 是否允许读写
        /// </summary>
        /// <param name="rdps"></param>
        /// <returns></returns>
        public bool AllowWrite(ReportDataParameterStruct rdps)
        {
            try
            {
               
                List<ReportLockEntity> locks = ReportLockList(rdps);
                if (locks.Count > 0)
                {
                    //如果为其本身
                    if (SessoinUtil.GetCurrentUser().Id == locks[0].Creater) return true;

                    return false;
                }
                else
                {
                    AddLock(rdps);
                    return true;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #region 辅助方法

        /// <summary>
        /// 创建审计状态锁条件
        /// </summary>
        /// <param name="rdps"></param>
        /// <returns></returns>
        private string CreateWhereSql(ReportDataParameterStruct rdps,bool includeUser)
        {
            try
            {
                ReportLockEntity rle = new ReportLockEntity();
                
                string sql = "";
                if (ReportGlobalConst.IsOrNotRelationTaskAndPaper)
                {
                    rle.TaskId = rdps.TaskId;
                    rle.PaperId = rdps.PaperId;
                    rle.ReportId = rdps.ReportId;
                    if (includeUser)
                    {
                        rle.Creater = SessoinUtil.GetCurrentUser().Id;
                        
                    }
                    rle.CompanyId = rdps.CompanyId;
                    rle.Year = rdps.Year;
                    rle.Cycle = rdps.Cycle;                    
                }
                else
                {
                    rle.ReportId = rdps.ReportId;
                    if (includeUser)
                    {

                        rle.Creater = SessoinUtil.GetCurrentUser().Id;
                    }
                    rle.CompanyId = rdps.CompanyId;
                    rle.Year = rdps.Year;
                    rle.Cycle = rdps.Cycle;   
                }
                Dictionary<string, string> excludes = new Dictionary<string, string>();
                excludes.Add("IsOrNotLock", "LOCK_ISORNOTLOCK");
                sql =" WHERE 1=1 "+ BeanUtil.ConvertObjectToWhereSqls<ReportLockEntity>(rle,excludes);
                return sql;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private ReportLockEntity ConvertReportParameterStructToReportLock(ReportDataParameterStruct rdps)
        {
            try
            {
                ReportLockEntity rle = new ReportLockEntity();
                rle.TaskId = rdps.TaskId;
                rle.PaperId = rdps.PaperId;
                rle.ReportId = rdps.ReportId;
                rle.CompanyId = rdps.CompanyId;
                rle.Year = rdps.Year;
                rle.Cycle = rdps.Cycle;
                return rle;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion




        /// <summary>
        /// 获取所有的锁定报表
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="rle"></param>
        /// <returns></returns>
        public AuditSPI.DataGrid<ReportLockEntity> GetReportLockEntiesDataGrid(AuditSPI.DataGrid<ReportLockEntity> dataGrid, ReportLockEntity rle)
        {
            try
            {
                DataGrid<ReportLockEntity> dg = new DataGrid<ReportLockEntity>();
                StringBuilder sql = new StringBuilder();
                StringBuilder countSql = new StringBuilder();
                sql.Append("SELECT");
                countSql.Append("SELECT");
                countSql.Append(" COUNT(*) ");
                sql.Append(" LOCK_ID, LOCK_TASKID,LOCK_PAPERID,LOCK_REPORTID,LOCK_COMPANYID,LOCK_YEAR,LOCK_CYCLE,SYUSER_MC,LOCK_CREATETIME,");
                sql.Append("AUDITTASK_NAME,AUDITPAPER_NAME,REPORTDICTIONARY_NAME,REPORTDICTIONARY_CODE,LSBZDW_DWMC");
                sql.Append(" FROM CT_STATE_LOCK ");
                sql.Append(" LEFT JOIN CT_TASK_AUDITTASK  ON LOCK_TASKID=AUDITTASK_ID ");
                sql.Append(" LEFT JOIN CT_PAPER_AUDITPAPER ON LOCK_PAPERID=AUDITPAPER_ID ");
                sql.Append(" LEFT JOIN CT_FORMAT_REPORTDICTIONARY ON REPORTDICTIONARY_ID=LOCK_REPORTID ");
                sql.Append(" LEFT JOIN LSBZDW ON LOCK_COMPANYID=LSBZDW_ID ");
                sql.Append(" LEFT JOIN SYUSER ON SYUSER_ID=LOCK_CREATER ");
                sql.Append(" WHERE 1=1 ");

                countSql.Append(" FROM CT_STATE_LOCK ");
                countSql.Append("INNER JOIN CT_TASK_AUDITTASK  ON LOCK_TASKID=AUDITTASK_ID ");
                countSql.Append("INNER JOIN CT_PAPER_AUDITPAPER ON LOCK_PAPERID=AUDITPAPER_ID ");
                countSql.Append("INNER JOIN CT_FORMAT_REPORTDICTIONARY ON REPORTDICTIONARY_ID=LOCK_REPORTID ");
                countSql.Append("INNER JOIN LSBZDW ON LOCK_COMPANYID=LSBZDW_ID ");
                countSql.Append(" WHERE 1=1 ");
                StringBuilder whereSql = new StringBuilder();
                if (!StringUtil.IsNullOrEmpty(rle.ReportCode))
                {
                    whereSql.Append(" AND REPORTDICTIONARY_CODE LIKE '%" + rle.ReportCode + "%' ");
                }
                if (!StringUtil.IsNullOrEmpty(rle.ReportName))
                {
                    whereSql.Append(" AND REPORTDICTIONARY_NAME LIKE '%" + rle.ReportName + "%' ");
                }
                if (!StringUtil.IsNullOrEmpty(rle.CompanyName))
                {
                    whereSql.Append(" AND LSBZDW_DWMC LIKE '%" + rle.CompanyName + "%' ");
                }

                whereSql.Append(" AND LOCK_COMPANYID " + companyService.GetFillReportAuthorityCompaniesIdSql() + " ");


                sql.Append(whereSql);
                countSql.Append(whereSql);
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<ReportLockEntity>();
                maps.Add("ReportCode", "REPORTDICTIONARY_CODE");
                maps.Add("ReportName", "REPORTDICTIONARY_NAME");
                maps.Add("CompanyName", "LSBZDW_DWMC");
                maps.Add("UserName", "SYUSER_MC");
                string sortName = maps[dataGrid.sort];
                dg.rows = dbManager.ExecuteSqlReturnTType<ReportLockEntity>(sql.ToString(), dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
                dg.total = dbManager.Count(countSql.ToString());
                return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 清空锁
        /// </summary>
        /// <param name="ids"></param>
        public void RemoveLocks(string ids)
        {
            try
            {
                string whereSql = StringUtil.ConvertStringToInSql(ids);
                string sql = "DELETE FROM  CT_STATE_LOCK  WHERE LOCK_ID IN (";
                sql += whereSql;
                sql += ")";
                dbManager.ExecuteSql(sql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
