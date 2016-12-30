using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.AuditTask
{
      [Table(Name = "CT_TASK_AUDITTASKANDAUDITPAPER")]
    public  class AuditTaskAndAuditPaperEntity
    {
             [Column(Name = "AUDITTASKANDAUDITPAPER_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
            [Column(Name = "AUDITTASKANDAUDITPAPER_TASKID")]
        public string TaskId
        {
            get;
            set;
        }
            [Column(Name = "AUDITTASKANDAUDITPAPER_PAPERID")]
        public string PaperId
        {
            get;
            set;
        }
          
    }
}
