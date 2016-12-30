using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditSPI;
using System.Reflection;
using System.Data.Linq.Mapping;
using System.Data;
using System.Data.Common;




namespace CtTool
{
    public  class BeanUtil
    {
        /// <summary>
        /// 将具体的对象转换为TreeNode
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="tList"></param>
        /// <param name="nodes"></param>
        /// <param name="idField"></param>
        /// <param name="textField"></param>
        /// <param name="parentField"></param>
        public static void ConvertTTypeToTreeNode<T>(List<T> tList, List<TreeNode> nodes, string idField, string textField, string parentField, string codeField="")
        {
            try
            {
                Type t = typeof(T);
                foreach (T obj in tList)
                {
                    string parent = GetPropertyValue<T>(t, parentField, obj);
                    int parentCount = FindParent<T>(tList, parentField, idField, t, parent);
                    if (parent == null||parent==""||parentCount==0)
                    {
                        TreeNode tn = new TreeNode();
                        tn.id = GetPropertyValue<T>(t, idField, obj);
                        tn.text = GetPropertyValue<T>(t, textField, obj);
                        if (!StringUtil.IsNullOrEmpty(codeField))
                        {
                            tn.code = GetPropertyValue<T>(t, codeField, obj);
                        }
                        tn.isOrNotChecked = GetFieldValue<T>(t, "isOrNotChecked", obj);
                        FindChildren<T>(tList, tn, idField, textField, parentField, t,codeField);
                        nodes.Add(tn);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static void ConvertTTypeToListTreeNodes<T>(List<T> tList, List<TreeNode> nodes, string idField, string textField,string codeField)
        {
            try
            {
                Type t = typeof(T);
                foreach (T obj in tList)
                {
                   
                        TreeNode tn = new TreeNode();
                        tn.id = GetPropertyValue<T>(t, idField, obj);
                        tn.text = GetPropertyValue<T>(t, textField, obj);
                        if (codeField!=null)
                        {
                            tn.code = GetPropertyValue<T>(t, codeField, obj);
                        }
                        nodes.Add(tn);
                  
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 将对象转换为Bean映射
        /// </summary>
        /// <param name="bean"></param>
        /// <returns></returns>
        public static Dictionary<string, string> ConvertObjectToMaps<T>()
        {
            try
            {
                Dictionary<string, string> maps = new Dictionary<string, string>();
                Type t = typeof(T);
                PropertyInfo[] propertis = t.GetProperties();
                foreach (PropertyInfo pi in propertis)
                {
                    foreach (ColumnAttribute a in pi.GetCustomAttributes(typeof(ColumnAttribute), false))
                    {
                        maps.Add(pi.Name, a.Name);
                    }
                }
                return maps;     
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
        /// <summary>
        /// 创建SELECT sql
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        public static string ConvertObjectToSqls<T>()
        {
            try
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" ");
                Type t = typeof(T);
                PropertyInfo[] propertis = t.GetProperties();
                foreach (PropertyInfo pi in propertis)
                {
                    foreach (ColumnAttribute a in pi.GetCustomAttributes(typeof(ColumnAttribute), false))
                    {
                        sb.Append(a.Name);
                        sb.Append(",");
                    }
                }
                sb.Length--;
                return sb.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
        /// <summary>
        /// 创建whereSql，但是不带WHERE 关键字
        /// 约束：字段只能为string、int、decimal
        /// AND A='SS'
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        public static string ConvertObjectToWhereSqls<T>(T obj,Dictionary<string,string>excludes=null)
        {
            try
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" ");
                Type t = typeof(T);
                PropertyInfo[] propertis = t.GetProperties();
                foreach (PropertyInfo pi in propertis)
                {
                    string name = "";
                 
                    foreach (ColumnAttribute a in pi.GetCustomAttributes(typeof(ColumnAttribute), false))
                    {
                        name = a.Name;
                    }
                    if (StringUtil.IsNullOrEmpty(name)) continue;
                    if (excludes!=null&& excludes.ContainsKey(pi.Name)) continue;
                    string valueType = pi.PropertyType.FullName;
                    object value = GetPropertyValue<T>(t, pi.Name, obj);
                    if (StringUtil.IsNullOrEmpty(value)) continue;
                    sb.Append(" AND ");
                    sb.Append(name);
                    sb.Append("=");
                    if (valueType == "System.String")
                    {

                        sb.Append("'");
                        sb.Append(value);
                        sb.Append("'");
                    }
                    else if (valueType == "System.Decimal")
                    {
                        sb.Append(value);                      
                    }
                    else if (valueType == "System.Int32")
                    {
                        sb.Append(value);                       
                    }
                    else if (valueType == "System.Int64")
                    {
                        sb.Append(value);                       
                    }
                   
                }               
                return sb.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
        public static string ConvertObjectToQueryWhereSqls<T>(T obj, List<string> properties)
        {
            try
            {
                StringBuilder sb = new StringBuilder();

                Type t = typeof(T);
                foreach (string pn in properties)
                {
                    PropertyInfo pi = t.GetProperty(pn);

                    string name = "";

                    foreach (ColumnAttribute a in pi.GetCustomAttributes(typeof(ColumnAttribute), false))
                    {
                        name = a.Name;
                    }

                    string valueType = pi.PropertyType.FullName;
                    object value = GetPropertyValue<T>(t, pi.Name, obj);
                    if (StringUtil.IsNullOrEmpty(value)) continue;

                    if (valueType == "System.String")
                    {
                        if (sb.Length > 0)
                        {
                            sb.Append(" AND ");
                        }

                        sb.Append(name);
                        sb.Append("=");
                        sb.Append(value);
              
                    }

                }

                return sb.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public static string ConvertObjectToFuzzyQueryWhereSqls<T>(T obj,List<string> properties)
        {
            try
            {
                StringBuilder sb = new StringBuilder();

                Type t = typeof(T);
                foreach(string pn in properties){
                    PropertyInfo pi=t.GetProperty(pn);

                    string name = "";

                    foreach (ColumnAttribute a in pi.GetCustomAttributes(typeof(ColumnAttribute), false))
                    {
                        name = a.Name;
                    }

                    string valueType = pi.PropertyType.FullName;
                    object value = GetPropertyValue<T>(t, pi.Name, obj);
                    if (StringUtil.IsNullOrEmpty(value)) continue;

                    if (valueType == "System.String")
                    {
                        if (sb.Length > 0)
                        {
                            sb.Append(" AND ");
                        }

                        sb.Append(name);
                        sb.Append(" LIKE ");
                        sb.Append("'%");
                        sb.Append(value);
                        sb.Append("%'");
                    }

                }
    
                return sb.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 创建模糊查询的whereSql，但是不带WHERE 关键字,并且开头也不带AND 
        /// 约束：字段只能为string
        /// 最后创建为 AND AA like ‘%value%’OR  BB
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        public static string ConvertObjectToFuzzyQueryWhereSqls<T>(T obj)
        {
            try
            {
                StringBuilder sb = new StringBuilder();
             
                Type t = typeof(T);
                PropertyInfo[] propertis = t.GetProperties();
                foreach (PropertyInfo pi in propertis)
                {
                    string name = "";

                    foreach (ColumnAttribute a in pi.GetCustomAttributes(typeof(ColumnAttribute), false))
                    {
                        name = a.Name;
                    }

                    string valueType = pi.PropertyType.FullName;
                    object value = GetPropertyValue<T>(t, pi.Name, obj);
                    if (StringUtil.IsNullOrEmpty(value)) continue;
                    
                    if (valueType == "System.String")
                    {
                       if (sb.Length > 0)
                    {
                        sb.Append(" AND ");
                    }

                    sb.Append(name);
                        sb.Append(" LIKE ");
                        sb.Append("'%");
                        sb.Append(value);
                        sb.Append("%'");
                    }
                   

                }
                return sb.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        /// <summary>
        /// 获取对象的值
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="t"></param>
        /// <param name="propertyName"></param>
        /// <param name="obj"></param>
        /// <returns></returns>
        public static string GetPropertyValue<T>(Type t, string propertyName, T obj)
        {
            try
            {
                PropertyInfo pi = t.GetProperty(propertyName);
                if (pi == null) return "";
                return Convert.ToString( pi.GetValue(obj, null));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static bool GetFieldValue<T>(Type t, string fieldName, T obj)
        {
            try
            {
                FieldInfo fi = t.GetField(fieldName);
                if (fi == null) return false;
                if (fi.GetValue(obj) == null) return false;
                return Convert.ToBoolean(fi.GetValue(obj));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static object GetFieldValueObj<T>(Type t, string fieldName, T obj)
        {
            try
            {
                FieldInfo fi = t.GetField(fieldName);
                if (fi == null) return false;
                if (fi.GetValue(obj) == null) return false;
                return fi.GetValue(obj);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static void FindChildren<T>(List<T> tList, TreeNode parentT, string idField, string textField, string parentField, Type t, string codeField="")
        {
            try{
                foreach (T obj in tList)
                {
                    string parentId = parentT.id;
                    string id = GetPropertyValue<T>(t, parentField, obj);
                    if (id == parentId)
                    {
                        TreeNode tn = new TreeNode();
                        tn.id = GetPropertyValue<T>(t, idField, obj);
                        tn.text = GetPropertyValue<T>(t, textField, obj);
                        tn.isOrNotChecked = GetFieldValue<T>(t, "isOrNotChecked", obj);
                        if (!StringUtil.IsNullOrEmpty(codeField))
                        {
                            tn.code = GetPropertyValue<T>(t, codeField, obj);
                        }
                        parentT.children.Add(tn);
                        parentT.state = "closed";
                        FindChildren<T>(tList, tn, idField, textField, parentField, t, codeField);
                    }
                    
                }
            }catch(Exception ex){
               throw ex;
            }

        }
        /// <summary>
        /// 查找子节点的数量
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="tList"></param>
        /// <param name="parentField"></param>
        /// <param name="idField"></param>
        /// <param name="t"></param>
        /// <returns></returns>
        public static int FindParent<T>(List<T> tList, string parentField,string idField, Type t,string parentValue)
        {
            try
            {
                int result = 0;
                if(StringUtil.IsNullOrEmpty(parentField))return 0;
                foreach (T obj in tList)
                {
                    string id = GetPropertyValue<T>(t, idField, obj);
                    if (id == parentValue)
                    {
                        result++;
                    }
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 拷贝数据
        /// </summary>
        /// <param name="from"></param>
        /// <param name="to"></param>
        public static void CopyBeanToBean(object from, object to)
        {
            try
            {
                if (from == null || to == null) return;
                Type fromType = from.GetType();
                Type toType = to.GetType();
                FieldInfo[] fis = fromType.GetFields();
                foreach (FieldInfo fi in fis)
                {
                    FieldInfo tfi = toType.GetField(fi.Name);
                    if (tfi != null && fi.FieldType == tfi.FieldType &&fi.GetValue(from)!=null&&  fi.GetValue(from)!=tfi.GetValue(to))
                    {
                        tfi.SetValue(to, fi.GetValue(from));
                    }
                }

                PropertyInfo[] pis = fromType.GetProperties();
                foreach (PropertyInfo pi in pis)
                {
                    PropertyInfo tpi = toType.GetProperty(pi.Name);
                    if (tpi != null && pi.PropertyType == tpi.PropertyType &&pi.GetValue(from,null)!=null&& tpi.GetValue(to,null)!=pi.GetValue(from,null))
                    {
                        tpi.SetValue(to, pi.GetValue(from,null),null);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 将对象列表转换为
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="beans"></param>
        /// <param name="dataTable"></param>
        /// <param name="parameters"></param>
        public static void ConvertListTtypeToDataTable<T>(List<T> beans, DataTable dataTable, List<DbParameter> parameters)
        {
            try
            {
                Type t = typeof(T);
                PropertyInfo[] pis = t.GetProperties();
                int i = 0;
                foreach (PropertyInfo pi in pis)
                {
                    DataColumn dc = new DataColumn();                    
                   

                    DbParameter parameter = parameters[i];
                   
                   
                    foreach (ColumnAttribute a in pi.GetCustomAttributes(typeof(ColumnAttribute), false))
                    {
                        parameter.SourceColumn = a.Name;
                        dc.ColumnName = a.Name;
                        parameter.ParameterName = a.Name;
                    }

                    string valueType = pi.PropertyType.FullName;
                    if (valueType == "System.String")
                    {
                        dc.DataType = Type.GetType("System.String");
                        parameter.DbType = DbType.String;
                    }
                    else if (valueType == "System.Decimal")
                    {
                        dc.DataType = Type.GetType("System.Decimal");
                        parameter.DbType = DbType.Decimal;
                    }
                    else if (valueType == "System.Int32")
                    {
                        dc.DataType = Type.GetType("System.Int32");
                        parameter.DbType = DbType.Int32;
                    }
                    else if (valueType == "System.Int64")
                    {
                        dc.DataType = Type.GetType("System.Int64");
                        parameter.DbType = DbType.Int64;
                    }
                    dataTable.Columns.Add(dc);
                    i++;                      
                }
               //创建DataTable
                foreach (T bean in beans)
                {
                    DataRow dr = dataTable.NewRow();
                    foreach (PropertyInfo pi in pis)
                    {
                        foreach (ColumnAttribute a in pi.GetCustomAttributes(typeof(ColumnAttribute), false))
                        {
                            string columnName = a.Name;
                            dr[columnName] = pi.GetValue(bean, null);
                        }
                       
                    }
                    dataTable.Rows.Add(dr);
                }



            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
     
        /// <summary>
        /// 将对象转换为插入语句
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        public static string ConvertBeanToInsertCommandSql<T>()
        {
            try
            {
                StringBuilder sb = new StringBuilder();
                StringBuilder sbv=new StringBuilder();
                sb.Append(" INSERT INTO  ");
                sbv.Append(" VALUES (");

                Type t = typeof(T);
                TableAttribute[] ts = (TableAttribute[])t.GetCustomAttributes(typeof(TableAttribute), false);
                string tableName = ts[0].Name;
                sb.Append(tableName);
                sb.Append("(");
                PropertyInfo[] propertis = t.GetProperties();
                int i = 0;
                foreach (PropertyInfo pi in propertis)
                {
                   
                    sbv.Append("'{"+i.ToString()+"}'");
                    sbv.Append(",");
                    foreach (ColumnAttribute a in pi.GetCustomAttributes(typeof(ColumnAttribute), false))
                    {
                        sb.Append(a.Name);
                        sb.Append(",");
                    }
                    i++;
                }
                sb.Length--;
                sbv.Length--;
                sb.Append(")");
                sbv.Append(")");
                return sb.ToString() + sbv.ToString();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 将对象转换为插入语句
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        public static string ConvertBeanToInsertCommandSql<T>(T obj)
        {
            try
            {
                StringBuilder sb = new StringBuilder();
                StringBuilder sbv = new StringBuilder();
                sb.Append(" INSERT INTO  ");
                sbv.Append(" VALUES (");

                Type t = typeof(T);
                TableAttribute[] ts = (TableAttribute[])t.GetCustomAttributes(typeof(TableAttribute), false);
                string tableName = ts[0].Name;
                sb.Append(tableName);
                sb.Append("(");
                PropertyInfo[] propertis = t.GetProperties();
                int i = 0;
                foreach (PropertyInfo pi in propertis)
                {

                   
                    foreach (ColumnAttribute a in pi.GetCustomAttributes(typeof(ColumnAttribute), false))
                    {
                        
                        

                        string valueType = pi.PropertyType.FullName;
                        object value = GetPropertyValue<T>(t, pi.Name, obj);
                        if (StringUtil.IsNullOrEmpty(value)) continue;
                        //增加参数
                        sb.Append(a.Name);
                        sb.Append(",");

                        //增加参数值
                        if (valueType == "System.String")
                        {

                            sbv.Append("'");
                            sbv.Append(value);
                            sbv.Append("'");
                        }
                        else if (valueType == "System.Decimal")
                        {
                            sbv.Append(value);
                        }
                        else if (valueType == "System.Int32")
                        {
                            sbv.Append(value);
                        }
                        else if (valueType == "System.Int64")
                        {
                            sbv.Append(value);
                        }
                        sbv.Append(",");
                    }
                    i++;
                }
                sb.Length--;
                sbv.Length--;
                sb.Append(")");
                sbv.Append(")");
                return sb.ToString() + sbv.ToString();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 如果T的属性为ID，则可以采用此方法形成INSQL
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="objs"></param>
        /// <param name="propertyName"></param>
        /// <returns></returns>
        public static string ConvertListObjectsToInSql<T>(List<T> objs, string propertyName)
        {
            try
            {
                StringBuilder sb = new StringBuilder();
                Type t = typeof(T);
                sb.Append(propertyName);
                sb.Append(" IN (");
                foreach (T obj in objs)
                {
                    if (!StringUtil.IsNullOrEmpty(t.GetProperty("Id")))
                    {
                        sb.Append("'");
                        sb.Append(GetPropertyValue<T>(t,"Id",obj));
                        sb.Append("'");
                        sb.Append(",");
                    }
                }
                if (sb.Length > 0) sb.Length--;
                sb.Append(")");
                return sb.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

      
      
        
    }
}
