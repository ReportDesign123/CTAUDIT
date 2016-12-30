using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using AuditService.BackUpService;
using AuditSPI.BackUp;
using CtTool;
using AuditSPI;
using AuditEntity.BackUp;

namespace Audit.Actions
{
    public class BackUpAction:BaseAction
    {
        IBackUp backUpService;
        public BackUpAction()
        {
            if (backUpService == null)
            {
                backUpService = new AuditService.BackUpService.BackUp();
            }
        }
        public override void GoToMethod(string methodName)
        {
            switch (methodName) { 
                case "GetBackUpDataGrid":
                    DataGrid<BackUpEntity> dg = ActionTool.DeserializeParametersByFields<DataGrid<BackUpEntity>>(context, actionType);
                    BackUpEntity bp = ActionTool.DeserializeParameters<BackUpEntity>(context, actionType);
                    GetBackUpDataGrid(dg, bp);
                    break;
                case "BackUp":
                    ActionTool.InvokeObjMethod<BackUpAction>(this, methodName, null);
                    break;
                case "RestoreData":
                    string fileName = Convert.ToString(ActionTool.DeserializeParameter("fileName", context));
                    ActionTool.InvokeObjMethod<BackUpAction>(this, methodName, fileName);
                    break;
            }
        }
        /// <summary>
        /// 获取已备份列表
        /// </summary>
        /// <param name="dg"></param>
        /// <param name="bp"></param>
        public void GetBackUpDataGrid(DataGrid<BackUpEntity> dg, BackUpEntity bp)
        {
            try {
                JsonTool.WriteJson<DataGrid<BackUpEntity>>(backUpService.GetBackUpDataGrid(dg, bp), context);
            
            }catch(Exception ex){
                LogManager.WriteLog(ex.Message);
            }
        
        }
        /// <summary>
        /// 备份
        /// </summary>
        public void BackUp()
        {
            JsonStruct js = new JsonStruct();
            try
            {
                backUpService.BackUp();
                js.sMeg = "备份成功";
                js.success = true;
            }
            catch (Exception ex) {
                LogManager.WriteLog(ex.Message);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        public void RestoreData(string fileName) {
            JsonStruct js = new JsonStruct();
            try
            {
                backUpService.RestoreData(fileName);
            }
            catch (Exception ex) {
                LogManager.WriteLog(ex.Message);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        
        }
    }
}