using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.AuditPaper
{
     [Table(Name = "CT_PAPER_AUDITPAPER")]
    public  class AuditPaperEntity
    {
          [Column(Name = "AUDITPAPER_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
         [Column(Name = "AUDITPAPER_CODE")]
        public string Code
        {
            get;
            set;
        }
         [Column(Name = "AUDITPAPER_NAME")]
        public string Name
        {
            get;
            set;
        }
         [Column(Name = "AUDITPAPER_TEMPLATEID")]
        public string TemplateId
        {
            get;
            set;
        }
         [Column(Name = "AUDITPAPER_STATE")]
        public string State
        {
            get;
            set;
        }
         [Column(Name = "AUDITPAPER_CREATETIME")]
        public string CreateTime
        {
            get;
            set;
        }

              [Column(Name = "AUDITPAPER_ZQ")]
         public string DefaultZq
         {
             get;
             set;
         }
         public string TemplateName
         {
             get;
             set;
         }
    }
}
