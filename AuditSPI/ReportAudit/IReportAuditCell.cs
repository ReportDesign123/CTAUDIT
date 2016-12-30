using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.ReportAudit;
using AuditSPI.ReportData;

namespace AuditSPI.ReportAudit
{
    public interface IReportAuditCell
    {
        /// <summary>
        /// 获取单个指标相关的数据
        /// </summary>
        /// <param name="rdps"></param>
        /// <param name="rade"></param>
        /// <returns></returns>
        ReportAuditCellStruct GetReportCellDefinitionAndData(ReportDataParameterStruct rdps, ReportAuditDefinitionEntity rade);
        /// <summary>
        /// 获取指标的审计结论和指标描述信息
        /// </summary>
        /// <param name="racc"></param>
        /// <returns></returns>
        ReportAuditCellConclusion GetReportCellConclusionAndDiscription(ReportAuditCellConclusion reportAuditCellConclusion);
        /// <summary>
        /// 获取相关指标
        /// </summary>
        /// <param name="racc"></param>
        /// <returns></returns>
        RelationsIndexesDataStruct GetRelationsIndexes(ReportAuditCellConclusion reportAuditCellConclusion, IndexRelationsStruct indexRelationsStruct);
        /// <summary>
        /// 指标趋势
        /// </summary>
        ChartDataStruct GetIndexTrend(ReportAuditCellConclusion reportAuditCellConclusion, IndexTrendStruct indexTrendStruct);
        /// <summary>
        /// 获取指标构成数据
        /// </summary>
        /// <param name="reportAuditCellConclusion"></param>
        /// <param name="indexConstitution"></param>
        /// <returns></returns>
        List<IndexConstitutionCellDifinition> GetIndexConstitutionCellDefinition(ReportAuditCellConclusion reportAuditCellConclusion, IndexConstitutionStruct indexConstitution);
        /// <summary>
        /// 获取联查报表的数据
        /// </summary>
        /// <param name="rdps"></param>
        /// <returns></returns>
        ReportAuditStruct GetReportLikData(ReportAuditCellConclusion reportAuditCellConclusion ,ReportJoinReportDefinition reportJoinDefinition);
        /// <summary>
        /// 获取自定义联查报表数据
        /// </summary>
        /// <param name="reportAuditCellConclusion"></param>
        /// <param name="customerJoinDefinition"></param>
        /// <returns></returns>
        CustomerGridDataStruct GetCustomerReportLinkData(ReportAuditCellConclusion reportAuditCellConclusion, CustomerJoinStruct customerJoinDefinition);

        void SaveReportCellIndexConclusion(ReportAuditCellConclusion reportAuditCellConclusion);
    }
}
