using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using AuditSPI.ReportAnalysis;
using AuditService.ReportAnalysis;
using Audit.Actions;
using AuditEntity.ReportState;
using CtTool;
using AuditSPI;

using AuditExportImport.ReportAnalysis;
using System.IO;

using AuditEntity;



namespace Audit.Actions.ReportAnalysis
{
    public class ReportStateAggregationAction:BaseAction
    {
        IReportStateAggregation reportAggregationService;
        public ReportStateAggregationAction()
        {
            if (reportAggregationService == null)
            {
                reportAggregationService = new ReportStateAggregationService();
            }
        }
        public override void GoToMethod(string methodName)
        {
            switch (methodName)
            {
                case "GetReportStateAggregation":
                case "GetReportStateAggregationByCompany":
                case "GetReportStateAggregationCompanies":
                case "GetReportStateAggregationReports":
                    ReportStateEntity rse = ActionTool.DeserializeParameters<ReportStateEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<ReportStateAggregationAction>(this, methodName, rse);
                    break;
                case "ExportReportStateAggregationByCompanies":
                    rse = ActionTool.DeserializeParameters<ReportStateEntity>(context, actionType);
                    string CodeStr = Convert.ToString(ActionTool.DeserializeParameter("CodeStr", context));
                    string NameStr = Convert.ToString(ActionTool.DeserializeParameter("NameStr", context));
                    ExportReportStateAggregationByCompanies(rse, CodeStr, NameStr);
                    break;
            }
        }
        /// <summary>
        /// 汇总报表状态数据列表
        /// </summary>
        /// <param name="state"></param>
        public void GetReportStateAggregation(ReportStateEntity state)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                List<ReportStateAggregationStruct> reportStateList = reportAggregationService.GetReportStateAggregation(state);
                js.obj = reportStateList;
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
        /// 汇总报表状态根据单位
        /// </summary>
        /// <param name="state"></param>
        public void GetReportStateAggregationByCompany(ReportStateEntity state)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                List<ReportStateAggregationStruct> CompanyList = reportAggregationService.GetReportStateAggregationByCompany(state);
                js.obj = CompanyList;
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
        /// 导出单位填报状态汇总表
        /// </summary>
        /// <param name="state"></param>
        public void ExportReportStateAggregationByCompanies(ReportStateEntity state, string CodeStr, string NameStr)
        {
            try
            {
                List<ReportStateAggregationStruct> reportStateList = reportAggregationService.GetReportStateAggregationByCompany(state);
                ReportStateAggregationExport rsae = new ReportStateAggregationExport();
                string dir = context.Server.MapPath("~/ct/attatchs/AggregationDir");
                 if (!Directory.Exists(dir))
                {
                    Directory.CreateDirectory(dir);
                }

                string filePath = dir + @"/"+Guid.NewGuid().ToString()+".xls";
                if (File.Exists(filePath))
                {
                    File.Delete(filePath);
                }
                string[] Codes = CodeStr.Split(',');
                string[] Names = NameStr.Split(','); 
                 Dictionary<string, string> titles = new Dictionary<string, string>();
                 titles.Add("CompanyCode", "单位编号");
                 titles.Add("CompanyName", "单位名称");
                 for (int i = 0; i < Codes.Length; ++i)
                 {
                     titles.Add(Codes[i], Names[i]);
                 }
                rsae.CreateWorkBook("济南宾朋信息科技有限公司");
                rsae.ExportReportStateAggregationByCompanies(filePath, "单位填报状态汇总表", reportStateList, titles);
                rsae.WriteToFile(filePath);
                ActionTool.SetExportExcelInfo(context, filePath, "单位填报状态汇总表");
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.Message);
            }
        }

        /// <summary>
        /// 根据报表状态获取单位的列表
        /// </summary>
        /// <param name="state"></param>
        public void GetReportStateAggregationCompanies(ReportStateEntity state)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                List<CompanyEntity> CompanyList = reportAggregationService.GetReportStateAggregationCompanies(state);
                js.obj = CompanyList;
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
        /// 获取报表列表详情
        /// </summary>
        /// <param name="state"></param>
        /// <returns></returns>
        public void GetReportStateAggregationReports(ReportStateEntity state){
            JsonStruct js = new JsonStruct();
            try
            {
                List<ReportFormatDicEntity> ReportList = reportAggregationService.GetReportStateAggregationReports(state);
                js.obj = ReportList;
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