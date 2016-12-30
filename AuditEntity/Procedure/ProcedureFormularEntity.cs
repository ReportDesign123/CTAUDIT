using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.Procedure
{
     [Table(Name = "CT_BASIC_PROCEDURE")]
   public  class ProcedureFormularEntity
    {
            [Column(Name = "PROCEDURE_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;

        }
          [Column(Name = "PROCEDURE_NAME")]
        public string Name
        {
            get;
            set;
        }
          [Column(Name = "PROCEDURE_NAMEVALUE")]
        public string NameValue
        {
            get;
            set;
        }
          [Column(Name = "PROCEDURE_PARAS")]
        public string Parameters
        {
            get;
            set;
        }
          [Column(Name = "PROCEDURE_CREATER")]
        public string Creater
        {
            get;
            set;
        }
          [Column(Name = "PROCEDURE_CREATETIME")]
        public string CreateTime
        {
            get;
            set;
        }
            [Column(Name = "PROCEDURE_DATASOURCE")]
          public string DataSource
          {
              get;
              set;
          }


    }
}
