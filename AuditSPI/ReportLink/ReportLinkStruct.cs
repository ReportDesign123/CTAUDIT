using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditSPI.ReportData;

namespace AuditSPI.ReportLink
{
    public  class ReportLinkStruct
    {
        public ReportDataParameterStruct reportParameter = new ReportDataParameterStruct();
    }

    public class CustomLinkStruct
    {
        public string LinkType;
        public string Content;
        public string DbType;
    }
    public class ReportCellStruct
    {
        public ReportDataParameterStruct reportParameter = new ReportDataParameterStruct();
        public ItemDataValueStruct cell = new ItemDataValueStruct(); 
    }
}
