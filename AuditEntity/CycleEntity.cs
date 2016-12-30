using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity
{
      [Table(Name = "CT_BASIC_CYCLE")]
    public  class CycleEntity
    {
          [Column(Name = "CYCLE_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }

           [Column(Name = "CYCLE_CODE")]
        public string Code
        {
            get;
            set;
        }
           [Column(Name = "CYCLE_NAME")]
        public string Name
        {
            get;
            set;
        }
           [Column(Name = "CYCLE_KSRQ")]
           public string KSRQ
           {
               get;
               set;
           }
           [Column(Name = "CYCLE_JSRQ")]
           public string JSRQ
           {
               get;
               set;
           }
             [Column(Name = "CYCLE_REMARKS")]
           public string Remarks
           {
               get;
               set;
           }
             public string state = "";
    }
}
