using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.ReportProblem;
using AuditSPI.ProblemTrace;
using AuditSPI;
using DbManager;
using CtTool;
using AuditService.ReportProblem;
using AuditEntity;


namespace AuditService.ProblemTrace
{
    public  class ProblemTrace:IProblemTrace
    {
        private CTDbManager dbManager;
        private ReportProblemServicecs reportProblemService;
        private UserService userService;
        public ProblemTrace()
        {
            if (dbManager == null)
            {
                dbManager = new CTDbManager();
            }
            if (reportProblemService == null)
            {
                reportProblemService = new ReportProblemServicecs();
            }
            if (userService == null)
            {
                userService = new UserService();
            }
           
        }
        /// <summary>
        /// 获取追踪问题
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="rpe"></param>
        /// <returns></returns>
        public AuditSPI.DataGrid<ReportProblemEntity> DataGridReportProblemEntity(AuditSPI.DataGrid<ReportProblemEntity> dataGrid, ReportProblemEntity rpe)
        {
            try
            {
                DataGrid<ReportProblemEntity> dg = new DataGrid<ReportProblemEntity>();
                string sql = "SELECT * FROM CT_PROBLEM_REPORTPROBLEM INNER JOIN SYUSER ON REPORTPROBLEM_CREATER=SYUSER_ID ";
                string whereSql = CreateReportProblemEntity(rpe);

                sql += whereSql;
                string countSql = "SELECT COUNT(*)  FROM CT_PROBLEM_REPORTPROBLEM " + whereSql;
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<ReportProblemEntity>();
                maps.Add("CreaterName", "SYUSER_MC");
                string sortName = maps[dataGrid.sort];
                dg.rows = dbManager.ExecuteSqlReturnTType<ReportProblemEntity>(sql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);

                foreach (ReportProblemEntity problem in dg.rows)
                {
                    problem.Type = ProblemTool.GetProblemType(problem.Type);
                    problem.State = ProblemTool.GetProblemStateType(problem.State);
                }
                dg.total = dbManager.Count(countSql);
                return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="rpe"></param>
        /// <returns></returns>
        private string CreateReportProblemEntity(ReportProblemEntity rpe)
        {
            try
            {
                StringBuilder whereSql = new StringBuilder();
                whereSql.Append(" WHERE 1=1 ");
          
                if (!StringUtil.IsNullOrEmpty(rpe.Type))
                {
                    whereSql.Append(" AND ");
                    whereSql.Append(" REPORTPROBLEM_TYPE='" + rpe.Type + "' ");
                }


                if (!StringUtil.IsNullOrEmpty(rpe.State))
                {
                    if (rpe.State.IndexOf(",") == -1)
                    {
                        whereSql.Append(" AND ");
                        whereSql.Append(" REPORTPROBLEM_STATE='" + rpe.State + "' ");
                    }
                    else
                    {
                        whereSql.Append(" AND ");
                        whereSql.Append(" REPORTPROBLEM_STATE IN (" + StringUtil.ConvertStringToInSql(rpe.State) + ")");
                    }
                  
                }
                if (!StringUtil.IsNullOrEmpty(rpe.TaskId))
                {
                    whereSql.Append(" AND ");
                    whereSql.Append(" REPORTPROBLEM_TASKID='" + rpe.TaskId + "' ");
                }
                if (!StringUtil.IsNullOrEmpty(rpe.PaperId))
                {
                    whereSql.Append(" AND ");
                    whereSql.Append(" REPORTPROBLEM_PAPERID='" + rpe.PaperId + "' ");
                }
                if (!StringUtil.IsNullOrEmpty(rpe.Year))
                {
                    whereSql.Append(" AND ");
                    whereSql.Append(" REPORTPROBLEM_ND='" + rpe.Year + "' ");
                }
                if (!StringUtil.IsNullOrEmpty(rpe.Zq))
                {
                    whereSql.Append(" AND ");
                    whereSql.Append(" REPORTPROBLEM_ZQ='" + rpe.Zq+ "' ");
                }
                if (!StringUtil.IsNullOrEmpty(rpe.ReportId))
                {
                    whereSql.Append(" AND ");
                    whereSql.Append(" REPORTPROBLEM_REPORTID IN (" + StringUtil.ConvertStringToInSql(rpe.ReportId)+ ") ");
                }
                if (!StringUtil.IsNullOrEmpty(rpe.CompanyId))
                {
                    whereSql.Append(" AND ");
                    whereSql.Append(" REPORTPROBLEM_COMPANYID IN (" + StringUtil.ConvertStringToInSql(rpe.CompanyId) + ") ");
                }
                return whereSql.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 增加问题
        /// </summary>
        /// <param name="reportProblemEntity"></param>
        public void AddProblem(ReportProblemEntity reportProblemEntity)
        {
            try
            {
                reportProblemService.Add(reportProblemEntity);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 编辑问题
        /// </summary>
        /// <param name="reportProblemEntiy"></param>
        public void EditProblem(ReportProblemEntity reportProblemEntiy)
        {
            try
            {
                reportProblemService.Edit(reportProblemEntiy);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 删除问题序列
        /// </summary>
        /// <param name="ids"></param>
        public void Delete(string ids)
        {
            try
            {
                string sql = "DELETE CT_PROBLEM_REPORTPROBLEM WHERE REPORTPROBLEM_ID IN ("+StringUtil.ConvertStringToInSql(ids)+")";
                dbManager.ExecuteSql(sql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 获取问题
        /// </summary>
        /// <param name="reportProblemEntity"></param>
        /// <returns></returns>
        public ReportProblemEntity GetProblem(ReportProblemEntity reportProblemEntity)
        {
            try
            {
                reportProblemEntity= reportProblemService.Get(reportProblemEntity);
                if (!StringUtil.IsNullOrEmpty(reportProblemEntity.Creater))
                {
                    UserEntity temp=new UserEntity();
                    temp.Id=reportProblemEntity.Creater;
                    UserEntity user = userService.Get(temp);
                    reportProblemEntity.UserName = user.Name;
                }
                return reportProblemEntity;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void ChangeReportProblemState(ReportProblemEntity reportProblemEntiy)
        {
            try
            {
                string sql = "UPDATE CT_PROBLEM_REPORTPROBLEM SET REPORTPROBLEM_STATE='" + reportProblemEntiy.State + "' WHERE REPORTPROBLEM_ID='"+reportProblemEntiy.Id+"'";
                dbManager.ExecuteSql(sql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void AddReportProblemReturn(ReportProblemEntity reportProblemEntiy)
        {
            try
            {
                string sql = "UPDATE CT_PROBLEM_REPORTPROBLEM SET REPORTPROBLEM_REPLAY='" + reportProblemEntiy.Replay + "',REPORTPROBLEM_STATE='"+reportProblemEntiy.State+"' WHERE REPORTPROBLEM_ID='" + reportProblemEntiy.Id + "'";
                dbManager.ExecuteSql(sql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

    }
}
