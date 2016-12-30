using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.ExportReport
{
      [Table(Name = "CT_REPORT_TEMPLATELOG")]
   public   class TemplateLogEntity
    {
           [Column(Name = "TEMPLATELOG_ID", IsPrimaryKey = true)]
       public string Id
       {
           get;
           set;
       }
            [Column(Name = "TEMPLATELOG_COMPANYID")]
       public string CompanyId
       {
           get;
           set;
       }
            [Column(Name = "TEMPLATELOG_TEMPLATEID")]
       public string TemplateId
       {
           get;
           set;
       }
            [Column(Name = "TEMPLATELOG_YEAR")]
       public string Year
       {
           get;
           set;
       }
            [Column(Name = "TEMPLATELOG_CYCLE")]
       public string Cycle
       {
           get;
           set;
       }
            [Column(Name = "TEMPLATELOG_ADDRESS")]
       public string InstanceAddress
       {
           get;
           set;
       }
            [Column(Name = "TEMPLATELOG_STATE")]
       public string State
       {
           get;
           set;
       }
            [Column(Name = "TEMPLATELOG_DOWNLOADNUM")]
       public int DownloadNum
       {
           get;
           set;
       }
            [Column(Name = "TEMPLATELOG_CREATER")]
       public string Creater
       {
           get;
           set;
       }
            [Column(Name = "TEMPLATELOG_CREATETIME")]
       public string CreateTime
       {
           get;
           set;
       }
           [Column(Name = "TEMPLATELOG_ATTATCHNAME")]
            public string AttatchName
            {
                get;
                set;
            }
           [Column(Name = "TEMPLATELOG_TYPE")]
           public string CycleType
           {
               get;
               set;
           }

           public string CompanyCode
           {
               get;
               set;
           }
           public string CompanyName
           {
               get;
               set;
           }
           public string TemplateCode
           {
               get;
               set;
           }
           public string TemplateName
           {
               get;
               set;
           }
    }
}
