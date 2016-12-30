using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.ReportAudit
{
    [Table(Name = "CT_AUDIT_REPORTAUDIT")]
   public  class ReportAuditEntity
    {
        [Column(Name = "REPORTAUDIT_ID", IsPrimaryKey = true)]
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
         [Column(Name = "REPORTAUDIT_PAPERID")]
       public string PaperId
       {
           get;
           set;
       }
         [Column(Name = "REPORTAUDIT_REPORTID")]
       public string ReportId
       {
           get;
           set;
       }
         [Column(Name = "REPORTAUDIT_COMPANYID")]
       public string CompanyId
       {
           get;
           set;
       }
         [Column(Name = "REPORTAUDIT_YEAR")]
       public string Year
       {
           get;
           set;
       }
         [Column(Name = "REPORTAUDIT_ZQ")]
       public string Zq
       {
           get;
           set;
       }
         [Column(Name = "REPORTAUDIT_STATE")]
       public string State
       {
           get;
           set;
       }
         [Column(Name = "REPORTAUDIT_CREATER")]
       public string Creater
       {
           get;
           set;
       }
         [Column(Name = "REPORTAUDIT_CREATETIME")]
       public string CreateTime
       {
           get;
           set;
       }
         [Column(Name = "REPORTAUDIT_CELLAUDIT")]
       public string CellAudit
       {
           get;
           set;
       }
         [Column(Name = "REPORTAUDIT_ISORNOTREAD")]
       public string IsOrNotRead
       {
           get;
           set;
       }
         [Column(Name = "REPORTAUDIT_READTIME")]
       public string ReadTime
       {
           get;
           set;
       }
         public string ReportCode
         {
             get;
             set;
         }
         public string ReportName
         {
             get;
             set;
         }
         public string CompanyCode
         {
             get;
             set;
         }
         public string CompanyName
         {
             get;
             set;
         }

         public string ReportType
         {
             get;
             set;
         }

         public int ProcessNumber
         {
             get;
             set;
         }
         public int NotProcessNumber
         {
             get;
             set;
         }

    }
}
