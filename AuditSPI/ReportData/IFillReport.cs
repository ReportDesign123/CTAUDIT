using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.AuditPaper;
using AuditEntity;
using System.Data;
using AuditEntity.ReportAudit;
using AuditSPI.ReportAudit;
using AuditSPI.ReportAggregation;

namespace AuditSPI.ReportData
{
    public interface IFillReport
    {
        List<AuditPaperEntity> GetAuditPaperByAuditTask(string TaskId);
        //获取审计任务下审计底稿的列表
        DataGrid<AuditPaperEntity> GetAuditPaperByAuditTask(string TaskId,AuditPaperEntity ape,DataGrid<AuditPaperEntity> datagrid);
        //获取审计底稿下面的审计报表
        List<ReportFormatDicEntity> GetReportsByAuditPaper(ReportFormatDicEntity rcde, string auditPaperId);
        Dictionary<string, List<ReportFormatDicEntity>> GetReportsByAuditPapers(List<AuditPaperEntity> AuditPapers);
        ReportDataStruct LoadReportDatas(ReportDataParameterStruct rdps,bool selectAll=false);
        void SaveReportDatas(ReportDataStruct rds);
        void SaveReportFormat(string BBID, string strFormula);
        void DeleteBdqData(string id, string tableName);
        DataTable LoadReportItems(string items, string tableName, ReportDataParameterStruct rdps,string whereSql);
        List<ReportFormatStruct> GetReportFormatStructsByAuditPaper(AuditPaperEntity ape, ReportFormatDicEntity rfde);
        string ExistReportFormat(ReportDataParameterStruct rdps, string tableName);
        string GetMarcoName(ReportDataParameterStruct rdps, string strMacro);
        //获取报表首次加载时报表的数据；
        ReportFirstLoadStruct GetReportFirstLoadStruct(ReportDataParameterStruct rdps,ReportFormatDicEntity rfde);
        //清空当前报表的数据
        void ClearReportData(ReportDataParameterStruct rdps);
        //报表批量运算时
        ReportFirstLoadStruct GetReportBatchProcessStruct(ReportDataParameterStruct rdps, ReportFormatDicEntity rfde);
        //获取相关指标的数据
        RelationsIndexesDataStruct GetRelationsIndexesData(ReportAuditCellConclusion reportAuditCellConclusion, IndexRelationsStruct indexRelationsStruct);
        //获取相关指标的历史趋势
       List<Dictionary<string,decimal>> GetIndexTrendData(ReportAuditCellConclusion reportAuditCellConclusion, IndexTrendStruct indexTrendStruct);

      
        //获取指标劣势趋势
        ChartDataStruct GetIndexTrendChartData(ReportAuditCellConclusion reportAuditCellConclusion, IndexTrendStruct indexTrendStruct);
        //获取指标构成属性
        List<IndexConstitutionCellDifinition> GetIndexConstitutionCellDefinitionData(ReportAuditCellConclusion reportAuditCellConclusion, IndexConstitutionStruct indexConstitution);
        /// <summary>
        /// 获取汇总报表单元格构成
        /// </summary>
        /// <param name="reportAuditCellConclusion"></param>
        /// <param name="companies"></param>
        /// <returns></returns>
        List<CompanyItemStruct> GetAggregationReportCellConstituteData(ReportAuditCellConclusion reportAuditCellConclusion, List<CompanyItemStruct> companies);
        ItemDataValueStruct GetReportDataItem(ReportDataParameterStruct rdps);
    }
    public class ReportFirstLoadStruct
    {
        //报表周期
      public   ReportCycleStruct reportCycle = new ReportCycleStruct();
        //报表单位
      public  List<CompanyEntity> companies = new List<CompanyEntity>();
        //当前审计底稿下的报表
      public   List<ReportFormatDicEntity> reports = new List<ReportFormatDicEntity>();
        //构建树形结构
      public List<TreeNode> companiesTree = new List<TreeNode>();
    

    }
}
