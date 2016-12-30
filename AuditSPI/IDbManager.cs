using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Common;
using System.Data;

namespace AuditSPI
{
  public   interface IDbManager
    {
      /// <summary>
      /// 获取链接类型
      /// </summary>
      /// <returns></returns>
      DbConnection GetDbConnection();
      /// <summary>
      /// 获取数据库类型
      /// </summary>
      /// <returns></returns>
      CTDbType GetDbType();
      DbCommand getDbCommand();
      DbParameter GetDbParameter();
      List<DbParameter> GetDbParameters(int count);

      /// <summary>
      /// 关闭连接对象
      /// </summary>
      void Open();
      /// <summary>
      /// 关闭链接对象
      /// </summary>
      void Close();
     /// <summary>
     /// 执行SQL
     /// </summary>
     /// <param name="sql"></param>
      void ExecuteSql(string sql);
      /// <summary>
      /// sql中的参数统一采用?的形式；
      /// 根据具体的数据库类型进行参数的替换
      /// </summary>
      /// <param name="sql"></param>
      /// <param name="parameters"></param>
      void ExecuteSql(string sql, List<DbParameter> parameters);

      /// <summary>
      /// 获取DataReader
      /// </summary>
      /// <param name="sql"></param>
      /// <returns></returns>
      DbDataReader ExecuteSqlReturnDataReader(string sql);
      /// <summary>
      /// 获取DataReader对象，方便获取大数据对象
      /// </summary>
      /// <param name="sql"></param>
      /// <param name="parameters"></param>
      /// <returns></returns>
      DbDataReader ExecuteSqlReturnDataReader(string sql, List<DbParameter> parameters);
      /// <summary>
      /// 获取Table对象
      /// </summary>
      /// <param name="sql"></param>
      /// <returns></returns>
      DataTable ExecuteSqlReturnDataTable(string sql);
      DataTable ExecuteProcedureDataTable(string procedureName, List<DbParameter> parameters);
      DataTable ExecuteSqlReturnDataTable(string sql, List<DbParameter> parameters);
      /// <summary>
      /// 返回数据对象列表
      /// </summary>
      /// <typeparam name="T"></typeparam>
      /// <param name="sql"></param>
      /// <param name="maps"></param>
      /// <returns></returns>
      List<T> ExecuteSqlReturnTType<T>(string sql);
      List<T> ExecuteSqlReturnTType<T>(string sql, List<DbParameter> parameters);
      List<T> ExecuteSqlReturnTType<T>(string sql, List<DbParameter> parameters, Dictionary<string, string> maps);
      List<T> ExecuteSqlReturnTType<T>(string sql, Dictionary<string, string> maps);
      List<T> ExecuteSqlReturnTTypeByFields<T>(string sql, Dictionary<string, string> maps);
      /// <summary>
      /// 更新数据对象函数
      /// </summary>
      /// <param name="dataTable"></param>
      /// <param name="sql"></param>
      /// <param name="updateType"></param>
      void BatchUpdateData(DataTable dataTable, string sql, UpdateType updateType, List<DbParameter> parameters);
      //void UpdateData<T>(string sql, List<T> objs,List<DbParameter> parameters);
      //void UpdateData(string sql, DataTable dt, List<DbParameter> parameters);

      /// <summary>
      /// 分页返回数据对象
      /// </summary>
      /// <typeparam name="T"></typeparam>
      /// <param name="sql"></param>
      /// <param name="dataGrid"></param>
      /// <param name="maps"></param>
      /// <returns></returns>
      List<T> ExecuteSqlReturnTType<T>(string sql, int pageIndex, int pageNumber, string sortOrder, Dictionary<string, string> maps);
      /// <summary>
      /// 返回聚合数据
      /// </summary>
      /// <param name="sql"></param>
      /// <returns></returns>
      int Count(string sql);
      /// <summary>
      /// 获取通用字符串截取函数
      /// </summary>
      /// <param name="field"></param>
      /// <param name="start"></param>
      /// <param name="length"></param>
      /// <returns></returns>
      string GetSubSql(string field, int start, int length);
      string GetSubSql(string field, int start);
      /// <summary>
      /// 获取通用字符串连接函数
      /// </summary>
      /// <returns></returns>
      string Join();
      /// <summary>
      /// 根据对象创建插入语句
      /// </summary>
      /// <typeparam name="T"></typeparam>
      /// <param name="obj"></param>
      /// <param name="parameters"></param>
      /// <returns></returns>
       string ConvertBeanToInsertCommandSql<T>(T obj, List<DbParameter> parameters);
      /// <summary>
      /// 根据某个字段创建删除SQL语句
      /// </summary>
      /// <typeparam name="T"></typeparam>
      /// <param name="obj"></param>
      /// <param name="field"></param>
      /// <param name="parameter"></param>
      /// <returns></returns>
       string ConvertBeanToDeleteCommandSql<T>(T obj, string field, DbParameter parameter);
    }
    /// <summary>
    /// 更新类型
    /// </summary>
   public  enum UpdateType{
        INSERTCOMMAND,
        UPDATECOMMAND,
        DELETECOMMAND
    }
    /// <summary>
    /// 数据库链接类型
    /// </summary>
  public   enum CTDbType
    {
        SQLSERVER,
        ORACLE,
        OLEDB,
        ODBC
    }
}
