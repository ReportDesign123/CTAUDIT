using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.ExportReport;

namespace AuditSPI.ExportReport
{
   public  interface IReportTemplateInstanceState
    {
       /// <summary>
       /// 上级审核
       /// </summary>
       /// <param name="templateLogEntity"></param>
        void ExamReport(OperationLogEntity operationLogEntity);
       /// <summary>
       /// 获取审核历史
       /// </summary>
       /// <param name="templateLogEntiy"></param>
       /// <returns></returns>
        List<OperationLogEntity> GetExamReportHistory(TemplateLogEntity templateLogEntiy);
       /// <summary>
       /// 取消上级审核
       /// </summary>
       /// <param name="templateLogEntity"></param>
        void CancelExamReport(OperationLogEntity operationLogEntity);
       /// <summary>
       /// 报告封存
       /// </summary>
       /// <param name="templateLogEntity"></param>
        void ExamReportSeal(OperationLogEntity operationLogEntity);
       /// <summary>
       /// 取消报告封存
       /// </summary>
       /// <param name="operationLogEntity"></param>
        void ExamReportCancelSeal(OperationLogEntity operationLogEntity);

       DataGrid<TemplateLogEntity> GetExamReportDataGrid(DataGrid<TemplateLogEntity> dataGrid, TemplateLogEntity templateLogEntity);
       DataGrid<TemplateLogEntity> GetCancelExamReportDataGrid(DataGrid<TemplateLogEntity> dataGrid, TemplateLogEntity templateLogEntity);
       DataGrid<TemplateLogEntity> GetSealReportDataGrid(DataGrid<TemplateLogEntity> dataGrid, TemplateLogEntity templateLogEntity);
       DataGrid<TemplateLogEntity> GetCancelSealReportDataGrid(AuditSPI.DataGrid<TemplateLogEntity> dataGrid, TemplateLogEntity templateLogEntity);
    }
}
