using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AuditSPI.Analysis
{
    public  interface IFormularExpressDeserialize
    {
        object ExpressParse(string formular);
    }
}
