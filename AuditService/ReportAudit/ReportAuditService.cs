using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.ReportAudit;
using AuditSPI.ReportAudit;
using AuditSPI;
using CtTool;
using DbManager;
using System.Data.Common;
using AuditService.ReportData;



namespace AuditService.ReportAudit
{
   public  class ReportAuditService:IReportAudit
    {
       CTDbManager dbManager;
       ILinqDataManager linqDbManager;
       CompanyService companyService;

     
       public ReportAuditService()
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

  
       
       public void InsertReportAudit(ReportAuditEntity rae)
       {
           try
           {
               string whereSql = BeanUtil.ConvertObjectToWhereSqls<ReportAuditEntity>(rae);

               string countSql = "SELECT COUNT(*) FROM CT_AUDIT_REPORTAUDIT WHERE 1=1 "+whereSql;
               int count = dbManager.Count(countSql);
               if (count == 0)
               {
                   if (StringUtil.IsNullOrEmpty(rae.Id))
                   {
                       rae.Id = Guid.NewGuid().ToString();
                   }
                   rae.Creater = SessoinUtil.GetCurrentUser().Id;
                   rae.CreateTime = SessoinUtil.GetCurrentDateTime();
                   rae.IsOrNotRead = "0";
                   linqDbManager.InsertEntity<ReportAuditEntity>(rae);
               }
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }
       /// <summary>
       /// 获取报表的审核列表
       /// </summary>
       /// <param name="dataGrid"></param>
       /// <param name="rae"></param>
       /// <returns></returns>
        public AuditSPI.DataGrid<ReportAuditEntity> DataGridReportAuditEntity(AuditSPI.DataGrid<ReportAuditEntity> dataGrid, ReportAuditEntity rae)
        {
            try
            {
                DataGrid<ReportAuditEntity> dg = new DataGrid<ReportAuditEntity>();
                string sql = "SELECT REPORTAUDIT_Id, REPORTAUDIT_STATE,REPORTAUDIT_REPORTID,REPORTAUDIT_COMPANYID,REPORTAUDIT_ISORNOTREAD,LSBZDW_DWBH,LSBZDW_DWMC,REPORTDICTIONARY_CODE,REPORTDICTIONARY_NAME FROM CT_AUDIT_REPORTAUDIT " +
 " INNER JOIN LSBZDW ON REPORTAUDIT_COMPANYID=LSBZDW_ID INNER JOIN CT_FORMAT_REPORTDICTIONARY ON REPORTAUDIT_REPORTID=REPORTDICTIONARY_ID ";
                string whereSql =CreateReportAuditEntityWhereSql(rae);

                sql += whereSql;
                string countSql = "SELECT COUNT(*)  FROM CT_AUDIT_REPORTAUDIT  INNER JOIN LSBZDW ON REPORTAUDIT_COMPANYID=LSBZDW_ID INNER JOIN CT_FORMAT_REPORTDICTIONARY ON REPORTAUDIT_REPORTID=REPORTDICTIONARY_ID "+whereSql;
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<ReportAuditEntity>();
                maps.Add("CompanyName", "LSBZDW_DWMC");
                maps.Add("ReportName", "REPORTDICTIONARY_NAME");
                maps.Add("ReportCode", "REPORTDICTIONARY_CODE");
                maps.Add("CompanyCode", "LSBZDW_DWBH");
                string sortName = maps[dataGrid.sort];
                dg.rows = dbManager.ExecuteSqlReturnTType<ReportAuditEntity>(sql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
                dg.total = dbManager.Count(countSql);
                return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 根据审计对象获取审计查询条件
       /// </summary>
       /// <param name="rae"></param>
       /// <returns></returns>
        private string CreateReportAuditEntityWhereSql(ReportAuditEntity rae) {
            try
            {
                StringBuilder sql=new StringBuilder();
                sql.Append(" WHERE 1=1 ");
                if (!StringUtil.IsNullOrEmpty(rae.CompanyCode))
                {
                    sql.Append(" AND LSBZDW_DWBH LIKE '%");
                    sql.Append(rae.CompanyCode);
                    sql.Append("%' ");
                }
                if (!StringUtil.IsNullOrEmpty(rae.CompanyName))
                {
                    sql.Append(" AND LSBZDW_DWMC LIKE '%");
                    sql.Append(rae.CompanyName);
                    sql.Append("%' ");
                }

                if (!StringUtil.IsNullOrEmpty(rae.ReportCode))
                {
                    sql.Append(" AND REPORTDICTIONARY_CODE LIKE '%");
                    sql.Append(rae.ReportCode);
                    sql.Append("%' ");
                }

                if (!StringUtil.IsNullOrEmpty(rae.ReportName))
                {
                    sql.Append(" AND REPORTDICTIONARY_NAME LIKE '%");
                    sql.Append(rae.ReportName);
                    sql.Append("%' ");
                }
                if (!StringUtil.IsNullOrEmpty(rae.State))
                {
                    sql.Append(" AND REPORTAUDIT_STATE = '");
                    sql.Append(rae.State);
                    sql.Append("' ");
                }
                if (!StringUtil.IsNullOrEmpty(rae.IsOrNotRead))
                {
                    sql.Append(" AND REPORTAUDIT_ISORNOTREAD = '");
                    sql.Append(rae.IsOrNotRead);
                    sql.Append("' ");
                }
                if (!StringUtil.IsNullOrEmpty(rae.TaskId))
                {
                    sql.Append(" AND REPORTAUDIT_TASKID = '");
                    sql.Append(rae.TaskId);
                    sql.Append("' ");
                }
                if (!StringUtil.IsNullOrEmpty(rae.PaperId))
                {
                    sql.Append(" AND REPORTAUDIT_PAPERID = '");
                    sql.Append(rae.PaperId);
                    sql.Append("' ");
                }
               
                if (!StringUtil.IsNullOrEmpty(rae.Year))
                {
                    sql.Append(" AND REPORTAUDIT_YEAR = '");
                    sql.Append(rae.Year);
                    sql.Append("' ");
                }
                if (!StringUtil.IsNullOrEmpty(rae.Zq))
                {
                    sql.Append(" AND REPORTAUDIT_ZQ = '");
                    sql.Append(rae.Zq);
                    sql.Append("' ");
                }

                if (!StringUtil.IsNullOrEmpty(rae.ReportType))
                {
                    sql.Append(" AND REPORTDICTIONARY_CYCLE = '");
                    sql.Append(rae.ReportType);
                    sql.Append("' ");
                }
                //设置权限
                sql.Append(" AND ");
                sql.Append("REPORTAUDIT_COMPANYID ");
                sql.Append(companyService.GetAuditAuthorityCompaniesIdSql());
                return sql.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 保存审计对象
       /// </summary>
       /// <param name="rae"></param>
        public void Save(ReportAuditEntity rae)
        {
            try
            {
                if(StringUtil.IsNullOrEmpty(rae.Id)){
                    rae.Id = Guid.NewGuid().ToString();
                }
                rae.Creater = SessoinUtil.GetCurrentUser().Id;
                rae.CreateTime = SessoinUtil.GetCurrentDateTime();
                linqDbManager.InsertEntity<ReportAuditEntity>(rae);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void Update(ReportAuditEntity rae)
        {
            try
            {
                rae.Creater = SessoinUtil.GetCurrentUser().Id;
                rae.CreateTime = SessoinUtil.GetCurrentDateTime();
                string whereSql = " WHERE REPORTAUDIT_ID ='" + rae.Id + "' ";
                List<DbParameter>parameters=new List<DbParameter>();
                List<string > excludes=new List<string>();
                excludes.Add("Id");
                string sql= dbManager.ConvertBeanToUpdateSql<ReportAuditEntity>(rae, whereSql, parameters, excludes);
                dbManager.ExecuteSql(sql, parameters);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void Delete(ReportAuditEntity rae)
        {
            try
            {
                string sql = "DELETE FROM CT_AUDIT_REPORTAUDIT  WHERE REPORTAUDIT_ID='"+rae.Id+"'";
                dbManager.ExecuteSql(sql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

       /// <summary>
       /// 获取审计信息
       /// </summary>
       /// <param name="rae"></param>
       /// <returns></returns>
        public ReportAuditEntity GetReportAudit(ReportAuditEntity rae)
        {
            try
            {
                string sql = "SELECT * FROM CT_AUDIT_REPORTAUDIT";
                string whereSql = BeanUtil.ConvertObjectToWhereSqls<ReportAuditEntity>(rae);
                if (!StringUtil.IsNullOrEmpty(whereSql.Trim()))
                {
                    sql = sql + " WHERE 1=1 " + whereSql;
                }
                List<ReportAuditEntity> lists = dbManager.ExecuteSqlReturnTType<ReportAuditEntity>(sql);
                if (lists.Count > 0)
                {
                    return lists[0];
                }
                else
                {
                    return null;
                }
               
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }



       /// <summary>
       /// 审计封存和取消审计封存
       /// </summary>
       /// <param name="ids"></param>
       /// <param name="isOrNotClose"></param>
        public void AuditClose(string ids,bool isOrNotClose)
        {
            try
            {
                string flag="";
                if(isOrNotClose){
                    flag="1";
                }else{
                    flag = "0";
                }
                string sql = "UPDATE CT_AUDIT_REPORTAUDIT SET REPORTAUDIT_STATE='" + flag + "' WHERE REPORTAUDIT_ID IN ("+StringUtil.ConvertStringToInSql(ids)+")";
                dbManager.ExecuteSql(sql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
