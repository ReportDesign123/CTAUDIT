using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.AuditPaper
{
      [Table(Name = "CT_PAPER_REPORTTEMPLATE")]
    public  class ReportTemplateEntity
    {
           [Column(Name = "REPORTTEMPLATE_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
           [Column(Name = "REPORTTEMPLATE_CODE")]
        public string Code
        {
            get;
            set;
        }
           [Column(Name = "REPORTTEMPLATE_NAME")]
        public string Name
        {
            get;
            set;
        }
            [Column(Name = "REPORTTEMPLATE_DISCRIPTION")]
        public string Description
        {
            get;
            set;
        }
           [Column(Name = "REPORTTEMPLATE_ROUTE")]
        public string Route
        {
            get;
            set;
        }
           [Column(Name = "REPORTTEMPLATE_CREATETIME")]
           public string CreateTime
           {
               get;
               set;
           }
          [Column(Name = "REPORTTEMPLATE_ATTATCHNAME")]
           public string AttatchName
           {
               get;
               set;
           }
    }
}
