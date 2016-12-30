using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.ReportAudit;

namespace AuditSPI.ReportAudit
{
   public   interface IReportAuditDefinition
    {
       /// <summary>
       /// 保存审计联查定义
       /// </summary>
       /// <param name="auditDefinitionMaps"></param>
       void SaveAuditDefinition(Dictionary<string, ReportAuditDefinitionEntity> auditDefinitionMaps);
       Dictionary<string,ReportAuditDefinitionEntity> GetAuditDefinition(ReportAuditDefinitionEntity rade);
       ReportAuditDefinitionEntity GetReportAuditCellIndexData(ReportAuditDefinitionEntity rade);
    }
}
