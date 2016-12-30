using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.ReportAggregation;
using AuditSPI.ReportAudit;
using AuditEntity.ReportAudit;


namespace AuditSPI.ReportAggregation
{
    public  interface IReportAggregation
    {
        /// <summary>
        /// 报表汇总
        /// </summary>
        /// <param name="ras"></param>
        void ReportAggregation(ReportAggregationStruct ras);

        void SaveAggregationLog(AggregationLogEntity ale);
        AggregationTemplateEntity GetPreAggregationLogEntity();
        DataGrid<AggregationLogEntity> GetAggregationLogEnties(DataGrid<AggregationLogEntity> dataGrid,AggregationLogEntity ale);

        void SaveAggregationTemplate(AggregationTemplateEntity ate);
        void UpdateAggregationTemplate(AggregationTemplateEntity ate);
        void DeleteAggregationTemplate(AggregationTemplateEntity ate);
        AggregationTemplateEntity GetAggregationTemplate(AggregationTemplateEntity ate);

        void SaveAggregationTemplateClassify(AggregationClassifyEntity ace);
        void UpdateAggregationTemplateClassify(AggregationClassifyEntity ace);
        void DeleteAggregationTemplateClassify(AggregationClassifyEntity ace);
        List<AggregationClassifyEntity> GetAggregationClassifys(AggregationClassifyEntity ace);
        DataGrid<AggregationTemplateEntity> GetAggregationTemplates(DataGrid<AggregationTemplateEntity> dataGrid, AggregationTemplateEntity ate);
        /// <summary>
        /// 获取汇总报表单元格的数据历史趋势
        /// </summary>
        /// <param name="reportAuditCellConclusion"></param>
        /// <returns></returns>
        ChartDataStruct GetReportCellDataTrend(ReportAuditCellConclusion reportAuditCellConclusion);
        /// <summary>
        /// 获取汇总报表单元格的构成
        /// </summary>
        /// <param name="reportAuditCellConclusion"></param>
        /// <param name="companies"></param>
        /// <returns></returns>
        List<CompanyItemStruct> GetAggregationReportCellConstitute(ReportAuditCellConclusion reportAuditCellConclusion, List<CompanyItemStruct> companies);
    }
}
