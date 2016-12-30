using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using AuditEntity.AuditTask;
using AuditService.AuditTask;
using AuditSPI.AuditTask;
using CtTool;
using AuditEntity;
using AuditSPI;
using AuditEntity.AuditPaper;


namespace Audit.Actions.AuditTask
{
    public class AuditTaskAction:BaseAction
    {
        AuditTaskService auditTaskService;
        public AuditTaskAction()
        {
            auditTaskService = new AuditTaskService();
        }
        public override void GoToMethod(string methodName)
        {
            switch (methodName)
            {
                case "GetDataGrid":
                    DataGrid<AuditTaskEntity> dg = new DataGrid<AuditTaskEntity>();
                    dg = ActionTool.DeserializeParametersByFields<DataGrid<AuditTaskEntity>>(context, actionType);
                    AuditTaskEntity ate = ActionTool.DeserializeParameters<AuditTaskEntity>(context, actionType);
                    GetDataGrid(dg, ate);
                    break;
                case "Save":
                case "Edit":
                case "Delete":
                case "TreeNodesAuditTaskAuthorities":
                     ate = ActionTool.DeserializeParameters<AuditTaskEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<AuditTaskAction>(this, methodName, ate);
                    break;
                case "BatchUpdate":
                    List<AuditTaskAndCompanyEntity> res = ActionTool.DeserializeListParameter<AuditTaskAndCompanyEntity>(context, actionType, "rows");
                    string AuditTaskId = ActionTool.DeserializeParameter("AuditTaskId", context).ToString();
                    BatchUpdate(res, AuditTaskId);
                    break;
                case "GetAuditTaskLists":
                    ActionTool.InvokeObjMethod<AuditTaskAction>(this, methodName, null);
                    break;
                case "GetAuditTaskAuditPapers":
                     object taskId = ActionTool.DeserializeParameter("AuditTaskId", context);
                     ActionTool.InvokeObjMethod<AuditTaskAction>(this, methodName, taskId);
                    break;
                case "BatchUpdataTaskAndPaper":
                    string rowstr = ActionTool.DeserializeParameter("rows", context).ToString();
                    List<AuditTaskAndAuditPaperEntity> resr = JsonTool.DeserializeObject<List<AuditTaskAndAuditPaperEntity>>(rowstr);
                    string taskIdR = ActionTool.DeserializeParameter("AuditTaskId", context).ToString();
                    BatchUpdataTaskAndPaper(taskIdR, resr);
                    break;

            }
        }

        public void GetDataGrid(AuditSPI.DataGrid<AuditEntity.AuditTask.AuditTaskEntity> dg,AuditTaskEntity ate)
        {
            try
            {
                JsonTool.WriteJson<DataGrid<AuditTaskEntity>>(auditTaskService.GetDataGrid(dg,ate), context);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void Save(AuditTaskEntity ate)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                auditTaskService.Save(ate);
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

        public void Edit(AuditTaskEntity ate)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                auditTaskService.Edit(ate);
                js.success = true;
                js.sMeg = "编辑成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }

        public void Delete(AuditTaskEntity ate)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                auditTaskService.Delete(ate);
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


        #region 审计任务与组织机构
        public void  TreeNodesAuditTaskAuthorities(AuditTaskEntity ate)
        {
            try
            {
                JsonTool.WriteJson<List<TreeNode>>(auditTaskService.TreeNodesAuditTaskAuthorities(ate), context);

            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }

        public void BatchUpdate(List<AuditTaskAndCompanyEntity> ataces, string AuditTaskId)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                auditTaskService.BatchUpdate(ataces, AuditTaskId);
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
        #endregion



        #region 审计任务与审计底稿关系
        public void GetAuditTaskLists()
        {

            try
            {
                List<AuditTaskEntity> tasks = auditTaskService.GetAuditTaskLists();
                Dictionary<string, List<AuditTaskEntity>> dic = new Dictionary<string, List<AuditTaskEntity>>();
                dic.Add("Rows", tasks);
                JsonTool.WriteJson<Dictionary<string, List<AuditTaskEntity>>>(dic, context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }


        public void  GetAuditTaskAuditPapers(string AuditTaskId)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                Dictionary<string, List<AuditPaperEntity>> dics = auditTaskService.GetAuditTaskAuditPapers(AuditTaskId);
                Dictionary<string, List<TreeNode>> nodes = new Dictionary<string, List<TreeNode>>();
                List<TreeNode> select = new List<TreeNode>();
                BeanUtil.ConvertTTypeToListTreeNodes<AuditPaperEntity>(dics["Select"], select, "Id", "Name","Code");
                nodes.Add("Select", select);

                List<TreeNode> unselect = new List<TreeNode>();
                BeanUtil.ConvertTTypeToListTreeNodes<AuditPaperEntity>(dics["UnSelect"], unselect, "Id", "Name","Code");
                nodes.Add("UnSelect", unselect);
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


        public void BatchUpdataTaskAndPaper(string AuditTaskId, List<AuditTaskAndAuditPaperEntity> apares)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                auditTaskService.BatchUpdataTaskAndPaper(AuditTaskId, apares);
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

        #endregion
    }
}