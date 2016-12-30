using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using AuditSPI.ReportAggregation;
using AuditService.ReportAggregation;
using CtTool;
using AuditEntity;
using AuditSPI;
using AuditService;
using AuditEntity.AuditPaper;
using AuditService.ReportData;
using AuditSPI.ReportData;
using AuditEntity.ReportAggregation;
using AuditSPI.ReportAudit;
using AuditEntity.ReportAudit;
using System.IO;
using AuditExportImport.ReportAggregation;

namespace Audit.Actions.ReportAggregation
{
    public class ReportAggregationAction:BaseAction
    {
        IReportAggregation reportAggregationService;
        ICompanyService companyService;
        IFillReport fillReportService;
        ReportFormatService reportFormatService;
        private static string AggregationCellConstitutePath = "~/ct/attatchs/AggregationDir";
        public ReportAggregationAction()
        {
            if (reportAggregationService == null)
            {
                reportAggregationService = new ReportAggregationService();
            }
            if (companyService == null)
            {
                companyService = new CompanyService();
            }
            if(fillReportService==null){
                fillReportService=new FillReportService();
            }
            if (reportFormatService == null)
            {
                reportFormatService = new ReportFormatService();
            }
        }
        public override void GoToMethod(string methodName)
        {
            switch (methodName)
            {
                case "ReportAggregation":
                    object dataStr =ActionTool.DeserializeParameter("dataStr", context);
                    ActionTool.InvokeObjMethod<ReportAggregationAction>(this, methodName, dataStr);

                    break;
                case "GetAuthorityCompanies":
                    ActionTool.InvokeObjMethod<ReportAggregationAction>(this, methodName, null);
                    break;
                case "GetAuditPaperDataGrid":
                    string taskId = Convert.ToString(ActionTool.DeserializeParameter("taskId",context));
                    AuditPaperEntity ape = ActionTool.DeserializeParameters<AuditPaperEntity>(context, actionType);
                    DataGrid<AuditPaperEntity> dg = ActionTool.DeserializeParametersByFields<DataGrid<AuditPaperEntity>>(context, actionType);
                    GetAuditPaperDataGrid(taskId, ape, dg);
                    break;
               case "GetReportFormatStructsByAuditPaper":
                    string auditReportDate = Convert.ToString(ActionTool.DeserializeParameter("auditReportDate", context));
                    AuditPaperEntity auditPaper = ActionTool.DeserializeParameters<AuditPaperEntity>(context, actionType);
                    ReportFormatDicEntity rfde = ActionTool.DeserializeParameters<ReportFormatDicEntity>(context, actionType);
                    GetReportFormatStructsByAuditPaper(auditPaper, rfde);
                break;
               case "SaveAggregationTemplateClassify":
               case "UpdateAggregationTemplateClassify":
               case "DeleteAggregationTemplateClassify":
               case "GetAggregationClassifys":
                AggregationClassifyEntity ace = ActionTool.DeserializeParameters<AggregationClassifyEntity>(context, actionType);
                ActionTool.InvokeObjMethod<ReportAggregationAction>(this, methodName, ace);
                break;
               case "SaveAggregationTemplate":
               case "UpdateAggregationTemplate":
               case "DeleteAggregationTemplate":
               case "GetAggregationTemplate":
                AggregationTemplateEntity ate = ActionTool.DeserializeParameters<AggregationTemplateEntity>(context, actionType);
                ActionTool.InvokeObjMethod<ReportAggregationAction>(this, methodName, ate);
                break;
                case "GetAggregationTemplates":
                DataGrid<AggregationTemplateEntity> atedg = ActionTool.DeserializeParametersByFields<DataGrid<AggregationTemplateEntity>>(context, actionType);
                ate = ActionTool.DeserializeParameters<AggregationTemplateEntity>(context, actionType);
                GetAggregationTemplates(atedg, ate);
                break;
                case "GetPreAggregationLogEntity":
                GetPreAggregationLogEntity();
                break;
                case"GetAggregationLogEnties":
                DataGrid<AggregationLogEntity> logs = ActionTool.DeserializeParametersByFields<DataGrid<AggregationLogEntity>>(context, actionType);
                AggregationLogEntity ale = ActionTool.DeserializeParameters<AggregationLogEntity>(context, actionType);
                GetAggregationLogEnties(logs, ale);
                    break;
                case "GetReportData":
                case "GetReportAllDatas":
                    ReportDataParameterStruct rdps = ActionTool.DeserializeParametersByFields<ReportDataParameterStruct>(context, actionType);
                    ActionTool.InvokeObjMethod<ReportAggregationAction>(this, methodName, rdps);
                    break;
                case"GetReportCellDataTrend":
                case"GetAggregationReportCellConstitute":
                case "ExportAggregationCellConstitute":
                   ReportAuditCellConclusion racc = ActionTool.DeserializeParameters<ReportAuditCellConclusion>(context, actionType);
                    ActionTool.InvokeObjMethod<ReportAggregationAction>(this, methodName, racc);
                    break;
            }
        }
        public void ReportAggregation(string dataStr)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                ReportAggregationStruct ras = JsonTool.DeserializeObject<ReportAggregationStruct>(dataStr);
                reportAggregationService.ReportAggregation(ras);
                js.sMeg = "汇总成功";
                js.success = true;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        public void GetAuthorityCompanies()
        {
            try
            {
                JsonTool.WriteJson<List<TreeNode>>(companyService.ParentComboAuthority(), context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
        /// <summary>
        /// 获取审计底稿列表
        /// </summary>
        /// <param name="AuditTaskId">审计任务</param>
        /// <param name="ape">审计底稿过滤对象</param>
        /// <param name="dataGrid">审计底稿表格</param>
        public void GetAuditPaperDataGrid(string taskId, AuditPaperEntity ape, DataGrid<AuditPaperEntity> dataGrid)
        {
            try
            {
                DataGrid<AuditPaperEntity> papers = fillReportService.GetAuditPaperByAuditTask(taskId, ape, dataGrid);
                JsonTool.WriteJson<DataGrid<AuditPaperEntity>>(papers, context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);

            }
        }
        /// <summary>
        /// 获取报表列表
        /// </summary>
        /// <param name="ape"></param>
        /// <param name="auditReportDate"></param>
        public void GetReportFormatStructsByAuditPaper(AuditPaperEntity ape, ReportFormatDicEntity rfde)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                List<ReportFormatStruct> reportFormats = fillReportService.GetReportFormatStructsByAuditPaper(ape, rfde);
                js.obj = reportFormats;
                js.success = true;

            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }


        #region 模板分类相关的方法
        /// <summary>
        /// 保存模板分类
        /// </summary>
        /// <param name="ale"></param>
        public void   SaveAggregationTemplateClassify(AuditEntity.ReportAggregation.AggregationClassifyEntity ace)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                reportAggregationService.SaveAggregationTemplateClassify(ace);
                js.success = true;
                js.sMeg = "保存成功";
                js.obj = ace.Id;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.StackTrace;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 更新模板分类方法
        /// </summary>
        /// <param name="ace"></param>
        public void UpdateAggregationTemplateClassify(AuditEntity.ReportAggregation.AggregationClassifyEntity ace)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                reportAggregationService.UpdateAggregationTemplateClassify(ace);
                js.success = true;
                js.sMeg = "编辑成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.StackTrace;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 删除报表分类
        /// </summary>
        /// <param name="ace"></param>
        public void DeleteAggregationTemplateClassify(AuditEntity.ReportAggregation.AggregationClassifyEntity ace)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                reportAggregationService.DeleteAggregationTemplateClassify(ace);
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
        /// <summary>
        /// 获取报表分类列表
        /// </summary>
        /// <param name="ace"></param>
        public void GetAggregationClassifys(AggregationClassifyEntity ace)
        {
            try
            {
                JsonTool.WriteJson<List<AggregationClassifyEntity>>(reportAggregationService.GetAggregationClassifys(ace), context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
        #endregion

        #region 获取报表汇总模板相关的方法
        /// <summary>
        /// 保存汇总模板
        /// </summary>
        /// <param name="ate"></param>
        public void SaveAggregationTemplate(AuditEntity.ReportAggregation.AggregationTemplateEntity ate)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                reportAggregationService.SaveAggregationTemplate(ate);
                js.success = true;
                js.sMeg = "保存成功";
                js.obj = ate;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.StackTrace;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }

        public void UpdateAggregationTemplate(AuditEntity.ReportAggregation.AggregationTemplateEntity ate)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                reportAggregationService.UpdateAggregationTemplate(ate);
                js.success = true;
                js.sMeg = "编辑成功";
                js.obj = ate;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.StackTrace;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }

        /// <summary>
        /// 删除报表汇总模板
        /// </summary>
        /// <param name="ate"></param>
        public void DeleteAggregationTemplate(AuditEntity.ReportAggregation.AggregationTemplateEntity ate)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                reportAggregationService.DeleteAggregationTemplate(ate);
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

        public void GetAggregationTemplates(AuditSPI.DataGrid<AggregationTemplateEntity> dataGrid, AggregationTemplateEntity ate)
        {
            try
            {
                JsonTool.WriteJson<DataGrid<AggregationTemplateEntity>>(reportAggregationService.GetAggregationTemplates(dataGrid, ate), context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
        /// <summary>
        /// 获取默认的汇总模板
        /// </summary>
        public void GetPreAggregationLogEntity()
        {
            JsonStruct js = new JsonStruct();
            try
            {
               AggregationTemplateEntity ate=  reportAggregationService.GetPreAggregationLogEntity();
               js.obj = ate;
                js.success = true;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.StackTrace;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        #endregion

        #region 报表汇总查看相关的方法
        /// <summary>
        /// 获取报表汇总日志列表
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="ale"></param>
        public void GetAggregationLogEnties(DataGrid<AggregationLogEntity> dataGrid, AggregationLogEntity ale)
        {
            try
            {
                DataGrid<AggregationLogEntity> logs = reportAggregationService.GetAggregationLogEnties(dataGrid, ale);
                JsonTool.WriteJson<DataGrid<AggregationLogEntity>>(logs, context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);

            }
        }
        ///<summary>
        ///获取汇总模板下的报表
        ///</summary>
        /// <param name="dataGrid"></param>
        /// <param name="ale"></param>
        public void GetAggregationTemplate(AggregationTemplateEntity ate)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                ate = reportAggregationService.GetAggregationTemplate(ate);
                js.obj = ate;
                js.success = true;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.StackTrace;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);

        }

        public void GetReportData(ReportDataParameterStruct rdps)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                ReportAuditStruct ras = new ReportAuditStruct();
                ras.reportFormat = reportFormatService.LoadReportFormatNotInclueFormular(rdps.ReportId);
                ras.reportData = fillReportService.LoadReportDatas(rdps,true);

                js.obj = ras;
                js.success = true;

            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.Message);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        public void GetReportAllDatas(ReportDataParameterStruct rdps)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                ReportAuditStruct ras = new ReportAuditStruct();
                ras.reportFormat = reportFormatService.LoadReportFormatNotInclueFormular(rdps.ReportId);
                ras.reportData = fillReportService.LoadReportDatas(rdps,true);

                js.obj = ras;
                js.success = true;

            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.Message);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 获取指标趋势
        /// </summary>
        /// <param name="racc"></param>
        public void GetReportCellDataTrend(ReportAuditCellConclusion racc)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                ChartDataStruct data = reportAggregationService.GetReportCellDataTrend(racc);
                js.obj = data;
                js.success = true;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.Message);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 获取其他汇总单位的指标值
        /// </summary>
        /// <param name="reportAuditCellConclusion"></param>
        /// <param name="companies"></param>
        public void GetAggregationReportCellConstitute(ReportAuditCellConclusion reportAuditCellConclusion)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                AggregationTemplateEntity temp = new AggregationTemplateEntity();
                temp.Id = reportAuditCellConclusion.TemplateId;
                AggregationTemplateEntity ate = reportAggregationService.GetAggregationTemplate(temp);

                ReportAggregationContentStruct contentStruct = JsonTool.DeserializeObject<ReportAggregationContentStruct>(ate.Content);
                contentStruct.Companies = reportAggregationService.GetAggregationReportCellConstitute(reportAuditCellConclusion, contentStruct.Companies);
                js.obj = contentStruct.Companies;
                js.success = true;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.Message);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        #endregion
        /// <summary>
        /// 汇总单位指定指标信息导出
        /// </summary>
        /// <param name="reportAuditCellConclusion"></param>
        public void ExportAggregationCellConstitute(ReportAuditCellConclusion reportAuditCellConclusion)
        {
            try
            {
                //获取指标单位汇总构成
                AggregationTemplateEntity temp = new AggregationTemplateEntity();
                temp.Id = reportAuditCellConclusion.TemplateId;
                AggregationTemplateEntity ate = reportAggregationService.GetAggregationTemplate(temp);

                ReportAggregationContentStruct contentStruct = JsonTool.DeserializeObject<ReportAggregationContentStruct>(ate.Content);
                contentStruct.Companies = reportAggregationService.GetAggregationReportCellConstitute(reportAuditCellConclusion, contentStruct.Companies);
                string dir = context.Server.MapPath(AggregationCellConstitutePath);

                if (!Directory.Exists(dir))
                {
                    Directory.CreateDirectory(dir);
                }

                string filePath = dir + @"/"+Guid.NewGuid().ToString()+".xls";
                if (File.Exists(filePath))
                {
                    File.Delete(filePath);
                }

                Dictionary<string, string> titles = new Dictionary<string, string>();
                titles.Add("name", "单位名称");

                ReportAggregationExport reportAggregationExport = new ReportAggregationExport();

                reportAggregationExport.CreateWorkBook("济南宾朋信息科技有限公司");
                reportAggregationExport.ExportReportAggregationCellConstitutes(filePath, "汇总指标构成", contentStruct.Companies, titles);
                reportAggregationExport.WriteToFile(filePath);
                FileInfo fi = new FileInfo(filePath);
                context.Response.ClearContent();
                context.Response.ClearHeaders();
                context.Response.ContentType = "application/octet-stream";
                context.Response.AddHeader("Content-Disposition", "attachment;filename=temp.xls");
                context.Response.AddHeader("Content-Length", fi.Length.ToString());
                context.Response.AddHeader("Content-Transfer-Encoding", "binary");
                context.Response.WriteFile(fi.FullName);
                context.Response.Flush();
                File.Delete(filePath);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.Message);
                JsonTool.WriteJson<string>(ex.Message, context);
            }
            
          
        }
    }
}