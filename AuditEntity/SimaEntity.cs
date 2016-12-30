using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity
{
      [Table(Name = "RPSIMA")]
    public  class SimaEntity
    {
           [Column(Name = "SIMA_OBJID")]
        public string Obid
        {
            get;
            set;
        }
          [Column(Name = "SIMA_DISP")]
        public string Desc
        {
            get;
            set;
        }
    }
}
