using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.AuditTask;

namespace AuditSPI.AuditTask
{
    public  interface IAuditTaskCompany
    {
        List<TreeNode> TreeNodesAuditTaskAuthorities(AuditTaskEntity ate);
        void BatchUpdate(List<AuditTaskAndCompanyEntity> apace, string AuditTaskId);
    }
}
