using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.AuditTask
{
         [Table(Name = "CT_TASK_AUDITTASKCOMPANYS")]
   public   class AuditTaskAndCompanyEntity
    {
               [Column(Name = "AUDITTASKCOMPANYS_ID", IsPrimaryKey = true)]
       public string Id
       {
           get;
           set;
       }
             [Column(Name = "AUDITTASKCOMPANYS_TASKID")]
       public string TaskId
       {
           get;
           set;
       }
             [Column(Name = "AUDITTASKCOMPANYS_COMPANYID")]
       public string CompanyId
       {
           get;
           set;
       }
             [Column(Name = "AUDITTASKCOMPANYS_STATE")]
             public string State
             {
                 get;
                 set;
             }
    }
}
