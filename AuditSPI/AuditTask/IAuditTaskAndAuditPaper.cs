using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.AuditTask;
using AuditEntity.AuditPaper;


namespace AuditSPI.AuditTask
{
    public   interface IAuditTaskAndAuditPaper
    {
        List<AuditTaskEntity> GetAuditTaskLists();
        Dictionary<string, List<AuditPaperEntity>> GetAuditTaskAuditPapers(string AuditTaskId);
        void BatchUpdataTaskAndPaper(string AuditTaskId, List<AuditTaskAndAuditPaperEntity> apares);
        DataGrid<AuditPaperEntity> GetDataGridByTaskId(DataGrid<AuditPaperEntity> dg, string TaskId);
        DataGrid<AuditPaperEntity> GetDataGridByTaskCode(DataGrid<AuditPaperEntity> dg, string TaskCode,AuditPaperEntity ape);
    }
}
