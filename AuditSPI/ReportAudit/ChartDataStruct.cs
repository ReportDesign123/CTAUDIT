using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AuditSPI.ReportAudit
{
    public  class ChartDataStruct
    {
        public  List<string> XSeries = new List<string>();
        public   List<SeriesData> series = new List<SeriesData>();
    }
    public class SeriesData
    {
        public string Name;
        public List<decimal> seriesData = new List<decimal>();
    }
}
