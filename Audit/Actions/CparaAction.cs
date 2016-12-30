using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using AuditEntity;
using AuditSPI;
using CtTool;
using AuditService;

namespace Audit.Actions
{
    public class CparaAction :BaseAction
    {
        public ICpara cparaService;
        public IFunctionService functionService;
        public CparaAction()
        {
            cparaService = new CparaService(); 
            functionService = new FunctionService();
        }
        /// <summary>
        /// 获取数据对象列表
        /// </summary>
        /// <param name="dataGrid"></param>
        public void DataGrid(DataGrid<CparaEntity> dataGrid, CparaEntity re)
        {
            try
            {
                DataGrid<CparaEntity> dg = cparaService.GetDataGrid(dataGrid, re);
                JsonTool.WriteJson<DataGrid<CparaEntity>>(dg, context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
        public void GetParaList()
        {
            try
            {
                JsonTool.WriteJson<List<CparaEntity>>(cparaService.GetList(), context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);

            }
        }
        public void Save(CparaEntity cparaEntity)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                cparaService.Save(cparaEntity);
                js.success = true;
                js.sMeg = "保存成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.StackTrace;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }

        public void Edit(CparaEntity cparaEntity)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                cparaService.Edit(cparaEntity);
                js.success = true;
                js.sMeg = "修改成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.StackTrace;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }

        public void Delete(CparaEntity cparaEntity)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                cparaService.Delete(cparaEntity);
                js.success = true;
                js.sMeg = "删除成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.StackTrace;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }

       
        /// <summary>
        /// 中控器
        /// </summary>
        /// <param name="methodName"></param>
        public override void GoToMethod(string methodName)
        {
            switch (methodName)
            {
                //获取功能菜单菜单
                case "DataGrid":
                    DataGrid<CparaEntity> dg = new DataGrid<CparaEntity>();
                    dg = ActionTool.DeserializeParametersByFields<DataGrid<CparaEntity>>(context, actionType);
                    CparaEntity re = ActionTool.DeserializeParameters<CparaEntity>(context, actionType);
                    DataGrid(dg, re);
                    break;
                case "Save":
                case "Edit":
                case "Delete":
                case "GetCparaFunctions":
                    CparaEntity re1 = ActionTool.DeserializeParameters<CparaEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<CparaAction>(this, methodName, re1);
                    break;
                case "GetParaList":
                    ActionTool.InvokeObjMethod<CparaAction>(this, methodName, null);
                    break;
            }
        }
    }
}