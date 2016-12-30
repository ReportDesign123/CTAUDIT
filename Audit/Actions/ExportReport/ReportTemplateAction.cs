using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CtTool;
using AuditService.ExportReport;
using AuditSPI.ExportReport;
using AuditEntity.ExportReport;
using AuditSPI;
using System.IO;
using AuditExportImport.ExportReport;

namespace Audit.Actions.ExportReport
{
    public class ReportTemplateAction:BaseAction
    {
        IReportTemplate reportTemplateService;
        ITemplateAndCompany templateAndCompanieyService;
        IReportTemplateBookmark templateBookmarkService;
        IBookmarkTemplate bookMarkServicr;
        public ReportTemplateAction()
        {
            if (reportTemplateService == null)
            {
                reportTemplateService = new ReportTemplateService();
            }
            if (templateAndCompanieyService==null)
            {
                templateAndCompanieyService = new TemplateAndCompanieyService();
            }
            if (templateBookmarkService == null) {
                templateBookmarkService = new ReportTemplateService();
            }
            if (bookMarkServicr == null) {
                bookMarkServicr = new BookmarkTemplateService();
            }
        }
        public override void GoToMethod(string methodName)
        {
            switch (methodName)
            {
                case "GetReportTemplateDataGrid":
                    ReportTemplateEntity rte = ActionTool.DeserializeParameters<ReportTemplateEntity>(context, actionType);
                    DataGrid<ReportTemplateEntity> dataGrid = ActionTool.DeserializeParametersByFields<DataGrid<ReportTemplateEntity>>(context, actionType);
                    GetReportTemplateDataGrid(dataGrid, rte);
                    break;
                case "SaveReportTemplate":
                case"EditReportTemplate":
                case"DeleteReportTemplate":
                case "TemplateAndCompanies":
                case "UploadTemplate":
                case"DownloadTemplate":
                case"GetWordTemplateStruct":
                    rte = ActionTool.DeserializeParameters<ReportTemplateEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<ReportTemplateAction>(this, methodName, rte);
                    break;
                case"BatchUpdate":
                    string Id = Convert.ToString(ActionTool.DeserializeParameter("Id", context));
                    string companies = Convert.ToString(ActionTool.DeserializeParameter("companies", context));
                    BatchUpdate(Id, companies);
                    break;
                case "SaveWordTemplateStruct":
                    string wordTemplateStr = Convert.ToString(ActionTool.DeserializeParameter("para", context));
                    ActionTool.InvokeObjMethod<ReportTemplateAction>(this, methodName, wordTemplateStr);
                    break;
                case "GetBookmarkTemplateDataGrid":
                    BookmarkTemplateEntity bte = ActionTool.DeserializeParameters<BookmarkTemplateEntity>(context, actionType);
                    DataGrid<BookmarkTemplateEntity> MarkDataGrid = ActionTool.DeserializeParametersByFields<DataGrid<BookmarkTemplateEntity>>(context, actionType);
                    GetBookmarkTemplateDataGrid(MarkDataGrid, bte);
                    break;
                case "SaveBookmarkTemplate":
                case "DeleteBookmarkTemplate":
                case "UpdateBookmarkTempalte":
                    bte = ActionTool.DeserializeParameters<BookmarkTemplateEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<ReportTemplateAction>(this, methodName, bte);
                    break;
            }
        }

        /// <summary>
        /// 获取列表
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="reportTemplate"></param>
        public void GetReportTemplateDataGrid(DataGrid<ReportTemplateEntity> dataGrid, ReportTemplateEntity reportTemplate)
        {
            try
            {
                dataGrid = reportTemplateService.GetReportTemplateDataGrid(dataGrid, reportTemplate);
                JsonTool.WriteJson<DataGrid<ReportTemplateEntity>>(dataGrid, context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
        /// <summary>
        /// 新建模板
        /// </summary>
        /// <param name="reportTemplate"></param>
        public void SaveReportTemplate(ReportTemplateEntity reportTemplate)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                reportTemplateService.SaveReportTemplate(reportTemplate);
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
        /// <summary>
        /// 编辑模板
        /// </summary>
        /// <param name="reportTemplate"></param>
        public void EditReportTemplate(ReportTemplateEntity reportTemplate)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                reportTemplateService.EditReportTemplate(reportTemplate);
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
        /// <summary>
        /// 删除模板
        /// </summary>
        /// <param name="reportTemplate"></param>
        public void DeleteReportTemplate(ReportTemplateEntity reportTemplate)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                reportTemplateService.DeleteReportTemplate(reportTemplate);
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
        /// <summary>
        /// 上传模板
        /// </summary>
        /// <param name="reportTemplate"></param>
        public void UploadTemplate(ReportTemplateEntity reportTemplate)
        {
            try
            {
                ReportTemplateEntity rte = reportTemplateService.GetReportTemplate(reportTemplate);
                if (!StringUtil.IsNullOrEmpty(rte.AttatchAddress))
                {
                    if (File.Exists(rte.AttatchAddress))
                    {
                        File.Delete(rte.AttatchAddress);
                    }
                }

               
                //创建文件路径
                string filePath = context.Server.MapPath("~/ct/attatchs/ExportReportAttatch/Template");
                List<FileStruct> fsList = ActionTool.UploadFile(context, filePath);
             

                
                if (fsList.Count > 0)
                {
                    reportTemplate.AttatchAddress = fsList[0].FileFullName;
                    reportTemplate.AttatchName = fsList[0].FileName;

                    //创建HTML页面                
                    string htmlPath = filePath + @"\" + reportTemplate.Id + ".htm";
                    reportTemplate.HtmlAddress = htmlPath;
                    List<string> bookmarks= WordTool.GetWordContentWithBookmarkHtml(reportTemplate, htmlPath);
                    reportTemplateService.UpdateReportTemplateBookmarks(reportTemplate, bookmarks);
                    reportTemplateService.EditReportTemplate(reportTemplate);

                   
                }

            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
        /// <summary>
        /// 下载报告模板
        /// </summary>
        /// <param name="reportTemplate"></param>
        public void DownloadTemplate(ReportTemplateEntity reportTemplate)
        {
            try
            {
                reportTemplate = reportTemplateService.GetReportTemplate(reportTemplate);
                ActionTool.DownloadFile(context, reportTemplate.AttatchAddress, reportTemplate.AttatchName);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
        /// <summary>
        /// 获取模板关联的单位
        /// </summary>
        /// <param name="reportTemplate"></param>
        public void TemplateAndCompanies(ReportTemplateEntity reportTemplate)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                List<TreeNode> data = templateAndCompanieyService.TemplateAndCompanies(reportTemplate);
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
        public void BatchUpdate(string reportTemplateId, string companyStr)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                List<TemplateAndCompanyRelationEntity> companies = JsonTool.DeserializeObject<List<TemplateAndCompanyRelationEntity>>(companyStr);
                templateAndCompanieyService.BatchUpdate(companies, reportTemplateId);
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
        ///  获取审计底稿模板的书签设置
        /// </summary>
        /// <param name="reportTemplate"></param>
        public void GetWordTemplateStruct(ReportTemplateEntity reportTemplate)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                WordTemplateStruct data = templateBookmarkService.GetWordTemplateStruct(reportTemplate);
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
        /// 
        /// </summary>
        /// <param name="wordTemplate"></param>
        public void SaveWordTemplateStruct(string wordTemplateStr)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                WordTemplateStruct wordTemplate = JsonTool.DeserializeObject<WordTemplateStruct>(wordTemplateStr);
                templateBookmarkService.SaveWordTemplateStruct(wordTemplate);
                js.obj = wordTemplate.Bookmarks;
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
        #region 书签模板相关的方法
       /// <summary>
        /// 获取书签模板列表
       /// </summary>
       /// <param name="dataGrid"></param>
       /// <param name="bookmarkTempalte"></param>
        public void GetBookmarkTemplateDataGrid(DataGrid<BookmarkTemplateEntity> dataGrid, BookmarkTemplateEntity bookmarkTempalte)
        {
            try
            {
                dataGrid = bookMarkServicr.GetBookmarkTemplateDataGrid(dataGrid, bookmarkTempalte);
                JsonTool.WriteJson<DataGrid<BookmarkTemplateEntity>>(dataGrid, context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
        /// <summary>
        /// 保存书签模板
        /// </summary>
        /// <param name="bookmarkTempalte"></param>
        public void SaveBookmarkTemplate(BookmarkTemplateEntity bookmarkTempalte)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                bookMarkServicr.SaveBookmarkTemplate(bookmarkTempalte);
                js.sMeg = "保存成功";
                js.success = true;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.obj = bookmarkTempalte;
               js.rank= ExceptionTool.GetExceptionRank(ex);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 更新书签模板
        /// </summary>
        /// <param name="bookmarkTempalte"></param>
        public void UpdateBookmarkTempalte(BookmarkTemplateEntity bookmarkTempalte)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                bookMarkServicr.UpdateBookmarkTempalte(bookmarkTempalte);
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
        /// 删除书签模板  
        /// </summary>
        /// <param name="bookmarkTempalte"></param>
        public void DeleteBookmarkTemplate(BookmarkTemplateEntity bookmarkTempalte)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                bookMarkServicr.DeleteBookmarkTemplate(bookmarkTempalte);
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

        
        #endregion

    }
}