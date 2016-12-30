using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.ReportState
{
     [Table(Name = "CT_STATE_REPORTSTATEDETAIL")]
    public  class ReportStateDetailEntity
    {
        [Column(Name = "REPORTSTATEDETAIL_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
        [Column(Name = "REPORTSTATEDETAIL_TASKID")]
        public string TaskId
        {
            get;
            set;
        }
        [Column(Name = "REPORTSTATEDETAIL_PAPERID")]
        public string PaperId
        {
            get;
            set;
        }
        [Column(Name = "REPORTSTATEDETAIL_REPORTID")]
        public string ReportId
        {
            get;
            set;
        }
        [Column(Name = "REPORTSTATEDETAIL_ND")]
        public string Nd
        {
            get;
            set;
        }
        [Column(Name = "REPORTSTATEDETAIL_ZQ")]
        public string Zq
        {
            get;
            set;
        }
        [Column(Name = "REPORTSTATEDETAIL_STATE")]
        public string State
        {
            get;
            set;
        }
        [Column(Name = "REPORTSTATEDETAIL_CREATER")]
        public string Creater
        {
            get;
            set;
        }
        [Column(Name = "REPORTSTATEDETAIL_CREATETIME")]
        public string CreateTime
        {
            get;
            set;
        }
         [Column(Name = "REPORTSTATEDETAIL_VERIFYDES")]
        public string Discription
        {
            get;
            set;
        }
         [Column(Name = "REPORTSTATEDETAIL_COMPANYID")]
         public string CompanyId
         {
             get;
             set;
         }
          [Column(Name = "REPORTSTATEDETAIL_STAGESTATE")]
         public string CurrentStageState
         {
             get;
             set;
         }
          [Column(Name = "REPORTSTATEDETAIL_PROSTAGESTATE")]
         public string ProStageState
         {
             get;
             set;
         }
          [Column(Name = "REPORTSTATEDETAIL_NEXTSTAGESTATE")]
         public string NextStageState
         {
             get;
             set;
         }
           [Column(Name = "REPORTSTATEDETAIL_RESULT")]
          public string StageResult
          {
              get;
              set;
          }
          [Column(Name = "REPORTSTATEDETAIL_STATEID")]
           public string StateId
           {
               get;
               set;
           }
         [Column(Name="REPORTSTATEDETAIL_OPERATION")]
          public string OperationType
          {
              get;
              set;
          }
           public string CompanyName
           {
               get;
               set;
           }
           public string ReportName
           {
               get;
               set;
           }
           public string ReportType
           {
               get;
               set;
           }
           public string Ids
           {
               get;
               set;
           }
           public string CreaterName
           {
               get;
               set;
           }
           public string ReportCode
           {
               get;
               set;
           }
    }
}
