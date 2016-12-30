using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditSPI;
using AuditSPI.ReportData;
using AuditEntity;


namespace AuditSPI.ReportData
{

    /// <summary>
    /// 报表格式数据结构
    /// 报表格式基本信息、报表周期基本信息；
    /// </summary>
     public   class ReportFormatStruct
    {
         public ReportFormatDicEntity ReportFormat = new ReportFormatDicEntity();
         public ReportCycleStruct ReportCycle = new ReportCycleStruct();
    }
}
