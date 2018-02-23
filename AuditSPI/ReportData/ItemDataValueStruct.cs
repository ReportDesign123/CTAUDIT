using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AuditSPI.ReportData
{
    public  class ItemDataValueStruct
    {
        public object value ;
        public string cellDataType="";
        public string isOrNotUpdate = "0";
        public string ParaValue = string.Empty;
        public string UrlValue = string.Empty;
        public int row;
        public int col;
    }
}
