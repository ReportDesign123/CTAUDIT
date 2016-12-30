using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.AuditPaper
{
    [Table(Name = "CT_PAPER_AUDITPAPERATTATCH")]
    public  class PaperAttatchEntity
    {
          [Column(Name = "PAPERATTATCH_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
           [Column(Name = "PAPERATTATCH_DESCRIPTION")]
        public string Description
        {
            get;
            set;
        }
           [Column(Name = "PAPERATTATCH_ROUTE")]
        public string Route
        {
            get;
            set;
        }
    }
}
