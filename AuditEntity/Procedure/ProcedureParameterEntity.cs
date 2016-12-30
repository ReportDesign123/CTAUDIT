using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.Procedure
{
  
  public    class ProcedureParameterEntity
    {
       
      public int Id
      {
          get;
          set;
      }
    
      public string Name
      {
          get;
          set;
      }
    
      public string Type
      {
          get;
          set;
      }
      public string Value
      {
          get;
          set;
      }
    }
}
