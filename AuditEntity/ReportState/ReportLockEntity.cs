using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.ReportState
{
     [Table(Name = "CT_STATE_LOCK")]
    public class ReportLockEntity
    {
          [Column(Name = "LOCK_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
          [Column(Name = "LOCK_TASKID")]
        public string TaskId
        {
            get;
            set;
        }
          [Column(Name = "LOCK_PAPERID")]
          public string PaperId
        {
            get;
            set;
        }
          [Column(Name = "LOCK_REPORTID")]
        public string ReportId
        {
            get;
            set;
        }
          [Column(Name = "LOCK_COMPANYID")]
        public string CompanyId
        {
            get;
            set;
        }
          [Column(Name = "LOCK_YEAR")]
        public string Year
        {
            get;
            set;
        }
          [Column(Name = "LOCK_CYCLE")]
        public string Cycle
        {
            get;
            set;
        }
          [Column(Name = "LOCK_ISORNOTLOCK")]
        public bool IsOrNotLock
        {
            get;
            set;
        }
          [Column(Name = "LOCK_CREATER")]
        public string Creater
        {
            get;
            set;
        }
          [Column(Name = "LOCK_CREATETIME")]
        public string CreateTime
        {
            get;
            set;
        }
          [Column(Name = "LOCK_NOTE")]
        public string Note
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
          public string CompanyName
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
