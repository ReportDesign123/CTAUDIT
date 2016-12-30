using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.ExportReport
{
        [Table(Name = "CT_REPORT_TEMPLATEANDCOMPANY")]
    public  class TemplateAndCompanyRelationEntity
    {
            [Column(Name = "TEMPLATEANDCOMPANY_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
             [Column(Name = "TEMPLATEANDCOMPANY_TEMPLATEID")]
        public string TemplateId
        {
            get;
            set;
        }
             [Column(Name = "TEMPLATEANDCOMPANY_COMPANYID")]
        public string CompanyId
        {
            get;
            set;
        }
             [Column(Name = "TEMPLATEANDCOMPANY_STATE")]
             public string State
             {
                 get;
                 set;
             }
    }
}
