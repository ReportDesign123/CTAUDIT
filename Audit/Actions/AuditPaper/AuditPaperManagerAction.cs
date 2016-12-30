using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using AuditSPI.AuditPaper;
using AuditSPI;
using AuditEntity.AuditPaper;
using CtTool;
using AuditService.AuditPaper;
using AuditEntity;

namespace Audit.Actions.AuditPaper
{
    public class AuditPaperManagerAction:BaseAction
    {
        AuditPaperService auditPaperService;
        public AuditPaperManagerAction()
        {
            auditPaperService = new AuditPaperService();
        }
        public override void GoToMethod(string methodName)
        {
            switch (methodName)
            {
                case "Save":
                case "Edit":
                case "Delete":
                case "TreeNodesAuditPaperAuthorities":
                    AuditPaperEntity rte = ActionTool.DeserializeParameters<AuditPaperEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<AuditPaperManagerAction>(this, methodName, rte);
                    break;
                case "getDataGrid":
                    DataGrid<AuditPaperEntity> dg = new DataGrid<AuditPaperEntity>();
                    rte = ActionTool.DeserializeParameters<AuditPaperEntity>(context, actionType);
                    dg = ActionTool.DeserializeParametersByFields<DataGrid<AuditPaperEntity>>(context, actionType);
                    getDataGrid(dg, rte);
                    break;
                case "BatchUpdate":
                    List<AuditPaperAndCompanyEntity> res = ActionTool.DeserializeListParameter<AuditPaperAndCompanyEntity>(context, actionType, "rows");
                    string AuditPaperId = ActionTool.DeserializeParameter("AuditPaperId", context).ToString();
                    BatchUpdate(res, AuditPaperId);
                    break;
                case "GetAuditPaperLists":
                    ActionTool.InvokeObjMethod<AuditPaperManagerAction>(this, methodName, null);
                    break;
                case "GetAuditPaperReportList":
                    object paperId = ActionTool.DeserializeParameter("AuditPaperId", context);
                    ActionTool.InvokeObjMethod<AuditPaperManagerAction>(this, methodName, paperId);
                    break;
                case "BatchUpdataReports":
                    string rowstr = ActionTool.DeserializeParameter("rows", context).ToString();
                    List<AuditPaperAndReportEntity> resr = JsonTool.DeserializeObject<List<AuditPaperAndReportEntity>>(rowstr);
                    string AuditPaperIdR = ActionTool.DeserializeParameter("AuditPaperId", context).ToString();
                    BatchUpdataReports(AuditPaperIdR, resr);
                    break;
               
            }
        }

        public void Save(AuditPaperEntity ape)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                auditPaperService.Save(ape);
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


        public void Edit(AuditPaperEntity ape)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                auditPaperService.Edit(ape);
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

        public void Delete(AuditPaperEntity ape)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                auditPaperService.Delete(ape);
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

        public void getDataGrid(DataGrid<AuditPaperEntity> dataGrid,AuditPaperEntity ape)
        {
            try
            {
                JsonTool.WriteJson<DataGrid<AuditPaperEntity>>(auditPaperService.GetDataGrid(dataGrid, ape), context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace );
            }
        }
        #region 组织机构关系
        public void TreeNodesAuditPaperAuthorities(AuditPaperEntity ape)
        {
            try
            {
                JsonTool.WriteJson<List<TreeNode>>(auditPaperService.TreeNodesAuditPaperAuthorities(ape), context);

            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }

        public void BatchUpdate(List<AuditPaperAndCompanyEntity> apaces, string AuditPaperId)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                auditPaperService.BatchUpdate(apaces,AuditPaperId);
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


        #region 报表子集关系
        public void GetAuditPaperLists()
        {
            try
            {
                List<AuditPaperEntity> papers = auditPaperService.GetAuditPaperLists();
                Dictionary<string, List<AuditPaperEntity>> dic = new Dictionary<string, List<AuditPaperEntity>>();
                dic.Add("Rows", papers);
                JsonTool.WriteJson<Dictionary<string, List<AuditPaperEntity>>>(dic, context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }

        public void GetAuditPaperReportList(string auditPaperId)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                Dictionary<string, List<ReportFormatDicEntity>> dics = auditPaperService.GetAuditPaperReports(auditPaperId);
                Dictionary<string, List<TreeNode>> nodes = new Dictionary<string, List<TreeNode>>();
                List<TreeNode> select=new List<TreeNode>();
                BeanUtil.ConvertTTypeToListTreeNodes<ReportFormatDicEntity>(dics["Select"], select, "Id", "bbName","bbCode");
                nodes.Add("Select", select);

                List<TreeNode> unselect = new List<TreeNode>();
                BeanUtil.ConvertTTypeToListTreeNodes<ReportFormatDicEntity>(dics["UnSelect"], unselect, "Id", "bbName","bbCode");
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

        public void BatchUpdataReports(string AuditPaperId, List<AuditPaperAndReportEntity> apares)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                auditPaperService.BatchUpdataReports(AuditPaperId, apares);
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