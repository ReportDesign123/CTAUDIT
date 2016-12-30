using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.AuditPaper
{
        [Table(Name = "CT_PAPER_AUDITPAPERANDREPORT")]
    public  class AuditPaperAndReportEntity
    {
             [Column(Name = "AUDITPAPERANDREPORT_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
             [Column(Name = "AUDITPAPERANDREPORT_AUDITPAPERID")]
        public string AuditPaperId
        {
            get;
            set;
        }
              [Column(Name = "AUDITPAPERANDREPORT_REPORTID")]
        public string ReportId
        {
            get;
            set;
        }
    }
}
