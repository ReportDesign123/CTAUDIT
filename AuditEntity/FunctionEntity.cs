using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity
{
    [Table(Name = "CT_BASIC_FUNCTIONS")]
   public   class FunctionEntity
    {
         [Column(Name = "FUNCTIONS_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
         [Column(Name = "FUNCTIONS_CODE")]
         public string Code
         {
             get;
             set;
         }
          [Column(Name = "FUNCTIONS_NAME")]
         public string Name
         {
             get;
             set;
         }
          [Column(Name = "FUNCTIONS_URL")]
         public string Url
         {
             get;
             set;
         }
          [Column(Name = "FUNCTIONS_SEQUENCE")]
         public decimal Sequence
         {
             get;
             set;
         }
          [Column(Name = "FUNCTIONS_PARENT")]
         public string Parent
         {
             get;
             set;
         }
          [Column(Name = "FUNCTIONS_ICON")]
         public string Icon
         {
             get;
             set;
         }
          public bool isOrNOtUsed = false;
          public string state = "";
          public bool isOrNotChecked = false;
    }
}
