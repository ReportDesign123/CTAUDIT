using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.ReportLink
{
      [Table(Name = "CT_REPORTLINK")]
    public  class ReportLinkEntity
    {
           [Column(Name = "REPORTLINK_ID", IsPrimaryKey = true)]
          public string Id
          {
              get;
              set;
          }
           [Column(Name = "REPORTLINK_TASKID")]
          public string TaskId
          {
              get;
              set;
          }
           [Column(Name = "REPORTLINK_PAPERID")]
          public string PaperId
          {
              get;
              set;
          }
           [Column(Name = "REPORTLINK_REPORTID")]
          public string ReportId
          {
              get;
              set;
          }
           [Column(Name = "REPORTLINK_DEFINITION")]
          public string Definition
          {
              get;
              set;
          }
           [Column(Name = "REPORTLINK_CREATER")]
          public string Creater
          {
              get;
              set;
          }
           [Column(Name = "REPORTLINK_CREATETIME")]
          public string CreateTime
          {
              get;
              set;
          }
            [Column(Name = "REPORTLINK_INDEXCODE")]
           public string IndexCode
           {
               get;
               set;
           }
           [Column(Name = "REPORTLINK_CODE")]
            public string Code
            {
                get;
                set;
            }
           [Column(Name = "REPORTLINK_NAME")]
            public string Name
            {
                get;
                set;
            }

           [Column(Name = "REPORTLINK_TYPE")]
           public string Type
           {
               get;
               set;
           }
    }
}
