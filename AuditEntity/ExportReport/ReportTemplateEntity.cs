using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.ExportReport
{
      [Table(Name = "CT_REPORT_TEMPLATE")]
    public  class ReportTemplateEntity
    {
           [Column(Name = "TEMPLATE_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
           [Column(Name = "TEMPLATE_CODE")]
        public string Code
        {
            get;
            set;
        }
           [Column(Name = "TEMPLATE_NAME")]
        public string Name
        {
            get;
            set;
        }
           [Column(Name = "TEMPLATE_CYCLE")]
        public string Cycle
        {
            get;
            set;
        }
           [Column(Name = "TEMPLATE_EXPORTTYPE")]
        public string ExportType
        {
            get;
            set;
        }
           [Column(Name = "TEMPLATE_CREATER")]
        public string Creater
        {
            get;
            set;
        }
           [Column(Name = "TEMPLATE_CREATETIME")]
        public string CreateTime
        {
            get;
            set;
        }
           [Column(Name = "TEMPLATE_ATTATCHADDRESS")]
        public string AttatchAddress
        {
            get;
            set;
        }
           [Column(Name = "TEMPLATE_ATTATCHNAME")]
        public string AttatchName
        {
            get;
            set;
        }
           [Column(Name = "TEMPLATE_ISORNOTLOADREPORTS")]
        public string IsOrNotLoadReports
        {
            get;
            set;
        }
            [Column(Name = "TEMPLATE_ATTATCHHTMLADDRESS")]
           public string HtmlAddress
           {
               get;
               set;
           }
            public string IsOrNotOverwrite
            {
                get;
                set;
            }
    }
}
