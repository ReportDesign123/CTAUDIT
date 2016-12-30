using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.ReportState
{
      [Table(Name = "CT_STATE_REPORTSTATE")]
    public  class ReportStateEntity
    {
          [Column(Name = "REPORTSTATE_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
           [Column(Name = "REPORTSTATE_TASKID")]
        public string TaskId
        {
            get;
            set;
        }
            [Column(Name = "REPORTSTATE_PAPERID")]
        public string PaperId
        {
            get;
            set;
        }
            [Column(Name = "REPORTSTATE_REPORTID")]
        public string ReportId
        {
            get;
            set;
        }
            [Column(Name = "REPORTSTATE_ND")]
        public string Nd
        {
            get;
            set;
        }
            [Column(Name = "REPORTSTATE_ZQ")]
        public string Zq
        {
            get;
            set;
        }
            [Column(Name = "REPORTSTATE_STATE")]
        public string State
        {
            get;
            set;
        }
            [Column(Name = "REPORTSTATE_CREATER")]
        public string Creater
        {
            get;
            set;
        }
            [Column(Name = "REPORTSTATE_CREATETIME")]
        public string CreateTime
        {
            get;
            set;
        }
           [Column(Name = "REPORTSTATE_COMPANYID")]
            public string CompanyId
            {
                get;
                set;
            }
           [Column(Name = "REPORTSTATE_STAGESTATE")]
           public string CurrentStageState
           {
               get;
               set;
           }
            [Column(Name = "REPORTSTATE_PR0STAGESTATE")]
           public string ProStageState
           {
               get;
               set;
           }
            [Column(Name = "REPORTSTATE_NEXTSTAGESTATE")]
            public string NextStageState
            {
                get;
                set;
            }
            [Column(Name = "REPORTSTATE_RESULT")]
            public string StageResult
            {
                get;
                set;
            }
           
          /// <summary>
          /// 审批方向
          /// </summary>
            public string ExamDirection
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
           public string ReportCode
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
           public string Discription
           {
               get;
               set;
           }
    }
}
