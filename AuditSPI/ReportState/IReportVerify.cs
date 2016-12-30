using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.ReportState;
using AuditSPI.ReportData;

namespace AuditSPI.ReportState
{
   public  interface IReportVerify
    {
        void SaveReportVerifies(List<VerifyProblemEntity> vpes);
        void DeleteReportVerifies(ReportDataParameterStruct rdps);
        List<VerifyProblemEntity> GetListVerifyProblemEntities(ReportDataParameterStruct rdps);
    }
}
