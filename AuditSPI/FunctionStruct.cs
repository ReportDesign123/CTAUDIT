using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace AuditSPI
{
    public class FunctionStruct
    {
        public string id;
        public string text;
        public string state;
        public string iconCls;
        public string parent;
        public string childrenJson;
        public  Dictionary<string, string> attributes = new Dictionary<string, string>();
        public  List<FunctionStruct> children = new List<FunctionStruct>(); 
    }
}