using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using AuditSPI;
using AuditEntity.ReportState;
using AuditEntity;

namespace AuditSPI.ReportAnalysis
{
  public   interface IReportStateAggregation
    {
     /// <summary>
     /// 汇总报表状态数据列表
     /// </summary>
     /// <param name="reportState"></param>
     /// <param name="state"></param>
     /// <returns></returns>
      List<ReportStateAggregationStruct> GetReportStateAggregation( ReportStateEntity state);
      /// <summary>
      /// 汇总报表状态根据单位
      /// </summary>
      /// <param name="state"></param>
      /// <returns></returns>
      List<ReportStateAggregationStruct> GetReportStateAggregationByCompany(ReportStateEntity state);
      
      /// <summary>
      /// 根据报表状态获取单位的列表
      /// </summary>
      /// <param name="state"></param>
      /// <returns></returns>
      List<CompanyEntity> GetReportStateAggregationCompanies(ReportStateEntity state);
      /// <summary>
      /// 获取报表列表详情
      /// </summary>
      /// <param name="state"></param>
      /// <returns></returns>
      List<ReportFormatDicEntity> GetReportStateAggregationReports(ReportStateEntity state);
    }
}
