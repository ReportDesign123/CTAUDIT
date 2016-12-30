using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.WorkFlow
{
      [Table(Name = "CT_WORKFLOW_DEFINITION")]
    public  class WorkFlowDefinition
    {
            [Column(Name = "DEFINITION_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
           [Column(Name = "DEFINITION_CODE")]
        public string Code
        {
            get;
            set;
        }
           [Column(Name = "DEFINITION_NAME")]
        public string Name
        {
            get;
            set;
        }
           [Column(Name = "DEFINITION_DATA")]
        public string Data
        {
            get;
            set;
        }
           [Column(Name = "DEFINITION_ORDER")]
        public string WorkFlowOrder
        {
            get;
            set;
        }
           [Column(Name = "DEFINITION_CREATER")]
           public string Creater
           {
               get;
               set;
           }
           [Column(Name = "DEFINITION_CREATETIME")]
        public string CreateTime
        {
            get;
            set;
        }
    }
}
