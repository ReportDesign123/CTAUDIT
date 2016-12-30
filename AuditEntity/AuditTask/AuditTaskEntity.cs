using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.AuditTask
{
     [Table(Name = "CT_TASK_AUDITTASK")]
    public  class AuditTaskEntity
    {
           [Column(Name = "AUDITTASK_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
           [Column(Name = "AUDITTASK_TYPE")]
        public string TaskType
        {
            get;
            set;
        }
           [Column(Name = "AUDITTASK_BEGIONDATE")]
        public string BeginDate
        {
            get;
            set;
        }
           [Column(Name = "AUDITTASK_ENDDATE")]
        public string EndDate
        {
            get;
            set;
        }
           [Column(Name = "AUDITTASK_CREATETIME")]
        public string CreateTime
        {
            get;
            set;
        }
           [Column(Name = "AUDITTASK_CREATER")]
        public string Creater
        {
            get;
            set;
        }
           [Column(Name = "AUDITTASK_STATE")]
        public string State
        {
            get;
            set;
        }
          [Column(Name = "AUDITTASK_CODE")]
           public string Code
           {
               get;
               set;
           }
          [Column(Name = "AUDITTASK_NAME")]
           public string Name
           {
               get;
               set;
           }
    }
}
