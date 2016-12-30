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
    public class RoleAction :BaseAction
    {
        public IRole roleService;
        public IFunctionService functionService;
        public RoleAction()
        {
            roleService = new RoleService();
            functionService = new FunctionService();
        }
        /// <summary>
        /// 获取数据对象列表
        /// </summary>
        /// <param name="dataGrid"></param>
        public void DataGrid(DataGrid<RoleEntity> dataGrid,RoleEntity re )
        {
            try
            {
                DataGrid<RoleEntity> dg = roleService.GetDataGrid(dataGrid, re);
                JsonTool.WriteJson<DataGrid<RoleEntity>>(dg,context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }

        public void Save(RoleEntity roleEntity)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                roleService.Save(roleEntity);
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

        public void Edit(RoleEntity roleEndity)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                roleService.Edit(roleEndity);
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

        public void Delete(RoleEntity roleEntity)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                roleService.Delete(roleEntity);
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

        public void GetRoleFunctions(RoleEntity roleEntity)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                List<TreeNode> nodes = functionService.AuthorityParentCombo(roleEntity.Id);
                js.obj = nodes;
                js.success = true;
                js.sMeg = "删除成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }

        public void BatchUpdate(List<RoleAndFunctionsEntity> roleEntities)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                roleService.BatchUpdate(roleEntities);
                js.success = true;
                js.sMeg = "权限保存成功";
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
                    DataGrid<RoleEntity> dg = new DataGrid<RoleEntity>();
                    dg = ActionTool.DeserializeParametersByFields<DataGrid<RoleEntity>>(context, actionType);
                    RoleEntity re = ActionTool.DeserializeParameters<RoleEntity>(context, actionType);
                    DataGrid(dg, re);
                    break;
                case "Save":
                case "Edit":
                case "Delete":
                case "GetRoleFunctions":
                    re = ActionTool.DeserializeParameters<RoleEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<RoleAction>(this, methodName, re);
                    break;
                case "BatchUpdate":
                    string rows = ActionTool.DeserializeParameter("rows", context).ToString();

                   List<RoleAndFunctionsEntity> res =JsonTool.DeserializeObject<List<RoleAndFunctionsEntity>>(rows);
                    ActionTool.InvokeObjMethod<RoleAction>(this, methodName, res);
                    break;
              
                  
            }
        }
    }
}