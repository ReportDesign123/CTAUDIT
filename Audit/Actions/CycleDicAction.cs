using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using GlobalConst;

using AuditSPI;
using AuditService;
using AuditEntity;
using CtTool;

namespace Audit.Actions
{
    public class CycleDicAction :BaseAction 
    {
        ICycleService dicService;
        public CycleDicAction()
        {
            dicService = new CycleService();
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
             
                case "GetCycleList":
                    DataGrid<CycleEntity> dg2 = new DataGrid<CycleEntity>();
                    dg2 = ActionTool.DeserializeParametersByFields<DataGrid<CycleEntity>>(context, actionType);

                    CycleEntity deg = ActionTool.DeserializeParameters<CycleEntity>(context, actionType);
                    GetCycleList(dg2, deg);
                    break;
                case "SaveCycle":
                case "UpdateCycle":
                case "DeleteCycle":
                case "GetCycle":
                    CycleEntity de = ActionTool.DeserializeParameters<CycleEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<CycleDicAction>(this, methodName, de);
                    break;
                case "GetCycleInfor":
                    List<string> pa = new List<string>();
                    pa.Add("YWRQ");
                    object[] obj = ActionTool.DeserializeParameters(pa, context, BasicGlobalConst.POSTTYPE_POST);
                    ActionTool.InvokeObjMethod<CycleDicAction>(this, methodName, obj);
                    break;
            }
        }
     
       
        public void SaveCycle(AuditEntity.CycleEntity de)
        {
              JsonStruct js = new JsonStruct();
            try
            {
                if (StringUtil.IsNullOrEmpty(de.Id))
                {
                    de.Id = Guid.NewGuid().ToString();
                }
                dicService.SaveCycle(de);
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

       
        public void UpdateCycle(AuditEntity.CycleEntity de)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                dicService.UpdateCycle(de);
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

      
        public void DeleteCycle(AuditEntity.CycleEntity de)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                dicService.DeleteCycle(de);
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




        public CycleEntity GetDictionary(CycleEntity de)
        {
            try
            {
                return dicService.GetCycle(de);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }




        public void GetCycleList(DataGrid<CycleEntity> dg, CycleEntity de)
        {
            try
            {
                DataGrid<CycleEntity> dataGrid = dicService.GetCycleList(dg,de);
                JsonTool.WriteJson<DataGrid<CycleEntity>>(dataGrid, context);  
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public void GetCycleInfor(string YWRQ)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                CycleEntity rfde = dicService.GetCycleInfor(YWRQ);
                js.obj = rfde;
                js.success = true;
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