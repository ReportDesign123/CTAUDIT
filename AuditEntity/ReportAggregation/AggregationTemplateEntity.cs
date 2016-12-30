using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.ReportAggregation
{
     [Table(Name = "CT_AGGREGATE_TEMPLATE")]
   public   class AggregationTemplateEntity
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
          [Column(Name = "TEMPLATE_CLASSIFYID")]
       public string ClassifyId
       {
           get;
           set;
       }
          [Column(Name = "TEMPLATE_CONTENT")]
       public string Content
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
          public string TemplateName
          {
              get;
              set;
          }
    }
}
