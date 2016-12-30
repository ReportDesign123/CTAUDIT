using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity
{
     [Table(Name = "CT_BASIC_USERPOSITIONRELATION")]
   public  class UserPositionRelation
    {
         [Column(Name = "USERPOSITIONRELATION_ID", IsPrimaryKey = true)]
       public string Id
       {
           get;
           set;
       }
          [Column(Name = "USERPOSITIONRELATION_USERID")]
       public string UserId
       {
           get;
           set;
       }
          [Column(Name = "USERPOSITIONRELATION_POSITIONID")]
       public string Position
       {
           get;
           set;
       }
    }
}
