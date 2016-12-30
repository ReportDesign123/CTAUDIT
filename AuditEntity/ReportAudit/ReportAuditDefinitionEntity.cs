using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.ReportAudit
{
    /// <summary>
    /// 报表审计联查定义
    /// </summary>
     [Table(Name = "CT_AUDIT_DEFINITION")]
    public  class ReportAuditDefinitionEntity
    {
          [Column(Name = "DEFINITION_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
          [Column(Name = "REPORTAUDIT_TASKID")]
        public string TaskId
        {
            get;
            set;
        }
          [Column(Name = "DEFINITION_PAPERID")]
        public string PaperId
        {
            get;
            set;
        }
          [Column(Name = "DEFINITION_REPORTID")]
        public string ReportId
        {
            get;
            set;
        }
          [Column(Name = "DEFINITION_INDEXCODE")]
        public string IndexCode
        {
            get;
            set;
        }
          [Column(Name = "DEFINITION_DATA")]
        public string Data
        {
            get;
            set;
        }
          [Column(Name = "DEFINITION_CREATER")]
        public string Creater
        {
            get;
            set;
        }
          [Column(Name = "DEFINITION_CREATETIME")]
        public string CreateTime
        {
            get;
            set;
        }
    }
}
