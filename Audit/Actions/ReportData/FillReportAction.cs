using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CtTool;
using AuditSPI;
using AuditSPI.AuditTask;
using AuditEntity.AuditTask;
using AuditService.AuditTask;
using AuditEntity.AuditPaper;
using AuditEntity;
using AuditService.ReportData;
using AuditService;
using AuditSPI.ReportData;
using AuditService.ReportState;
using AuditSPI.ReportState;
using AuditEntity.ReportState;
using GlobalConst;
using AuditService.WorkFlow;
using AuditEntity.WorkFlow;
using AuditSPI.WorkFlow;
using AuditService.ReportAttatchment;



namespace Audit.Actions.ReportData
{
    public class FillReportAction :BaseAction
    {
        AuditTaskService ats;
        FillReportService fillReportService;
        ICompanyService companyService;
        IReportCycle reportCycleService;
        FormularService formularService;
        ReportStateService reportStateService;
        IReportHigherExamine HigherExamineService;
        WorkFlowDefinitionService workFlowDefinitionService;
        ReportProcessManager reportProcessManager;
        ReportAttatchmentService reportAttatchService;
        public FillReportAction()
        {
            ats = new AuditTaskService();
            fillReportService = new FillReportService();
            companyService = new CompanyService();
            reportCycleService = new ReportCycleService();
            formularService = new FormularService();
            reportStateService = new ReportStateService();
            workFlowDefinitionService=new WorkFlowDefinitionService();
            reportProcessManager = new ReportProcessManager();
            HigherExamineService = new ReportStateService();
            reportAttatchService = new ReportAttatchmentService();
        }
        public override void GoToMethod(string methodName)
        {
            switch (methodName)
            {
                
                case "GetAuditTasksDataGrid":
                    DataGrid<AuditTaskEntity> dg = new DataGrid<AuditTaskEntity>();
                    dg = ActionTool.DeserializeParametersByFields<DataGrid<AuditTaskEntity>>(context, actionType);
                    //AuditTaskEntity ate = ActionTool.DeserializeParameters<AuditTaskEntity>(context, actionType);
                    string AuditType = Convert.ToString(ActionTool.DeserializeParameter("AuditType",context));
                    string AuditDate = Convert.ToString(ActionTool.DeserializeParameter("AuditDate",context));
                    GetAuditTasksDataGrid(AuditType, AuditDate,dg);
                    break;
                //case "GetMarcoName":
                //    List<object> MarcoParas = new List<object>();
                //     ReportDataParameterStruct rdpstruct = ActionTool.DeserializeParametersByFields<ReportDataParameterStruct>(context, actionType);
                //     MarcoParas.Add(rdpstruct);
                //     MarcoParas.Add("MarcoName");

                //     object[] objMaros = ActionTool.DeserializeParameters(MarcoParas, context, actionType);
                //     ActionTool.InvokeObjMethod<FillReportAction>(this, methodName, objMaros);
                //    break;
                case "GetAuditPapersAndReports":
                    string taskId = ActionTool.DeserializeParameter("TaskId", context).ToString();
                    ActionTool.InvokeObjMethod<FillReportAction>(this, methodName, taskId);
                break;
                case "GetCompaniesByAuditPaperAndAuthority":
                     string AuditPaperId = ActionTool.DeserializeParameter("AuditPaperId", context).ToString();
                     ActionTool.InvokeObjMethod<FillReportAction>(this, methodName, AuditPaperId);
                break;
                case "GetReportCycle":
                ReportCycleStruct rcs = ActionTool.DeserializeParametersByFields<ReportCycleStruct>(context, actionType);
                ActionTool.InvokeObjMethod<FillReportAction>(this, methodName, rcs);
                break;
                case "SelfCheck":
                case "CancelSelfCheck":
                case "LoadReportDatas":
                case "LoadReportAllDatas":
                case "ClearReportData":
                case "RemoveReportReadWriteState":
                    ReportDataParameterStruct rdps=ActionTool.DeserializeParametersByFields<ReportDataParameterStruct>(context,actionType);
                    ActionTool.InvokeObjMethod<FillReportAction>(this, methodName, rdps);
                    break;
                case "DeserializeVarifyFormular":
                case "DeserializeCaculateFormular":
                case "DeserializeFatchFormular":
                    string dataStr = ActionTool.DeserializeParameter("dataStr", context).ToString();
                    ActionTool.InvokeObjMethod<FillReportAction>(this, methodName, dataStr);
                    break;
                case "SaveReportDatas":
                     List<string> Sparas=new List<string>();
                    Sparas.Add("dataStr");
                    Sparas.Add("BBID");
                    Sparas.Add("formulaStr");
                   // string dataStr = ActionTool.DeserializeParameter("dataStr", context).ToString();
                    object[] sparaobjs = ActionTool.DeserializeParameters(Sparas, context, actionType);
                    ActionTool.InvokeObjMethod<FillReportAction>(this, methodName, sparaobjs);
                    break;
                case "DeleteBdqData":
                    List<string> paras=new List<string>();
                    paras.Add("Id");
                    paras.Add("TableName");
                    object[] paraobjs= ActionTool.DeserializeParameters(paras, context, actionType);
                    ActionTool.InvokeObjMethod<FillReportAction>(this, methodName, paraobjs);
                    break;
              
                case "GetReportExamReportStateDataGrid":
                     ReportStateEntity rse = ActionTool.DeserializeParameters<ReportStateEntity>(context, actionType);
                    DataGrid<ReportStateEntity> rsedg = ActionTool.DeserializeParametersByFields<DataGrid<ReportStateEntity>>(context, actionType);
                    GetReportExamReportStateDataGrid(rsedg, rse);
                    break;
                case "GetReportCancelExamReportStateDataGrid":
                    rse = ActionTool.DeserializeParameters<ReportStateEntity>(context, actionType);
                    rsedg = ActionTool.DeserializeParametersByFields<DataGrid<ReportStateEntity>>(context, actionType);
                    GetReportCancelExamReportStateDataGrid(rsedg, rse);
                    break;
                case"GetHigherExamReportStateDataGrid":
                    rse = ActionTool.DeserializeParameters<ReportStateEntity>(context, actionType);
                    rsedg = ActionTool.DeserializeParametersByFields<DataGrid<ReportStateEntity>>(context, actionType);
                    GetHigherExamReportStateDataGrid(rsedg, rse);
                    break;
                case"GetHigherCancelReportStateDataGrid":
                    rse = ActionTool.DeserializeParameters<ReportStateEntity>(context, actionType);
                    rsedg = ActionTool.DeserializeParametersByFields<DataGrid<ReportStateEntity>>(context, actionType);
                    GetHigherCancelReportStateDataGrid(rsedg, rse);
                    break;
                case "GetAllReportsStateDataGrid":
                     rse = ActionTool.DeserializeParameters<ReportStateEntity>(context, actionType);
                     rsedg = ActionTool.DeserializeParametersByFields<DataGrid<ReportStateEntity>>(context, actionType);
                    GetAllReportsStateDataGrid(rsedg, rse);
                    break;
                case "ExamReportState":
                case "CancelExamedReportState":
                case"HigherCheck":
                case"CancelHigherCheck":
                    rse = ActionTool.DeserializeParameters<ReportStateEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<FillReportAction>(this, methodName, rse);
                    break;

                case "GetMyExamReportHistoryGrid":
                    ReportStateDetailEntity rsde = ActionTool.DeserializeParameters<ReportStateDetailEntity>(context, actionType);
                    DataGrid<ReportStateDetailEntity> rsdedg = ActionTool.DeserializeParametersByFields<DataGrid<ReportStateDetailEntity>>(context, actionType);
                    GetMyExamReportHistoryGrid(rsdedg, rsde);
                    break;
                case "GetExamAllHistoryGrid":
                    rsde = ActionTool.DeserializeParameters<ReportStateDetailEntity>(context, actionType);
                    rsdedg = ActionTool.DeserializeParametersByFields<DataGrid<ReportStateDetailEntity>>(context, actionType);
                    GetExamAllHistoryGrid(rsdedg, rsde);
                    break;
                 
                case "ReportExamineWorkFlowPublish":
                    ConfigEntity ce = ActionTool.DeserializeParameters<ConfigEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<FillReportAction>(this, methodName, ce);
                    break;
                case "GetReportsByAuditPaper":
                    ReportFormatDicEntity rfde = ActionTool.DeserializeParameters<ReportFormatDicEntity>(context, actionType);
                    string auditPaperId =Convert.ToString( ActionTool.DeserializeParameter("auditPaperId",context));
                    GetReportsByAuditPaper(rfde, auditPaperId);
                    break;
                case "GetReportFirstLoadStruct":
                    rdps = ActionTool.DeserializeParametersByFields<ReportDataParameterStruct>(context, actionType);
                     rfde = ActionTool.DeserializeParametersByFields<ReportFormatDicEntity>(context, actionType);
                     GetReportFirstLoadStruct(rdps, rfde);
                    break;
                case "GetReportBatchProcessStruct":
                    rdps = ActionTool.DeserializeParametersByFields<ReportDataParameterStruct>(context, actionType);
                    rfde = ActionTool.DeserializeParametersByFields<ReportFormatDicEntity>(context, actionType);
                    GetReportBatchProcessStruct(rdps, rfde);
                    break;
                case "GetReportWithStateAndAttatch":
                     rdps = ActionTool.DeserializeParametersByFields<ReportDataParameterStruct>(context, actionType);
                     rfde = ActionTool.DeserializeParametersByFields<ReportFormatDicEntity>(context, actionType);
                     GetReportWithStateAndAttatch(rdps, rfde);
                    break;
                case "BatchDeserializeFatchFormular":
                case "BatchDeserializeCaculateFormular":
                case "BatchDeserializeVerifyFormular":
                case "GetListVerifyProblemEntities":
                case "BatchDownLoadAttatches":
                    rdps = ActionTool.DeserializeParametersByFields<ReportDataParameterStruct>(context, actionType);
                    ActionTool.InvokeObjMethod<FillReportAction>(this, methodName, rdps);
                    break;
            }
        }

        public void GetAuditTasksDataGrid(string AuditType, string AuditDate, DataGrid<AuditTaskEntity> dg)
        {
            try
            {
                DataGrid<AuditTaskEntity> dataGrid = ats.GetDataGrid(AuditType,AuditDate,dg);
                JsonTool.WriteJson<DataGrid<AuditTaskEntity>>(dataGrid, context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
        /// <summary>
        /// 获取报表初次加载的信息
        /// </summary>
        /// <param name="rdps"></param>GetReportWithStateAndAttatch
        /// <param name="rfde"></param>
        public void GetReportFirstLoadStruct(ReportDataParameterStruct rdps, ReportFormatDicEntity rfde)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                ReportFirstLoadStruct rfls = fillReportService.GetReportFirstLoadStruct(rdps, rfde);
                js.obj = rfls;
                js.success = true;
            }
            catch (Exception ex)
            {
                js.sMeg = ex.Message;
                LogManager.WriteLog(ex.StackTrace);
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 获取批量处理报表初次加载的信息
        /// </summary>
        /// <param name="rdps"></param>GetReportWithStateAndAttatch
        /// <param name="rfde"></param>
        public void GetReportBatchProcessStruct(ReportDataParameterStruct rdps, ReportFormatDicEntity rfde)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                ReportFirstLoadStruct rfls = fillReportService.GetReportBatchProcessStruct(rdps, rfde);
                //构建树形结构
                BeanUtil.ConvertTTypeToTreeNode<CompanyEntity>(rfls.companies, rfls.companiesTree, "Id", "Name", "ParentId");
                rfls.companies = null;
                js.obj = rfls;
                js.success = true;
            }
            catch (Exception ex)
            {
                js.sMeg = ex.Message;
                LogManager.WriteLog(ex.StackTrace);
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 获取改变月份和公司后的报表信息
        /// </summary>
        /// <param name="rdps"></param>
        /// <param name="rfde"></param>
        public void GetReportWithStateAndAttatch(ReportDataParameterStruct rdps, ReportFormatDicEntity rfde)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                List<ReportFormatDicEntity> ReportList = fillReportService.GetReportWithStateAndAttatch(rdps, rfde);
                Dictionary<string, List<ReportFormatDicEntity>> dic = new Dictionary<string, List<ReportFormatDicEntity>>();
                dic.Add("rows", ReportList);
                js.obj = dic;
                js.success = true;
            }
            catch (Exception ex)
            {
                js.sMeg = ex.Message;
                LogManager.WriteLog(ex.StackTrace);
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }

        /// <summary>
        /// 此方法获取当前任务下的所有审计底稿和所对应的审计报表；
        /// 此方法已经作废；
        /// </summary>
        /// <param name="taskId"></param>
        public void GetAuditPapersAndReports(string taskId)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                List<AuditPaperEntity> papers = fillReportService.GetAuditPaperByAuditTask(taskId);
                Dictionary<string, List<ReportFormatDicEntity>> reports = fillReportService.GetReportsByAuditPapers(papers);
                Dictionary<string, object> navigatorData = new Dictionary<string, object>();
                List<TabStruct> papersTab = new List<TabStruct>();
                foreach (AuditPaperEntity ape in papers)
                {
                    TabStruct ts = new TabStruct();
                    ts.tabid = ape.Id;
                    ts.text = ape.Name;
                    papersTab.Add(ts);
                }

                Dictionary<string, List<TabStruct>> dic = new Dictionary<string, List<TabStruct>>();
                foreach (string  key in reports.Keys)
                {
                    List<TabStruct> lists = new List<TabStruct>();
                    foreach (ReportFormatDicEntity rfd in reports[key])
                    {
                        TabStruct ts = new TabStruct();
                        ts.tabid = rfd.Id;
                        ts.text = rfd.bbName;
                        lists.Add(ts);
                    }
                    dic.Add(key, lists);
                }
                Dictionary<string, object> obj = new Dictionary<string, object>();
                obj.Add("auditPapers",papersTab);
                obj.Add("auditReports", dic);
                js.obj = obj;
                js.success = true;                
            }
            catch (Exception ex)
            {
                js.sMeg = ex.Message;
                LogManager.WriteLog(ex.StackTrace);
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 根据审计底稿获取当前报表子集
        /// </summary>
        /// <param name="rfde"></param>
        /// <param name="auditPaperId"></param>
        public void GetReportsByAuditPaper(ReportFormatDicEntity rfde, string auditPaperId)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                List<ReportFormatDicEntity> reports = fillReportService.GetReportsByAuditPaper(rfde, auditPaperId);                         
                js.obj = reports;
                js.success = true;
            }
            catch (Exception ex)
            {
                js.sMeg = ex.Message;
                LogManager.WriteLog(ex.StackTrace);
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }

        public void GetCompaniesByAuditPaperAndAuthority(string AuditPaperId)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                List<CompanyEntity> nodes = companyService.GetCompaniesByAuditPaperAndAuthority(AuditPaperId);
                js.obj = nodes;
                js.success = true;                
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }

        public void GetReportCycle(ReportCycleStruct cycle)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                ReportCycleStruct rcs = reportCycleService.GetReportCycleData(cycle);
                js.obj = rcs;
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
        /// 加载报表数据
        /// </summary>
        /// <param name="rdps"></param>
        public void LoadReportDatas(ReportDataParameterStruct rdps)
        {
              JsonStruct js = new JsonStruct();
            try
            {
                if (!StringUtil.IsNullOrEmpty(rdps.bdqStr))
                {
                    //获取变动区的辅助信息
                    rdps.bdqMaps = JsonTool.DeserializeObject<Dictionary<string, BdqData>>(rdps.bdqStr);
                }
                //System.Threading.Thread.Sleep(5000);
              ReportDataStruct rds=fillReportService.LoadReportDatas(rdps,true);
              
              rds.IsOrNotLock = reportStateService.GetReportReadWriteState(rdps);
                js.obj = rds;
                js.success = true;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }

        public void LoadReportAllDatas(ReportDataParameterStruct rdps)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                if (!StringUtil.IsNullOrEmpty(rdps.bdqStr))
                {
                    //获取变动区的辅助信息
                    rdps.bdqMaps = JsonTool.DeserializeObject<Dictionary<string, BdqData>>(rdps.bdqStr);
                }
                ReportDataStruct rds = fillReportService.LoadReportDatas(rdps,true);
                rds.IsOrNotLock = reportStateService.GetReportReadWriteState(rdps);
                js.obj = rds;
                js.success = true;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }

        public void GetMarcoName(ReportDataParameterStruct rds, string MarcoName)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                js.obj = fillReportService.GetMarcoName(rds, MarcoName);
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
        public void SaveReportDatas(string dataStr, string BBID, string strFormula)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                ReportDataStruct rds = JsonTool.DeserializeObject<ReportDataStruct>(dataStr);
                fillReportService.SaveReportDatas(rds);
                if (SessoinUtil.GetCurrentUser().Code == "9999")
                    fillReportService.SaveReportFormat(BBID, strFormula);
                js.obj = fillReportService.LoadReportDatas(rds.rdps);
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

        public void DeleteBdqData(string Id, string TableName)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                fillReportService.DeleteBdqData(Id, TableName);
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
        /// 删除报表数据
        /// </summary>
        /// <param name="dataStr"></param>
        public void ClearReportData(ReportDataParameterStruct rdps)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                fillReportService.ClearReportData(rdps);
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

        public void DeserializeFatchFormular(string dataStr)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                ReportDataStruct rds = JsonTool.DeserializeObject<ReportDataStruct>(dataStr);
                formularService.DeserializeFatchFormular(rds);
                js.success = true;
                js.sMeg = "取数成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }

        public void DeserializeCaculateFormular(string dataStr)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                ReportDataStruct rds = JsonTool.DeserializeObject<ReportDataStruct>(dataStr);
                formularService.DeserializeCaculateFormular(rds);
                js.success = true;
                js.sMeg = "计算成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 解析报表校验公式
        /// </summary>
        /// <param name="dataStr"></param>
        public void DeserializeVarifyFormular(string dataStr)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                ReportDataStruct rds = JsonTool.DeserializeObject<ReportDataStruct>(dataStr);
                string result= formularService.DeserializeVarifyFormular(rds);
                js.success = true;
                if (result == "")
                {
                    result = "校验成功";
                }
                js.sMeg =result;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 获取指定报表的校验信息
        /// </summary>
        /// <param name="rdps"></param>
        public void GetListVerifyProblemEntities(ReportDataParameterStruct rdps)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                ReportVerifyService rvs = new ReportVerifyService();
                List<VerifyProblemEntity> list= rvs.GetListVerifyProblemEntities(rdps);
                js.obj = list;
                js.success = true;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        #region 报表状态相关的方法
        /// <summary>
        /// 本级审核
        /// </summary>
        /// <param name="rdps"></param>
        public void SelfCheck(ReportDataParameterStruct rdps)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                ReportStateEntity rse = reportStateService.ConvertReportDataParameterToStateEntity(rdps);
                rse.State = ReportGlobalConst.REPORTSTATE_SELFCHECK;
                //启动审批流程
                //if (reportProcessManager.IsOrNotExamReportAfterSelfCheck())
                //{ 
                //    workFlowDefinitionService.ReportExamine(rse, WorkFlowDirection.Forward);  
                //}
                            

                ReportStateDetailEntity rsde= reportStateService.ConvertReportDataParameterToStateDetailEntity(rdps);
                rsde.State = ReportGlobalConst.REPORTSTATE_SELFCHECK;              
               
                reportStateService.SaveReportSate(rse, rsde);
                js.success = true;
                js.sMeg = "本级审核成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 取消本级审核
        /// </summary>
        /// <param name="rdps"></param>
        public void CancelSelfCheck(ReportDataParameterStruct rdps)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                ReportStateEntity rse = reportStateService.ConvertReportDataParameterToStateEntity(rdps);
                rse.State = ReportGlobalConst.REPORTSTATE_JYTG;
                //关闭审批流程
                //if (reportProcessManager.IsOrNotExamReportAfterSelfCheck())
                //{
                //    rse.CurrentStageState = "";
                //    rse.NextStageState = "";
                //}
               
                
                ReportStateDetailEntity rsde = reportStateService.ConvertReportDataParameterToStateDetailEntity(rdps);
                rsde.State = ReportGlobalConst.REPORTSTATE_JYTG;
                reportStateService.SaveReportSate(rse, rsde);
                js.success = true;
                js.sMeg = "取消本级审核成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        
        /// <summary>
        /// 上级审核
        /// </summary>
        /// <param name="rdps"></param>
        public void HigherCheck(ReportStateEntity state)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                if (state.StageResult == ReportGlobalConst.REPORTEXAM_SUCCESS)
                {
                    state.State = ReportGlobalConst.REPORTSTATE_HigherExam;
                }
                else
                {
                    state.State = ReportGlobalConst.REPORTSTATE_HigherFail;
                }
                HigherExamineService.HigherExamReportState(state);
                js.success = true;
                js.sMeg = "上级审核成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 取消上级审核
        /// </summary>
        /// <param name="rdps"></param>
        public void CancelHigherCheck(ReportStateEntity state)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                state.State = ReportGlobalConst.REPORTSTATE_SELFCHECK;
                HigherExamineService.HigherExamReportState(state);
                js.success = true;
                js.sMeg = "取消成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 获取上级审核列表
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="rse"></param>
        public void GetHigherExamReportStateDataGrid(DataGrid<ReportStateEntity> dataGrid, ReportStateEntity rse)
        {
            try
            {

                DataGrid<ReportStateEntity> dg = HigherExamineService.GetHigherExamOrCancelReportStateDataGrid(dataGrid, rse, true);

                JsonTool.WriteJson<DataGrid<ReportStateEntity>>(dg, context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
        /// <summary>
        /// 获取取消上级审核列表
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="rse"></param>
        public void GetHigherCancelReportStateDataGrid(DataGrid<ReportStateEntity> dataGrid, ReportStateEntity rse)
        {
            try
            {
                DataGrid<ReportStateEntity> dg = reportStateService.GetHigherExamOrCancelReportStateDataGrid(dataGrid, rse, false);
                JsonTool.WriteJson<DataGrid<ReportStateEntity>>(dg, context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
        /// <summary>
        /// 获取当前审核列表
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="rse"></param>
        public void GetReportExamReportStateDataGrid(DataGrid<ReportStateEntity> dataGrid, ReportStateEntity rse)
        {
            try
            {
                DataGrid<ReportStateEntity> dg = reportStateService.GetExamOrCancelReportStateDataGrid(dataGrid, rse,true);
                JsonTool.WriteJson<DataGrid<ReportStateEntity>>(dg, context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
        /// <summary>
        /// 获取反审核列表
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="rse"></param>
        public void GetReportCancelExamReportStateDataGrid(DataGrid<ReportStateEntity> dataGrid, ReportStateEntity rse)
        {
            try
            {
                DataGrid<ReportStateEntity> dg = reportStateService.GetExamOrCancelReportStateDataGrid(dataGrid, rse, false);
                JsonTool.WriteJson<DataGrid<ReportStateEntity>>(dg, context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
    
        /// <summary>
        /// 审核报表资料
        /// sunhaidong
        /// </summary>
        /// <param name="rse">报表资料相关信息</param>
        public  void ExamReportState(ReportStateEntity rse){
            JsonStruct js = new JsonStruct();
            try
            {
                rse.ExamDirection = ReportGlobalConst.REPORTEXAM_EXAM;
                reportStateService.ExamReportState(rse);
                js.success = true;
                js.sMeg = "审核成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 获取审核历史列表
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="rsde"></param>
        public void GetMyExamReportHistoryGrid(DataGrid<ReportStateDetailEntity> dataGrid, ReportStateDetailEntity rsde)
        {
            try
            {
                DataGrid<ReportStateDetailEntity> dg = reportStateService.GetMyExamReportHistoryGrid(dataGrid, rsde);
                JsonTool.WriteJson<DataGrid<ReportStateDetailEntity>>(dg, context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
        /// <summary>
        /// 获取审核历史列表
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="rsde"></param>
        public void GetExamAllHistoryGrid(DataGrid<ReportStateDetailEntity> dataGrid, ReportStateDetailEntity rsde)
        {
            try
            {
                DataGrid<ReportStateDetailEntity> dg = reportStateService.GetAllHistoryGrid(dataGrid, rsde);
                JsonTool.WriteJson<DataGrid<ReportStateDetailEntity>>(dg, context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }



        public void CancelExamedReportState(ReportStateEntity rse)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                rse.ExamDirection = ReportGlobalConst.REPORTEXAM_CANCELEXAM;
                reportStateService.ExamReportState(rse);
                js.success = true;
                js.sMeg = "取消审核成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);

        }


        public void GetAllReportsStateDataGrid(DataGrid<ReportStateEntity> dataGrid, ReportStateEntity rse)
        {
            try
            {
                DataGrid<ReportStateEntity> dg = reportStateService.GetAllReportsStateDataGrid(dataGrid, rse);
                JsonTool.WriteJson<DataGrid<ReportStateEntity>>(dg, context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }

        public void ReportExamineWorkFlowPublish(AuditEntity.ConfigEntity ce)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                reportStateService.ReportExamineWorkFlowPublish(ce);
                js.success = true;
                js.sMeg = "发布成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
           
        }
        /// <summary>
        /// 加锁是在报表获取数据的时候进行加锁
        /// 报表关闭之后，接触读写锁
        /// </summary>
        /// <param name="rdps"></param>
        public void RemoveReportReadWriteState(ReportDataParameterStruct rdps)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                reportStateService.RemoveReportReadWriteState(rdps);
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
        #region 批量操作相关的方法

        /// <summary>
        /// 批量取数
        /// </summary>
        /// <param name="dataStr"></param>
        public void BatchDeserializeFatchFormular(ReportDataParameterStruct rdps)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                string result = formularService.BatchDeserializeFatchFormular(rdps);

                if (result == "")
                {
                    result = "取数成功";
                    js.success = true;
                }
                else
                {
                    js.success = false;
                }
                js.sMeg = result;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 批量计算
        /// </summary>
        /// <param name="dataStr"></param>
        public void BatchDeserializeCaculateFormular(ReportDataParameterStruct rdps)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                string result = formularService.BatchDeserializeCaculateFormular(rdps);

                if (result == "")
                {
                    result = "计算成功";
                    js.success = true;
                }
                else
                {
                    js.success = false;
                }
                js.sMeg = result;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 批量校验
        /// </summary>
        /// <param name="dataStr"></param>
        public void BatchDeserializeVerifyFormular(ReportDataParameterStruct rdps)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                string result = formularService.BatchDeserializeVerifyFormular(rdps);
                js.success = true;
                if (result == "")
                {
                    result = "校验成功";
                }
                js.sMeg = result;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 批量下载
        /// </summary>
        /// <param name="rdps"></param>
        public void BatchDownLoadAttatches(ReportDataParameterStruct rdps)
        {
            try
            {
                string fileDirectory= context.Server.MapPath("~/ct/attatchs/reportAttatch");
                string relativePath = "ct/attatchs/reportAttatch";
                string filePath= reportAttatchService.BatchDownload(rdps, fileDirectory,relativePath);
               // ActionTool.DownloadFile(context, filePath, DateUtil.GetDateShortString(DateTime.Now)+".zip");
                JsonStruct json = new JsonStruct();
                json.obj = @"../../"+filePath;
                json.success = true;
                JsonTool.WriteJson<JsonStruct>(json,context);
                
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.Message);
            }
        }
        #endregion
    }
}