using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AuditSPI
{
    public  class ReportCycleStruct
    {
        public string  CurrentZq;
        public string CurrentNd;
        public List<NameValueStruct> Nds = new List<NameValueStruct>();
        public List<NameValueStruct> Cycles = new List<NameValueStruct>();
        public string ReportType;
       

    }
}
