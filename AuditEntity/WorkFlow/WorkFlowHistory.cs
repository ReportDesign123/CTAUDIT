using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.WorkFlow
{
     [Table(Name = "CT_WORKFLOW_HISTORY")]
   public   class WorkFlowHistory
    {
           [Column(Name = "HISTORY_ID", IsPrimaryKey = true)]
       public string Id
       {
           get;
           set;
       }
          [Column(Name = "HISTORY_BUSINESSID")]
       public string BusinessId
       {
           get;
           set;
       }
          [Column(Name = "HISTORY_EXAMINESTAGE")]
       public string ExaminStage
       {
           get;
           set;
       }
          [Column(Name = "HISTORY_USER")]
       public string User
       {
           get;
           set;
       }
          [Column(Name = "HISTORY_SUGGESTION")]
       public string Suggestion
       {
           get;
           set;
       }
          [Column(Name = "HISTORY_STATE")]
       public string State
       {
           get;
           set;
       }
          [Column(Name = "HISTORY_CREATETIME")]
       public string CreateTime
       {
           get;
           set;
       }
           [Column(Name = "HISTORY_ROLE")]
          public string Role
          {
              get;
              set;
          }
    }
}
