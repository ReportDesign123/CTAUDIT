using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.Procedure;

namespace AuditSPI.Procedure
{
   public   class ProcedureParametersStruct
    {
       public string name;
       public List<ProcedureParameterEntity> parameters = new List<ProcedureParameterEntity>();
    }
}
