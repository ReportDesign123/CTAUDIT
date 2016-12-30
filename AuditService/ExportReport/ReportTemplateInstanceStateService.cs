using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.ExportReport;
using AuditSPI.ExportReport;
using CtTool;
using DbManager;
using GlobalConst;

namespace AuditService.ExportReport
{
   public  class ReportTemplateInstanceStateService:IReportTemplateInstanceState
    {
       private CTDbManager dbManager;
       private LinqDataManager linqDbManager;
       private ICreateReport createReportService;
       public ReportTemplateInstanceStateService()
       {
           if (dbManager == null)
           {
               dbManager = new CTDbManager();
           }
           if (linqDbManager == null)
           {
               linqDbManager = new LinqDataManager();
           }
           if (createReportService == null)
           {
               createReportService = new CreateReportService();
           }
       }
       /// <summary>
       /// 上级审核模板状态
       /// </summary>
       /// <param name="templateLogEntity"></param>
       public void ExamReport(OperationLogEntity operationLogEntity)
        {
            try
            {
                
                //更新审计底稿模板的状态
                UpdateTemplateLogState(operationLogEntity);
                //日志记录
                string type = "";
                if (operationLogEntity.State == CreateReportConst.TEMPLATESTATE_EXAMSUCCESS)
                {
                    type = "上级审核成功";
                }
                else if (operationLogEntity.State == CreateReportConst.TEMPLATESTATE_EXAMFAIL)
                {
                    type = "上级审核失败";
                }
                InsertTemplateStateLog(operationLogEntity,type);
                
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 更新审计底稿模板的状态
       /// </summary>
       /// <param name="templateLogEntity"></param>
       private void UpdateTemplateLogState(OperationLogEntity operationLogEntity)
        {
            try
            {
                StringBuilder sql = new StringBuilder();
                sql.Append("UPDATE CT_REPORT_TEMPLATELOG SET TEMPLATELOG_STATE='"+operationLogEntity.State+"'");
                sql.Append(" WHERE ");
                sql.Append(" TEMPLATELOG_ID='" + operationLogEntity.TemplateInstanceId+ "'");
                dbManager.ExecuteSql(sql.ToString());
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 保存日志
       /// </summary>
       /// <param name="operationLogEntity"></param>
       /// <param name="stateFlg"></param>
        private void InsertTemplateStateLog(OperationLogEntity operationLogEntity,string type)
        {
            try
            {
                //string type = "";
                //if (operationLogEntity.State == CreateReportConst.TEMPLATESTATE_EXAMSUCCESS)
                //{
                //    type="上级审核成功";
                //}
                //else if (operationLogEntity.State == CreateReportConst.TEMPLATESTATE_EXAMFAIL)
                //{
                //    type="上级审核失败";
                //}
                //else if (operationLogEntity.State == CreateReportConst.TEMPLATESTATE_SEAL)
                //{
                //    type = "审计报告封存";
                //}
                //else if (operationLogEntity.State == CreateReportConst.TEMPLATESTATE_CANCELEXAM)
                //{
                //    type = "取消上级审核";
                //}
                operationLogEntity.Id = Guid.NewGuid().ToString();
                operationLogEntity.Type = type;
                operationLogEntity.Creater = SessoinUtil.GetCurrentUser().Id;
                operationLogEntity.CreateTime = SessoinUtil.GetCurrentDateTime();
                linqDbManager.InsertEntity<OperationLogEntity>(operationLogEntity);

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 获取审计报告的审核历史
       /// </summary>
       /// <param name="templateLogEntiy"></param>
       /// <returns></returns>
        public List<OperationLogEntity> GetExamReportHistory(TemplateLogEntity templateLogEntiy)
        {
            try
            {
                StringBuilder sql = new StringBuilder();
                sql.Append("SELECT * FROM CT_REPORT_OPERATIONLOG INNER JOIN SYUSER ON OPERATIONLOG_CREATER =SYUSER_ID WHERE OPERATIONLOG_TEMPLATEINSTANCEID='"+templateLogEntiy.Id+"' ORDER BY OPERATIONLOG_CREATERTIME DESC");
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<OperationLogEntity>();
                maps.Add("UserName", "SYUSER_MC");
                List<OperationLogEntity> optons = dbManager.ExecuteSqlReturnTType<OperationLogEntity>(sql.ToString(),maps);
                foreach (OperationLogEntity op in optons)
                {
                    op.State = CreateReportConst.GetTemplateSateNameByState(op.State);
                }
                return optons;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

       

        public void CancelExamReport(OperationLogEntity operationLogEntity)
        {
            try
            {

                operationLogEntity.State = CreateReportConst.TEMPLATESTATE_CANCELEXAM;
                //更新审计底稿模板的状态
                UpdateTemplateLogState(operationLogEntity);
                string type = "";
                if (operationLogEntity.State == CreateReportConst.TEMPLATESTATE_CANCELEXAM)
                {
                    type = "取消上级审核";
                }
                //日志记录
                InsertTemplateStateLog(operationLogEntity,type);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void ExamReportSeal(OperationLogEntity operationLogEntity)
        {
            try
            {
               
                operationLogEntity.State = CreateReportConst.TEMPLATESTATE_SEAL;
                //更新审计底稿模板的状态
                UpdateTemplateLogState(operationLogEntity);
                string type = "";
                if (operationLogEntity.State == CreateReportConst.TEMPLATESTATE_SEAL)
                {
                    type = "报告封存";
                }
                //日志记录
                InsertTemplateStateLog(operationLogEntity,type);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public void ExamReportCancelSeal(OperationLogEntity operationLogEntity)
        {
            try
            {
                operationLogEntity.State = CreateReportConst.TEMPLATESTATE_CANCELSEAL;
                //更新审计底稿模板的状态
                UpdateTemplateLogState(operationLogEntity);
                string type = "";
                if (operationLogEntity.State == CreateReportConst.TEMPLATESTATE_CANCELSEAL)
                {
                    type = "取消封存";
                }
                //日志记录
                InsertTemplateStateLog(operationLogEntity,type);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 获取上级审核的列表
       /// </summary>
       /// <param name="dataGrid"></param>
       /// <param name="templateLogEntity"></param>
       /// <returns></returns>
        public AuditSPI.DataGrid<TemplateLogEntity> GetExamReportDataGrid(AuditSPI.DataGrid<TemplateLogEntity> dataGrid, TemplateLogEntity templateLogEntity)
        {
            try
            {
                return createReportService.GetTempalteLogListByState(dataGrid, templateLogEntity, ReportTemplateLogStateEnum.Exam);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 获取取消审核的列表
       /// </summary>
       /// <param name="dataGrid"></param>
       /// <param name="templateLogEntity"></param>
       /// <returns></returns>
        public AuditSPI.DataGrid<TemplateLogEntity> GetCancelExamReportDataGrid(AuditSPI.DataGrid<TemplateLogEntity> dataGrid, TemplateLogEntity templateLogEntity)
        {
            try
            {
                return createReportService.GetTempalteLogListByState(dataGrid, templateLogEntity, ReportTemplateLogStateEnum.CancelExam);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 获取封存的审核列表
       /// </summary>
       /// <param name="dataGrid"></param>
       /// <param name="templateLogEntity"></param>
       /// <returns></returns>
        public AuditSPI.DataGrid<TemplateLogEntity> GetSealReportDataGrid(AuditSPI.DataGrid<TemplateLogEntity> dataGrid, TemplateLogEntity templateLogEntity)
        {
            try
            {
                return createReportService.GetTempalteLogListByState(dataGrid, templateLogEntity, ReportTemplateLogStateEnum.Seal);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 获取取消封存的审核列表
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="templateLogEntity"></param>
        /// <returns></returns>
        public AuditSPI.DataGrid<TemplateLogEntity> GetCancelSealReportDataGrid(AuditSPI.DataGrid<TemplateLogEntity> dataGrid, TemplateLogEntity templateLogEntity)
        {
            try
            {
                return createReportService.GetTempalteLogListByState(dataGrid, templateLogEntity, ReportTemplateLogStateEnum.CancelSeal);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
