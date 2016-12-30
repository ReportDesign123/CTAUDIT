using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditSPI;
using AuditEntity.AuditPaper;

namespace AuditSPI.AuditPaper
{
    public  interface IAuditPaperAndCompanys
    {
         List<TreeNode> TreeNodesAuditPaperAuthorities(AuditPaperEntity ape);
         void BatchUpdate(List<AuditPaperAndCompanyEntity> apace, string AuditPaperId);
    }
}
