using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.ReportAudit
{
    /// <summary>
    /// 单元格评论明细:
    /// 包括：转发、评论 需要内码支持
    /// 支持对于转发和评论进行的赞成
    /// 阅读、支持、反对  不用增加内码支持
    /// </summary>
         [Table(Name = "CT_AUDIT_DETAIL")]
    public class ReportAuditCellCommentDetail
    {
             [Column(Name = "COMMENT_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
             [Column(Name = "COMMENT_TASKID")]
        public string TaskId
        {
            get;
            set;
        }
             [Column(Name = "COMMENT_PAPERID")]
        public string PaperId
        {
            get;
            set;
        }
             [Column(Name = "COMMENT_COMPANYID")]
        public string CompanyId
        {
            get;
            set;
        }
             [Column(Name = "COMMENT_REPORTID")]
        public string ReportId
        {
            get;
            set;
        }
             [Column(Name = "COMMENT_YEAR")]
        public string Year
        {
            get;
            set;
        }
             [Column(Name = "COMMENT_CYCLE")]
        public string Cycle
        {
            get;
            set;
        }
             [Column(Name = "COMMENT_INDEXCODE")]
        public string CellCode
        {
            get;
            set;
        }
             [Column(Name = "COMMENT_CONTENT")]
        public string Content
        {
            get;
            set;
        }
             [Column(Name = "COMMENT_TYPE")]
        public string Type
        {
            get;
            set;
        }
             [Column(Name = "COMMENT_NM")]
        public string Nm
        {
            get;
            set;
        }
             [Column(Name = "COMMENT_CREATER")]
        public string Creater
        {
            get;
            set;
        }
             [Column(Name = "COMMENT_CREATETIME")]
        public string CreateTime
        {
            get;
            set;
        }
             [Column(Name = "COMMENT_SUPPORTER")]
             public int SupportersNumber
             {
                 get;
                 set;
             }
             [Column(Name = "COMMENT_PRIMARY")]
             public string BdPrimary
             {
                 get;
                 set;
             }

    }
}
