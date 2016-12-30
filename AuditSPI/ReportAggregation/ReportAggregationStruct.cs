using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.ReportAggregation;


namespace AuditSPI.ReportAggregation
{
    /// <summary>
    /// 报表汇总辅助数据结构
    /// </summary>
   public   class ReportAggregationStruct
    {
       public  List<string> ReportItems = new List<string>();
       public  List<string> Companies = new List<string>();
       public string TaskId;
       public string PaperId;
       public string Year;
       public string Cycle;
       public string templateId;
       public string ReportType;

    }
    /// <summary>
    /// 报表ID、报表年度、报表周期封装包
    /// </summary>
   public class ReportItem
   {
       public string ReportId;
   }
    /// <summary>
    /// 报表和单位结构
    /// </summary>
   public class ReportsAndCompanies
   {
       public List<string> reports = new List<string>();
       public List<string> companies = new List<string>();
   }
   /// <summary>
   /// 报表汇总中的单位结构
   /// </summary>
   public class CompanyItemStruct
   {
       public string id;
       public string name;
       public Dictionary<string, object> values = new Dictionary<string, object>();
      
   }
    /// <summary>
    /// 报表汇总中的报表结构
    /// </summary>
   public class ReportItemStruct
   {
       public string Id;
       public string bbCode;
       public string bbName;

      
   }
    /// <summary>
    /// 报表汇总模板内容反序列化结构
    /// </summary>
   public class ReportAggregationContentStruct
   {
      public   List<ReportItemStruct> ReportItems = new List<ReportItemStruct>();
      public   List<CompanyItemStruct> Companies = new List<CompanyItemStruct>();
   }


}
