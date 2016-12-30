using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using AuditEntity;
using AuditService;
using AuditSPI;
using CtTool;
using AuditEntity.AuditPaper;


namespace Audit.Actions
{
    public class ReportClassifyAction:BaseAction
    {
        public ReportClassifyService reportClassifyservice = new ReportClassifyService();
        public override void GoToMethod(string methodName)
        {
            switch (methodName)
            {
                case "AddClassifyEntity":
                case "EditClassifyEntity":
                case "DeleteClassifyEntity":
                case "GetClassifyEntity":
                case "GetReportsByClassify":
                case "GetUnClassifyReports":
                    ReportClassifyEntity rce = ActionTool.DeserializeParameters<ReportClassifyEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<ReportClassifyAction>(this, methodName, rce);
                    break;
                case "GetClassifiesList":
                    rce = ActionTool.DeserializeParameters<ReportClassifyEntity>(context, actionType);
                    GetClassifiesList(rce);
                    break;
                case "SaveReports":
                    string rowstr = ActionTool.DeserializeParameter("rows", context).ToString();
                    List<ReportRelationEntity> rps = JsonTool.DeserializeObject<List<ReportRelationEntity>>(rowstr);
                    string classId = ActionTool.DeserializeParameter("classifyid", context).ToString();
                    SaveReports(rps, classId);
                    break;
            }
        }
        /// <summary>
        /// 获取报表分类列表 
        /// </summary>
        /// <param name="dse"></param>
        public void GetClassifiesList(ReportClassifyEntity rce)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                List<ReportClassifyEntity> List = reportClassifyservice.GetClassifiesList(rce);
                Dictionary<string, List<ReportClassifyEntity>> dic = new Dictionary<string, List<ReportClassifyEntity>>();
                dic.Add("Rows", List);
                js.obj = dic;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 保存报表分类
        /// </summary>
        /// <param name="dse"></param>
        public void AddClassifyEntity(ReportClassifyEntity rce)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                 
                reportClassifyservice.AddClassifyEntity(rce);
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
        /// 修改报表分类
        /// </summary>
        /// <param name="dse"></param>
        public void EditClassifyEntity(ReportClassifyEntity rce)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                reportClassifyservice.EditClassifyEntity(rce);
                js.success = true;
                js.sMeg = "修改成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 删除分类
        /// </summary>
        /// <param name="dse"></param>
        public void DeleteClassifyEntity(ReportClassifyEntity rce)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                reportClassifyservice.DeleteClassifyEntity(rce);
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
        /// 获取分类下的报表
        /// </summary>
        /// <param name="dse"></param>
        public void GetReportsByClassify(ReportClassifyEntity rce)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                List<ReportFormatDicEntity>reports = reportClassifyservice.GetReportsByClassify(rce);
                Dictionary<string, List<ReportFormatDicEntity>> dic = new Dictionary<string, List<ReportFormatDicEntity>>();
                dic.Add("Rows", reports);
                js.success = true;
                js.obj = dic;  
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 获取未分类报表
        /// </summary>
        /// <param name="dse"></param>
        public void GetUnClassifyReports(ReportClassifyEntity rce)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                List<ReportFormatDicEntity> reports = reportClassifyservice.GetUnClassifyReports();
                Dictionary<string, List<ReportFormatDicEntity>> dic = new Dictionary<string, List<ReportFormatDicEntity>>();
                dic.Add("Rows", reports);
                js.success = true;
                js.obj = dic;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 获取分类
        /// </summary>
        /// <param name="dse"></param>
        public void GetClassifyEntity(ReportClassifyEntity rce)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                ReportClassifyEntity reportclassfyEntity = reportClassifyservice.GetClassifyEntity(rce);
                JsonTool.WriteJson<ReportClassifyEntity>(reportclassfyEntity, context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 获取保存报表分类调整
        /// </summary>
        /// <param name="dse"></param>
        public void SaveReports(List<ReportRelationEntity> rps ,string classId)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                reportClassifyservice.SaveReports(rps,classId);
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
    }
}