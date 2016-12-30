using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditService;
using AuditSPI;
using DbManager;
using CtTool;
using AuditEntity;
using GlobalConst;

namespace AuditService
{
   public   class ReportCycleService:IReportCycle
    {
       LinqDataManager linqDataManager;
       public ReportCycleService()
       {
           linqDataManager = new LinqDataManager();
       }
        public ReportCycleStruct GetReportCycleData(ReportCycleStruct cycle)
        {
            try
            {
                string ReportDateStr=SessoinUtil.GetCurrentDateTime();
                if (StringUtil.IsNullOrEmpty(cycle.CurrentNd)) { cycle.CurrentNd = ReportDateStr.Substring(0, 4); }
                ReportCycleStruct rcs = new ReportCycleStruct();
                //生成年度列表
                ConfigEntity cf = linqDataManager.GetEntity<ConfigEntity>(r => r.Name == "CSND");
                int startYear = Convert.ToInt32(cf.Value);
                rcs.Nds = GetYearReportNameValues(startYear, SessoinUtil.GetCurrentYear());

                rcs.CurrentNd = cycle.CurrentNd;
                //生成周期列表
                switch (cycle.ReportType)
                {
                    case "01"://年报
                        rcs.Cycles = GetYearReportNameValues(startYear, SessoinUtil.GetCurrentYear());
                        rcs.CurrentZq =cycle.CurrentNd;
                        break;
                    case "02"://月报
                        rcs.Cycles = GetMonthNameValues();
                        if (StringUtil.IsNullOrEmpty(cycle.CurrentZq))
                        {
                            rcs.CurrentZq = ReportDateStr.Substring(5, 2);
                        }
                        else
                        {
                            rcs.CurrentZq = cycle.CurrentZq;
                        }
                        
                        break;
                    case "03"://季报
                        rcs.Cycles = GetQuarterNameValues();                        
                        if (StringUtil.IsNullOrEmpty(cycle.CurrentZq))
                        {
                            rcs.CurrentZq = "0" + ((Convert.ToInt32(ReportDateStr.Substring(5, 2)) - 1) / 3 + 1).ToString();
                        }
                        else
                        {
                            rcs.CurrentZq = cycle.CurrentZq;
                        }
                        break;
                    case "04"://日报
                        if (StringUtil.IsNullOrEmpty(cycle.CurrentZq))
                        {
                            rcs.CurrentZq = ReportDateStr;
                        }
                        else
                        {
                            rcs.CurrentZq = cycle.CurrentZq;
                        }                        
                        break;
                    case "05"://周报
                       
                       rcs.CurrentZq = cycle.CurrentZq;
                        
                        break;
                    default:
                        rcs.Cycles = GetMonthNameValues();
                        rcs.CurrentZq = ReportDateStr.Substring(5, 2);
                        break;
                }
                return rcs;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 获取年报周期
       /// </summary>
       /// <param name="startYear"></param>
       /// <param name="endYear"></param>
       /// <returns></returns>
        private List<NameValueStruct> GetYearReportNameValues(int startYear, int endYear)
        {
            List<NameValueStruct> nvss = new List<NameValueStruct>();
            for (int i = startYear; i <= endYear; i++)
            {
                NameValueStruct nvs = new NameValueStruct();
                nvs.name = i.ToString()+"年";
                nvs.value = i.ToString();
                nvss.Add(nvs);
            }
            return nvss;
        }

        private List<NameValueStruct> GetMonthNameValues()
        {
            List<NameValueStruct> months = new List<NameValueStruct>();
            for (int i = 1; i <= 12; i++)
            {
                NameValueStruct nvs = new NameValueStruct();
                nvs.name = i.ToString() + "月";
                nvs.value = i < 10 ? "0" + i.ToString() : i.ToString();
                months.Add(nvs);
            }
            return months;
        }

        public List<NameValueStruct> GetQuarterNameValues()
        {
            List<NameValueStruct> quarters = new List<NameValueStruct>();
            for (int i = 1; i <= 4; i++)
            {
                NameValueStruct nvs = new NameValueStruct();
                nvs.name = i.ToString() + "季度";
                nvs.value = "0" + i.ToString();
                quarters.Add(nvs);
            }
            return quarters;
        }


       /// <summary>
       /// 根据指标类型获取相关指标的报表年度和周期
       /// </summary>
       /// <param name="rcs"></param>
       /// <param name="indexType"></param>
       /// <returns></returns>
        public ReportCycleStruct GetReportIndexCycleByIndexType(ReportCycleStruct rcs, RelationIndexesType indexType)
        {
            try
            {
                switch (indexType)
                {
                    case RelationIndexesType.LastPeriod:
                        GetReportLastPeriodOrRelativeRatioYearCycle(rcs);
                        break;
                    case RelationIndexesType.SamePeriod:
                        GetReportSamePeriodOrSameRatioYearCycle(rcs);
                        break;
                    case RelationIndexesType.RelativeRatio:
                        GetReportLastPeriodOrRelativeRatioYearCycle(rcs);
                        break;
                    case RelationIndexesType.SameRatio:
                        GetReportSamePeriodOrSameRatioYearCycle(rcs);
                        break;
                }
                return rcs;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

     
       /// <summary>
       /// 获取报表上期数的年度和周期
       /// </summary>
       /// <param name="?"></param>
       /// <returns></returns>
        private ReportCycleStruct GetReportLastPeriodOrRelativeRatioYearCycle(ReportCycleStruct rcs)
        {
            try
            {
                int year = Convert.ToInt32(rcs.CurrentNd);
                int zq=Convert.ToInt32(rcs.CurrentZq);

                switch (rcs.ReportType)
                {
                    case "01":                        
                        rcs.CurrentNd = (year - 1).ToString();
                        rcs.CurrentZq = rcs.CurrentNd;
                        break;
                    case "02":
                        if (zq == 1)
                        {
                            zq = 12;
                            year = year - 1;
                        }
                        else
                        {
                            zq = zq - 1;
                        }
                        rcs.CurrentNd = year.ToString();
                        rcs.CurrentZq = GetMonthOrQuarterCycle(zq);
                        break;
                    case "03":
                        if (zq == 1)
                        {
                            zq = 4;
                            year = year - 1;
                        }
                        else
                        {
                            zq = zq - 1;
                        }
                        rcs.CurrentNd = year.ToString();
                        rcs.CurrentZq = GetMonthOrQuarterCycle(zq);
                        break;
                    case "04":
                        DateTime dt = Convert.ToDateTime(rcs.CurrentZq);
                        dt.AddDays(-1);                       
                        rcs.CurrentNd = dt.Year.ToString();
                        rcs.CurrentZq = dt.ToString("D");
                        break;
                }

                return rcs;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 获取报表同期数的年度和周期
       /// </summary>
       /// <param name="rcs"></param>
       /// <returns></returns>
        private ReportCycleStruct GetReportSamePeriodOrSameRatioYearCycle(ReportCycleStruct rcs)
        {
            try
            {
                int year = Convert.ToInt32(rcs.CurrentNd);
                rcs.CurrentNd = (year - 1).ToString();
                return rcs;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

       
       /// <summary>
       /// 获取月报或者季报的周期
       /// </summary>
       /// <param name="zq"></param>
       /// <returns></returns>
        private string GetMonthOrQuarterCycle(int zq)
        {
            try
            {
                return zq < 10 ? "0" + zq.ToString() : zq.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

       /// <summary>
       /// 根据联查趋势的时间周期获取报表的周期
       /// </summary>
       /// <param name="rcs"></param>
       /// <param name="DurationType"></param>
       /// <returns></returns>
        public List<string> GetReportCyclesByDurationType(ReportCycleStruct rcs, string DurationType)
        {
            try
            {
                List<string> cycles = new List<string>();
                if (DurationType == ReportGlobalConst.IndexTrend_CurrentYear)
                {
                   cycles= GetYearDurationTypeCycles(rcs);
                }
                else if (DurationType == ReportGlobalConst.IndexTrend_CurrentMonth)
                {
                   cycles = GetMonthDurationTypeCycles(rcs);
                }
                else if (DurationType == ReportGlobalConst.IndexTrend_CurrentQuarter)
                {
                   cycles= GetQuarterDurationTypeCycles(rcs);
                }
                else if (DurationType == ReportGlobalConst.IndexTrend_CurrentWeek)
                {
                   cycles = GetWeekDurationTypeCycles(rcs);
                }
                return cycles;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 当前年的列表
       /// </summary>
       /// <param name="rcs"></param>
       /// <returns></returns>
        private List<string> GetYearDurationTypeCycles(ReportCycleStruct rcs)
        {
            try
            {
                List<string> results = new List<string>();
                switch (rcs.ReportType)
                {
                    case "01":
                        results.Add(rcs.CurrentZq);
                        break;
                    case "02":
                        for (int i = 1; i <= 12; i++)
                        {
                            if (i < 10)
                            {
                                results.Add("0" + i.ToString());

                            }
                            else
                            {
                                results.Add(i.ToString());
                            }
                        }
                        break;
                    case "03":
                        for (int i = 1; i <= 4; i++)
                        {
                            results.Add("0"+i.ToString());
                        }
                        break;
                    case "04":
                        int year = Convert.ToInt32(rcs.CurrentNd);
                        int yearDays = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0) ? 366 : 365;
                        DateTime temp = new DateTime(year, 1, 1);
                        for (int i = 1; i <= yearDays; i++)
                        {
                            results.Add(temp.ToString("D"));
                            temp.AddDays(1);
                        }

                        break;
                }
                return results;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 获取月
       /// </summary>
       /// <param name="rcs"></param>
       /// <returns></returns>
        private List<string> GetMonthDurationTypeCycles(ReportCycleStruct rcs)
        {
            try
            {
                List<string> results = new List<string>();
                switch (rcs.ReportType)
                {
                        //年报
                    case "01":
                        results.Add(rcs.CurrentZq);
                        break;
                        //月报
                    case "02":
                        results.Add(rcs.CurrentZq);
                        break;
                        //季报
                    case "03":
                        results.Add(rcs.CurrentZq);
                        break;
                        //日报
                    case "04":
                        int year = Convert.ToInt32(rcs.CurrentNd);
                        int month = Convert.ToInt32(SessoinUtil.GetCwMonth(rcs.CurrentZq));
                        int days = DateTime.DaysInMonth(year, month);
                        DateTime temp = new DateTime(year, month, 1);
                        for (int i = 1; i <= days; i++)
                        {
                            results.Add(temp.ToString("D"));
                            temp.AddDays(1);
                        }
                        break;
                }
                return results;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 获取季度
       /// </summary>
       /// <param name="rcs"></param>
       /// <returns></returns>
        private List<string> GetQuarterDurationTypeCycles(ReportCycleStruct rcs)
        {
            try
            {
                List<string> results = new List<string>();
                switch (rcs.ReportType)
                {
                    //年报
                    case "01":
                        results.Add(rcs.CurrentZq);
                        break;
                    //月报
                    case "02":
                        
                        break;
                    //季报
                    case "03":
                        results.Add(rcs.CurrentZq);
                        break;
                    //日报
                    case "04":
                        int year = Convert.ToInt32(rcs.CurrentNd);
                        int month = Convert.ToInt32(SessoinUtil.GetCwMonth(rcs.CurrentZq));
                        int days = DateTime.DaysInMonth(year, month);
                        DateTime temp = new DateTime(year, month, 1);
                        for (int i = 1; i <= days; i++)
                        {
                            results.Add(temp.ToString("D"));
                            temp.AddDays(1);
                        }
                        break;
                }
                return results;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// 获取周
        /// </summary>
        /// <param name="rcs"></param>
        /// <returns></returns>
        private List<string> GetWeekDurationTypeCycles(ReportCycleStruct rcs)
        {
            try
            {
                List<string> results = new List<string>();
                switch (rcs.ReportType)
                {
                    //年报
                    case "01":
                        results.Add(rcs.CurrentZq);
                        break;
                    //月报
                    case "02":
                        results.Add(rcs.CurrentZq);
                        break;
                    //季报
                    case "03":
                        results.Add(rcs.CurrentZq);
                        break;
                    //日报
                    case "04":

                        DateTime temp = Convert.ToDateTime(rcs.CurrentZq);
                        DayOfWeek day = temp.DayOfWeek;
                        int d = (int)day;
                        if (d > 0)
                        {
                            temp.AddDays(1 - d);
                        }
                        else
                        {
                            //周日
                            temp.AddDays(-6);
                           
                        }
                        for (int i = 1; i <= 7; i++)
                        {
                            results.Add(temp.ToString("D"));
                            temp.AddDays(1);
                        }

                        break;
                    //周报
                    case "05":
                        results.Add(rcs.CurrentZq);
                        break;
                }
                return results;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 获取报表的周期后缀
       /// </summary>
       /// <param name="reportType"></param>
       /// <returns></returns>
        public string GetReportCycleSuffix(string reportType)
        {
            try
            {
                string result = "";
                switch (reportType)
                {
                    //年报
                    case "01":
                        result= "年";
                        break;
                    //月报
                    case "02":
                        result = "月";
                        break;
                    //季报
                    case "03":
                        result = "季";
                        break;
                    //日报
                    case "04":

                        result = "";
                        break;
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 获取汇总报表的历史趋势类型
       /// </summary>
       /// <param name="reportType"></param>
       /// <returns></returns>
        public string GetAgggregationReportTrendType(string reportType)
        {
            try
            {
                string result="";
                switch (reportType)
                {
                    case "01":
                        result = ReportGlobalConst.IndexTrend_CurrentYear;
                        break;
                    case "02":
                        result = ReportGlobalConst.IndexTrend_CurrentYear;
                        break;
                    case "03":
                        result = ReportGlobalConst.IndexTrend_CurrentYear;
                        break;
                    case "04":
                        result = ReportGlobalConst.IndexTrend_CurrentWeek;
                        break;
                    case "05":
                        result = ReportGlobalConst.IndexTrend_CurrentWeek;
                        break;
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
