using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.ExportReport;
using AuditSPI;

namespace AuditSPI.ExportReport
{
   public   interface ITemplateAndCompany
    {
        List<TreeNode> TemplateAndCompanies(ReportTemplateEntity reportTemplate);
        void BatchUpdate(List<TemplateAndCompanyRelationEntity> lists, string templateId);
    }
}
