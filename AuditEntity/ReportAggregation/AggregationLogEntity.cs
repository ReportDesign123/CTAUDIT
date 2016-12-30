using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.ReportAggregation
{
    [Table(Name = "CT_AGGREGATE_LOG")]
    public  class AggregationLogEntity
    {
          [Column(Name = "LOG_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
          [Column(Name = "LOG_COMPANYID")]
        public string CompanyId
        {
            get;
            set;
        }
          [Column(Name = "LOG_YEAR")]
        public string Year
        {
            get;
            set;
        }
          [Column(Name = "LOG_CYCLE")]
        public string Cycle
        {
            get;
            set;
        }
          [Column(Name = "LOG_TEMPLATEID")]
        public string TemplateId
        {
            get;
            set;
        }
          [Column(Name = "LOG_CREATER")]
        public string Creater
        {
            get;
            set;
        }
          [Column(Name = "LOG_CREATETIME")]
        public string CreateTime
        {
            get;
            set;
        }
          [Column(Name = "LOG_TASKID")]
        public string TaskId
        {
            get;
            set;
        }
          [Column(Name = "LOG_PAPERID")]
        public string Paper
        {
            get;
            set;
        }
        [Column(Name = "LOG_REPORTTYPE")]
          public string ReportType
          {
              get;
              set;
          }
          public string CompanyName
          {
              get;
              set;
          }
          public string TemplateName
          {
              get;
              set;
          }
          public string TemplateCode
          {
              get;
              set;
          }
    }
}
