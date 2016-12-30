using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity;

namespace AuditSPI.Format
{
    public  class BBData
    {
        public string Id;
        public string bbCode;
        public string bbName;
        public string bbClassifyId;
        public Dictionary<int, Dictionary<int, Cell>> bbData = new Dictionary<int, Dictionary<int, Cell>>();
        public BdqsData bdq = new BdqsData();
        public string formatStr;
        public string dataStr;
        public int bbRows;
        public int bbCols;
        public string zq;
        public string fixTableName;
        public string BBState = "";//报表状态1 创建；2编辑；
        public   Dictionary<string, List<DataItemEntity>> UpdateTablesAndDatas = new Dictionary<string, List<DataItemEntity>>();

    }
}
