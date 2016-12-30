using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using AuditEntity.AuditPaper;
using CtTool;
using AuditService.AuditPaper;
using AuditSPI.AuditPaper;
using AuditSPI;
using System.IO;


namespace Audit.Actions.AuditPaper
{
    public class AuditPaperAction:BaseAction
    {
        IReportTemplate reportTemplateService;
        public AuditPaperAction()
        {
            reportTemplateService = new ReportTemplateService();
           
        }
        public override void GoToMethod(string methodName)
        {
            switch (methodName)
            {
                case "Save":
                case "Edit":
                     HttpFileCollection hfc = context.Request.Files;
                     string filePath = "";
                     string fileName = "";
                     string fileRealPath="";
                    for(int i=0;i<hfc.Count;i++){
                        HttpPostedFile hpf = hfc[i];
                         if (hpf.ContentLength > 0)
                         {
                             fileRealPath = hpf.FileName;
                             int index= hpf.FileName.LastIndexOf("\\");
                             fileName = hpf.FileName.Substring(index+1);
                             filePath=context.Server.MapPath("~") + "/ct/attatchs/AuditPaperAttatch/"+fileName;
                             hpf.SaveAs(filePath);
                             
                         }
                     }
                     ReportTemplateEntity rte2=ActionTool.DeserializeParameters<ReportTemplateEntity>(context, actionType);
                     rte2.Route = filePath;
                     rte2.AttatchName = fileRealPath;
                    ActionTool.InvokeObjMethod<AuditPaperAction>(this, methodName, rte2);
                    break;
                case "Delete":
                    ReportTemplateEntity rte=ActionTool.DeserializeParameters<ReportTemplateEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<AuditPaperAction>(this, methodName, rte);
                    break;
                case "getDataGrid":
                     DataGrid<ReportTemplateEntity> dg = new DataGrid<ReportTemplateEntity>();
                    dg = ActionTool.DeserializeParametersByFields<DataGrid<ReportTemplateEntity>>(context, actionType);
                    rte = ActionTool.DeserializeParameters<ReportTemplateEntity>(context, actionType);
                    getDataGrid(dg, rte);
                    break;
            }
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="reportTemplate"></param>
        public void Save(ReportTemplateEntity reportTemplate)
        {
         //   JsonStruct js = new JsonStruct();
            try
            {
                reportTemplateService.Save(reportTemplate);
                context.Response.Redirect("../ct/AuditPaper/AuditPaperReportTemplateManager.aspx");
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
              //  js.sMeg = ex.Message;
            }
          // JsonTool.WriteJson<JsonStruct>(js, context);
            
        }

        public void Edit(ReportTemplateEntity reportTemplate)
        {
         //   JsonStruct js = new JsonStruct();
            try
            {
                ReportTemplateEntity oldEntity = reportTemplateService.Get(reportTemplate.Id);
                if (oldEntity != null && File.Exists(oldEntity.Route))
                {
                    File.Delete(oldEntity.Route);
                }
                reportTemplateService.Edit(reportTemplate);
                context.Response.Redirect("../ct/AuditPaper/AuditPaperReportTemplateManager.aspx");

            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                //js.sMeg = ex.Message;
            }
           // JsonTool.WriteJson<JsonStruct>(js, context);
        }

        public void Delete(ReportTemplateEntity reportTemplate)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                ReportTemplateEntity oldEntity = reportTemplateService.Get(reportTemplate.Id);
                if (oldEntity!=null&&File.Exists(oldEntity.Route))
                {
                    File.Delete(oldEntity.Route);
                }
                reportTemplateService.Delete(reportTemplate);
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

        public void getDataGrid(DataGrid<ReportTemplateEntity> reportTemplates,ReportTemplateEntity rte)
        {
            try
            {
                JsonTool.WriteJson<DataGrid<ReportTemplateEntity>>(reportTemplateService.getDataGrid(reportTemplates,rte), context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
    }
}