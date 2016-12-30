using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity
{
      [Table(Name = "CT_BASIC_LOG")]
    public  class LogEntity
    {
            [Column(Name = "LOG_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
           [Column(Name = "LOG_USERID")]
        public string UserId
        {
            get;
            set;
        }
           [Column(Name = "LOG_USERCODE")]
        public string UserCode
        {
            get;
            set;
        }
           [Column(Name = "LOG_USERNAME")]
        public string UserName
        {
            get;
            set;
        }
           [Column(Name = "LOG_CREATETIME")]
        public string CreateTime
        {
            get;
            set;
        }
           [Column(Name = "LOG_FUNCTIONNNAME")]
        public string Function
        {
            get;
            set;
        }
           [Column(Name = "LOG_OPTION")]
        public string Option
        {
            get;
            set;
        }

    }
}
