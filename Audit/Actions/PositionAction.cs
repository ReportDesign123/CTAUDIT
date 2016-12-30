using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using AuditSPI;
using AuditEntity;
using AuditService;
using CtTool;

namespace Audit.Actions
{
    public class PositionAction :BaseAction
    {
        IPositionService positionService;
        public PositionAction()
        {
            positionService = new PositionService();
        }
        public override void GoToMethod(string methodName)
        {
            switch (methodName)
            {
                case "GetPositionList":
                case "Save":
                case "Edit":
                case "Delete":
                    PositionEntity pe = ActionTool.DeserializeParameters<PositionEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<PositionAction>(this, methodName, pe);
                    break;
                case "ParentCombo":
                case "WorkFlowCombo":
                    ActionTool.InvokeObjMethod<PositionAction>(this, methodName, null);
                    break;
                case "GetPositionDataGrid":
                    pe = ActionTool.DeserializeParameters<PositionEntity>(context, actionType);
                    DataGrid<PositionEntity> dg = new DataGrid<PositionEntity>();
                    dg = ActionTool.DeserializeParametersByFields<DataGrid<PositionEntity>>(context, actionType);
                    GetPositionDataGrid(pe, dg);
                    break;

            }
        }
        public void GetPositionList(PositionEntity position)
        {
            try
            {
                JsonTool.WriteJson<List<PositionEntity>>(positionService.GetPositionList(position), context);

            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);

            }
        }
        public void Save(PositionEntity position)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                positionService.Save(position);
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
        public void Edit(PositionEntity position)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                positionService.Edit(position);
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
        public void Delete(PositionEntity position)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                positionService.Delete(position);
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

        public void ParentCombo()
        {
            try
            {
                JsonTool.WriteJson<List<TreeNode>>(positionService.ParentCombo(), context);

            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);

            }
        }

        public void WorkFlowCombo()
        {
            try
            {
                JsonTool.WriteJson<List<TreeNode>>(positionService.WorkFlowCombo(), context);

            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);

            }
        }
        /// <summary>
        /// 获取dataGrid数据
        /// </summary>
        /// <param name="pe"></param>
        /// <param name="dg"></param>
        public void GetPositionDataGrid(PositionEntity pe, DataGrid<PositionEntity> dg) {
            try
            {
                JsonTool.WriteJson<DataGrid<PositionEntity>>(positionService.GetPositionDataGrid(dg,pe), context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
    }
}