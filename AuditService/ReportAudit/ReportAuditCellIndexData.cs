using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;

using AuditSPI.ReportAudit;
using AuditEntity.ReportAudit;
using AuditSPI.ReportData;
using DbManager;
using CtTool;
using GlobalConst;
using AuditService.ReportData;
using AuditEntity;


namespace AuditService.ReportAudit
{
    public  class ReportAuditCellIndexData:IReportAuditCell
    {
        CTDbManager dbManager;
        ReportAuditDefinitionService reportAuditDefinitionService;
        FillReportService fillReportService;
        LinqDataManager linqDbManager;
        ReportFormatService reportFormatService;
        FormularService formularService;
        public ReportAuditCellIndexData()
        {
            if (dbManager == null)
            {
                dbManager = new CTDbManager();
            }
            if (reportAuditDefinitionService == null)
            {
                reportAuditDefinitionService = new ReportAuditDefinitionService();
            }
            if (fillReportService == null)
            {
                fillReportService = new FillReportService();
            }
            if (linqDbManager == null)
            {
                linqDbManager = new LinqDataManager();
            }
            if (reportFormatService == null)
            {
                reportFormatService = new ReportFormatService();
            }
            if (formularService == null)
            {
                formularService = new FormularService();
            }
        }

        #region 指标数据获取
        /// <summary>
        /// 获取审计单元格的信息
        /// </summary>
        /// <param name="rade"></param>
        /// <returns></returns>
        public ReportAuditCellStruct GetReportCellDefinitionAndData(ReportDataParameterStruct rdps, ReportAuditDefinitionEntity rade)
        {
            try
            {
                ReportAuditCellStruct racs=new ReportAuditCellStruct();
                ReportAuditDefinitionEntity trade = reportAuditDefinitionService.GetReportAuditCellIndexData(rade);
                if (rade != null)
                {
                    //根据联查定义加载数据
                    string cellData =Base64.Decode64(trade.Data);
                    ReportAuditCellDefinitionDataStruct racdds = JsonTool.DeserializeObject<ReportAuditCellDefinitionDataStruct>(cellData);
                     //是否存在指标结论
                    if (racdds.IsOrNotExistModule(ReportAuditCellDefinitionDataStruct.IndexConclusion_Module))
                    {
                        ReportAuditCellConclusion racc=new ReportAuditCellConclusion();
                        racc.TaskId=rdps.TaskId;
                        racc.PaperId=rdps.PaperId;
                        racc.ReportId=rdps.ReportId;
                        racc.CompanyId=rdps.CompanyId;
                        racc.Year=rdps.Year;
                        racc.Cycle=rdps.Cycle;
                        racc.CellCode=rade.IndexCode;

                        racs.reportAuditCellConclusion = GetReportCellConclusionAndDiscription(racc);
                    }

                    //判断是否存在报表指标信息

                    

                }
                else
                {
                    //加载默认的数据
                }
                return racs;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 获取指标的审计结论和指标的描述
        /// </summary>
        /// <param name="racc"></param>
        /// <returns></returns>
        public ReportAuditCellConclusion GetReportCellConclusionAndDiscription(ReportAuditCellConclusion racc)
        {
            try
            {
                
                string sql = "SELECT * FROM CT_AUDIT_INDEX WHERE 1=1 ";
                if (!StringUtil.IsNullOrEmpty(racc.TaskId)&&ReportGlobalConst.IsOrNotRelationTaskAndPaper)
                {
                    sql += " AND INDEX_TASKID='"+racc.TaskId+"'";
                }

                if (!StringUtil.IsNullOrEmpty(racc.PaperId) && ReportGlobalConst.IsOrNotRelationTaskAndPaper)
                {
                    sql += " AND INDEX_PAPERID='" + racc.PaperId + "'";
                }

                if (!StringUtil.IsNullOrEmpty(racc.ReportId))
                {
                    sql += " AND INDEX_REPORTID='" + racc.ReportId + "'";
                }

                if (!StringUtil.IsNullOrEmpty(racc.CompanyId))
                {
                    sql += " AND INDEX_COMPANYID='" + racc.CompanyId + "'";
                }

                if (!StringUtil.IsNullOrEmpty(racc.Year))
                {
                    sql += " AND INDEX_YEAR='" + racc.Year + "'";
                }

                if (!StringUtil.IsNullOrEmpty(racc.Cycle))
                {
                    sql += " AND INDEX_CYCLE='" + racc.Cycle + "'";
                }

                if (!StringUtil.IsNullOrEmpty(racc.CellCode))
                {
                    sql += " AND INDEX_CODE='" + racc.CellCode + "'";
                }
                if (!StringUtil.IsNullOrEmpty(racc.BdPrimary))
                {
                    sql += " AND INDEX_PRIMARY='" + racc.BdPrimary + "'";
                }
                List<ReportAuditCellConclusion> results = dbManager.ExecuteSqlReturnTType<ReportAuditCellConclusion>(sql);
                if (results.Count > 0)
                {
                    results[0].Conclusion = Base64.Decode64(results[0].Conclusion);
                    return results[0];
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
        /// 获取相关指标的数据
        /// </summary>
        /// <param name="reportAuditCellConclusion"></param>
        /// <param name="indexRelationsStruct"></param>
        /// <returns></returns>
        public RelationsIndexesDataStruct GetRelationsIndexes(ReportAuditCellConclusion reportAuditCellConclusion, IndexRelationsStruct indexRelationsStruct)
        {
            try
            {
                RelationsIndexesDataStruct indexes = fillReportService.GetRelationsIndexesData(reportAuditCellConclusion, indexRelationsStruct);
                return indexes;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 获取指标趋势的数据
        /// </summary>
        /// <param name="reportAuditCellConclusion"></param>
        /// <param name="indexTrendStruct"></param>
        /// <returns></returns>
        public ChartDataStruct GetIndexTrend(ReportAuditCellConclusion reportAuditCellConclusion, IndexTrendStruct indexTrendStruct)
        {
            try
            {
                ChartDataStruct result = fillReportService.GetIndexTrendChartData(reportAuditCellConclusion, indexTrendStruct);
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 获取指标构成数据
        /// </summary>
        /// <param name="reportAuditCellConclusion"></param>
        /// <param name="indexConstitution"></param>
        /// <returns></returns>
        public List<IndexConstitutionCellDifinition> GetIndexConstitutionCellDefinition(ReportAuditCellConclusion reportAuditCellConclusion, IndexConstitutionStruct indexConstitution)
        {
            try
            {
                return fillReportService.GetIndexConstitutionCellDefinitionData(reportAuditCellConclusion, indexConstitution);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 获取联查报表数据
        /// </summary>
        /// <param name="rdps"></param>
        /// <returns></returns>
        public ReportAuditStruct  GetReportLikData(ReportAuditCellConclusion reportAuditCellConclusion ,ReportJoinReportDefinition reportJoinDefinition)
        {
            try
            {
                ReportAuditStruct ras = new ReportAuditStruct();
                if (ReportGlobalConst.IsOrNotRelationTaskAndPaper)
                {
                    if (StringUtil.IsNullOrEmpty(reportJoinDefinition.Parameters.TaskId))
                    {
                        reportJoinDefinition.Parameters.TaskId = reportAuditCellConclusion.TaskId;
                    }
                    if (StringUtil.IsNullOrEmpty(reportJoinDefinition.Parameters.PaperId))
                    {
                        reportJoinDefinition.Parameters.PaperId = reportAuditCellConclusion.PaperId;
                    }
                }

                if (StringUtil.IsNullOrEmpty(reportJoinDefinition.Parameters.ReportId))
                {
                    reportJoinDefinition.Parameters.ReportId = reportAuditCellConclusion.ReportId;
                }
                if (StringUtil.IsNullOrEmpty(reportJoinDefinition.Parameters.CompanyId))
                {
                    reportJoinDefinition.Parameters.CompanyId = reportAuditCellConclusion.CompanyId;
                }
                if (StringUtil.IsNullOrEmpty(reportJoinDefinition.Parameters.Year))
                {
                    reportJoinDefinition.Parameters.Year = reportAuditCellConclusion.Year;
                }
                if (StringUtil.IsNullOrEmpty(reportJoinDefinition.Parameters.Cycle))
                {
                    reportJoinDefinition.Parameters.Cycle = reportAuditCellConclusion.Cycle;
                }
                ras.reportFormat = reportFormatService.LoadReportFormat(reportJoinDefinition.Parameters.ReportId);
                ras.reportData = fillReportService.LoadReportDatas(reportJoinDefinition.Parameters);
               
                return ras;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

              #endregion

        /// <summary>
        /// 保存或者更新指标结论；
        /// 更新的时候需要传入ID
        /// </summary>
        /// <param name="reportAuditCellConclusion"></param>
        public void SaveReportCellIndexConclusion(ReportAuditCellConclusion reportAuditCellConclusion)
        {
            try
            {
                if (StringUtil.IsNullOrEmpty(reportAuditCellConclusion.Id))
                {
                    reportAuditCellConclusion.Id = Guid.NewGuid().ToString();
                    reportAuditCellConclusion.Creater = SessoinUtil.GetCurrentUser().Id;
                    reportAuditCellConclusion.CreateTime = SessoinUtil.GetCurrentDateTime();
                    reportAuditCellConclusion.Conclusion = Base64.Encode64(reportAuditCellConclusion.Conclusion);
                    linqDbManager.InsertEntity<ReportAuditCellConclusion>(reportAuditCellConclusion);
                }else{
                    ReportAuditCellConclusion temp = linqDbManager.GetEntity<ReportAuditCellConclusion>(r => r.Id == reportAuditCellConclusion.Id);
                    BeanUtil.CopyBeanToBean(reportAuditCellConclusion, temp);
                    temp.Conclusion = Base64.Encode64(temp.Conclusion);
                    linqDbManager.UpdateEntity<ReportAuditCellConclusion>(temp);
                }
               
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 获取自动以联查报表数据
        /// </summary>
        /// <param name="reportAuditCellConclusion"></param>
        /// <param name="customerJoinDefinition"></param>
        /// <returns></returns>
        public CustomerGridDataStruct GetCustomerReportLinkData(ReportAuditCellConclusion reportAuditCellConclusion, CustomerJoinStruct customerJoinDefinition)
        {
            try
            {
                if (customerJoinDefinition.LinkType == "url") return null;
                CustomerGridDataStruct result = new CustomerGridDataStruct();
                ReportDataParameterStruct rdps=new ReportDataParameterStruct();
                rdps.TaskId=reportAuditCellConclusion.TaskId;
                rdps.PaperId=reportAuditCellConclusion.PaperId;
                rdps.ReportId=reportAuditCellConclusion.ReportId;
                rdps.CompanyId=reportAuditCellConclusion.CompanyId;
                rdps.Year=reportAuditCellConclusion.Year;
                rdps.Cycle=reportAuditCellConclusion.Cycle;

                FormularEntity formular=new FormularEntity();
                formular.content=customerJoinDefinition.Content;
                formular.FormularDb = customerJoinDefinition.DbType;
                DataTable dataTable=  formularService.GetSingleFatchFormularData(rdps, formular);
                foreach (DataRow row in dataTable.Rows)
                {
                    Dictionary<string, object> rowD = new Dictionary<string, object>();
                    foreach (DataColumn column in dataTable.Columns)
                    {
                        rowD.Add(column.ColumnName, row[column.ColumnName]);
                    }
                    result.Rows.Add(rowD);
                }

                foreach (DataColumn column in dataTable.Columns)
                {
                    result.Columns.Add(column.ColumnName);
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
