using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity
{
     [Table(Name = "CT_BASIC_CPARA")]
    public class CparaEntity
    {
       [Column(Name = "CPARA_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
            [Column(Name = "CPARA_CODE")]
        public string Code
        {
            get;
            set;
        }
          [Column(Name = "CPARA_NAME")]
        public string Name
        {
            get;
            set;
        }
          [Column(Name = "CPARA_CONTENT")]
          public string CONTENT
          {
              get;
              set;
          }
          [Column(Name = "CPARA_SPARA")]
          public string SPARA
          {
              get;
              set;
          }
          public List<DictionaryEntity> Sparas
          {
              get;
              set;
          }
          public string SparaName
          {
              get;
              set;
          }

    }
}
