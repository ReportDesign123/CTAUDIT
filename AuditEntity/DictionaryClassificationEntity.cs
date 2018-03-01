using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity
{
    [Table(Name = "LSHELP")]
    public class LSHELPDIC
    {
        [Column(Name = "LSHELP_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
        [Column(Name = "LSHELP_CODE")]
        public string Code
        {
            get;
            set;
        }
        [Column(Name = "LSHELP_NAME")]
        public string Name
        {
            get;
            set;
        }
        [Column(Name = "LSHELP_TABLE")]
        public string TableName
        {
            get;
            set;
        }
        [Column(Name = "LSHELP_TABLECODE")]
        public string TableFCode
        {
            get;
            set;
        }
        [Column(Name = "LSHELP_TABLENAME")]
        public string TableFName
        {
            get;
            set;
        }
        [Column(Name = "LSHELP_TABLEWHERE")]
        public string TableWhere
        {
            get;
            set;
        }
    }

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
