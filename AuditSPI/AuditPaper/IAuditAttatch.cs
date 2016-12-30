using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.AuditPaper;


namespace AuditSPI.AuditPaper
{
    public  interface IAuditAttatch
    {
        void Save(PaperAttatchEntity pae);
        void Edit(PaperAttatchEntity pae);
        void Delete(string attatchId);
    }
}
