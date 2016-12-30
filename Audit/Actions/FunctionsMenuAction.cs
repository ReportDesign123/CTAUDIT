using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using AuditEntity;
using AuditSPI;
using AuditService;
using CtTool;
using GlobalConst;

namespace Audit.Actions
{
    public class FunctionsMenuAction :BaseAction
    {
        public IFunctionService functionService;
        public FunctionsMenuAction()
        {
            functionService = new FunctionService();

        }
        #region 功能菜单对外接口
        /// <summary>
        /// 获取功能菜单
        /// </summary>
        public void getFunctions(FunctionEntity function)
        {
            try
            {
                List<FunctionEntity> entities = functionService.getFunctions(function);
                JsonTool.WriteJson<List<FunctionEntity>>(entities, context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace.ToString());
            }
        }
        /// <summary>
        /// 获取功能菜单上级
        /// </summary>
        public void comboParent()
        {
            try
            {
                List<TreeNode> nodes = functionService.ParentCombo();
                JsonTool.WriteJson<List<TreeNode>>(nodes, context);

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 保存菜单
        /// </summary>
        /// <param name="function"></param>
        public void Save(FunctionEntity function)
        {
            JsonStruct js = new JsonStruct();
            try
            {             
                functionService.Save(function);
                js.success = true;
                js.sMeg = "保存成功";
            }
            catch (Exception ex)
            {
                js.sMeg = ex.StackTrace;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 更新功能菜单
        /// </summary>
        /// <param name="function"></param>
        public void Update(FunctionEntity function)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                functionService.Update(function);
                js.success = true;
                js.sMeg = "修改成功";
            }
            catch (Exception ex)
            {
                js.sMeg = ex.StackTrace;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }

        public void Delete(string Id)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                functionService.Delete(Id);
                js.success = true;
                js.sMeg = "删除成功";
            }
            catch (Exception ex)
            {
                js.sMeg = ex.StackTrace;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        #endregion
        #region Action入口方法
        /// <summary>
        /// 跳转到具体的方法
        /// </summary>
        /// <param name="methodName"></param>
        public  override void GoToMethod(string methodName)
        {
            switch (methodName)
            {
                    //获取功能菜单菜单
                case "getFunctions":
                    FunctionEntity fe = new FunctionEntity();
                    fe = ActionTool.DeserializeParameters<FunctionEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<FunctionsMenuAction>(this, methodName, fe);
                    break;
                    //获取父级
                case "comboParent":
                    ActionTool.InvokeObjMethod<FunctionsMenuAction>(this, methodName, null);
                    break;
                case "Save":
                    FunctionEntity fes = new FunctionEntity();
                    fes = ActionTool.DeserializeParameters<FunctionEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<FunctionsMenuAction>(this, methodName, fes);
                    break;
                case "Update":
                    FunctionEntity feu = new FunctionEntity();
                    feu = ActionTool.DeserializeParameters<FunctionEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<FunctionsMenuAction>(this, methodName, feu);
                    break;
                case "Delete":
                    List<string> pas=new List<string>();
                    pas.Add("Id");
                    object[] objs = ActionTool.DeserializeParameters(pas, context, BasicGlobalConst.POSTTYPE_POST);
                    ActionTool.InvokeObjMethod<FunctionsMenuAction>(this, methodName, objs);
                    break;
                

            }
        }
        #endregion

    }
}