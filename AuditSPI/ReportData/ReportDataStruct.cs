using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity;
using System.Collections;

namespace AuditSPI.ReportData
{
    [Serializable]
    public  class ReportDataStruct
    {
        //固定区数据
        public Dictionary<string, ItemDataValueStruct> Gdq = new Dictionary<string, ItemDataValueStruct>();
        //变动区数据
        public List<List<Dictionary<string, ItemDataValueStruct>>> BdqData = new List<List<Dictionary<string, ItemDataValueStruct>>>();
        public   Dictionary<string, int> bdMaps = new Dictionary<string, int>();
        public ReportDataParameterStruct rdps = new ReportDataParameterStruct();
        public string GdbId;
        public string GdbTableName;
        public Dictionary<string, string> bdTableNames = new Dictionary<string, string>();
        public Dictionary<string, string> bdWhere = new Dictionary<string, string>();
        public Dictionary<string, string> bdIndexMaps = new Dictionary<string, string>();
        public string IsOrNotLock = "0";
                
    }
}
