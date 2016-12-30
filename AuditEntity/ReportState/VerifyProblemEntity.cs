using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.ReportState
{
      [Table(Name = "CT_STATE_VERIFY")]
    public  class VerifyProblemEntity
    {
            [Column(Name = "VERIFY_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
            [Column(Name = "VERIFY_TASKID")]
        public string TaskId
        {
            get;
            set;
        }
            [Column(Name = "VERIFY_PAPERID")]
        public string PaperId
        {
            get;
            set;
        }
            [Column(Name = "VERIFY_COMPANYID")]
        public string CompanyId
        {
            get;
            set;
        }
            [Column(Name = "VERIFY_REPORTID")]
        public string ReportId
        {
            get;
            set;
        }
            [Column(Name = "VERIFY_YEAR")]
        public string Year
        {
            get;
            set;
        }
            [Column(Name = "VERIFY_CYCLE")]
        public string Cycle
        {
            get;
            set;
        }
            [Column(Name = "VERIFY_ROW")]
        public string Row
        {
            get;
            set;
        }
            [Column(Name = "VERIFY_COL")]
        public string Col
        {
            get;
            set;
        }
            [Column(Name = "VERIFY_FORMULARCONTENT")]
        public string FormularContent
        {
            get;
            set;
        }
            [Column(Name = "VERIFY_PROBLEM")]
        public string Problem
        {
            get;
            set;
        }
            [Column(Name = "VERIFY_CREATER")]
        public string Creater
        {
            get;
            set;
        }
            [Column(Name = "VERIFY_CREATETIME")]
        public string CreateTime
        {
            get;
            set;
        }

    }
}
