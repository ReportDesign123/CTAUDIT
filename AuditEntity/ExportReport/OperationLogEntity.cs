using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.ExportReport
{
    [Table(Name = "CT_REPORT_OPERATIONLOG")]
   public   class OperationLogEntity
    {
         [Column(Name = "OPERATIONLOG_ID", IsPrimaryKey = true)]
       public string Id
       {
           get;
           set;
       }
         [Column(Name = "OPERATIONLOG_TEMPLATEINSTANCEID")]
       public string TemplateInstanceId
       {
           get;
           set;
       }
         [Column(Name = "OPERATIONLOG_CREATER")]
       public string Creater
       {
           get;
           set;
       }
         [Column(Name = "OPERATIONLOG_CREATERTIME")]
       public string CreateTime
       {
           get;
           set;
       }
         [Column(Name = "OPERATIONLOG_CONTENT")]
       public string Content
       {
           get;
           set;
       }
         [Column(Name = "OPERATIONLOG_TYPE")]
       public string Type
       {
           get;
           set;
       }
         [Column(Name = "OPERATIONLOG_STATE")]
         public string State
         {
             get;
             set;
         }
         public string UserName
         {
             get;
             set;
         }
    }
}
