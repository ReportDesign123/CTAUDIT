using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;


namespace AuditEntity
{

     [Table(Name = "CT_BASIC_POSITION")]
    public  class PositionEntity
    {
        [Column(Name = "POSITION_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
          [Column(Name = "POSITION_CODE")]
        public string Code
        {
            get;
            set;
        }
           [Column(Name = "POSITION_NAME")]
        public string Name
        {
            get;
            set;
        }
           [Column(Name = "POSITION_NM")]
        public string Nm
        {
            get;
            set;
        }
           [Column(Name = "POSITION_REMARKS")]
        public string Remarks
        {
            get;
            set;
        }
            [Column(Name = "POSITION_JS")]
        public int Js
        {
            get;
            set;
        }
            [Column(Name = "POSITION_PARENTID")]
        public string ParentId
        {
            get;
            set;
        }
            [Column(Name = "POSITION_SEQUENCE")]
        public int Sequence
        {
            get;
            set;
        }
            public string state = "";
    }
}
