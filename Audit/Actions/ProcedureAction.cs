using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using AuditService.Procedure;
using AuditEntity.Procedure;
using AuditSPI;
using CtTool;

namespace Audit.Actions
{
    public class ProcedureAction:BaseAction
    {
        ProcedureService procedureService;
        public ProcedureAction()
        {
            if (procedureService == null)
            {
                procedureService = new ProcedureService();
            }
        }
        public override void GoToMethod(string methodName)
        {
            switch (methodName)
            {
                case "GetProcedureDataGrid":
                    DataGrid<ProcedureEntity> dg = ActionTool.DeserializeParametersByFields<DataGrid<ProcedureEntity>>(context, actionType);
                    ProcedureEntity pe = ActionTool.DeserializeParameters<ProcedureEntity>(context, actionType);

                    GetProcedureDataGrid(dg, pe);
                    break;
                case "DataGridParameters":
                case "GetParametersByProcedure":
                    int procedureId = Convert.ToInt32(ActionTool.DeserializeParameter("procedureId",context));
                    string DataSourceId = ActionTool.DeserializeParameter("DataSourceId", context).ToString();
                    GetParametersByProcedure(procedureId,DataSourceId);
                    break;
                case "AddProcedureFormularEntity":
                case "EditProcedureFormularEntity":
                case "DeleteProcedureFormularEntity":
                    ProcedureFormularEntity pfe = ActionTool.DeserializeParameters<ProcedureFormularEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<ProcedureAction>(this, methodName, pfe);
                    break;
                case "DataGridProcedureFormularEntities":
                    DataGrid<ProcedureFormularEntity> dgPfe = ActionTool.DeserializeParametersByFields<DataGrid<ProcedureFormularEntity>>(context, actionType);
                    pfe = ActionTool.DeserializeParameters<ProcedureFormularEntity>(context, actionType);
                    DataGridProcedureFormularEntities(dgPfe, pfe);
                    break;
            }
        }

        public void GetProcedureDataGrid(AuditSPI.DataGrid<AuditEntity.Procedure.ProcedureEntity> dataGrid, AuditEntity.Procedure.ProcedureEntity pe)
        {
            try
            {
                DataGrid<ProcedureEntity> dg = procedureService.GetProcedureDataGrid(dataGrid, pe);
                JsonTool.WriteJson<DataGrid<ProcedureEntity>>(dg, context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }

        public void GetParametersByProcedure(int procedureId,string DataSourceId)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                List<ProcedureParameterEntity> parameters = procedureService.GetParametersByProcedure(procedureId,DataSourceId);
                js.success = true;
                js.obj = parameters;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        public void DataGridParameters(int procedureId, string DataSourceId)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                List<ProcedureParameterEntity> parameters = procedureService.GetParametersByProcedure(procedureId, DataSourceId);
                DataGrid<ProcedureParameterEntity> dg = new DataGrid<ProcedureParameterEntity>();
                dg.rows = parameters;
                dg.total = parameters.Count;
                js.success = true;
                js.obj = dg;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }

        public void DataGridProcedureFormularEntities(DataGrid<ProcedureFormularEntity> dataGrid, ProcedureFormularEntity pfe)
        {
            try
            {
                DataGrid<ProcedureFormularEntity> dg = procedureService.DataGridProcedureFormularEntities(dataGrid, pfe);
                JsonTool.WriteJson<DataGrid<ProcedureFormularEntity>>(dg, context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.Message);
            }
        }
        public void AddProcedureFormularEntity(ProcedureFormularEntity pfe)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                procedureService.AddProcedureFormularEntity(pfe);
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
        public void EditProcedureFormularEntity(ProcedureFormularEntity pfe)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                procedureService.EditProcedureFormularEntity(pfe);
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
        public void DeleteProcedureFormularEntity(ProcedureFormularEntity pfe)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                procedureService.DeleteProcedureFormularEntity(pfe);
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
    }
}