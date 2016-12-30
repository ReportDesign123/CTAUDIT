using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.ReportAudit
{
    /// <summary>
    /// 指标统计：
    /// 统计：订阅数、评论数、阅读数、支持数、反对数
    /// </summary>
      [Table(Name = "CT_AUDIT_DEFINITION")]
    public  class ReportAuditCellStatistic
    {
           [Column(Name = "INDEXSTATISTIC_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
        [Column(Name = "INDEXSTATISTIC_TASKID")]
        public string TaskId
        {
            get;
            set;
        }
        [Column(Name = "INDEXSTATISTIC_PAPERID")]
        public string PaperId
        {
            get;
            set;
        }
        [Column(Name = "INDEXSTATISTIC_REPORTID")]
        public string ReportId
        {
            get;
            set;
        }
        [Column(Name = "INDEXSTATISTIC_COMPANYID")]
        public string CompanyId
        {
            get;
            set;
        }
        [Column(Name = "INDEXSTATISTIC_YEAR")]
        public string Year
        {
            get;
            set;
        }
        [Column(Name = "INDEXSTATISTIC_CYCLE")]
        public string Cycle
        {
            get;
            set;
        }
           [Column(Name = "INDEXSTATISTIC_SUBSCRIBE")]
        public int SubscribeNumber
        {
            get;
            set;
        }
           [Column(Name = "INDEXSTATISTIC_READERS")]
        public int ReaderNumber
        {
            get;
            set;
        }
           [Column(Name = "INDEXSTATISTIC_COMMENTS")]
        public int CommentsNumber
        {
            get;
            set;
        }
           [Column(Name = "INDEXSTATISTIC_SUPPORT")]
        public int SupportNumber
        {
            get;
            set;
        }
           [Column(Name = "INDEXSTATISTIC_REJECT")]
        public int RejectNumber
        {
            get;
            set;
        }
           [Column(Name = "INDEXSTATISTIC_PRIMARY")]
           public string BdPrimary
           {
               get;
               set;
           }
    }
}
