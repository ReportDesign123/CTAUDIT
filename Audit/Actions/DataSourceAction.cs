using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using AuditSPI;
using AuditService;
using AuditEntity;
using CtTool;

namespace Audit.Actions
{
    public class DataSourceAction:BaseAction
    {
        IDataSource ds;
        public DataSourceAction()
        {
            ds = new DataSourceService();
        }
        public override void GoToMethod(string methodName)
        {
            switch (methodName)
            {
                case "SetDefault":
                case "Save":
                case "Edit":
                case "Delete":
                case "DataSourceInstances":
                case "TestDataSource":
                    DataSourceEntity dse = ActionTool.DeserializeParameters<DataSourceEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<DataSourceAction>(this, methodName, dse);
                    break;
                case "DataGrid":
                    DataGrid<DataSourceEntity> dg = ActionTool.DeserializeParametersByFields<DataGrid<DataSourceEntity>>(context, actionType);
                    DataSourceEntity temp = ActionTool.DeserializeParameters<DataSourceEntity>(context, actionType);
                    DataGrid(dg, temp);
                    break;
            }
        }
        /// <summary>
        /// 保存数据源
        /// </summary>
        /// <param name="dse"></param>
        public void Save(DataSourceEntity dse)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                ds.Save(dse);
                js.success = true;
                js.sMeg = "保存成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 修改数据源
        /// </summary>
        /// <param name="dse"></param>
        public void Edit(DataSourceEntity dse)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                ds.Edit(dse);
                js.success = true;
                js.sMeg = "修改成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }

        /// <summary>
        /// 删除数据源
        /// </summary>
        /// <param name="dse"></param>
        public void Delete(DataSourceEntity dse)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                ds.Delete(dse);
                js.success = true;
                js.sMeg = "删除成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 获取数据源列表
        /// </summary>
        /// <param name="dg"></param>
        /// <param name="dse"></param>
        public void DataGrid(DataGrid<DataSourceEntity> dg, DataSourceEntity dse)
        {
         
            try
            {
                DataGrid<DataSourceEntity> tdg = ds.DataGrid(dg, dse);
                JsonTool.WriteJson<DataGrid<DataSourceEntity>>(tdg, context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                
            }        
        }
        /// <summary>
        /// 获取服务器的所有数据库实例
        /// </summary>
        /// <param name="dse"></param>
        public void DataSourceInstances(DataSourceEntity dse)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                List<NameValueStruct> tdg = ds.DataSourceInstances(dse);
                js.obj = tdg;
                js.success = true;
                
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = "获取失败";

            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 测试数据库实例是否通
        /// </summary>
        /// <param name="dse"></param>
        public void TestDataSource(DataSourceEntity dse)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                ds.TestDataSource(dse);
                js.success = true;
                js.sMeg = "测试成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }

        public void SetDefault(DataSourceEntity dse)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                ds.SetDefault(dse);
                js.success = true;
                js.sMeg = "设置完成！";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        
    }
}