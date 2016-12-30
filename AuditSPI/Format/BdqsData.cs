using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AuditSPI.Format
{
   public   class BdqsData
    {
       public int bdNum;
       public int BdRowNum;
       public int BdColNum;
       public   Dictionary<string, int> BdqMaps = new Dictionary<string, int>();
       public  List<Bdq> Bdqs = new List<Bdq>();
    }
}
