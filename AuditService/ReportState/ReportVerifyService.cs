using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.ReportState;
using AuditSPI.ReportState;
using DbManager;
using CtTool;
using GlobalConst;
using AuditSPI.ReportData;

namespace AuditService.ReportState
{
   public   class ReportVerifyService:IReportVerify
    {
       CTDbManager dbManager;
       public ReportVerifyService()
       {
           if (dbManager == null)
           {
               dbManager = new CTDbManager();
           }
       }
       /// <summary>
       /// 批量保存报表校验问题
       /// </summary>
       /// <param name="vpes"></param>
        public void SaveReportVerifies(List<VerifyProblemEntity> vpes)
        {
            try
            {
                StringBuilder sqls = new StringBuilder();
                int i = 0;
                foreach (VerifyProblemEntity vpe in vpes)
                {
                    if (StringUtil.IsNullOrEmpty(vpe.Id))
                    {
                        vpe.Id = Guid.NewGuid().ToString();
                    }
                    vpe.Creater = SessoinUtil.GetCurrentUser().Id;
                    vpe.CreateTime = SessoinUtil.GetCurrentDateTime();
                    sqls.Append(BeanUtil.ConvertBeanToInsertCommandSql<VerifyProblemEntity>(vpe));
                    sqls.Append(";");
                    if (i == 20)
                    {
                        dbManager.ExecuteSql(sqls.ToString());
                        sqls.Length = 0;
                        i = 0;
                    }
                }
                if (sqls.Length > 0) dbManager.ExecuteSql(sqls.ToString());
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 删除当前报表的校验问题
       /// </summary>
       /// <param name="rdps"></param>
        public void DeleteReportVerifies(AuditSPI.ReportData.ReportDataParameterStruct rdps)
        {
            try
            {
                StringBuilder deleteSql = new StringBuilder();
                deleteSql.Append("DELETE FROM CT_STATE_VERIFY WHERE 1=1 ");
                CreateWhereSql(deleteSql, rdps);
                dbManager.ExecuteSql(deleteSql.ToString());
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public List<VerifyProblemEntity> GetListVerifyProblemEntities(ReportDataParameterStruct rdps)
        {
            try
            {
                StringBuilder selectSql = new StringBuilder();
                selectSql.Append("SELECT * FROM CT_STATE_VERIFY WHERE  1=1 ");
               CreateWhereSql(selectSql, rdps);
               return dbManager.ExecuteSqlReturnTType<VerifyProblemEntity>(selectSql.ToString());
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void  CreateWhereSql(StringBuilder sql, ReportDataParameterStruct rdps)
        {
            try
            {
                if (ReportGlobalConst.IsOrNotRelationTaskAndPaper)
                {
                    sql.Append(" AND  VERIFY_TASKID=");
                    sql.Append("'");
                    sql.Append(rdps.TaskId);
                    sql.Append("'");

                    sql.Append(" AND ");
                    sql.Append(" VERIFY_PAPERID=");
                    sql.Append("'");
                    sql.Append(rdps.PaperId);
                    sql.Append("'");

                }

                sql.Append(" AND ");
                sql.Append(" VERIFY_COMPANYID=");
                sql.Append("'");
                sql.Append(rdps.CompanyId);
                sql.Append("'");

                sql.Append(" AND ");
                sql.Append(" VERIFY_REPORTID=");
                sql.Append("'");
                sql.Append(rdps.ReportId);
                sql.Append("'");

                sql.Append(" AND ");
                sql.Append(" VERIFY_YEAR=");
                sql.Append("'");
                sql.Append(rdps.Year);
                sql.Append("'");

                sql.Append(" AND ");
                sql.Append(" VERIFY_CYCLE=");
                sql.Append("'");
                sql.Append(rdps.Cycle);
                sql.Append("'");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        
    }
}
