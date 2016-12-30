namespace DbManager
{
    using AuditSPI;
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Data.Common;
    using AuditEntity;
    public class DBTool
    {
        public static string CreateDbProvider(CTDbType dbType)
        {
            if (dbType == CTDbType.SQLSERVER)
            {
                return "System.Data.SqlClient";
            }
            return "";
        }

        public static string CreateMasterConnection(string userName, string passWord, string serverIp, CTDbType dbType)
        {
            if (dbType == CTDbType.SQLSERVER)
            {
                return ("Data Source=" + serverIp + ";Initial Catalog=master;User ID=" + userName + ";Password=" + passWord + ";Persist Security Info=False");
            }
            if (dbType == CTDbType.ORACLE)
            {
            }
            return "";
        }

        public static string CreatePageSql<T>(string sql, CTDbType dbType, int pageIndex, int pageNumber, string sortOrder)
        {
            sql = sql.TrimStart(new char[0]);
            sql = sql.ToUpper();
            string str2 = sql.Substring(0, 6) + " ";
            int index = sql.IndexOf("FROM");
            string str3 = sql.Substring(7, index - 3);
            string str4 = sql.Substring(index + 4);
            int num2 = (pageIndex - 1) * pageNumber;
            int num3 = num2 + pageNumber;
            switch (dbType)
            {
                case CTDbType.SQLSERVER:
                    return string.Concat(new object[] { str2, str3, "(", str2, " ROW_NUMBER() OVER (ORDER BY ", sortOrder, ") as rank, ", str3, str4, ") as t where t.rank between ", num2, " and ", num3 });

                case CTDbType.ORACLE:
                    return string.Concat(new object[] { str2, str3, "(", str2, " ROWNUM  rank, ", str3, str4, ") as t where t.rank between ", num2, " and ", num3 });
            }
            return sql;
        }

        public static string CreateSqlConnection(string userName, string passWord, string serverIp, string dbName, CTDbType dbType)
        {
            if (dbType == CTDbType.SQLSERVER)
            {
                return ("Data Source=" + serverIp + ";Initial Catalog=" + dbName + ";User ID=" + userName + ";Password=" + passWord + ";Persist Security Info=False");
            }
            if (dbType == CTDbType.ORACLE)
            {
            }
            return "";
        }

        public static DataTable DataTableTranspose(DataTable dt)
        {
            DataTable table2;
            try
            {
                int num;
                DataTable table = new DataTable();
                for (num = 0; num < dt.Rows.Count; num++)
                {
                    table.Columns.Add(num.ToString(), typeof(decimal));
                }
                for (num = 0; num < dt.Columns.Count; num++)
                {
                    DataRow row = table.NewRow();
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        row[i] = dt.Rows[i][num];
                    }
                    table.Rows.Add(row);
                }
                table2 = table;
            }
            catch (Exception exception)
            {
                throw exception;
            }
            return table2;
        }

        public static DbDataSourceInstance GetDataSource(string dataSourceId, IDbManager dbManager)
        {
            DbDataSourceInstance instance2;
            try
            {
                string sql = "SELECT * FROM CT_BASIC_DATASOURCE WHERE DATASOURCE_ID='" + dataSourceId + "'";
                List<DataSourceEntity> list = dbManager.ExecuteSqlReturnTType<DataSourceEntity>(sql);
                if (list.Count > 0)
                {
                    return new DbDataSourceInstance(new DataSource { ConnectionString = list[0].DbConnection, DataProviderName = list[0].DbProvider, DbType = list[0].DbType });
                }
                sql = "SELECT * FROM CT_BASIC_DATASOURCE WHERE DATASOURCE_DEFAULT='1'";
                list = dbManager.ExecuteSqlReturnTType<DataSourceEntity>(sql);
                if (list.Count <= 0)
                {
                    throw new Exception("没有默认的数据源");
                }
                DataSource dataSource = new DataSource {
                    ConnectionString = list[0].DbConnection,
                    DataProviderName = list[0].DbProvider,
                    DbType = list[0].DbType
                };
                instance2 = new DbDataSourceInstance(dataSource);
            }
            catch (Exception exception)
            {
                throw exception;
            }
            return instance2;
        }

        public static CTDbType GetDbType(string dbType)
        {
            CTDbType type2;
            try
            {
                CTDbType sQLSERVER = CTDbType.SQLSERVER;
                if (dbType.ToLower() == "sql")
                {
                    sQLSERVER = CTDbType.SQLSERVER;
                }
                else if (dbType.ToLower() == "ora")
                {
                    sQLSERVER = CTDbType.ORACLE;
                }
                type2 = sQLSERVER;
            }
            catch (Exception exception)
            {
                throw exception;
            }
            return type2;
        }

        public static string ReplaceDbSqlPrameters(string sql, List<DbParameter> parameters)
        {
            int num;
            object[] args = new object[parameters.Count];
            switch (ConnectionManager.getDbType())
            {
                case CTDbType.SQLSERVER:
                    for (num = 0; num < parameters.Count; num++)
                    {
                        args[num] = "@" + parameters[num].ParameterName;
                    }
                    return string.Format(sql, args);

                case CTDbType.ORACLE:
                    num = 0;
                    while (num < parameters.Count)
                    {
                        args[num] = ":" + parameters[num].ParameterName;
                        num++;
                    }
                    return string.Format(sql, args);
            }
            for (num = 0; num < parameters.Count; num++)
            {
                args[num] = "?";
            }
            return string.Format(sql, args);
        }
    }
}

