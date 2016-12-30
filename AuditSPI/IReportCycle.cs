using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AuditSPI
{
    public  interface IReportCycle
    {
        ReportCycleStruct GetReportCycleData(ReportCycleStruct rcs);
        /// <summary>
        /// 获取指标的年度和周期
        /// 应用：审计联查中的相关指标获取报表的年度和周期；
        /// </summary>
        /// <param name="rcs"></param>
        /// <param name="indexType"></param>
        /// <returns></returns>
        ReportCycleStruct GetReportIndexCycleByIndexType(ReportCycleStruct rcs, RelationIndexesType indexType);
        /// <summary>
        /// 根据报表类型、周期类型获取当前报表的周期序列
        /// 应用：审计联查中的指标趋势获取周期序列
        /// </summary>
        /// <param name="ReportType"></param>
        /// <param name="DurationType"></param>
        /// <returns></returns>
        List<string> GetReportCyclesByDurationType(ReportCycleStruct rcs, string DurationType);

        string GetReportCycleSuffix(string reportType);
        /// <summary>
        /// 获取汇总报表数据的历史趋势周期
        /// </summary>
        /// <param name="reportType"></param>
        /// <returns></returns>
        string GetAgggregationReportTrendType(string reportType);
    }

    /// <summary>
    /// 指标类型
    /// </summary>
       public enum RelationIndexesType
   {
       LastPeriod,
       SamePeriod,
       RelativeRatio,
       SameRatio
   }

}
