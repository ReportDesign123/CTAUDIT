using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AuditSPI.ReportData
{
    /// <summary>
    /// 报表处理对象
    /// </summary>
    public  class ReportDataParameterStruct
    {
        public string TaskId;
        public string PaperId;
        public string CompanyId;
        public string ReportId;
        public string Year;
        public string Cycle;
        public string ReportCode;
        public string AuditDate;
        public string ReportType;
       
        //变动区辅助数据加载
        //解决大数据量问题，用于记录每个变动区实际的数据量和已加载数据量
        public Dictionary<string, BdqData> bdqMaps = new Dictionary<string, BdqData>();

       
        public string bdqStr = "";
        //批量处理的报表ID、单位ID和报表编号序列，每个ID之间用逗号隔开
        public string Reports;
        public string Companies;
        public string ReportCodes;

        public string WeekReportID;
        public string WeekReportName;
        public string WeekReportKsrq;
        public string WeekReportJsrq;

        public string Where;


    }

    /// <summary>
    /// 大数据流量加载对象
    /// </summary>
    public class BdqData
    {
        public int loadNumber;
        public int totalNumber;
        public string isOrNotLoadAll = "0";
    }
}
