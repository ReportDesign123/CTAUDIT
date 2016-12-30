using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.Procedure
{
      [Table(Name = "OBJECTS")]
    public  class ProcedureEntity
    {
            [Column(Name = "object_id", IsPrimaryKey = true)]
        public int Id
        {
            get;
            set;
        }
            [Column(Name = "name")]
        public string Name
        {
            get;
            set;
        }
            public string DataSourceId
            {
                get;
                set;
            }
    }
}
