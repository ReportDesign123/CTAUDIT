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
    public class DicAction :BaseAction 
    {
        IDictionaryService dicService;
        public DicAction()
        {
            dicService = new DictionaryService();
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
                case "GetDicClassifyList":
                    DataGrid<DictionaryClassificationEntity> dg = new DataGrid<DictionaryClassificationEntity>();
                    dg = ActionTool.DeserializeParametersByFields<DataGrid<DictionaryClassificationEntity>>(context, actionType);
                    ActionTool.InvokeObjMethod<DicAction>(this, methodName, dg);
                    break;
               
                case "GetDictionaryList":
                    DataGrid<DictionaryEntity> dg2 = new DataGrid<DictionaryEntity>();
                    dg2 = ActionTool.DeserializeParametersByFields<DataGrid<DictionaryEntity>>(context, actionType);

                    DictionaryEntity deg = ActionTool.DeserializeParameters<DictionaryEntity>(context, actionType);
                    GetDictionaryList(dg2, deg);
                    break;
                case "SaveDictionaryClassify":
                case "UpdateDictionaryClassify":
                case "DeleteDictionaryClassify":
                case "GetDictionaryClassify":
                
                    DictionaryClassificationEntity dce = ActionTool.DeserializeParameters<DictionaryClassificationEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<DicAction>(this, methodName, dce);
                    break;
                case "SaveDictionary":
                case "UpdateDictionary":
                case "DeleteDictionary":
                case "GetDictionary":
                    DictionaryEntity de = ActionTool.DeserializeParameters<DictionaryEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<DicAction>(this, methodName, de);
                    break;
                case "GetDicClassifyCombo":
                    ActionTool.InvokeObjMethod<DicAction>(this, methodName, null);
                    break;
                case "GetDictionaryListByClass":
                      DataGrid<DictionaryEntity> dg3 = new DataGrid<DictionaryEntity>();
                    dg3 = ActionTool.DeserializeParametersByFields<DataGrid<DictionaryEntity>>(context, actionType);
                    dce = ActionTool.DeserializeParameters<DictionaryClassificationEntity>(context, actionType);
                    string classId = Convert.ToString(ActionTool.DeserializeParameter("classId", context));
                   // string Name = Convert.ToString(ActionTool.DeserializeParameter("Name",context));
                    GetDictionaryListByClass(dg3,classId, dce);
                    break;
                case "GetDictionaryListByClassType":
                    List<string> paraNames=new List<string>();
                    paraNames.Add("ClassType");
                    object[] objs = ActionTool.DeserializeParameters(paraNames, context, actionType);
                    ActionTool.InvokeObjMethod<DicAction>(this, methodName, objs);
                    break;
                case "GetDictionaryDataGridByClassType":
                    DataGrid<DictionaryEntity> dg4 = new DataGrid<DictionaryEntity>();
                    dg4 = ActionTool.DeserializeParametersByFields<DataGrid<DictionaryEntity>>(context, actionType);
                    List<string> paras2=new List<string>();
                    paras2.Add("ClassType");
                    string classType = Convert.ToString( ActionTool.DeserializeParameters(paras2, context, actionType)[0]);
                    de = ActionTool.DeserializeParameters<DictionaryEntity>(context, actionType);
                    GetDictionaryDataGridByClassType(classType, dg4,de);
                    break;
                case "GetDicClassifyDataGridFilter":
                    dg = ActionTool.DeserializeParametersByFields<DataGrid<DictionaryClassificationEntity>>(context, actionType);
                    dce = ActionTool.DeserializeParameters<DictionaryClassificationEntity>(context, actionType);
                    GetDicClassifyDataGridFilter(dg, dce);
                    break;


            }
        }
        public void GetDicClassifyCombo()
        {
            try
            {
                JsonTool.WriteJson<List<DictionaryClassificationEntity>>(dicService.GetDicClassifyCombo(), context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
        public void SaveDictionaryClassify(AuditEntity.DictionaryClassificationEntity dce)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                if (StringUtil.IsNullOrEmpty(dce.Id))
                {
                    dce.Id = Guid.NewGuid().ToString();
                }
                dicService.SaveDictionaryClassify(dce);
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

        public void SaveDictionary(AuditEntity.DictionaryEntity de)
        {
              JsonStruct js = new JsonStruct();
            try
            {
                if (StringUtil.IsNullOrEmpty(de.Id))
                {
                    de.Id = Guid.NewGuid().ToString();
                }
                dicService.SaveDictionary(de);
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

        public void UpdateDictionaryClassify(AuditEntity.DictionaryClassificationEntity dce)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                dicService.UpdateDictionaryClassify(dce);
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

        public void UpdateDictionary(AuditEntity.DictionaryEntity de)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                dicService.UpdateDictionary(de);
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

        public void DeleteDictionaryClassify(AuditEntity.DictionaryClassificationEntity dce)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                dicService.DeleteDictionaryClassify(dce);
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

        public void DeleteDictionary(AuditEntity.DictionaryEntity de)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                dicService.DeleteDictionary(de);
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



        public DictionaryClassificationEntity GetDictionaryClassify(DictionaryClassificationEntity dce)
        {
            try
            {
                return dicService.GetDictionaryClassify(dce);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DictionaryEntity GetDictionary(DictionaryEntity de)
        {
            try
            {
                return dicService.GetDictionary(de);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void GetDicClassifyList(DataGrid<DictionaryClassificationEntity> dg)
        {
            try
            {

                DataGrid<DictionaryClassificationEntity> dataGrid = dicService.GetDicClassifyList(dg);
                JsonTool.WriteJson<DataGrid<DictionaryClassificationEntity>>(dataGrid, context);  
             
              
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void GetDicClassifyDataGridFilter(DataGrid<DictionaryClassificationEntity> dg,DictionaryClassificationEntity dce)
        {
            try
            {

                DataGrid<DictionaryClassificationEntity> dataGrid = dicService.GetDicClasifyList(dg, dce);
                JsonTool.WriteJson<DataGrid<DictionaryClassificationEntity>>(dataGrid, context);


            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

      public  void GetDictionaryList(DataGrid<DictionaryEntity> dg,DictionaryEntity de)
        {
            try
            {
                DataGrid<DictionaryEntity> dataGrid = dicService.GetDictionaryList(dg,de);
                JsonTool.WriteJson<DataGrid<DictionaryEntity>>(dataGrid, context);  
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 获取特定分类的帮助
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="classid"></param>
      public void GetDictionaryListByClass(DataGrid<DictionaryEntity> dataGrid,string classid, DictionaryClassificationEntity dce)
      {
          try
          {
              DataGrid<DictionaryEntity> dgs = dicService.GetDictionaryListByClass(dataGrid,classid, dce);
              JsonTool.WriteJson<DataGrid<DictionaryEntity>>(dgs,context);
          }
          catch (Exception ex)
          {
              LogManager.WriteLog(ex.Message);
          }
      }

      public void GetDictionaryListByClassType(string classType)
      {
          try
          {
              JsonTool.WriteJson < List<DictionaryEntity>>(dicService.GetDictionaryListByClassType(classType), context);
          }
          catch (Exception ex)
          {
              LogManager.WriteLog(ex.Message);
          }
      }

      public void GetDictionaryDataGridByClassType(string classType, DataGrid<DictionaryEntity> dataGrid,DictionaryEntity de)
      {
          try
          {
              DataGrid<DictionaryEntity> dgs = dicService.GetDictionaryDataGridByClassType(classType, dataGrid,de);
              JsonTool.WriteJson<DataGrid<DictionaryEntity>>(dgs, context);
          }
          catch (Exception ex)
          {
              LogManager.WriteLog(ex.Message);
          }
      }



    }

}