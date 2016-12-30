namespace DbManager
{
    using AuditSPI;
    using CtTool;
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Data.Common;
    using System.Data.Linq.Mapping;
    using System.Reflection;
    using System.Text;
    using System.Data.SqlClient;

    public class CTDbManager : IDbManager
    {
        private DbCommand command;
        private DbConnection connection;
        private DbProviderFactory dbProvider;

        public CTDbManager()
        {
            try
            {
                if (this.dbProvider == null)
                {
                    this.dbProvider = DbProviderFactories.GetFactory(ConnectionManager.getProviderName());
                    this.connection = this.dbProvider.CreateConnection();
                    this.command = this.dbProvider.CreateCommand();
                    this.command.Connection = this.connection;
                    this.connection.ConnectionString = ConnectionManager.getConnectionStr();
                }
            }
            catch (DbException exception)
            {
                Console.WriteLine("Exception.Message: {0}", exception.Message);
            }
            catch (Exception exception2)
            {
                Console.WriteLine("Exception.Message: {0}", exception2.Message);
            }
        }

        public void BatchUpdateData(DataTable dataTable, string sql, UpdateType updateType, List<DbParameter> parameters)
        {
            try
            {
                using (this.connection)
                {
                    this.Open();
                    sql = DBTool.ReplaceDbSqlPrameters(sql, parameters);
                    this.command.CommandText = sql;
                    this.command.Parameters.Clear();
                    try
                    {
                        DbDataAdapter adapter = this.dbProvider.CreateDataAdapter();
                        switch (updateType)
                        {
                            case UpdateType.INSERTCOMMAND:
                                adapter.InsertCommand = this.command;
                                adapter.InsertCommand.UpdatedRowSource = UpdateRowSource.None;
                                foreach (DbParameter parameter in parameters)
                                {
                                    adapter.InsertCommand.Parameters.Add(parameter);
                                }
                                break;

                            case UpdateType.UPDATECOMMAND:
                                adapter.UpdateCommand = this.command;
                                adapter.UpdateCommand.UpdatedRowSource = UpdateRowSource.None;
                                foreach (DbParameter parameter in parameters)
                                {
                                    adapter.UpdateCommand.Parameters.Add(parameter);
                                }
                                break;

                            case UpdateType.DELETECOMMAND:
                                adapter.DeleteCommand = this.command;
                                adapter.DeleteCommand.UpdatedRowSource = UpdateRowSource.None;
                                foreach (DbParameter parameter in parameters)
                                {
                                    adapter.DeleteCommand.Parameters.Add(parameter);
                                }
                                break;
                        }
                        adapter.UpdateBatchSize = 10;
                        adapter.Update(dataTable);
                    }
                    catch (Exception exception)
                    {
                        throw exception;
                    }
                    finally
                    {
                        this.Close();
                    }
                }
            }
            catch (DbException exception2)
            {
                throw exception2;
            }
            finally
            {
                this.Close();
            }
        }

        public void Close()
        {
            if ((this.connection != null) && (this.connection.State == ConnectionState.Open))
            {
                this.connection.Close();
            }
        }

        public string ConvertBeanByOldBeanToUpdateSql<T>(T newObj, T oldObj, string whereSql, List<DbParameter> parameters)
        {
            string str4;
            try
            {
                Type type = typeof(T);
                StringBuilder builder = new StringBuilder();
                TableAttribute[] customAttributes = (TableAttribute[])type.GetCustomAttributes(typeof(TableAttribute), false);
                string name = customAttributes[0].Name;
                PropertyInfo[] properties = type.GetProperties();
                int num = 0;
                foreach (PropertyInfo info in properties)
                {
                    object obj2 = info.GetValue(newObj, null);
                    object obj3 = info.GetValue(oldObj, null);
                    if ((obj2 != obj3) && !StringUtil.IsNullOrEmpty(obj2))
                    {
                        foreach (ColumnAttribute attribute in info.GetCustomAttributes(typeof(ColumnAttribute), false))
                        {
                            DbParameter item = this.dbProvider.CreateParameter();
                            builder.Append(attribute.Name);
                            builder.Append("=");
                            builder.Append("{");
                            builder.Append(num.ToString());
                            builder.Append("}");
                            builder.Append(",");
                            item.ParameterName = info.Name;
                            switch (info.PropertyType.FullName)
                            {
                                case "System.String":
                                    item.DbType = DbType.String;
                                    break;

                                case "System.Decimal":
                                    item.DbType = DbType.Decimal;
                                    break;

                                case "System.Int32":
                                    item.DbType = DbType.Int32;
                                    break;

                                case "System.Int64":
                                    item.DbType = DbType.Int64;
                                    break;

                                case "System.DateTime":
                                    item.DbType = DbType.DateTime;
                                    break;
                            }
                            item.Value = info.GetValue(newObj, null);
                            parameters.Add(item);
                        }
                        num++;
                    }
                }
                if (builder.Length > 0)
                {
                    builder.Length--;
                    return DBTool.ReplaceDbSqlPrameters("UPDATE " + name + " SET " + builder.ToString() + whereSql, parameters);
                }
                str4 = null;
            }
            catch (Exception exception)
            {
                throw exception;
            }
            return str4;
        }

        public string ConvertBeanToDeleteCommandSql<T>(T obj, string field, DbParameter parameter)
        {
            string str4;
            try
            {
                string str = "";
                StringBuilder builder = new StringBuilder();
                builder.Append(" DELETE FROM ");
                Type type = typeof(T);
                TableAttribute[] customAttributes = (TableAttribute[])type.GetCustomAttributes(typeof(TableAttribute), false);
                string name = customAttributes[0].Name;
                builder.Append(name);
                PropertyInfo property = type.GetProperty(field);
                if (property == null)
                {
                    return builder.ToString();
                }
                foreach (ColumnAttribute attribute in property.GetCustomAttributes(typeof(ColumnAttribute), false))
                {
                    builder.Append(" WHERE ");
                    builder.Append(attribute.Name);
                    if (StringUtil.IsNullOrEmpty(property.GetValue(obj, null)))
                    {
                        builder.Append(" IS NULL ");
                        builder.Append(" OR ");
                        builder.Append(attribute.Name);
                        builder.Append("=''");
                        str = builder.ToString();
                    }
                    else
                    {
                        builder.Append("={0}");
                        parameter.ParameterName = property.Name;
                        switch (property.PropertyType.FullName)
                        {
                            case "System.String":
                                parameter.DbType = DbType.String;
                                break;

                            case "System.Decimal":
                                parameter.DbType = DbType.Decimal;
                                break;

                            case "System.Int32":
                                parameter.DbType = DbType.Int32;
                                break;

                            case "System.Int64":
                                parameter.DbType = DbType.Int64;
                                break;

                            case "System.DateTime":
                                parameter.DbType = DbType.DateTime;
                                break;
                        }
                        parameter.Value = property.GetValue(obj, null);
                        List<DbParameter> parameters = new List<DbParameter> {
                            parameter
                        };
                        str = DBTool.ReplaceDbSqlPrameters(builder.ToString(), parameters);
                    }
                }
                str4 = str;
            }
            catch (Exception exception)
            {
                throw exception;
            }
            return str4;
        }

        public string ConvertBeanToInsertCommandSql<T>(T obj, List<DbParameter> parameters)
        {
            string str4;
            try
            {
                StringBuilder builder = new StringBuilder();
                StringBuilder builder2 = new StringBuilder();
                builder.Append(" INSERT INTO  ");
                builder2.Append(" VALUES (");
                Type type = typeof(T);
                TableAttribute[] customAttributes = (TableAttribute[])type.GetCustomAttributes(typeof(TableAttribute), false);
                string name = customAttributes[0].Name;
                builder.Append(name);
                builder.Append("(");
                PropertyInfo[] properties = type.GetProperties();
                int num = 0;
                foreach (PropertyInfo info in properties)
                {
                    if ((info.GetValue(obj, null) != null) && !(info.GetValue(obj, null).ToString() == ""))
                    {
                        foreach (ColumnAttribute attribute in info.GetCustomAttributes(typeof(ColumnAttribute), false))
                        {
                            DbParameter item = this.dbProvider.CreateParameter();
                            builder2.Append("{" + num.ToString() + "}");
                            builder2.Append(",");
                            builder.Append(attribute.Name);
                            builder.Append(",");
                            item.ParameterName = info.Name;
                            switch (info.PropertyType.FullName)
                            {
                                case "System.String":
                                    item.DbType = DbType.String;
                                    break;

                                case "System.Decimal":
                                    item.DbType = DbType.Decimal;
                                    break;

                                case "System.Int32":
                                    item.DbType = DbType.Int32;
                                    break;

                                case "System.Int64":
                                    item.DbType = DbType.Int64;
                                    break;

                                case "System.DateTime":
                                    item.DbType = DbType.DateTime;
                                    break;
                            }
                            item.Value = info.GetValue(obj, null);
                            parameters.Add(item);
                        }
                        num++;
                    }
                }
                builder.Length--;
                builder2.Length--;
                builder.Append(")");
                builder2.Append(")");
                str4 = DBTool.ReplaceDbSqlPrameters(builder.ToString() + builder2.ToString(), parameters);
            }
            catch (Exception exception)
            {
                throw exception;
            }
            return str4;
        }

        public string ConvertBeanToUpdateSql<T>(T newObj, string whereSql, List<DbParameter> parameters, List<string> exclude)
        {
            string str5;
            try
            {
                Type type = typeof(T);
                StringBuilder builder = new StringBuilder();
                TableAttribute[] customAttributes = (TableAttribute[])type.GetCustomAttributes(typeof(TableAttribute), false);
                string name = customAttributes[0].Name;
                PropertyInfo[] properties = type.GetProperties();
                int num = 0;
                foreach (PropertyInfo info in properties)
                {
                    bool flag = false;
                    foreach (string str2 in exclude)
                    {
                        if (info.Name == str2)
                        {
                            flag = true;
                            break;
                        }
                    }
                    if (!flag && (info.GetValue(newObj, null) != null))
                    {
                        foreach (ColumnAttribute attribute in info.GetCustomAttributes(typeof(ColumnAttribute), false))
                        {
                            DbParameter item = this.dbProvider.CreateParameter();
                            builder.Append(attribute.Name);
                            builder.Append("=");
                            builder.Append("{");
                            builder.Append(num.ToString());
                            builder.Append("}");
                            builder.Append(",");
                            item.ParameterName = info.Name;
                            switch (info.PropertyType.FullName)
                            {
                                case "System.String":
                                    item.DbType = DbType.String;
                                    break;

                                case "System.Decimal":
                                    item.DbType = DbType.Decimal;
                                    break;

                                case "System.Int32":
                                    item.DbType = DbType.Int32;
                                    break;

                                case "System.Int64":
                                    item.DbType = DbType.Int64;
                                    break;

                                case "System.DateTime":
                                    item.DbType = DbType.DateTime;
                                    break;
                            }
                            item.Value = info.GetValue(newObj, null);
                            parameters.Add(item);
                        }
                        num++;
                    }
                }
                if (builder.Length > 0)
                {
                    builder.Length--;
                    return DBTool.ReplaceDbSqlPrameters("UPDATE " + name + " SET " + builder.ToString() + whereSql, parameters);
                }
                str5 = null;
            }
            catch (Exception exception)
            {
                throw exception;
            }
            return str5;
        }

        public List<T> ConvertDataReaderToType<T>(DbDataReader reader)
        {
            List<T> list2;
            try
            {
                List<T> list = new List<T>();
                PropertyInfo[] properties = typeof(T).GetProperties();
                while (reader.Read())
                {
                    T local = Activator.CreateInstance<T>();
                    foreach (PropertyInfo info in properties)
                    {
                        foreach (ColumnAttribute attribute in info.GetCustomAttributes(typeof(ColumnAttribute), false))
                        {
                            string name = attribute.Name;
                            if ((this.ExistColumnName(reader, name) && !Convert.IsDBNull(reader[name])) && (reader[name] != null))
                            {
                                info.SetValue(local, reader[name], null);
                            }
                        }
                    }
                    list.Add(local);
                }
                list2 = list;
            }
            catch (Exception exception)
            {
                throw exception;
            }
            finally
            {
                // this.Close();
            }
            return list2;
        }

        public int Count(string sql)
        {
            int num;
            try
            {
                using (this.connection)
                {
                    this.Open();
                    this.command.CommandText = sql;
                    this.command.Parameters.Clear();
                    num = Convert.ToInt32(this.command.ExecuteScalar());
                }
            }
            catch (Exception exception)
            {
                throw exception;
            }
            finally
            {
                this.Close();
            }
            return num;
        }

        public DataTable ExecuteProcedureDataTable(string procedureName, List<DbParameter> parameters)
        {
            DataTable table2;
            try
            {
                using (this.connection)
                {
                    this.Open();
                    this.command.CommandText = procedureName;
                    this.command.CommandType = CommandType.StoredProcedure;
                    DbDataAdapter adapter = this.dbProvider.CreateDataAdapter();
                    adapter.SelectCommand = this.command;
                    DataTable dataTable = new DataTable();
                    adapter.Fill(dataTable);
                    table2 = dataTable;
                }
            }
            catch (DbException exception)
            {
                throw exception;
            }
            finally
            {
                this.Close();
            }
            return table2;
        }

        public void ExecuteSql(string sql)
        {
            try
            {
                using (this.connection)
                {
                    this.Open();
                    DbTransaction transaction = this.connection.BeginTransaction();
                    try
                    {
                        this.command.Transaction = transaction;
                        this.command.CommandText = sql;
                        this.command.Parameters.Clear();
                        this.command.ExecuteNonQuery();
                        transaction.Commit();
                    }
                    catch (Exception exception)
                    {
                        transaction.Rollback();
                        this.Close();
                        throw exception;
                    }
                    finally
                    {
                        this.Close();
                    }
                }
            }
            catch (DbException exception2)
            {
                throw exception2;
            }
            finally
            {
                this.Close();
            }
        }

        public void ExecuteSql(string sql, List<DbParameter> parameters)
        {
            try
            {
                using (this.connection)
                {
                    this.Open();
                    sql = DBTool.ReplaceDbSqlPrameters(sql, parameters);
                    this.command.CommandText = sql;
                    this.command.Parameters.Clear();
                    foreach (DbParameter parameter in parameters)
                    {
                        this.command.Parameters.Add(parameter);
                    }
                    this.command.ExecuteNonQuery();
                    this.command.Parameters.Clear();
                }
            }
            catch (DbException exception)
            {
                throw exception;
            }
            finally
            {
                this.Close();
            }
        }

        public DbDataReader ExecuteSqlReturnDataReader(string sql)
        {
            DbDataReader reader2;
            try
            {
                this.Open();
                this.command.CommandText = sql;
                reader2 = this.command.ExecuteReader();
            }
            catch (DbException exception)
            {
                throw exception;
            }
            return reader2;
        }

        public DbDataReader ExecuteSqlReturnDataReader(string sql, List<DbParameter> parameters)
        {
            DbDataReader reader;
            try
            {
                this.Open();
                sql = DBTool.ReplaceDbSqlPrameters(sql, parameters);
                this.command.CommandText = sql;
                this.command.Parameters.Clear();
                foreach (DbParameter parameter in parameters)
                {
                    this.command.Parameters.Add(parameter);
                }
                this.command.Parameters.Clear();
                reader = this.command.ExecuteReader();
            }
            catch (DbException exception)
            {
                throw exception;
            }
            return reader;
        }

        public DataTable ExecuteSqlReturnDataTable(string sql)
        {
            DataTable table2;
            try
            {

                this.Open();
                this.command.CommandText = sql;
                DbDataAdapter adapter = this.dbProvider.CreateDataAdapter();
                adapter.SelectCommand = this.command;
                DataTable dataTable = new DataTable();
                adapter.Fill(dataTable);
                table2 = dataTable;

            }
            catch
            {
                throw;
            }
            finally
            {
                this.Close();
            }
            return table2;
        }

        public DataTable ExecuteSqlReturnDataTable(string sql, List<DbParameter> parameters)
        {
            DataTable table2;
            try
            {
                using (this.connection)
                {
                    this.Open();
                    sql = DBTool.ReplaceDbSqlPrameters(sql, parameters);
                    this.command.CommandText = sql;
                    this.command.Parameters.Clear();
                    foreach (DbParameter parameter in parameters)
                    {
                        this.command.Parameters.Add(parameter);
                    }
                    DbDataAdapter adapter = this.dbProvider.CreateDataAdapter();
                    adapter.SelectCommand = this.command;
                    DataTable dataTable = new DataTable();
                    adapter.Fill(dataTable);
                    this.command.Parameters.Clear();
                    table2 = dataTable;
                }
            }
            catch (DbException exception)
            {
                throw exception;
            }
            finally
            {
                this.Close();
            }
            return table2;
        }

        public List<T> ExecuteSqlReturnTType<T>(string sql)
        {
            List<T> list2;
            try
            {
                using (this.connection)
                {
                    this.Open();
                    List<T> list = new List<T>();
                    DbDataReader dr = this.ExecuteSqlReturnDataReader(sql);
                    PropertyInfo[] properties = typeof(T).GetProperties();
                    while (dr.Read())
                    {
                        T local = Activator.CreateInstance<T>();
                        foreach (PropertyInfo info in properties)
                        {
                            foreach (ColumnAttribute attribute in info.GetCustomAttributes(typeof(ColumnAttribute), false))
                            {
                                string name = attribute.Name;
                                if ((this.ExistColumnName(dr, name) && !Convert.IsDBNull(dr[name])) && (dr[name] != null))
                                {
                                    info.SetValue(local, dr[name], null);
                                }
                            }
                        }
                        list.Add(local);
                    }
                    dr.Close();
                    list2 = list;
                }
            }
            catch (DbException exception)
            {
                throw exception;
            }
            finally
            {
                this.Close();
            }
            return list2;
        }

        public List<T> ExecuteSqlReturnTType<T>(string sql, Dictionary<string, string> maps)
        {
            List<T> list2;
            try
            {
                List<T> list = new List<T>();
                this.command.Parameters.Clear();
                DbDataReader dr = this.ExecuteSqlReturnDataReader(sql);
                Type type = typeof(T);
                while (dr.Read())
                {
                    T local = Activator.CreateInstance<T>();
                    foreach (string str in maps.Keys)
                    {
                        PropertyInfo property = type.GetProperty(str);
                        if ((this.ExistColumnName(dr, maps[str]) && !Convert.IsDBNull(dr[maps[str]])) && (dr[maps[str]] != null))
                        {
                            property.SetValue(local, dr[maps[str]], null);
                        }
                    }
                    list.Add(local);
                }
                dr.Close();
                list2 = list;
            }
            catch (DbException exception)
            {
                throw exception;
            }
            finally
            {
                this.Close();
            }
            return list2;
        }

        public List<T> ExecuteSqlReturnTType<T>(string sql, List<DbParameter> parameters)
        {
            sql = DBTool.ReplaceDbSqlPrameters(sql, parameters);
            foreach (DbParameter parameter in parameters)
            {
                this.command.Parameters.Add(parameter);
            }
            return this.ExecuteSqlReturnTType<T>(sql);
        }

        public List<T> ExecuteSqlReturnTType<T>(string sql, List<DbParameter> parameters, Dictionary<string, string> maps)
        {
            List<T> list2;
            try
            {
                List<T> list = new List<T>();
                sql = DBTool.ReplaceDbSqlPrameters(sql, parameters);
                this.command.Parameters.Clear();
                foreach (DbParameter parameter in parameters)
                {
                    this.command.Parameters.Add(parameter);
                }
                DbDataReader dr = this.ExecuteSqlReturnDataReader(sql);
                Type type = typeof(T);
                while (dr.Read())
                {
                    T local = Activator.CreateInstance<T>();
                    foreach (string str in maps.Keys)
                    {
                        PropertyInfo property = type.GetProperty(str);
                        if ((this.ExistColumnName(dr, maps[str]) && !Convert.IsDBNull(dr[maps[str]])) && (dr[maps[str]] != null))
                        {
                            property.SetValue(local, dr[maps[str]], null);
                        }
                    }
                    list.Add(local);
                }
                dr.Close();
                this.command.Parameters.Clear();
                list2 = list;
            }
            catch (DbException exception)
            {
                throw exception;
            }
            finally
            {
                this.Close();
            }
            return list2;
        }

        public List<T> ExecuteSqlReturnTType<T>(string sql, int pageIndex, int pageNumber, string sortOrder, Dictionary<string, string> maps)
        {
            List<T> list2;
            try
            {
                using (this.connection)
                {
                    this.Open();
                    sql = DBTool.CreatePageSql<T>(sql, ConnectionManager.getDbType(), pageIndex, pageNumber, sortOrder);
                    List<DbParameter> parameters = new List<DbParameter>();
                    list2 = this.ExecuteSqlReturnTType<T>(sql, parameters, maps);
                }
            }
            catch (Exception exception)
            {
                throw exception;
            }
            finally
            {
                this.Close();
            }
            return list2;
        }

        public List<T> ExecuteSqlReturnTTypeByFields<T>(string sql, Dictionary<string, string> maps)
        {
            List<T> list2;
            try
            {
                List<T> list = new List<T>();
                this.command.Parameters.Clear();
                DbDataReader dr = this.ExecuteSqlReturnDataReader(sql);
                Type type = typeof(T);
                while (dr.Read())
                {
                    T local = Activator.CreateInstance<T>();
                    foreach (string str in maps.Keys)
                    {
                        FieldInfo field = type.GetField(str);
                        if ((this.ExistColumnName(dr, maps[str]) && !Convert.IsDBNull(dr[maps[str]])) && (dr[maps[str]] != null))
                        {
                            field.SetValue(local, dr[maps[str]]);
                        }
                    }
                    list.Add(local);
                }
                dr.Close();
                list2 = list;
            }
            catch (DbException exception)
            {
                throw exception;
            }
            finally
            {
                this.Close();
            }
            return list2;
        }

        public bool ExistColumnName(DbDataReader dr, string columnName)
        {
            for (int i = 0; i < dr.FieldCount; i++)
            {
                if (columnName.ToUpper() == dr.GetName(i).ToUpper())
                {
                    return true;
                }
            }
            return false;
        }

        public void BulkToDB(string tableName, DataTable dt)
        {
            SqlConnection sqlConn = new SqlConnection() { ConnectionString = ConnectionManager.getConnectionStr() };
;
            // dbManager.GetDbConnection();
            SqlBulkCopy bulkCopy = new SqlBulkCopy(sqlConn) { DestinationTableName = tableName, BatchSize = dt.Rows.Count };

            try
            {
                if (sqlConn.State == ConnectionState.Closed)
                    sqlConn.Open();
                if (dt != null && dt.Rows.Count != 0)
                    bulkCopy.WriteToServer(dt);
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                sqlConn.Close();
                if (bulkCopy != null)
                    bulkCopy.Close();
            }
        }
        public  void BulkToUpdateDB(string tableName, DataTable dt)
        {

            SqlConnection conn = new SqlConnection(ConnectionManager.getConnectionStr());
            SqlCommand comm = conn.CreateCommand(); 
            comm.CommandType = CommandType.Text;
            SqlDataAdapter adapter = new SqlDataAdapter(comm);
            SqlCommandBuilder commandBulider = new SqlCommandBuilder(adapter) { ConflictOption = ConflictOption.OverwriteChanges };
            try
            {
                conn.Open();
                //设置批量更新的每次处理条数 
                adapter.UpdateBatchSize = 5000;
                adapter.SelectCommand.Transaction = conn.BeginTransaction();/////////////////开始事务 

                if (dt.ExtendedProperties["SQL"] != null)
                {
                    //DataTable SourTable = new DataTable();
                    adapter.SelectCommand.CommandText = dt.ExtendedProperties["SQL"].ToString();// dt.ExtendedProperties["SQL"].ToString();
                }

                SqlCommandBuilder scb = new SqlCommandBuilder(adapter);
                foreach (DataRow dr in dt.Rows)
                {
                    if (dr.RowState == DataRowState.Unchanged)
                        dr.SetModified();
                }
                adapter.Update(dt);
                dt.AcceptChanges();
                adapter.SelectCommand.Transaction.Commit();/////提交事务 
            }
            catch (Exception ex)
            {
                if (adapter.SelectCommand != null && adapter.SelectCommand.Transaction != null)
                {
                    adapter.SelectCommand.Transaction.Rollback();
                }
                throw ex;
            }
            finally
            {
                conn.Close();
                conn.Dispose();
            }
        }

        public string GetDatabase()
        {
            return this.connection.Database;
        }

        public DbCommand getDbCommand()
        {
            return this.command;
        }

        public DbConnection GetDbConnection()
        {
            return this.connection;
        }

        public DbParameter GetDbParameter()
        {
            return this.dbProvider.CreateParameter();
        }

        public List<DbParameter> GetDbParameters(int count)
        {
            List<DbParameter> list = new List<DbParameter>();
            for (int i = 0; i < count; i++)
            {
                DbParameter dbParameter = this.GetDbParameter();
                list.Add(dbParameter);
            }
            return list;
        }

        public CTDbType GetDbType()
        {
            return ConnectionManager.getDbType();
        }

        public string GetSubSql(string field, int start)
        {
            string str;
            try
            {
                switch (ConnectionManager.getDbType())
                {
                    case CTDbType.SQLSERVER:
                        return string.Concat(new object[] { " SUBSTRING(", field, ", ", start, ",len(", field, ")-", start, ") " });

                    case CTDbType.ORACLE:
                        return string.Concat(new object[] { " substr(", field, ", ", start, ")" });
                }
                str = field;
            }
            catch (Exception exception)
            {
                throw exception;
            }
            return str;
        }

        public string GetSubSql(string field, int start, int length)
        {
            string str;
            try
            {
                switch (ConnectionManager.getDbType())
                {
                    case CTDbType.SQLSERVER:
                        return string.Concat(new object[] { " SUBSTRING(", field, ", ", start, ", ", length + 1, ") " });

                    case CTDbType.ORACLE:
                        return string.Concat(new object[] { " substr(", field, ", ", start, ", ", length, ") " });
                }
                str = field;
            }
            catch (Exception exception)
            {
                throw exception;
            }
            return str;
        }

        public string Join()
        {
            string str2;
            try
            {
                string str = "";
                switch (ConnectionManager.getDbType())
                {
                    case CTDbType.SQLSERVER:
                        str = "+";
                        break;

                    case CTDbType.ORACLE:
                        str = "||";
                        break;
                }
                str2 = str;
            }
            catch (Exception exception)
            {
                throw exception;
            }
            return str2;
        }

        public void Open()
        {
            if ((this.connection != null) && (this.connection.State == ConnectionState.Closed))
            {
                this.connection.ConnectionString = ConnectionManager.getConnectionStr();
                this.command.Connection = this.connection;
                this.connection.Open();
            }
        }
    }
}

