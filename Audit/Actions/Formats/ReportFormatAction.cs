using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Audit.Actions;
using AuditSPI;
using AuditSPI.Format;
using AuditService;
using GlobalConst;
using CtTool;
using AuditEntity;




namespace Audit.Actions.Formats
{
    public class ReportFormatAction:BaseAction
    {
        IReportFormat reportFormat;
        public ReportFormatAction()
        {
            if (reportFormat == null)
            {
                reportFormat =new  ReportFormatService();
            }
        }
        public override void GoToMethod(string methodName)
        {
            switch (methodName)
            {
                case "Save1":         
                    ReportStruct  rf = ActionTool.DeserializeParametersByFields<ReportStruct>(context, actionType);
                    ActionTool.InvokeObjMethod<ReportFormatAction>(this, methodName, rf);
                    break;
                case "LoadReportFormat":
                     List<string> pas=new List<string>();
                    pas.Add("Id");
                    object[] objs = ActionTool.DeserializeParameters(pas, context, BasicGlobalConst.POSTTYPE_POST);
                    ActionTool.InvokeObjMethod<ReportFormatAction>(this, methodName, objs);
                    break;
                case "LoadComReportFormat":
                    List<string> pa = new List<string>();
                    pa.Add("Id");
                    pa.Add("CompanyId");
                    object[] obj = ActionTool.DeserializeParameters(pa, context, BasicGlobalConst.POSTTYPE_POST);
                    ActionTool.InvokeObjMethod<ReportFormatAction>(this, methodName, obj);
                    break;
                case "DeleteReports":
                    object ids = ActionTool.DeserializeParameter("ids", context);
                    ActionTool.InvokeObjMethod<ReportFormatAction>(this, methodName, ids);
                    break;

                case "ReportDataGrid":
                    DataGrid<ReportFormatDicEntity> dg = ActionTool.DeserializeParametersByFields<DataGrid<ReportFormatDicEntity>>(context, actionType);
                    ReportFormatDicEntity rfde = ActionTool.DeserializeParameters<ReportFormatDicEntity>(context, actionType);
                    ReportDataGrid(dg, rfde);
                    break;


            }
        }
        /// <summary>
        /// 锁定
        /// </summary>
        /// <param name="ComPID"></param>
        /// <param name="TableName"></param>
        public void LoadComReportFormat(string ComPID,string TableName)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                JsonTool.WriteJson<List<ReportCompFormatDicEntity>>(reportFormat.LoadCompReportFormat(ComPID, TableName), context);
               
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        public void  LoadReportFormat(string id)
        {
            JsonStruct js = new JsonStruct();
            try
            {
               ReportFormatDicEntity rfde = reportFormat.LoadReportFormat(id);
               if (rfde.formularStr != null)
                 rfde.formularStr = Base64.Decode64(rfde.formularStr);
               //rfde.formatCalcuStr = "";
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
        /// <summary>
        /// 保存报表格式信息
        /// </summary>
        /// <param name="report"></param>
        public void Save1(ReportStruct report)
        {
            JsonStruct js = new JsonStruct();
            try
            {
               // object obj = JSON.Parse(report.dataStr);
               // BBData bb = JsonTool.ConvertObjectToBBData(obj);
                BBData bb = JsonTool.DeserializeObject<BBData>(report.dataStr);
                bb.formatStr = report.gridXmlStr;
                bb.dataStr = report.dataStr;
                reportFormat.SaveBBFormat(bb);
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

        public void DeleteReports(string ids)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                reportFormat.DeleteReports(ids);
                js.sMeg = "删除成功";
                js.success = true;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }

        public void ReportDataGrid(DataGrid<ReportFormatDicEntity> dataGrid, ReportFormatDicEntity rfde)
        {
            try
            {
                DataGrid<ReportFormatDicEntity> dg = reportFormat.ReportDataGrid(dataGrid, rfde);
                JsonTool.WriteJson<DataGrid<ReportFormatDicEntity>>(dg, context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
    }
}