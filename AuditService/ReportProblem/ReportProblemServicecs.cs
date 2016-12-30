using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using AuditEntity.ReportProblem;
using AuditSPI.ReportProblem;
using DbManager;
using CtTool;
using AuditSPI;

namespace AuditService.ReportProblem
{
    public  class ReportProblemServicecs:IReportProblem
    {
        ILinqDataManager linqDbManager;
        CTDbManager dbManager;
        public ReportProblemServicecs()
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
        public void Add(ReportProblemEntity rpe)
        {
            try
            {
                if (StringUtil.IsNullOrEmpty(rpe.Id))
                {
                    rpe.Id = Guid.NewGuid().ToString();
                }
                rpe.Creater = SessoinUtil.GetCurrentUser().Id;
                rpe.CreateTime = SessoinUtil.GetCurrentDateTime();
                rpe.State = "0";
                linqDbManager.InsertEntity<ReportProblemEntity>(rpe);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void Edit(ReportProblemEntity rpe)
        {
            try
            {
                ReportProblemEntity temp = linqDbManager.GetEntity<ReportProblemEntity>(r => r.Id == rpe.Id);
                BeanUtil.CopyBeanToBean(rpe, temp);
                linqDbManager.UpdateEntity<ReportProblemEntity>(temp);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void Delete(ReportProblemEntity rpe)
        {
            try
            {
                ReportProblemEntity temp = linqDbManager.GetEntity<ReportProblemEntity>(r => r.Id == rpe.Id);
                linqDbManager.Delete<ReportProblemEntity>(temp);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public AuditSPI.DataGrid<ReportProblemEntity> DataGridReportProblemEntity(AuditSPI.DataGrid<ReportProblemEntity> dataGrid, ReportProblemEntity rpe)
        {
            try
            {
                DataGrid<ReportProblemEntity> dg = new DataGrid<ReportProblemEntity>();
                string sql = "SELECT * FROM CT_PROBLEM_REPORTPROBLEM ";
                string whereSql = CreateReportProblemEntity(rpe);

                sql += whereSql;
                string countSql = "SELECT COUNT(*)  FROM CT_PROBLEM_REPORTPROBLEM " + whereSql;
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<ReportProblemEntity>();              
                string sortName = maps[dataGrid.sort];
                dg.rows = dbManager.ExecuteSqlReturnTType<ReportProblemEntity>(sql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
                dg.total = dbManager.Count(countSql);
                return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private string CreateReportProblemEntity(ReportProblemEntity rpe)
        {
            try
            {
                StringBuilder whereSql = new StringBuilder();
                whereSql.Append(" WHERE 1=1 ");
                if (!StringUtil.IsNullOrEmpty(rpe.ReportAuditId))
                {
                    whereSql.Append(" AND ");
                    whereSql.Append(" REPORTPROBLEM_REPORTAUDITID='" + rpe.ReportAuditId + "' ");
                }
                if (!StringUtil.IsNullOrEmpty(rpe.Type))
                {
                    whereSql.Append(" AND ");
                    whereSql.Append(" REPORTPROBLEM_TYPE='" + rpe.Type + "' ");
                }
                if (rpe.Rank!=0)
                {
                    whereSql.Append(" AND ");
                    whereSql.Append(" REPORTPROBLEM_RANK='" + rpe.Rank + "' ");
                }

                if (!StringUtil.IsNullOrEmpty(rpe.State))
                {
                    whereSql.Append(" AND ");
                    whereSql.Append(" REPORTPROBLEM_STATE='" + rpe.State + "' ");
                }
                return whereSql.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public ReportProblemEntity Get(ReportProblemEntity rpe)
        {
            try
            {
                return linqDbManager.GetEntity<ReportProblemEntity>(r => r.Id == rpe.Id);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<ReportProblemEntity> GetReportProblems(string ReportAuditId)
        {
            try
            {
                string sql = "SELECT * FROM CT_PROBLEM_REPORTPROBLEM  WHERE  REPORTPROBLEM_REPORTAUDITID='" + ReportAuditId + "' ORDER BY REPORTPROBLEM_CREATETIME DESC";
                List<ReportProblemEntity> problems = dbManager.ExecuteSqlReturnTType<ReportProblemEntity>(sql);
                return problems;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 获取审计问题
        /// </summary>
        /// <param name="AuditId"></param>
        /// <returns></returns>
        public List<ReportProblemEntity> ExportReportProblems(string AuditId)
        {
            try
            {
                string sql = "SELECT * FROM CT_PROBLEM_REPORTPROBLEM WHERE REPORTPROBLEM_REPORTAUDITID='"+AuditId+"'";
                List<ReportProblemEntity> problems = dbManager.ExecuteSqlReturnTType<ReportProblemEntity>(sql);
                return problems;
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        /// <summary>
        /// 问题数据处理
        /// </summary>
        /// <param name="reportProblemEntity"></param>
        /// <returns></returns>
        public Dictionary<string,int> GetProblemProcessData(ReportProblemEntity reportProblemEntity)
        {
            try
            {
                Dictionary<string, int> result = new Dictionary<string, int>();
                string sql = "SELECT COUNT(*),REPORTPROBLEM_STATE FROM CT_PROBLEM_REPORTPROBLEM WHERE 1=1  "+CreateWhereSql(reportProblemEntity)+" GROUP BY REPORTPROBLEM_STATE";
                DataTable dt = dbManager.ExecuteSqlReturnDataTable(sql);
                foreach (DataRow row in dt.Rows)
                {
                    result.Add(row["REPORTPROBLEM_STATE"].ToString(), Convert.ToInt32(row[0]));

                }
                return result;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 创建Where条件
        /// </summary>
        /// <param name="problem"></param>
        /// <returns></returns>
        public string CreateWhereSql(ReportProblemEntity problem)
        {
            try
            {
                StringBuilder sql = new StringBuilder();
                sql.Append(" AND ");
                sql.Append(" REPORTPROBLEM_TASKID ");
                sql.Append("=");
                sql.Append("'");
                sql.Append(problem.TaskId);
                sql.Append("' ");

                sql.Append(" AND ");
                sql.Append(" REPORTPROBLEM_PAPERID ");
                sql.Append("=");
                sql.Append("'");
                sql.Append(problem.PaperId);
                sql.Append("' ");

                sql.Append(" AND ");
                sql.Append(" REPORTPROBLEM_REPORTID ");
                sql.Append("=");
                sql.Append("'");
                sql.Append(problem.ReportId);
                sql.Append("' ");

                sql.Append(" AND ");
                sql.Append(" REPORTPROBLEM_COMPANYID ");
                sql.Append("=");
                sql.Append("'");
                sql.Append(problem.CompanyId);
                sql.Append("' ");

                sql.Append(" AND ");
                sql.Append(" REPORTPROBLEM_ND ");
                sql.Append("=");
                sql.Append("'");
                sql.Append(problem.Year);
                sql.Append("' ");

                sql.Append(" AND ");
                sql.Append(" REPORTPROBLEM_ZQ ");
                sql.Append("=");
                sql.Append("'");
                sql.Append(problem.Zq);
                sql.Append("' ");

                return sql.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
