using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.ReportLink;
using AuditSPI.ReportAudit;

namespace AuditSPI.ReportLink
{
   public  interface IReportLink
    {
       void SaveReportLink(ReportLinkEntity reportLinkEntity);
       void DeleteReportLink(ReportLinkEntity reportLinkEntity);
       List<ReportLinkEntity> GetReportLinkList(ReportLinkEntity reportLink);
       ReportAuditStruct GetReportLinkData(ReportCellStruct cell, ReportLinkStruct reportLinkStruct);
       CustomerGridDataStruct GetCustomLinkData(ReportCellStruct cell, CustomLinkStruct customLink);
       ReportLinkEntity GetReportLinkEntity(string id);
    }
}
