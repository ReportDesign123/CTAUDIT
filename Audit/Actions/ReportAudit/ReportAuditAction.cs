using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using AuditSPI.ReportAudit;
using AuditService.ReportAudit;
using AuditSPI;
using AuditEntity.ReportAudit;
using CtTool;
using AuditService;
using AuditService.ReportState;
using AuditService.ReportProblem;
using AuditService.ReportData;
using AuditSPI.ReportData;
using AuditEntity.ReportProblem;
using AuditExportImport.AuditProblem;


using System.IO;


namespace Audit.Actions.ReportAudit
{
    public class ReportAuditAction:BaseAction
    {
        IReportAudit reportAuditService;
        ReportAuditDefinitionService reportAuditDefinitionService;
        ReportFormatService reportFormatService;
        FillReportService reportDataService;
        ReportStateService reportStateService;
        ReportProblemServicecs reportProblemService;
        ReportAuditCellIndexData reportAuditCellIndexData;
        private static string ProblemPath = "~/ct/attatchs/problemDir";
        
        public ReportAuditAction()
        {
            if (reportAuditService == null)
            {
                reportAuditService = new ReportAuditService();
            }
            reportFormatService = new ReportFormatService();
            reportDataService = new FillReportService();
            reportStateService = new ReportStateService();
            reportProblemService = new ReportProblemServicecs();
            reportAuditDefinitionService = new ReportAuditDefinitionService();
            reportAuditCellIndexData = new ReportAuditCellIndexData();
        }


        public override void GoToMethod(string methodName)
        {
            switch (methodName)
            {
                case "DataGridReportAuditEntity":
                    DataGrid<ReportAuditEntity> dg = ActionTool.DeserializeParametersByFields<DataGrid<ReportAuditEntity>>(context, actionType);
                    ReportAuditEntity rae = ActionTool.DeserializeParameters<ReportAuditEntity>(context, actionType);
                    DataGridReportAuditEntity(dg, rae);
                    break;
                case "GetReportAuditData":
                    ReportDataParameterStruct rdps = ActionTool.DeserializeParametersByFields<ReportDataParameterStruct>(context, actionType);
                    ActionTool.InvokeObjMethod<ReportAuditAction>(this, methodName, rdps);
                    break;
                case "GetProblemsList":
                    string Id =Convert.ToString( ActionTool.DeserializeParameter("Id", context));
                    ActionTool.InvokeObjMethod<ReportAuditAction>(this, methodName, Id);
                    break;
                case "Update":
                    rae = ActionTool.DeserializeParameters<ReportAuditEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<ReportAuditAction>(this, methodName, rae);
                    break;
                case "AuditClose":
                case "CancelAuditClose":
                    string Ids = Convert.ToString(ActionTool.DeserializeParameter("Ids",context));
                    ActionTool.InvokeObjMethod<ReportAuditAction>(this, methodName, Ids);
                    break;
                case "ExportProblems":
                    object datas = ActionTool.DeserializeParameter("Datas", context);
                    ExportProblems(Convert.ToString(datas));
                    break;
                case "SaveAuditDefinition":
                    string dataStr = Convert.ToString(ActionTool.DeserializeParameter("data", context));
                    ActionTool.InvokeObjMethod<ReportAuditAction>(this, methodName, dataStr);
                    break;
                case"GetAuditDefinition":
                    ReportAuditDefinitionEntity rade = ActionTool.DeserializeParameters<ReportAuditDefinitionEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<ReportAuditAction>(this, methodName, rade);
                    break;
                case "GetReportCellConclusionAndDiscription":
                case "SaveReportCellIndexConclusion":
                    ReportAuditCellConclusion racc = ActionTool.DeserializeParameters<ReportAuditCellConclusion>(context, actionType);
                    ActionTool.InvokeObjMethod<ReportAuditAction>(this, methodName, racc);
                    break;
                case "GetRelationsIndexesData":
                    racc = ActionTool.DeserializeParameters<ReportAuditCellConclusion>(context, actionType);
                    string des = Convert.ToString(ActionTool.DeserializeParameter("des", context));
                    GetRelationsIndexesData(racc, des);
                    break;
                case "GetIndexTrendChartData":
                    racc = ActionTool.DeserializeParameters<ReportAuditCellConclusion>(context, actionType);
                    des = Convert.ToString(ActionTool.DeserializeParameter("des", context));
                    GetIndexTrendChartData(racc, des);
                    break;
                case"GetIndexConstitutionCellDefinitionData":
                    racc = ActionTool.DeserializeParameters<ReportAuditCellConclusion>(context, actionType);
                    des = Convert.ToString(ActionTool.DeserializeParameter("des", context));
                    GetIndexConstitutionCellDefinitionData(racc, des);
                    break;
                case"GetReportLikData":
                    racc = ActionTool.DeserializeParameters<ReportAuditCellConclusion>(context, actionType);
                    des = Convert.ToString(ActionTool.DeserializeParameter("des", context));
                    GetReportLikData(racc, des);
                    break;
                case"GetCustomerReportLinkData":
                    racc = ActionTool.DeserializeParameters<ReportAuditCellConclusion>(context, actionType);
                    des = Convert.ToString(ActionTool.DeserializeParameter("des", context));
                    GetCustomerReportLinkData(racc, des);
                    break;
            }
        }

        public void DataGridReportAuditEntity(AuditSPI.DataGrid<ReportAuditEntity> dataGrid, ReportAuditEntity rae)
        {
            try
            {
                DataGrid<ReportAuditEntity> dg = reportAuditService.DataGridReportAuditEntity(dataGrid, rae);
                foreach (ReportAuditEntity r in dg.rows)
                {
                    ReportProblemEntity p = new ReportProblemEntity();
                    p.TaskId = rae.TaskId;
                    p.PaperId = rae.PaperId;
                    p.ReportId = r.ReportId;
                    p.CompanyId = r.CompanyId;
                    p.Year = rae.Year;
                    p.Zq = rae.Zq;
                    Dictionary<string,int> temp= reportProblemService.GetProblemProcessData(p);
                    if (temp.ContainsKey("0"))
                    {
                        r.NotProcessNumber=temp["0"];
                    }
                    if (temp.ContainsKey("1"))
                    {
                        r.ProcessNumber = temp["1"];
                    }
                }
                JsonTool.WriteJson<DataGrid<ReportAuditEntity>>(dg, context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
        /// <summary>
        /// 根据报表参数获取报表审计相关的数据
        /// </summary>
        /// <param name="reportParameter"></param>
        /// <returns></returns>
        public void  GetReportAuditData(AuditSPI.ReportData.ReportDataParameterStruct reportParameter)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                ReportAuditStruct ras = new ReportAuditStruct();
                ras.reportFormat = reportFormatService.LoadReportFormatNotInclueFormular(reportParameter.ReportId);
                ras.reportData = reportDataService.LoadReportDatas(reportParameter);
                //获取审计信息
                ReportAuditEntity rae = new ReportAuditEntity();
                rae.TaskId = reportParameter.TaskId;
                rae.PaperId = reportParameter.PaperId;
                rae.CompanyId = reportParameter.CompanyId;
                rae.ReportId = reportParameter.ReportId;
                rae.Year = reportParameter.Year;
                rae.Zq = reportParameter.Cycle;
                ras.reportAudit = reportAuditService.GetReportAudit(rae);
                //获取审计问题
                if (ras.reportAudit != null)
                {
                    ras.reportProblems = reportProblemService.GetReportProblems(ras.reportAudit.Id);
                }
                //获取审计单元格的联查信息 
                ReportAuditDefinitionEntity rade = new ReportAuditDefinitionEntity();
                rade.TaskId = reportParameter.TaskId;
                rade.PaperId = reportParameter.PaperId;
                rade.ReportId = reportParameter.ReportId;
                ras.reportCellsDefinition = reportAuditDefinitionService.GetAuditDefinition(rade);

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

        public void GetProblemsList(string auditId)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                List<AuditEntity.ReportProblem.ReportProblemEntity> lists = reportProblemService.GetReportProblems(auditId);
                js.obj = lists;
                js.success = true;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.Message);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);       
        }

        public void AuditClose(string ids)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                reportAuditService.AuditClose(ids, true);
                js.success = true;
                js.sMeg = "封存成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.Message);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);       
        }

        public void CancelAuditClose(string ids)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                reportAuditService.AuditClose(ids, false);
                js.success = true;
                js.sMeg = "封存成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.Message);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }

        /// <summary>
        /// 导出审计问题
        /// </summary>
        /// <param name="datas"></param>
        public void ExportProblems(string datas)
        {
            try
            {
                List<ReportAuditEntity> audits = JsonTool.DeserializeObject<List<ReportAuditEntity>>(datas);
                string dir =  context.Server.MapPath(ProblemPath);

                if (!Directory.Exists(dir))
                {
                    Directory.CreateDirectory(dir);
                }
                
                 string filePath = dir + @"/temp.xls";
                 if (File.Exists(filePath))
                 {
                     File.Delete(filePath);
                 }
                Dictionary<string,string> titles=new Dictionary<string,string>();
                titles.Add("Title","标题");
                titles.Add("DependOn","问题依据");
                titles.Add("Content","内容");
                titles.Add("Rank","问题等级");
                titles.Add("Type","问题类型");
                AuditProblemExport ape = new AuditProblemExport();
                ape.CreateWorkBook("济南宾朋信息科技有限公司");
                foreach (ReportAuditEntity audit in audits)
                {
                    string fileName = audit.ReportName+"("+audit.CompanyName+")";
                    List<ReportProblemEntity> problems = reportProblemService.ExportReportProblems(audit.Id);
                    
                    ape.ExportReportProblems(filePath, fileName, problems, titles);
                }
                ape.WriteToFile(filePath);
                FileInfo fi = new FileInfo(filePath);
                context.Response.ClearContent();
                context.Response.ClearHeaders();
                context.Response.ContentType = "application/octet-stream";
                context.Response.AddHeader("Content-Disposition", "attachment;filename=temp.xls");
                context.Response.AddHeader("Content-Length", fi.Length.ToString());
                context.Response.AddHeader("Content-Transfer-Encoding", "binary");
                context.Response.WriteFile(fi.FullName);
              
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.Message);
                JsonTool.WriteJson<string>(ex.Message,context);
            }
            context.Response.Flush(); 
        }
        /// <summary>
        /// 更新报表数据
        /// </summary>
        /// <param name="datas"></param>
        public void Update(ReportAuditEntity rae)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                reportAuditService.Update(rae);
                js.success = true;
                js.sMeg = "更新成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.Message);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }

        #region 审计联查相关方法
        /// <summary>
        /// 保存审计联查定义
        /// </summary>
        /// <param name="datas"></param>
        public void SaveAuditDefinition(string dataStr)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                Dictionary<string, ReportAuditDefinitionEntity> auditDefinitionMaps = JsonTool.DeserializeObject<Dictionary<string, ReportAuditDefinitionEntity>>(dataStr);
                reportAuditDefinitionService.SaveAuditDefinition(auditDefinitionMaps);
                js.success = true;
                js.sMeg = "更新成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.Message);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 获取报表审计联查属性
        /// </summary>
        /// <param name="datas"></param>
        public void GetAuditDefinition(ReportAuditDefinitionEntity rade)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                Dictionary<string, ReportAuditDefinitionEntity> dtRade =reportAuditDefinitionService.GetAuditDefinition(rade);
                js.obj = dtRade;
                js.success = true;
                js.sMeg = "获取成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.Message);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 获取审计联查 结论 和描述
        /// </summary>
        /// <param name="racc"></param>
        public void GetReportCellConclusionAndDiscription(ReportAuditCellConclusion racc) {
            JsonStruct js = new JsonStruct();
            try
            {
                racc = reportAuditCellIndexData.GetReportCellConclusionAndDiscription(racc);
                js.obj = racc;
                js.success = true;
                js.sMeg = "获取成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.Message);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        
        }
        /// <summary>
        /// 保存或更新指标结论
        /// </summary>
        /// <param name="racc"></param>
        public void SaveReportCellIndexConclusion(ReportAuditCellConclusion racc)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                reportAuditCellIndexData.SaveReportCellIndexConclusion(racc);
                js.success = true;
                js.sMeg = "保存成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.Message);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        
        }
        /// <summary>
        /// 获取相关指标
        /// </summary>
        /// <param name="racc"></param>
        /// <param name="irs"></param>
        public void GetRelationsIndexesData(ReportAuditCellConclusion racc, string des)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                IndexRelationsStruct irs = JsonTool.DeserializeObject<IndexRelationsStruct>(des);
                RelationsIndexesDataStruct rids = reportAuditCellIndexData.GetRelationsIndexes(racc, irs);
                js.obj = rids;
                js.success = true;
                js.sMeg = "获取成功";
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
        /// <param name="irs"></param>
        public void GetIndexTrendChartData(ReportAuditCellConclusion racc, string des)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                IndexTrendStruct indexTrendStruct = JsonTool.DeserializeObject<IndexTrendStruct>(des);
                ChartDataStruct cds = reportAuditCellIndexData.GetIndexTrend(racc, indexTrendStruct);
                js.obj = cds;
                js.success = true;
                js.sMeg = "获取成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.Message);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);

        }
        /// <summary>
        /// 获取联查指标数据
        /// </summary>
        /// <param name="racc"></param>
        /// <param name="des"></param>
        public void GetIndexConstitutionCellDefinitionData(ReportAuditCellConclusion racc, string des)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                IndexConstitutionStruct indexConstitution = JsonTool.DeserializeObject<IndexConstitutionStruct>(des);
                List<IndexConstitutionCellDifinition> data = reportAuditCellIndexData.GetIndexConstitutionCellDefinition(racc, indexConstitution);
                js.obj = data;
                js.success = true;
                js.sMeg = "获取成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.Message);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);

        }
        /// <summary>
        /// 获取报表联查数据
        /// </summary>
        /// <param name="racc"></param>
        /// <param name="des"></param>
        public void GetReportLikData(ReportAuditCellConclusion racc, string des)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                ReportJoinReportDefinition reportJoinDefinition = JsonTool.DeserializeObject<ReportJoinReportDefinition>(des);
                ReportAuditStruct data = reportAuditCellIndexData.GetReportLikData(racc, reportJoinDefinition);
                js.obj = data;
                js.success = true;
                js.sMeg = "获取成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.Message);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        public void GetCustomerReportLinkData(ReportAuditCellConclusion racc, string des)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                CustomerJoinStruct reportJoinDefinition = JsonTool.DeserializeObject<CustomerJoinStruct>(des);
                CustomerGridDataStruct data = reportAuditCellIndexData.GetCustomerReportLinkData(racc, reportJoinDefinition);
                js.obj = data;
                js.success = true;
                js.sMeg = "获取成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.Message);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        #endregion
    }
}