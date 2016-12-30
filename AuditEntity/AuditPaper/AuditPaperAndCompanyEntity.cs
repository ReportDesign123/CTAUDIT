using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.AuditPaper
{
      [Table(Name = "CT_PAPER_AUDITPAPERANDCOMPANY")]
   public   class AuditPaperAndCompanyEntity
    {
             [Column(Name = "AUDITPAPERANDCOMPANY_ID", IsPrimaryKey = true)]
       public string Id
       {
           get;
           set;
       }
           [Column(Name = "AUDITPAPERANDCOMPANY_PAPERID")]
       public string AuditPaperId
       {
           get;
           set;
       }
           [Column(Name = "AUDITPAPERANDCOMPANY_COMPANYID")]
       public string CompanyId
       {
           get;
           set;
       }
            [Column(Name = "AUDITPAPERANDCOMPANY_STATE")]
           public string State
           {
               get;
               set;
           }
    }
}
