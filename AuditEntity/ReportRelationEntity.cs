using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity
{
    [Table(Name = "CT_FORMAT_RELATION")]
   public  class ReportRelationEntity
    {
          [Column(Name = "RELATION_ID", IsPrimaryKey = true)]
       public string Id
       {
           get;
           set;
       }
          [Column(Name = "RELATION_REPORTID")]
       public string ReportId
       {
           get;
           set;
       }
          [Column(Name = "RELATION_CLASSIFYID")]
       public string ClassifyId
       {
           get;
           set;
       }
    }
}
