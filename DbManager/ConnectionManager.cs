namespace DbManager
{
    using AuditSPI;
    using System;
    using System.Data.Common;
    using System.Data.SqlClient;
    using System.Web;
    using System.Xml;

    public class ConnectionManager
    {
        private static string connectionStr = "";
        private static string dbType = "";
        private static DataSource ds = new DataSource();

        public static DbConnection getConnection()
        {
            ReadXmlInfo();
            string dbType = ConnectionManager.dbType;
            if ((dbType != null) && (dbType == "sql"))
            {
                return new SqlConnection(connectionStr);
            }
            return null;
        }

        public static string getConnectionStr()
        {
            ReadXmlInfo();
            string dbType = ConnectionManager.dbType;
            if ((dbType != null) && (dbType == "sql"))
            {
                return connectionStr;
            }
            return "";
        }

        public static CTDbType getDbType()
        {
            ReadXmlInfo();
            string dbType = ConnectionManager.dbType;
            if ((dbType != null) && (dbType == "sql"))
            {
                return CTDbType.SQLSERVER;
            }
            return CTDbType.SQLSERVER;
        }

        public static string getProviderName()
        {
            ReadXmlInfo();
            string dbType = ConnectionManager.dbType;
            if ((dbType != null) && (dbType == "sql"))
            {
                return "System.Data.SqlClient";
            }
            return "";
        }

        public static void ReadXmlInfo()
        {
            if (!(ds.DbType != "") || !(ds.ConnectionString != ""))
            {
                XmlDocument document = new XmlDocument();
                document.Load(HttpContext.Current.Server.MapPath("~") + @"\DBConfig.xml");
                XmlNodeList childNodes = document.SelectSingleNode("CtConfig").SelectSingleNode("DataSources").ChildNodes;
                foreach (XmlNode node3 in childNodes)
                {
                    XmlElement element = (XmlElement) node3;
                    if (element.GetAttribute("Default").ToString().ToLower() == "true")
                    {
                        ds.DbType = element.GetAttribute("DbType");
                        ds.ConnectionString = element.GetAttribute("ConnectString");
                    }
                }
                dbType = ds.DbType;
                connectionStr = ds.ConnectionString;
            }
        }
    }
}

