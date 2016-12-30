using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CtTool;
using AuditSPI.ExportReport;
using AuditService.ExportReport;
using AuditEntity.ExportReport;
using AuditSPI;
using GlobalConst;

namespace Audit.Actions.ExportReport
{
    public class ReportTempalteInstanceStateAction:BaseAction
    {
        IReportTemplateInstanceState reportStateService;
        public ReportTempalteInstanceStateAction() {
            if (reportStateService == null)
            {
                reportStateService = new ReportTemplateInstanceStateService();
            }
        }
        public override void GoToMethod(string methodName)
        {
             switch (methodName)
             {
                 case "GetExamReportDataGrid":
                     DataGrid<TemplateLogEntity> dataGrid = ActionTool.DeserializeParametersByFields<DataGrid<TemplateLogEntity>>(context, actionType);
                     TemplateLogEntity tle = ActionTool.DeserializeParameters<TemplateLogEntity>(context, actionType);
                     GetExamReportDataGrid(dataGrid, tle);
                     break;
                 case "GetCancelExamReportDataGrid":
                     dataGrid = ActionTool.DeserializeParametersByFields<DataGrid<TemplateLogEntity>>(context, actionType);
                     tle = ActionTool.DeserializeParameters<TemplateLogEntity>(context, actionType);
                     GetCancelExamReportDataGrid(dataGrid, tle);
                     break;
                 case "GetSealReportDataGrid":
                     dataGrid = ActionTool.DeserializeParametersByFields<DataGrid<TemplateLogEntity>>(context, actionType);
                     tle = ActionTool.DeserializeParameters<TemplateLogEntity>(context, actionType);
                     GetSealReportDataGrid(dataGrid, tle);
                     break;
                 case "GetCancelSealReportDataGrid":
                     dataGrid = ActionTool.DeserializeParametersByFields<DataGrid<TemplateLogEntity>>(context, actionType);
                     tle = ActionTool.DeserializeParameters<TemplateLogEntity>(context, actionType);
                     GetCancelSealReportDataGrid(dataGrid, tle);
                     break;                    
                 case"GetExamReportHistory":
                     tle = ActionTool.DeserializeParameters<TemplateLogEntity>(context, actionType);
                     ActionTool.InvokeObjMethod<ReportTempalteInstanceStateAction>(this, methodName, tle);
                     break;
                 case "ExamReportPass":
                 case "ExamReportFail":
                 case "CancelExamReport":
                 case "ExamReportSeal":
                 case"ExamReportCancelSeal":
                     OperationLogEntity operationLogEntity = ActionTool.DeserializeParameters<OperationLogEntity>(context, actionType);
                     ActionTool.InvokeObjMethod<ReportTempalteInstanceStateAction>(this, methodName, operationLogEntity);
                     break;                  
             }
        }
        /// <summary>
        /// 获取审核报告列表
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="templateLogEntity"></param>
        public void GetExamReportDataGrid(DataGrid<TemplateLogEntity> dataGrid, TemplateLogEntity templateLogEntity)
        {
            try
            {
                JsonTool.WriteJson<DataGrid<TemplateLogEntity>>(reportStateService.GetExamReportDataGrid(dataGrid, templateLogEntity), context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
        /// <summary>
        /// 获取取消审核报告列表
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="templateLogEntity"></param>
        public void GetCancelExamReportDataGrid(DataGrid<TemplateLogEntity> dataGrid, TemplateLogEntity templateLogEntity)
        {
            try
            {
                JsonTool.WriteJson<DataGrid<TemplateLogEntity>>(reportStateService.GetCancelExamReportDataGrid(dataGrid, templateLogEntity), context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
        /// <summary>
        /// 获取待封存的报告
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="templateLogEntity"></param>
        public void GetSealReportDataGrid(DataGrid<TemplateLogEntity> dataGrid, TemplateLogEntity templateLogEntity)
        {
            try
            {
                JsonTool.WriteJson<DataGrid<TemplateLogEntity>>(reportStateService.GetSealReportDataGrid(dataGrid, templateLogEntity), context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
        /// <summary>
        /// 获取已封存的报告
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="templateLogEntity"></param>
        public void GetCancelSealReportDataGrid(DataGrid<TemplateLogEntity> dataGrid, TemplateLogEntity templateLogEntity)
        {
            try
            {
                JsonTool.WriteJson<DataGrid<TemplateLogEntity>>(reportStateService.GetCancelSealReportDataGrid(dataGrid, templateLogEntity), context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }        
        /// <summary>
        /// 上级审核通过
        /// </summary>
        /// <param name="dataStr"></param>
        public void ExamReportPass(OperationLogEntity operationLogEntity)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                operationLogEntity.State = CreateReportConst.TEMPLATESTATE_EXAMSUCCESS;
                reportStateService.ExamReport(operationLogEntity);
                js.sMeg = "审核成功";
                js.success = true;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 上级审核不通过
        /// </summary>
        /// <param name="operationLogEntity"></param>
        public void ExamReportFail(OperationLogEntity operationLogEntity)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                operationLogEntity.State = CreateReportConst.TEMPLATESTATE_EXAMFAIL;
                reportStateService.ExamReport(operationLogEntity);
                js.sMeg = "审核成功";
                js.success = true;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 取消审核
        /// </summary>
        /// <param name="operationLogEntity"></param>
        public void CancelExamReport(OperationLogEntity operationLogEntity)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                reportStateService.CancelExamReport(operationLogEntity);
                js.sMeg = "取消审核成功";
                js.success = true;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 获取审核历史
        /// </summary>
        /// <param name="templateLogEntiy"></param>
        public void GetExamReportHistory(TemplateLogEntity templateLogEntiy) { 
         try
            {
                JsonTool.WriteJson<List<OperationLogEntity>>(reportStateService.GetExamReportHistory(templateLogEntiy), context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
        /// <summary>
        /// 审计封存
        /// </summary>
        /// <param name="operationLogEntity"></param>
        public void ExamReportSeal(OperationLogEntity operationLogEntity)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                reportStateService.ExamReportSeal(operationLogEntity);
                js.sMeg = "封存成功";
                js.success = true;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 取消封存
        /// </summary>
        /// <param name="operationLogEntity"></param>
        public void ExamReportCancelSeal(OperationLogEntity operationLogEntity)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                reportStateService.ExamReportCancelSeal(operationLogEntity);
                js.sMeg = "解除成功";
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