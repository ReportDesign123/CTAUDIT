using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity
{
     [Table(Name = "CT_BASIC_USERROLERELATION")]
   public   class UserRoleRelation
    {
         [Column(Name = "USERROLERELATION_ID", IsPrimaryKey = true)]
       public string Id
       {
           get;
           set;
       }
           [Column(Name = "USERROLERELATION_USERID")]
       public string UserId
       {
           get;
           set;
       }
           [Column(Name = "USERROLERELATION_ROLEID")]
       public string RoleId
       {
           get;
           set;
       }
    }
}
