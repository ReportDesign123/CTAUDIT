using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using AuditService.ProblemTrace;
using AuditSPI.ProblemTrace;
using AuditSPI;
using AuditEntity.ReportProblem;
using CtTool;
using AuditEntity;
using AuditEntity.AuditPaper;
using AuditService.AuditPaper;
using AuditSPI.AuditPaper;

namespace Audit.Actions.ProblemTrace
{
    public class ProblemTraceAction:BaseAction
    {
        IProblemTrace problemTraceService;
        IAuditPaperAndReports auditPaperAndReports;
        public ProblemTraceAction()
        {
            if (problemTraceService == null)
            {
                problemTraceService = new AuditService.ProblemTrace.ProblemTrace();
            }
            if (auditPaperAndReports == null)
            {
                auditPaperAndReports = new AuditPaperService();
            }
        }
        
        public override void GoToMethod(string methodName)
        {
            switch (methodName)
            {
                case "DataGridReportProblemEntity":
                    DataGrid<ReportProblemEntity> dg = ActionTool.DeserializeParametersByFields<DataGrid<ReportProblemEntity>>(context, actionType);
                    ReportProblemEntity rpe = ActionTool.DeserializeParameters<ReportProblemEntity>(context, actionType);
                    DataGridReportProblemEntity(dg, rpe);
                    break;
                case "AddProblem":
                case "EditProblem":
                case "AddReportProblemReturn":
                    rpe = ActionTool.DeserializeParameters<ReportProblemEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<ProblemTraceAction>(this, methodName, rpe);
                    break;
                case "Delete":
                case "publishProblem":
                case "canclePublishProblem":
                case "cancelFinishProblem":
                case "finishProblem":
                    string ids = ActionTool.DeserializeParameter("ids", context).ToString();
                    ActionTool.InvokeObjMethod<ProblemTraceAction>(this, methodName, ids);
                    break;
                case "GetReportsByPaperId":
                    DataGrid<ReportFormatDicEntity> dgR = ActionTool.DeserializeParametersByFields<DataGrid<ReportFormatDicEntity>>(context, actionType);
                     ReportFormatDicEntity rfde = ActionTool.DeserializeParameters<ReportFormatDicEntity>(context, actionType);
                    string paperId = ActionTool.DeserializeParameter("paperId", context).ToString();
                    GetReportsByPaperId(dgR,paperId,rfde);
                    break;

            }
        }
        /// <summary>
        /// 获取问题列表
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="rpe"></param>
        public void DataGridReportProblemEntity(DataGrid<ReportProblemEntity> dataGrid, ReportProblemEntity rpe)
        {
            try
            {
                JsonTool.WriteJson<DataGrid<ReportProblemEntity>>(problemTraceService.DataGridReportProblemEntity(dataGrid, rpe),context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.Message);
            }
           
        }
        /// <summary>
        /// 增加问题
        /// </summary>
        /// <param name="reportProblemEntity"></param>
        public void AddProblem(ReportProblemEntity reportProblemEntity)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                problemTraceService.AddProblem(reportProblemEntity);
                js.sMeg = "增加成功";
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
        /// 修改问题
        /// </summary>
        /// <param name="reportProblemEntiy"></param>
        public void EditProblem(ReportProblemEntity reportProblemEntiy)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                problemTraceService.EditProblem(reportProblemEntiy);
                js.sMeg = "编辑成功";
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
        /// 删除问题
        /// </summary>
        /// <param name="ids"></param>
        public   void Delete(string ids)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                problemTraceService.Delete(ids);
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
        /// <summary>
        /// 问题下达
        /// </summary>
        /// <param name="ids"></param>
        public void publishProblem(string ids)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                string [] IdArr = ids.Split(',');
                foreach (string Id in IdArr) {
                    ReportProblemEntity reportProblemEntiy = new ReportProblemEntity();
                    reportProblemEntiy.Id = Id;
                    reportProblemEntiy.State = GlobalConst.ReportProblemGlobal.ProblemSate_XD;
                    problemTraceService.ChangeReportProblemState(reportProblemEntiy);
                }
                js.sMeg = "问题下达成功";
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
        /// 取消问题下达
        /// </summary>
        /// <param name="ids"></param>
        public void canclePublishProblem(string ids)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                string[] IdArr = ids.Split(',');
                foreach (string Id in IdArr)
                {
                    ReportProblemEntity reportProblemEntiy = new ReportProblemEntity();
                    reportProblemEntiy.Id = Id;
                    reportProblemEntiy.State = GlobalConst.ReportProblemGlobal.ProblemState_QY;
                    problemTraceService.ChangeReportProblemState(reportProblemEntiy);
                }
                js.sMeg = "问题下达成功";
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
        /// 问题反馈
        /// </summary>
        /// <param name="ids"></param>
        public void AddReportProblemReturn(ReportProblemEntity reportProblemEntiy)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                if (StringUtil.IsNullOrEmpty(reportProblemEntiy.Replay)){
                    reportProblemEntiy.State = GlobalConst.ReportProblemGlobal.ProblemSate_XD;
                }else {
                    reportProblemEntiy.State = GlobalConst.ReportProblemGlobal.ProblemSate_FK;
                }
                problemTraceService.AddReportProblemReturn(reportProblemEntiy);
                js.obj = reportProblemEntiy.Replay;
                js.sMeg = "反馈信息添加成功";
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
        /// 问题结题
        /// </summary>
        /// <param name="ids"></param>
        public void finishProblem(string ids)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                string[] IdArr = ids.Split(',');
                foreach (string Id in IdArr)
                {
                    ReportProblemEntity reportProblemEntiy = new ReportProblemEntity();
                    reportProblemEntiy.Id = Id;
                    reportProblemEntiy.State = GlobalConst.ReportProblemGlobal.ProblemState_FC;
                    problemTraceService.ChangeReportProblemState(reportProblemEntiy);
                }
                js.sMeg = "结题成功";
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
        /// 取消结题
        /// </summary>
        /// <param name="ids"></param>
        public void cancelFinishProblem(string ids)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                string[] IdArr = ids.Split(',');
                foreach (string Id in IdArr)
                {
                    ReportProblemEntity reportProblemEntiy = new ReportProblemEntity();
                    reportProblemEntiy.Id = Id;
                    reportProblemEntiy.State = GlobalConst.ReportProblemGlobal.ProblemSate_FK;
                    problemTraceService.ChangeReportProblemState(reportProblemEntiy);
                }
                js.sMeg = "取消成功";
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
        /// 根据底稿Id获取报表列表
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="PaperId"></param>
        /// <param name="rfde"></param>
       public void GetReportsByPaperId(DataGrid<ReportFormatDicEntity> dataGrid, string PaperId, ReportFormatDicEntity rfde)
       {
           try
           {
               JsonTool.WriteJson<DataGrid<ReportFormatDicEntity>>(auditPaperAndReports.GetReportsByPaperId2(dataGrid, PaperId, rfde), context);
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }
    }
}