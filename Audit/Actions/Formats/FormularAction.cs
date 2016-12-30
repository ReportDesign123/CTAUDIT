using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using AuditSPI;
using AuditSPI.Format;
using AuditService;
using DbManager;
using AuditEntity;
using CtTool;
using AuditEntity.AuditPaper;
using AuditSPI.AuditTask;
using AuditService.AuditTask;
using AuditSPI.AuditPaper;
using AuditService.AuditPaper;
using AuditSPI.ReportData;

namespace Audit.Actions.Formats
{
    public class FormularAction :BaseAction
    {
        IReportFormat reportService;
        IFormular formularService;
        IAuditTaskAndAuditPaper taskAndPaperService;
        IAuditPaperAndReports paperAndReportService;
        public FormularAction()
        {
            reportService = new ReportFormatService();
            formularService = new FormularService();
            taskAndPaperService = new AuditTaskService();
            paperAndReportService = new AuditPaperService();
        }
        public override void GoToMethod(string methodName)
        {
            switch (methodName)
            {
                case "DataGrid":
                     DataGrid<ReportFormatDicEntity> dg = new DataGrid<ReportFormatDicEntity>();
                    dg = ActionTool.DeserializeParametersByFields<DataGrid<ReportFormatDicEntity>>(context, actionType);
                    ReportFormatDicEntity rfde = ActionTool.DeserializeParameters<ReportFormatDicEntity>(context, actionType);
                    DataGrid(dg, rfde);
                    break;
                case "Save":
                    FormularStruct fs = new FormularStruct();
                    fs = ActionTool.DeserializeParametersByFields<FormularStruct>(context, actionType);
                    ActionTool.InvokeObjMethod<FormularAction>(this, methodName, fs);
                    break;
                case "GetDataSourceList":
                    ActionTool.InvokeObjMethod<FormularAction>(this, methodName, null);
                    break;
                case "GetDataGridByTaskCode":
                    DataGrid<AuditPaperEntity> dgP = new DataGrid<AuditPaperEntity>();
                    dgP = ActionTool.DeserializeParametersByFields<DataGrid<AuditPaperEntity>>(context, actionType);
                    AuditPaperEntity ape = ActionTool.DeserializeParameters<AuditPaperEntity>(context, actionType);
                    string TaskCode = ActionTool.DeserializeParameter("TaskCode",context).ToString();
                    GetDataGridByTaskCode(dgP, TaskCode, ape);
                    break;
                case "GetAuditPapersByTaskId":
                    dgP = ActionTool.DeserializeParametersByFields<DataGrid<AuditPaperEntity>>(context, actionType);
                    string TaskId = ActionTool.DeserializeParameter("TaskId",context).ToString();
                    GetAuditPapersByTaskId(dgP, TaskId);
                    break;

                case "GetReportsByPaperCode":
                    DataGrid<ReportFormatDicEntity> dgR = new DataGrid<ReportFormatDicEntity>();
                    dgR = ActionTool.DeserializeParametersByFields<DataGrid<ReportFormatDicEntity>>(context, actionType);
                    ReportFormatDicEntity rfe = ActionTool.DeserializeParameters<ReportFormatDicEntity>(context, actionType);
                    string PaperCode = ActionTool.DeserializeParameter("PaperCode", context).ToString();
                    GetReportsByPaperCode(dgR, PaperCode, rfe);
                    break;
            }
        }


        public void DataGrid(DataGrid<ReportFormatDicEntity> dg,ReportFormatDicEntity rfde)
        {
            try
            {
               DataGrid<ReportFormatDicEntity> dgs= reportService.getDataGrid(dg,rfde);
               JsonTool.WriteJson<DataGrid<ReportFormatDicEntity>>(dgs,context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }

        public void Save(FormularStruct fs)
        {
            JsonStruct js = new JsonStruct();
         
            try
            {
               
                object obj = JSON.Parse(fs.FormularData);
                List<FormularEntity> lists = JsonTool.ConvertBeanToListFormulars(obj);
                formularService.SaveFormulars(lists, fs.FormularData + "|" + fs.RowColInfo, fs.ReportCode);
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

        public void GetDataSourceList()
        {
            try
            {
                List<DataSourceEntity> lists = formularService.GetDataSourceList();
                JsonTool.WriteJson<List<DataSourceEntity>>(lists,context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                
            }
        }

        public void GetAuditPapersByTaskId(DataGrid<AuditPaperEntity> dg, string TaskId)
        {
            try
            {
                JsonTool.WriteJson<DataGrid<AuditPaperEntity>>(taskAndPaperService.GetDataGridByTaskId(dg, TaskId), context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);

            }
        }
        public void  GetDataGridByTaskCode(DataGrid<AuditPaperEntity> dg, string TaskCode, AuditPaperEntity ape)
        {
            JsonTool.WriteJson<DataGrid<AuditPaperEntity>>(taskAndPaperService.GetDataGridByTaskCode(dg, TaskCode, ape), context);
        }

        public void GetReportsByPaperCode(DataGrid<ReportFormatDicEntity> dg, string PaperCode, ReportFormatDicEntity rfe)
        {
            try
            {
                JsonTool.WriteJson<DataGrid<ReportFormatDicEntity>>(paperAndReportService.GetReportsByPaperId(dg, PaperCode, rfe), context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);

            }
        }
    }
}