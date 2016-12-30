using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.ReportAttatch
{
     [Table(Name = "CT_DATA_ATTACHMENT")]
    public  class ReportAttatchEntity
    {
 [Column(Name = "ATTACHMENT_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
         [Column(Name = "ATTACHMENT_NAME")]
        public string Name
        {
            get;
            set;
        }
         [Column(Name = "ATTACHMENT_INSTRUCTION")]
        public string INSTRUCTION
        {
            get;
            set;
        }
         [Column(Name = "ATTACHMENT_ROUTE")]
        public string Route
        {
            get;
            set;
        }
         [Column(Name = "ATTACHMENT_CREATER")]
        public string Creater
        {
            get;
            set;
        }
         [Column(Name = "ATTACHMENT_TIME")]
        public string CreateTime
        {
            get;
            set;
        }
         [Column(Name = "ATTACHMENT_TASKID")]
        public string TaskId
        {
            get;
            set;
        }
         [Column(Name = "ATTACHMENT_PAPERID")]
        public string PaperId
        {
            get;
            set;
        }
         [Column(Name = "ATTACHMENT_REPORTID")]
        public string ReportId
        {
            get;
            set;
        }
         [Column(Name = "ATTACHMENT_COMPANYID")]
        public string CompanyId
        {
            get;
            set;
        }
         [Column(Name = "ATTACHMENT_ND")]
        public string Nd
        {
            get;
            set;
        }
         [Column(Name = "ATTACHMENT_ZQ")]
        public string Zq
        {
            get;
            set;
        }
         [Column(Name = "ATTACHMENT_EXTEND")]
        public string Extend
        {
            get;
            set;
        }
          [Column(Name = "ATTACHMENT_DATAITEM")]
         public string DataItem
         {
             get;
             set;
         }
        // [Column(Name = "ATTACHMENT_Length")]
        //public float Length
        //{
        //    get;
        //    set;
        //}
         public int AttatchNum
         {
             get;
             set;
         }
    }
}
