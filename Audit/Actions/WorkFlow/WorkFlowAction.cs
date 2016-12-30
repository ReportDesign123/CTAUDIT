using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using AuditEntity.WorkFlow;
using AuditSPI.WorkFlow;
using AuditService.WorkFlow;
using CtTool;
using AuditSPI;

namespace Audit.Actions.WorkFlow
{
    public class WorkFlowAction:BaseAction
    {
        WorkFlowDefinitionService workFlowDefinitionService;
        public WorkFlowAction()
        {
            if (workFlowDefinitionService == null)
            {
                workFlowDefinitionService = new WorkFlowDefinitionService();
            }
        }
        public override void GoToMethod(string methodName)
        {
            switch (methodName)
            {
                case "EditBusinessEntity":
                case "DeleteBusinessEntity":
                case "AddBusinessEntity":
                    WorkFlowBusinessEntity wfbe = ActionTool.DeserializeParameters<WorkFlowBusinessEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<WorkFlowAction>(this, methodName, wfbe);
                    break;
                case "GetWorkFlowDefinition":
                case "EditWorkFlowEntity":
                case "DeleteWorkFlow":
                case "AddWorkFlow":
                    WorkFlowDefinition wfd = ActionTool.DeserializeParameters<WorkFlowDefinition>(context, actionType);
                    ActionTool.InvokeObjMethod<WorkFlowAction>(this, methodName, wfd);
                    break;
                case "DataGridBusinessEntity":
                    wfbe = ActionTool.DeserializeParameters<WorkFlowBusinessEntity>(context, actionType);
                    DataGrid<WorkFlowBusinessEntity> dg = ActionTool.DeserializeParametersByFields<DataGrid<WorkFlowBusinessEntity>>(context, actionType);
                    DataGridBusinessEntity(wfbe, dg);
                    break;
                case "DataGridWorkFlow":
                    wfd = ActionTool.DeserializeParameters<WorkFlowDefinition>(context, actionType);
                    DataGrid<WorkFlowDefinition> dgwf = ActionTool.DeserializeParametersByFields<DataGrid<WorkFlowDefinition>>(context, actionType);
                    DataGridWorkFlow(wfd, dgwf);
                    break;
            }
        }

        public void EditBusinessEntity(WorkFlowBusinessEntity wfbe)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                workFlowDefinitionService.EditBusinessEntity(wfbe);
                js.success = true;
                js.sMeg = "编辑成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }

      

        public void  DataGridBusinessEntity(WorkFlowBusinessEntity wfbe, AuditSPI.DataGrid<WorkFlowBusinessEntity> dataGrid)
        {
            try
            {
                DataGrid<WorkFlowBusinessEntity> dg = workFlowDefinitionService.DataGridBusinessEntity(wfbe, dataGrid);
                JsonTool.WriteJson<DataGrid<WorkFlowBusinessEntity>>(dg, context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }

        public void EditWorkFlowEntity(AuditEntity.WorkFlow.WorkFlowDefinition wfd)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                workFlowDefinitionService.EditWorkFlowEntity(wfd);
                js.success = true;
                js.sMeg = "编辑成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }

      

        public void  DataGridWorkFlow(AuditEntity.WorkFlow.WorkFlowDefinition wfd, AuditSPI.DataGrid<AuditEntity.WorkFlow.WorkFlowDefinition> dataGrid)
        {
            try
            {
                DataGrid<WorkFlowDefinition> dg = workFlowDefinitionService.DataGridWorkFlow(wfd, dataGrid);
                JsonTool.WriteJson<DataGrid<WorkFlowDefinition>>(dg, context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }


        public void DeleteBusinessEntity(WorkFlowBusinessEntity wfbe)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                workFlowDefinitionService.DeleteBusinessEntity(wfbe);
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


        public void DeleteWorkFlow(WorkFlowDefinition wfd)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                workFlowDefinitionService.DeleteWorkFlow(wfd);
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
        public void AddBusinessEntity(WorkFlowBusinessEntity wfbe)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                workFlowDefinitionService.AddBusinessEntity(wfbe);
                js.success = true;
                js.sMeg = "增加成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }


        public void AddWorkFlow(WorkFlowDefinition wfd)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                workFlowDefinitionService.AddWorkFlow(wfd);
                js.success = true;
                js.sMeg = "增加成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        public void GetWorkFlowDefinition(WorkFlowDefinition wfd)
        {
            try
            {
                List<WorkFlowDefinition> wfdlists = workFlowDefinitionService.GetWorkFlowDefinitionLists(wfd);
                JsonTool.WriteJson<List<WorkFlowDefinition>>(wfdlists, context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
    }
}