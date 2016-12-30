using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using AuditEntity.ExportReport;
using AuditEntity;
using AuditSPI.ExportReport;
using AuditService.ExportReport;
using CtTool;
using System.IO;
using AuditSPI;


namespace Audit.Actions.ExportReport
{
    public class CreateReportAction:BaseAction
    {
        ICreateReport createReportService;
        IReportTemplate reportTemplateService;
        public CreateReportAction()
        {
            if (createReportService == null) {
                createReportService = new CreateReportService();
            } 
             if (reportTemplateService == null)
            {
                reportTemplateService = new ReportTemplateService();
            }
        }
        public override void GoToMethod(string methodName)
        {
            switch (methodName)
            {
                case "GetCreateTemplateData":
                case "GetReportTemplatesByCompanyId":
                case "DownloadReport":
                case"UploadReport":
                    TemplateLogEntity tle = ActionTool.DeserializeParameters<TemplateLogEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<CreateReportAction>(this, methodName, tle);
                    break;
                case "GetCompaniesByAuthority":
                    CompanyEntity companyEntity = ActionTool.DeserializeParameters<CompanyEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<CreateReportAction>(this, methodName, companyEntity);
                    break;
                case"CreateReport":
                    string dataStr = Convert.ToString(ActionTool.DeserializeParameter("dataStr", context));
                    ActionTool.InvokeObjMethod<CreateReportAction>(this, methodName, dataStr);
                    break;
                case"GetTemplateLogList":
                    DataGrid<TemplateLogEntity> dataGrid = ActionTool.DeserializeParametersByFields<DataGrid<TemplateLogEntity>>(context, actionType);
                    tle = ActionTool.DeserializeParameters<TemplateLogEntity>(context, actionType);
                    GetTemplateLogList(dataGrid, tle);
                    break;
            }

        }
        /// <summary>
        /// 获取指定周期的模板数据
        /// </summary>
        /// <param name="rte"></param>
        public void GetCreateTemplateData(TemplateLogEntity tle)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                CreateTemplateReportStruct data = createReportService.GetCreateTemplateData(tle);
                js.obj = data;
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
        /// 根据权限获取单位
        /// </summary>
        /// <param name="companyEntity"></param>
        public void GetCompaniesByAuthority(CompanyEntity companyEntity)
        {
            try
            {
                JsonTool.WriteJson<List<CompanyEntity>>(createReportService.GetCompaniesByAuthority(companyEntity), context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
        /// <summary>
        /// 获取指定单位下的模板
        /// </summary>
        /// <param name="tle"></param>
        public void GetReportTemplatesByCompanyId(TemplateLogEntity tle)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                List<ReportTemplateEntity> data = createReportService.GetReportTemplatesByCompanyId(tle);
                js.obj = data;
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
        /// 形成报告
        /// </summary>
        /// <param name="dataStr"></param>
        public void CreateReport(string  dataStr)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                CreateTemplateReportStruct CreateTemplateReportStruct = JsonTool.DeserializeObject<CreateTemplateReportStruct>(dataStr);
                string filePath = ActionTool.GetReportTemplatePath(context);
                createReportService.CreateReport(CreateTemplateReportStruct,filePath);
                js.sMeg = "保存成功";
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
        /// 获取生成报告的下载记录DataGrid
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="templateLogEntity"></param>
        public void GetTemplateLogList(DataGrid<TemplateLogEntity> dataGrid, TemplateLogEntity templateLogEntity)
        {
            try
            {
                JsonTool.WriteJson<DataGrid<TemplateLogEntity>>(createReportService.GetTemplateLogList(dataGrid, templateLogEntity), context);                 
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
        /// <summary>
        /// 下载报告
        /// </summary>
        /// <param name="reportTemplate"></param>
        public void DownloadReport(TemplateLogEntity templateLogEntity)
        {
            try
            {
                ActionTool.DownloadFile(context, templateLogEntity.InstanceAddress, templateLogEntity.AttatchName);
                createReportService.DownloadLog(templateLogEntity);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
        /// <summary>
        /// 上传日志
        /// </summary>
        /// <param name="templateLogEntity"></param>
        public void UploadReport(TemplateLogEntity templateLogEntity)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                string filePath = ActionTool.GetReportTemplatePath(context);
                List<FileStruct> fsList = ActionTool.UploadFile(context, filePath);
                if (fsList.Count > 0)
                {
                    createReportService.UploadLog(templateLogEntity, fsList[0].FileFullName);
                }
                js.sMeg = "上传成功";
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