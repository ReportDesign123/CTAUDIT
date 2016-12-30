using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditSPI.ReportData;
using AuditEntity.ReportState;
using AuditEntity;

namespace AuditSPI.ReportState
{
     public interface IReportState
    {
         void SaveReportSate(ReportStateEntity rse,ReportStateDetailEntity rsde);
         string ConvertReportState(string state);
         void SaveReportSate_Tb(ReportStateEntity rse, ReportStateDetailEntity rsde);
         ReportStateEntity ConvertReportDataParameterToStateEntity(ReportDataParameterStruct rdps);
         ReportStateDetailEntity ConvertReportDataParameterToStateDetailEntity(ReportDataParameterStruct rdps);
         //获取报表的状态
         void GetReportsState(List<ReportFormatDicEntity> reports,ReportDataParameterStruct rdps);
         /// <summary>
         /// 获取报表读写状态
         /// </summary>
         /// <param name="rdps"></param>
         /// <returns></returns>
         string GetReportReadWriteState(ReportDataParameterStruct rdps);
         void RemoveReportReadWriteState(ReportDataParameterStruct rdps);

         void DeleteReportState(AuditSPI.ReportData.ReportDataParameterStruct rdps);
         
    }

   
}
