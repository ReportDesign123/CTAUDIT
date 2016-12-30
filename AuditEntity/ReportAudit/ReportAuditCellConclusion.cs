using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.ReportAudit
{
    /// <summary>
    /// 审计结论
    /// 存储指标的审计结论、说明
    /// 指标说明
    /// </summary>
         [Table(Name = "CT_AUDIT_INDEX")]
  public   class ReportAuditCellConclusion
    {
[Column(Name = "INDEX_ID", IsPrimaryKey = true)]
      public string Id
      {
          get;
          set;
      }
              [Column(Name = "INDEX_TASKID")]
      public string TaskId
      {
          get;
          set;
      }
              [Column(Name = "INDEX_PAPERID")]
      public string PaperId
      {
          get;
          set;
      }
             [Column(Name = "INDEX_REPORTID")]
              public string ReportId
              {
                  get;
                  set;
              }
              [Column(Name = "INDEX_COMPANYID")]
      public string CompanyId
      {
          get;
          set;
      }
              [Column(Name = "INDEX_YEAR")]
      public string Year
      {
          get;
          set;
      }
              [Column(Name = "INDEX_CYCLE")]
      public string Cycle
      {
          get;
          set;
      }
              [Column(Name = "INDEX_CODE")]
      public string CellCode
      {
          get;
          set;
      }
              [Column(Name = "INDEX_CREATER")]
      public string Creater
      {
          get;
          set;
      }
              [Column(Name = "INDEX_CREATETIME")]
      public string CreateTime
      {
          get;
          set;
      }
              [Column(Name = "INDEX_CONCLUSION")]
      public string Conclusion
      {
          get;
          set;
      }
              [Column(Name = "INDEX_DISCRIPTION")]
      public string Discription
      {
          get;
          set;
      }
             [Column(Name = "INDEX_PRIMARY")]
              public string BdPrimary
              {
                  get;
                  set;
              }
              public string ReportType
              {
                  get;
                  set;
              }

              public string TemplateId
              {
                  get;
                  set;
              }
    }
}
