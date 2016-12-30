using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity;
using AuditSPI.ReportData;
using AuditEntity.ReportAudit;
using AuditEntity.ReportProblem;


namespace AuditSPI.ReportAudit
{
    /// <summary>
    /// 报表审计相关的报表数据
    /// </summary>
    public  class ReportAuditStruct
    {
        /// <summary>
        /// 报表格式
        /// </summary>
       public  ReportFormatDicEntity reportFormat = new ReportFormatDicEntity();
        /// <summary>
        /// 报表数据
        /// </summary>
       public ReportDataStruct reportData = new ReportDataStruct();


        /// <summary>
        /// 报表审计信息
        /// </summary>
       public ReportAuditEntity reportAudit = new ReportAuditEntity();
        /// <summary>
        /// 报表问题
        /// </summary>
       public List<ReportProblemEntity> reportProblems = new List<ReportProblemEntity>();
        //审计单元格的联查定义
       public Dictionary<string, ReportAuditDefinitionEntity> reportCellsDefinition = new Dictionary<string, ReportAuditDefinitionEntity>();

    }
}
