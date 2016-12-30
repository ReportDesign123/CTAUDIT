using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity
{
     [Table(Name = "CT_BASIC_ROLE")]
    public  class RoleEntity
    {
       [Column(Name = "ROLE_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
            [Column(Name = "ROLE_CODE")]
        public string Code
        {
            get;
            set;
        }
          [Column(Name = "ROLE_NAME")]
        public string Name
        {
            get;
            set;
        }

    }
}
