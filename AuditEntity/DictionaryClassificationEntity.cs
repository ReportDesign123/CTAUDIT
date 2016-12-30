using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity
{
    [Table(Name = "CT_BASIC_DICTIONARYCLASSIFICATION")]
    public   class DictionaryClassificationEntity
    {
          [Column(Name = "DICTIONARYCLASSIFICATION_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
         [Column(Name = "DICTIONARYCLASSIFICATION_CODE")]
        public string Code
        {
            get;
            set;
        }
         [Column(Name = "DICTIONARYCLASSIFICATION_NAME")]
        public string Name
        {
            get;
            set;

        }
         [Column(Name = "DICTIONARYCLASSIFICATION_REMARKS")]
         public string Remarks
         {
             get;
             set;
         }
         public string state = "closed";
    }
}
