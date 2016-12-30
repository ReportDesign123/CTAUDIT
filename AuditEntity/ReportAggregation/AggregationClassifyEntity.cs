using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.ReportAggregation
{
    [Table(Name = "CT_AGGREGATE_TEMPLATECLASSIFY")]
    public  class AggregationClassifyEntity
    {
         [Column(Name = "TEMPLATECLASSIFY_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
            [Column(Name = "TEMPLATECLASSIFY_CODE")]
        public string Code
        {
            get;
            set;
        }
            [Column(Name = "TEMPLATECLASSIFY_NAME")]
        public string Name
        {
            get;
            set;
        }
            [Column(Name = "TEMPLATECLASSIFY_CREATER")]
        public string Creater
        {
            get;
            set;
        }
            [Column(Name = "TEMPLATECLASSIFY_CREATETIME")]
        public string CreateTime
        {
            get;
            set;
        }
    }
}
