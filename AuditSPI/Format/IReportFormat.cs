using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using AuditEntity;

namespace AuditSPI.Format
{
   public   interface IReportFormat
    {
       void SaveBBFormat(BBData report);
       DataGrid<ReportFormatDicEntity> getDataGrid(DataGrid<ReportFormatDicEntity> dataGrid,ReportFormatDicEntity rfde);
       DataGrid<ReportFormatDicEntity> ReportDataGrid(DataGrid<ReportFormatDicEntity> dataGrid, ReportFormatDicEntity rfde);

       ReportFormatDicEntity LoadReportFormat(string id);
     
       List<ReportCompFormatDicEntity> LoadCompReportFormat(string compID, string bbName);

       List<ReportFormatDicEntity> getAllReport();
       ReportFormatDicEntity LoadReportFormatNotInclueFormular(string id);
       /// <summary>
       /// 获取报表的单元格格式数据
       /// </summary>
       /// <param name="reportCode"></param>
       /// <returns></returns>
       ReportFormatDicEntity LoadReportCellFormat(string reportCode);
       //获取当前报表相关的表名
       List<string> GetReportTables(string reportId);
       /// <summary>
       /// 删除报表表结构
       /// </summary>
       /// <param name="ids"></param>
       void DeleteReports(string ids);
       /// <summary>
       /// 获取变动表排序字段
       /// </summary>
       /// <param name="tableName"></param>
       /// <returns></returns>
       string GetBdqSortCode(string tableName);
       /// <summary>
       /// 根据报表ID获取报表的基本信息，不包括格式信息
       /// </summary>
       /// <param name="id"></param>
       /// <returns></returns>
       ReportFormatDicEntity GetReportFormatById(string id);
    }
}
