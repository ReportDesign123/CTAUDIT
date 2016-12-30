using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AuditSPI.ReportAudit
{
    /// <summary>
    /// 自定义
    /// </summary>
   public   class CustomerGridDataStruct
    {
       public List<Dictionary<string, object>> Rows = new List<Dictionary<string, object>>();
       public List<string> Columns = new List<string>();
    }
}
