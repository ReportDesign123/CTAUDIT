using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Common;

namespace AuditSPI
{
    public  class DataSource
    {
        public string DataProviderName = "";
        public string ConnectionString = "";
        public string DbType = "";
        


        public  CTDbType getDbType()
        {
            switch (DbType)
            {
                case "sql":
                    return CTDbType.SQLSERVER;
                default:
                    return CTDbType.SQLSERVER;
            }
        }
    }
}
