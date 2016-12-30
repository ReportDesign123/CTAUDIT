using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using AuditEntity;
using AuditSPI.ReportData;


namespace AuditSPI.Analysis
{
  public  interface IFormularDeserialize
    {
        DataTable DeserializeToSql(FormularEntity fe);
        void SetReportParameters(ReportDataParameterStruct rdps);
    }
}
