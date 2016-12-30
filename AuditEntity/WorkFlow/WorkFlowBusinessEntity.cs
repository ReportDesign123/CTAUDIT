using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.WorkFlow
{
    [Table(Name = "CT_WORKFLOW_BUSINESS")]
    public class WorkFlowBusinessEntity
    {
          [Column(Name = "BUSINESS_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
          [Column(Name = "BUSINESS_CODE")]
        public string BusinessCode
        {
            get;
            set;
        }
          [Column(Name = "BUSINESS_NAME")]
        public string Name
        {
            get;
            set;
        }
          [Column(Name = "BUSINESS_WORKFLOWID")]
        public string WorkFlowId
        {
            get;
            set;
        }
          [Column(Name = "BUSINESS_NEXT")]
        public string NextStage
        {
            get;
            set;
        }
          [Column(Name = "BUSINESS_CURRENT")]
        public string CurrentStage
        {
            get;
            set;
        }
          [Column(Name = "BUSINESS_STATE")]
        public string State
        {
            get;
            set;
        }
          [Column(Name = "BUSINESS_BEGINTIME")]
        public string BeginTime
        {
            get;
            set;
        }
          [Column(Name = "BUSINESS_ENDTIME")]
        public string EndTime
        {
            get;
            set;
        }
          [Column(Name = "BUSINESS_DETAILID")]
        public string DetailId
        {
            get;
            set;
        }
    }
}
