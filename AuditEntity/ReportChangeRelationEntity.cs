using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity
{
      [Table(Name = "CT_FORMAT_REPORTANDCHANGEREGIONAL")]
   public   class ReportChangeRelationEntity
    {
           [Column(Name = "REPORTANDCHANGEREGIONAL_ID", IsPrimaryKey = true)]
          public string Id
          {
              get;
              set;
          }
            [Column(Name = "REPORTANDCHANGEREGIONAL_REPORTID")]
          public string ReportId
          {
              get;
              set;
          }
            [Column(Name = "REPORTANDCHANGEREGIONAL_CHANGEREGIONID")]
          public string ChangeId
          {
              get;
              set;
          }
            [Column(Name = "REPORTANDCHANGEREGIONAL_CHANGETYPE")]
          public string ChangeType
          {
              get;
              set;
          }
    }
}
