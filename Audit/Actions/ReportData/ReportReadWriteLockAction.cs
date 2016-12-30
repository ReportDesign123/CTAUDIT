using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CtTool;
using AuditSPI;
using AuditService.ReportState;
using AuditSPI.ReportData;
using AuditEntity.ReportState;

namespace Audit.Actions.ReportData
{
    public class ReportReadWriteLockAction:BaseAction
    {
        ReportLockService reportLockService;
        public ReportReadWriteLockAction()
        {
            if (reportLockService == null)
            {
                reportLockService = new ReportLockService();
            }
        }

        public override void GoToMethod(string methodName)
        {
            switch (methodName)
            {
                case "GetReportLockEntiesDataGrid":
                    DataGrid<ReportLockEntity> dg = new DataGrid<ReportLockEntity>();
                    dg = ActionTool.DeserializeParametersByFields<DataGrid<ReportLockEntity>>(context, actionType);
                    ReportLockEntity rle = ActionTool.DeserializeParameters<ReportLockEntity>(context,actionType);
                    GetReportLockEntiesDataGrid(dg, rle);
                    break;
                case "RemoveLock":
                    ReportDataParameterStruct rdps = ActionTool.DeserializeParametersByFields<ReportDataParameterStruct>(context,actionType);
                    ActionTool.InvokeObjMethod<ReportReadWriteLockAction>(this, methodName, rdps);
                    break;
                case"RemoveLocks":
                    string ids = ActionTool.DeserializeParameter("Ids",context).ToString();
                    ActionTool.InvokeObjMethod<ReportReadWriteLockAction>(this, methodName, ids);
                    break;
            }
        }
        public void GetReportLockEntiesDataGrid(DataGrid<ReportLockEntity> dg,ReportLockEntity rle){
            try
            {
                DataGrid<ReportLockEntity> datagrid = reportLockService.GetReportLockEntiesDataGrid(dg, rle);
                JsonTool.WriteJson<DataGrid<ReportLockEntity>>(datagrid, context);
            }
            catch (Exception ex) {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
        public void RemoveLock(ReportDataParameterStruct rdps)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                reportLockService.RemoveLock(rdps);
                js.success = true;
                js.sMeg = "解锁成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
        }
        public void RemoveLocks(string ids) {
            JsonStruct js = new JsonStruct();
            try
            {
                reportLockService.RemoveLocks(ids);
                js.success = true;
                js.sMeg = "解锁成功";
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