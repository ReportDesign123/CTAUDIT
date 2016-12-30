using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using AuditService.ReportProblem;
using AuditEntity.ReportProblem;
using CtTool;
using AuditService;
using AuditSPI.ReportProblem;
using AuditSPI;


namespace Audit.Actions.ReportProblem
{
    public class ReportProblemAction:BaseAction
    {
        ReportProblemServicecs reportProblemService;
        public ReportProblemAction()
        {
            if (reportProblemService == null)
            {
                reportProblemService = new ReportProblemServicecs();
            }
        }
        public override void GoToMethod(string methodName)
        {
            switch (methodName)
            {
                case "Add":
                case "Edit":
                case "Get":
                case "Delete":
                    ReportProblemEntity rpe = ActionTool.DeserializeParameters<ReportProblemEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<ReportProblemAction>(this, methodName, rpe);
                    break;
                case "DataGridReportProblemEntity":
                    rpe = ActionTool.DeserializeParameters<ReportProblemEntity>(context, actionType);
                    DataGrid<ReportProblemEntity> dataGrid = ActionTool.DeserializeParametersByFields<DataGrid<ReportProblemEntity>>(context, actionType);
                    DataGridReportProblemEntity(dataGrid, rpe);
                    break;
            }
        }
        public void Add(ReportProblemEntity reportProblem)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                reportProblemService.Add(reportProblem);
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
        public void Edit(ReportProblemEntity reportProblem)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                reportProblemService.Edit(reportProblem);
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
        public void Delete(ReportProblemEntity reportProblem)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                reportProblemService.Delete(reportProblem);
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
        public void DataGridReportProblemEntity(DataGrid<ReportProblemEntity> dataGrid, ReportProblemEntity ce)
        {
            try
            {
                DataGrid<ReportProblemEntity> dg = reportProblemService.DataGridReportProblemEntity(dataGrid, ce);
                JsonTool.WriteJson<DataGrid<ReportProblemEntity>>(dg, context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }

    }
}