using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.ReportProblem
{
     [Table(Name = "CT_PROBLEM_REPORTPROBLEM")]
    public class ReportProblemEntity
    {
        [Column(Name = "REPORTPROBLEM_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
        [Column(Name = "REPORTPROBLEM_TASKID")]
        public string TaskId
        {
            get;
            set;
        }
        [Column(Name = "REPORTPROBLEM_PAPERID")]
        public string PaperId
        {
            get;
            set;
        }
        [Column(Name = "REPORTPROBLEM_REPORTID")]
        public string ReportId
        {
            get;
            set;
        }
        [Column(Name = "REPORTPROBLEM_COMPANYID")]
        public string CompanyId
        {
            get;
            set;
        }
        [Column(Name = "REPORTPROBLEM_ND")]
        public string Year
        {
            get;
            set;
        }
        [Column(Name = "REPORTPROBLEM_ZQ")]
        public string Zq
        {
            get;
            set;
        }
          [Column(Name = "REPORTPROBLEM_CREATER")]
        public string Creater
        {
            get;
            set;
        }
          [Column(Name = "REPORTPROBLEM_CREATETIME")]
        public string CreateTime
        {
            get;
            set;
        }
          [Column(Name = "REPORTPROBLEM_TYPE")]
        public string Type
        {
            get;
            set;
        }
          [Column(Name = "REPORTPROBLEM_STATE")]
        public string State
        {
            get;
            set;
        }
          [Column(Name = "REPORTPROBLEM_RANK")]
        public int Rank
        {
            get;
            set;
        }
          [Column(Name = "REPORTPROBLEM_TITLE")]
        public string Title
        {
            get;
            set;
        }
          [Column(Name = "REPORTPROBLEM_CONTENT")]
        public string Content
        {
            get;
            set;
        }
          [Column(Name = "REPORTPROBLEM_DEPEND")]
        public string DependOn
        {
            get;
            set;
        }
          [Column(Name = "REPORTPROBLEM_REPLAY")]
        public string Replay
        {
            get;
            set;
        }
          [Column(Name = "REPORTPROBLEM_REPORTAUDITID")]
          public string ReportAuditId
          {
              get;
              set;
          }
          [Column(Name = "REPORTPROBLEM_ISORNOTCELL")]
          public string IsOrNotCell
          {
              get;
              set;
          }
          [Column(Name = "REPORTPROBLEM_CELLINFO")]
          public string CellInfo
          {
              get;
              set;
          }

          public string CreaterName
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
