using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity
{
      [Table(Name = "CT_BASIC_DICTIONARY")]
    public  class DictionaryEntity
    {
          [Column(Name = "DICTIONARY_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
           [Column(Name = "DICTIONARY_CLASSID")]
        public string ClassifyId
        {
            get;
            set;
        }
           [Column(Name = "DICTIONARY_CODE")]
        public string Code
        {
            get;
            set;
        }
           [Column(Name = "DICTIONARY_NAME")]
        public string Name
        {
            get;
            set;
        }
             [Column(Name = "DICTIONARY_REMARKS")]
           public string Remarks
           {
               get;
               set;
           }

             public string CName
             {
                 get;
                 set;
             }
             public string state = "";
    }
}
