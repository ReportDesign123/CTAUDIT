using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity
{
     [Table(Name = "CT_FORMAT_CLASSIFY")]
   public  class ReportClassifyEntity
    {
       [Column(Name = "CLASSIFY_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
       [Column(Name = "CLASSIFY_CODE")]
        public string Code
        {
            get;
            set;
        }
       [Column(Name = "CLASSIFY_NAME")]
        public string Name
        {
            get;
            set;
        }
      [Column(Name = "CLASSIFY_CREATETIME")]
        public string CreateTime
        {
            get;
            set;
        }
       [Column(Name = "CLASSIFY_CREATER")]
        public string Creater
        {
            get;
            set;
        }
       public string bbCode
       {
           get;
           set;
       }
       public string bbName
       {
           get;
           set;
       }
    }


}
