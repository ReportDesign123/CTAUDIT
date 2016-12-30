using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity
{
      [Table(Name = "CT_BASIC_CONFIG")]
    public  class ConfigEntity
    {
              [Column(Name = "CONFIG_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
              [Column(Name = "CONFIG_NAME")]
        public string Name
        {
            get;
            set;
        }
              [Column(Name = "CONFIG_VALUE")]
        public string Value
        {
            get;
            set;
        }
              [Column(Name = "CONFIG_REMARK")]
        public string Remark
        {
            get;
            set;
        }
           [Column(Name = "CONFIG_VALUEDIS")]
              public string ValueDis
              {
                  get;
                  set;
              }
    }
}
