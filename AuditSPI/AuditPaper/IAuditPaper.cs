using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.AuditPaper;
using AuditSPI;

namespace AuditSPI.AuditPaper
{
    public  interface IAuditPaper
    {
        void Save(AuditPaperEntity ape);
        void Edit(AuditPaperEntity ape);
        void Delete(AuditPaperEntity ape);
        AuditPaperEntity Get(string Id);
        DataGrid<AuditPaperEntity> GetDataGrid(DataGrid<AuditPaperEntity> dg,AuditPaperEntity ape);
    }
}
