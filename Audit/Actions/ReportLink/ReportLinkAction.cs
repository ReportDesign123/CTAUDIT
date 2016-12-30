using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CtTool;
using AuditSPI.ReportLink;
using AuditEntity.ReportLink;
using AuditService.ReportLink;
using AuditSPI;
using AuditSPI.ReportAudit;
using GlobalConst;


namespace Audit.Actions.ReportLink
{
    public class ReportLinkAction:BaseAction
    {
        IReportLink reportLinkService;
        public ReportLinkAction() {
            if (reportLinkService == null) {
                reportLinkService = new ReportLinkService();
            }
        }
        public override void GoToMethod(string methodName)
        {
            switch (methodName)
            {
                case "GetReportLinkList":
                case "SaveReportLink":
                    ReportLinkEntity rle = ActionTool.DeserializeParameters<ReportLinkEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<ReportLinkAction>(this, methodName, rle);
                    break;
                case "DeleteReportLink":
                    string Ids = ActionTool.DeserializeParameter("Ids", context).ToString();
                    ActionTool.InvokeObjMethod<ReportLinkAction>(this, methodName, Ids);
                    break;
                case "GetReportLinkData":
                    string data = Convert.ToString( ActionTool.DeserializeParameter("data", context));
                    string linkId=Convert.ToString(ActionTool.DeserializeParameter("linkId",context));
                    GetReportLinkData(data,linkId);
                    break;
            }
        }
        /// <summary>
        /// 保存联查信息
        /// </summary>
        /// <param name="ReportLinkStr"></param>
        public void SaveReportLink(ReportLinkEntity ReportLinkEntity)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                reportLinkService.SaveReportLink(ReportLinkEntity);
                js.obj = ReportLinkEntity;
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
        /// 删除记录
        /// </summary>
        /// <param name="ReportLinkEntity"></param>
        public void DeleteReportLink(string Ids)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                string [] IdArr  = Ids.Split(',');
                foreach (string Id in IdArr) {
                    ReportLinkEntity rle = new ReportLinkEntity();
                    rle.Id = Id;
                    reportLinkService.DeleteReportLink(rle);
                }
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
        /// 获取联查列表
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="rle"></param>
        public void GetReportLinkList(ReportLinkEntity rle)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                List<ReportLinkEntity> list = reportLinkService.GetReportLinkList(rle);
                js.success = true;
                js.obj = list;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }

        public void GetReportLinkData(string data,string linkId)
        {
            try
            {
                ReportCellStruct cellStruct = JsonTool.DeserializeObject<ReportCellStruct>(data);
                ReportLinkEntity reportLink = reportLinkService.GetReportLinkEntity(linkId);
                if (reportLink.Type == ReportLinkConst.ReportLink)
                {
                    ReportLinkStruct rls = JsonTool.DeserializeObject<ReportLinkStruct>(reportLink.Definition);
                    ReportAuditStruct ras = reportLinkService.GetReportLinkData(cellStruct, rls);
                    JsonTool.WriteJson<ReportAuditStruct>(ras, context);
                }
                else if (reportLink.Type == ReportLinkConst.CustomLink_Formular)
                {
                    CustomLinkStruct cls = JsonTool.DeserializeObject<CustomLinkStruct>(reportLink.Definition);
                    CustomerGridDataStruct cgds = reportLinkService.GetCustomLinkData(cellStruct, cls);
                    JsonTool.WriteJson<CustomerGridDataStruct>(cgds, context);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}