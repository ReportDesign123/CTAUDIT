using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.ReportAttatch;
using AuditEntity;
using AuditSPI.ReportData;

namespace AuditSPI.ReportAttatchment
{
    public  interface IReportAttatchment
    {
        void AddReportAttatchment(ReportAttatchEntity rae);
        void DeleteReportAttatchment(ReportAttatchEntity rae);
        List<ReportAttatchEntity> GetReportAttatchments(ReportAttatchEntity rae);
        List<ReportAttatchEntity> GetReportAttatchments(string ids);
        void DeleteReportAttatchments(string ids);
        void GetReportAttatchments(List<ReportFormatDicEntity> reports,ReportDataParameterStruct rdps);

        string BatchDownload(ReportDataParameterStruct reportParameters, string fileDirectory, string relativePath);
    }
}
