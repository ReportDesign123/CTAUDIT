using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity;

namespace AuditSPI.Analysis
{
    public class IfFormularStruct
    {
        public FormularEntity IfFormular = new FormularEntity();
        public string CondisionExpress = "";
        public string TrueExpress = "";
        public string FalseExpress = "";
    }
}
