using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity;


namespace AuditSPI.Format
{
    public  interface IReportClassify
    {
        ReportClassifyEntity GetClassifyEntity(ReportClassifyEntity rce);
        List<ReportClassifyEntity> GetClassifiesList(ReportClassifyEntity rce);
        void AddClassifyEntity(ReportClassifyEntity rce);
        ReportClassifyEntity EditClassifyEntity(ReportClassifyEntity rce);
        void DeleteClassifyEntity(ReportClassifyEntity rce);
        List<ReportFormatDicEntity> GetReportsByClassify(ReportClassifyEntity rce);
        List<ReportFormatDicEntity> GetUnClassifyReports();
        void SaveReports(List<ReportRelationEntity> relations, string classifyid);
         //public void SaveReportRelations(ReportRelationEntity relation)
    }
}
