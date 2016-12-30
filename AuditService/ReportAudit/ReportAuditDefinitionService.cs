using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.ReportAudit;
using AuditSPI.ReportAudit;
using DbManager;
using CtTool;
using GlobalConst;

namespace AuditService.ReportAudit
{
    public  class ReportAuditDefinitionService:IReportAuditDefinition
    {
        CTDbManager dbManager;
        public ReportAuditDefinitionService()
        {
            if (dbManager == null)
            {
                dbManager = new CTDbManager();
            }
        }
        /// <summary>
        /// 保存审计联查定义
        /// </summary>
        /// <param name="auditDefinitionMaps"></param>
        public void SaveAuditDefinition(Dictionary<string, ReportAuditDefinitionEntity> auditDefinitionMaps)
        {
            try
            {
                StringBuilder result = new StringBuilder();
                StringBuilder sql = new StringBuilder();
                foreach (string indexCode in auditDefinitionMaps.Keys)
                {
                    try
                    {
                        sql.Length = 0;
                        sql.Append("SELECT * FROM CT_AUDIT_DEFINITION WHERE 1=1 ");
                        sql.Append(CreateAuditDefinitionWhereSql(auditDefinitionMaps[indexCode]));
                        List<ReportAuditDefinitionEntity> auditDefinitions = dbManager.ExecuteSqlReturnTType<ReportAuditDefinitionEntity>(sql.ToString());
                        if (auditDefinitions.Count > 0)
                        {
                            sql.Length = 0;
                            auditDefinitionMaps[indexCode].Id = auditDefinitions[0].Id;
                            sql.Append(CreateAuditDefinitionUpdateSql(auditDefinitionMaps[indexCode]));
                            dbManager.ExecuteSql(sql.ToString());

                        }
                        else
                        {
                      
                            auditDefinitionMaps[indexCode].Id = Guid.NewGuid().ToString();
                            auditDefinitionMaps[indexCode].Creater = SessoinUtil.GetCurrentUser().Id;
                            auditDefinitionMaps[indexCode].CreateTime = SessoinUtil.GetCurrentDateTime();
                            sql.Length = 0;
                            sql.Append(CreateAuditDefinitionInsertSql(auditDefinitionMaps[indexCode]));
                            dbManager.ExecuteSql(sql.ToString());
                        }
                    }
                    catch (Exception ex)
                    {
                        result.Append("单元格"+indexCode+"错误信息:"+ex.Message+";");
                    }
                }
                if (result.Length > 0) throw new Exception(result.ToString());
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 创建审计联查定义的Where条件Sql
        /// </summary>
        /// <param name="rade"></param>
        /// <returns></returns>
        private string CreateAuditDefinitionWhereSql(ReportAuditDefinitionEntity rade)
        {
            try
            {
                 Dictionary<string,string> maps=new Dictionary<string,string>();
                 maps.Add("Id","Id");
                 maps.Add("Data","Data");
                 maps.Add("Creater","Creater");
                 maps.Add("CreateTime","CreateTime");
                 string sql = BeanUtil.ConvertObjectToWhereSqls<ReportAuditDefinitionEntity>(rade, maps);
                 return sql;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        
        /// <summary>
        /// 创建联查定义更新SQL
        /// </summary>
        /// <param name="rade"></param>
        /// <returns></returns>
        private string CreateAuditDefinitionUpdateSql(ReportAuditDefinitionEntity rade)
        {
            try
            {
                rade.Data = Base64.Encode64(rade.Data);
                string updateSql = "UPDATE CT_AUDIT_DEFINITION SET DEFINITION_DATA='"+rade.Data+"'";
                updateSql += " WHERE DEFINITION_ID='"+rade.Id+"'";
                return updateSql;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 创建插入Sql
        /// </summary>
        /// <param name="rade"></param>
        /// <returns></returns>
        private string CreateAuditDefinitionInsertSql(ReportAuditDefinitionEntity rade)
        {
            try
            {
                rade.Data = Base64.Encode64(rade.Data);
                string insertSql = BeanUtil.ConvertBeanToInsertCommandSql<ReportAuditDefinitionEntity>(rade);
                return insertSql;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 获取报表审计联查属性
        /// </summary>
        /// <param name="rade"></param>
        public Dictionary<string, ReportAuditDefinitionEntity> GetAuditDefinition(ReportAuditDefinitionEntity rade)
        {
            try
            {
                StringBuilder sql = new StringBuilder();
                sql.Append("SELECT * FROM CT_AUDIT_DEFINITION WHERE 1=1 ");
                if (false)
                {
                    //sql.Append(" AND DEFINITION_TASKID='" + rade.TaskId + "'");
                    //sql.Append(" AND DEFINITION_PAPERID='" + rade.TaskId + "'");
                }
                sql.Append(" AND DEFINITION_REPORTID='"+rade.ReportId+"'");
                List<ReportAuditDefinitionEntity> definitions = dbManager.ExecuteSqlReturnTType<ReportAuditDefinitionEntity>(sql.ToString());

                Dictionary<string, ReportAuditDefinitionEntity> result = new Dictionary<string, ReportAuditDefinitionEntity>();
                foreach (ReportAuditDefinitionEntity d in definitions)
                {
                    if (d.IndexCode != null)
                    {
                        d.Data = Base64.Decode64(d.Data);
                        result.Add(d.IndexCode, d);
                    }
                }
                return result;
                
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// 获取单个单元格的审计联查定义信息
        /// </summary>
        /// <param name="rade"></param>
        /// <returns></returns>
        public ReportAuditDefinitionEntity GetReportAuditCellIndexData(ReportAuditDefinitionEntity rade)
        {
            try
            {
                StringBuilder sql = new StringBuilder();
                sql.Append("SELECT * FROM CT_AUDIT_DEFINITION WHERE 1=1 ");
                if (!StringUtil.IsNullOrEmpty(rade.ReportId))
                {
                    sql.Append(" AND ");
                    sql.Append(" DEFINITION_REPORTID='"+rade.ReportId+"' ");
                }
                if (!StringUtil.IsNullOrEmpty(rade.IndexCode))
                {
                    sql.Append(" AND ");
                    sql.Append(" DEFINITION_INDEXCODE='"+rade.IndexCode+"' ");
                }
                List<ReportAuditDefinitionEntity> definitions = dbManager.ExecuteSqlReturnTType<ReportAuditDefinitionEntity>(sql.ToString());
                if (definitions.Count > 0)
                {
                    return definitions[0];
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
    }
}
