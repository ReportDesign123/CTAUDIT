using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Common;
using AuditSPI.ReportState;
using DbManager;
using AuditSPI;
using AuditEntity.ReportState;
using CtTool;
using GlobalConst;

using AuditSPI.WorkFlow;
using AuditService.WorkFlow;
using AuditEntity.WorkFlow;
using AuditEntity;
using AuditSPI.ReportData;



namespace AuditService.ReportState
{
    
    public  class ReportStateService:IReportState,IReportExam,IReportHigherExamine
    {
        ILinqDataManager linqDbManager;
        CTDbManager dbManager;
        IWorkFlowDefinition workFlowDefinitionService;
        ISystemService systemService;
        ReportProcessManager reportProcessManager;
        ReportLockService reportLockService;
        CompanyService companyService;
        public ReportStateService()
        {
            if (linqDbManager == null)
            {
                linqDbManager = new LinqDataManager();
            }
            if (dbManager == null)
            {
                dbManager = new CTDbManager();
            }
            if (workFlowDefinitionService == null)
            {
                workFlowDefinitionService = new WorkFlowDefinitionService();
            }
            if (systemService == null)
            {
                systemService = new SystemService();
            }
            if (reportProcessManager == null)
            {
                reportProcessManager = new ReportProcessManager();
            }
            if (reportLockService == null)
            {
                reportLockService = new ReportLockService();
            }
            if (companyService == null)
            {
                companyService = new CompanyService();
            }
        }
        #region 报表的状态相关 保存报表状态 获取报表状态

        /// <summary>
        /// 清空报表状态
        /// </summary>
        /// <param name="rdps"></param>
        public void DeleteReportState(AuditSPI.ReportData.ReportDataParameterStruct rdps)
        {
            try
            {
                string sql = "DELETE FROM CT_STATE_REPORTSTATE WHERE "+CreateWhereSql(rdps);
                dbManager.ExecuteSql(sql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 获取报表的状态信息
        /// </summary>
        /// <param name="reports"></param>
        /// <param name="rdps"></param>
        public void GetReportsState(List<ReportFormatDicEntity> reports, AuditSPI.ReportData.ReportDataParameterStruct rdps)
        {
            try
            {
                string sql = "SELECT * FROM CT_STATE_REPORTSTATE WHERE " + CreateWhereSql(reports, rdps);
                List<ReportStateEntity> states = dbManager.ExecuteSqlReturnTType<ReportStateEntity>(sql);
                foreach (ReportStateEntity rse in states)
                {
                    SetReportState(rse, reports);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 保存报表状态
        /// </summary>
        /// <param name="rse"></param>
        /// <param name="rsde"></param>
        public void SaveReportSate(AuditEntity.ReportState.ReportStateEntity rse, AuditEntity.ReportState.ReportStateDetailEntity rsde)
        {
            try
            {
                rse.Creater = SessoinUtil.GetCurrentUser().Id;
                rse.CreateTime = SessoinUtil.GetSystemDate();
                rsde.Creater = SessoinUtil.GetCurrentUser().Id;
                rsde.CreateTime = SessoinUtil.GetCurrentDateTime();
                string stateSql = CreateReportStateSql(rse);
                List<ReportStateEntity> rseLists = dbManager.ExecuteSqlReturnTType<ReportStateEntity>(stateSql);
                ReportStateEntity old = rseLists.Count == 0 ? null : rseLists[0];
                string verify = VerifyReportState(rse, old);
                if (verify != "1")
                {
                    throw new Exception(verify);
                }
                if (rseLists != null && rseLists.Count > 0)
                {
                    rse.Id = rseLists[0].Id;
                    //更新报表状态
                    List<DbParameter> parameters=new List<DbParameter>();
                    List<string> excludes=new List<string>();
                    excludes.Add("Id");
                    excludes.Add("TaskId");
                    excludes.Add("PaperId");
                    excludes.Add("ReportId");
                     excludes.Add("Nd");
                     excludes.Add("Zq");
                     excludes.Add("CompanyId");
                    stateSql = dbManager.ConvertBeanToUpdateSql<ReportStateEntity>(rse, " WHERE REPORTSTATE_ID='"+rse.Id+"'",parameters,excludes);                   
                    dbManager.ExecuteSql(stateSql,parameters);
                }
                else
                {
                    //插入报表状态
                    if (StringUtil.IsNullOrEmpty(rse.Id))
                    {
                        rse.Id = Guid.NewGuid().ToString();
                    }                   
                    List<DbParameter>parameters=new List<DbParameter>();
                    stateSql = dbManager.ConvertBeanToInsertCommandSql<ReportStateEntity>(rse, parameters);
                    dbManager.ExecuteSql(stateSql, parameters);
                }

                //保存报表状态明细
                if (StringUtil.IsNullOrEmpty(rsde.Id))
                {
                    rsde.Id = Guid.NewGuid().ToString();
                }
                List<DbParameter> dparameters=new List<DbParameter>();
                string stateDetailSql = dbManager.ConvertBeanToInsertCommandSql<ReportStateDetailEntity>(rsde, dparameters);
                dbManager.ExecuteSql(stateDetailSql, dparameters);

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public string ConvertReportState(string state)
        {
            try
            {
                string result = "";
                result = reportProcessManager.GetCurrentStateName(state);
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public void SaveReportSate_Tb(ReportStateEntity rse, ReportStateDetailEntity rsde)
        {
            try
            {
                rse.Creater = SessoinUtil.GetCurrentUser().Id;
                rse.CreateTime = SessoinUtil.GetSystemDate();
                rsde.Creater = SessoinUtil.GetCurrentUser().Id;
                rsde.CreateTime = SessoinUtil.GetSystemDate();
                string stateSql = CreateReportStateSql(rse);
                List<ReportStateEntity> rseLists = dbManager.ExecuteSqlReturnTType<ReportStateEntity>(stateSql);
                if (rseLists == null || rseLists.Count == 0)
                {
                    //更新报表状态
                    //插入报表状态
                    if (StringUtil.IsNullOrEmpty(rse.Id))
                    {
                        rse.Id = Guid.NewGuid().ToString();
                    }
                    List<DbParameter> parameters = new List<DbParameter>();
                    stateSql = dbManager.ConvertBeanToInsertCommandSql<ReportStateEntity>(rse, parameters);
                    dbManager.ExecuteSql(stateSql, parameters);
                    //保存报表状态明细
                    if (StringUtil.IsNullOrEmpty(rsde.Id))
                    {
                        rsde.Id = Guid.NewGuid().ToString();
                    }
                    List<DbParameter> dparameters = new List<DbParameter>();
                    string stateDetailSql = dbManager.ConvertBeanToInsertCommandSql<ReportStateDetailEntity>(rsde, dparameters);
                    dbManager.ExecuteSql(stateDetailSql, dparameters);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public ReportStateEntity Get(string id)
        {
            try
            {
                return linqDbManager.GetEntity<ReportStateEntity>(r => r.Id == id);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #endregion
        #region 辅助方法
        private string CreateReportStateSql(ReportStateEntity rse)
        {
            try
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("SELECT * FROM CT_STATE_REPORTSTATE WHERE ");
                sb.Append(CreateWhereSql(rse));
                return sb.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 创建Where条件
        /// </summary>
        /// <param name="rse"></param>
        /// <returns></returns>
        private string CreateWhereSql(ReportStateEntity rse)
        {
            try
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" REPORTSTATE_TASKID='" + rse.TaskId + "' ");
                if (ReportGlobalConst.IsOrNotRelationTaskAndPaper)
                {
                    sb.Append(" AND REPORTSTATE_PAPERID='" + rse.PaperId + "' ");
                    sb.Append(" AND REPORTSTATE_REPORTID='" + rse.ReportId + "' ");
                }
               
                sb.Append(" AND REPORTSTATE_ND='" + rse.Nd + "' ");
                sb.Append(" AND REPORTSTATE_ZQ='" + rse.Zq + "' ");
                sb.Append(" AND REPORTSTATE_COMPANYID='" + rse.CompanyId + "' ");
                return sb.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        private void SetReportState(ReportStateEntity rse, List<ReportFormatDicEntity> reports)
        {
            try
            {
                foreach (ReportFormatDicEntity report in reports)
                {
                    if (report.Id == rse.ReportId)
                    {
                        report.ReportState = ConvertReportState(rse.State);
                        break;
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 创建Where条件
        /// </summary>
        /// <param name="reports"></param>
        /// <param name="rdps"></param>
        /// <returns></returns>
        private string CreateWhereSql(List<ReportFormatDicEntity> reports, ReportDataParameterStruct rdps)
        {
            try
            {
                if (reports.Count == 0) return " 1=1 ";
                StringBuilder sb = new StringBuilder();
                sb.Append("  REPORTSTATE_REPORTID IN (");
                foreach (ReportFormatDicEntity r in reports)
                {
                    sb.Append("'");
                    sb.Append(r.Id);
                    sb.Append("'");
                    sb.Append(",");
                }
                sb.Length--;
                sb.Append(")");
                if (ReportGlobalConst.IsOrNotRelationTaskAndPaper)
                {
                    sb.Append(" AND REPORTSTATE_TASKID='" + rdps.TaskId + "' ");
                    sb.Append(" AND REPORTSTATE_PAPERID='" + rdps.PaperId + "' ");
                }
                
                sb.Append(" AND REPORTSTATE_ND='" + rdps.Year + "' ");
                sb.Append(" AND REPORTSTATE_ZQ='" + rdps.Cycle + "' ");
                sb.Append(" AND REPORTSTATE_COMPANYID='" + rdps.CompanyId + "' ");

                return sb.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private string CreateWhereSql( ReportDataParameterStruct rdps)
        {
            try
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("  REPORTSTATE_REPORTID='");
                sb.Append(rdps.ReportId);
                sb.Append("' ");
                if (ReportGlobalConst.IsOrNotRelationTaskAndPaper)
                {
                    sb.Append(" AND REPORTSTATE_TASKID='" + rdps.TaskId + "' ");
                    sb.Append(" AND REPORTSTATE_PAPERID='" + rdps.PaperId + "' ");
                }

                sb.Append(" AND REPORTSTATE_ND='" + rdps.Year + "' ");
                sb.Append(" AND REPORTSTATE_ZQ='" + rdps.Cycle + "' ");
                sb.Append(" AND REPORTSTATE_COMPANYID='" + rdps.CompanyId + "' ");

                return sb.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private string VerifyReportState(ReportStateEntity rse,ReportStateEntity oldRse)
        {
            try
            {
                string result = "1";
                if(oldRse==null)throw new Exception("报表数据为空，不能进行此操作！");
                //if (oldRse.State == rse.State) throw new Exception("目前状态下，不需要此操作！");
                
                switch (rse.State)
                {
                    case "02":
                        //随时都可以保存报表校验结果
                        if (oldRse.State == "08")
                        {
                            result = "上级审核通过，不能取消本级审核或者再进行校验";
                        }
                      
                        break;
                    case "04":
                        if (oldRse.State == "01")
                        {
                            result = "填报数据不能进行审核,校验通过后的报表才能进行本级审核";
                        }
                        if (oldRse.State == "03")
                        {
                            result = "校验通过后的报表才能进行本级审核";
                        }
                        if (oldRse.State == "04")
                        {
                            result = "已经审核通过通过";
                        }
                        
                        if (oldRse.State == "02")
                        {
                        }
                        else
                        {

                        }
                        break;
                  
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 获取报表读写状态
        /// 1、判断报表的状态是否允许写
        /// 2、判断报表锁状态是否允许写
        /// 3、1,2逻辑与则为判断的结果；
        /// </summary>
        /// <param name="rdps"></param>
        /// <returns></returns>
        public string GetReportReadWriteState(ReportDataParameterStruct rdps)
        {
            try
            {
                 //获取报表状态读写锁
                bool processFlag=false;
                string sql=" SELECT * FROM CT_STATE_REPORTSTATE WHERE "+CreateWhereSql(rdps);
                List<ReportStateEntity> rses = dbManager.ExecuteSqlReturnTType<ReportStateEntity>(sql);
                if (rses.Count == 0)
                {
                    processFlag = reportProcessManager.AllowWrite("");
                }
                else
                {
                    processFlag = reportProcessManager.AllowWrite(rses[0].State);
                }
               
                //获取锁状态
                bool lockFlag = reportLockService.AllowWrite(rdps);
                if (processFlag && lockFlag)
                {
                    return "1";
                }
                else
                {
                    return "0";
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 删除报表锁
        /// </summary>
        /// <param name="rdps"></param>
        public void RemoveReportReadWriteState(ReportDataParameterStruct rdps)
        {
            try
            {
                reportLockService.RemoveLock(rdps);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       
        #endregion





        public ReportStateEntity ConvertReportDataParameterToStateEntity(AuditSPI.ReportData.ReportDataParameterStruct rdps)
        {
            try
            {
                ReportStateEntity rse = new ReportStateEntity();
                rse.TaskId = rdps.TaskId;
                rse.PaperId = rdps.PaperId;
                rse.ReportId = rdps.ReportId;
                rse.Nd = rdps.Year;
                rse.Zq = rdps.Cycle;
                rse.CompanyId =rdps.CompanyId;
                return rse;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public ReportStateDetailEntity ConvertReportDataParameterToStateDetailEntity(AuditSPI.ReportData.ReportDataParameterStruct rdps)
        {
            try
            {
                ReportStateDetailEntity rsde = new ReportStateDetailEntity();
                rsde.TaskId = rdps.TaskId;
                rsde.PaperId = rdps.PaperId;
                rsde.ReportId = rdps.ReportId;
                rsde.Nd = rdps.Year;
                rsde.Zq = rdps.Cycle;
                rsde.CompanyId = rdps.CompanyId;
                return rsde;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #region 报表审核相关方法
        /// <summary>
        /// 获取报表审核列表;
        /// flag 代表是审批列表还是反审批列表
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="rse"></param>
        /// <returns></returns>
        public DataGrid<ReportStateEntity> GetExamOrCancelReportStateDataGrid(DataGrid<ReportStateEntity> dataGrid, ReportStateEntity rse, bool flag)
        {
            try
            {
                
                DataGrid<ReportStateEntity> dg = new DataGrid<ReportStateEntity>();
                string sql = "SELECT REPORTSTATE_ID,REPORTDICTIONARY_CODE, REPORTSTATE_REPORTID,REPORTSTATE_COMPANYID,LSBZDW_DWMC,REPORTSTATE_STATE,REPORTSTATE_STAGESTATE,REPORTDICTIONARY_NAME,REPORTSTATE_NEXTSTAGESTATE,REPORTSTATE_PR0STAGESTATE,REPORTSTATE_CREATETIME FROM CT_STATE_REPORTSTATE INNER JOIN LSBZDW ON REPORTSTATE_COMPANYID=LSBZDW_ID INNER JOIN CT_FORMAT_REPORTDICTIONARY ON REPORTSTATE_REPORTID=REPORTDICTIONARY_ID  ";
                string whereSql = CreateExamingReportStateSql(rse,flag);

                sql += whereSql ;
                string countSql = "SELECT COUNT(*)  FROM CT_STATE_REPORTSTATE INNER JOIN LSBZDW ON REPORTSTATE_COMPANYID=LSBZDW_ID INNER JOIN CT_FORMAT_REPORTDICTIONARY ON REPORTSTATE_REPORTID=REPORTDICTIONARY_ID   " + whereSql;
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<ReportStateEntity>();
                maps.Add("CompanyName", "LSBZDW_DWMC");
                maps.Add("ReportName", "REPORTDICTIONARY_NAME");
                maps.Add("ReportCode", "REPORTDICTIONARY_CODE");
                string sortName = maps[dataGrid.sort];
                List<ReportStateEntity> states = dbManager.ExecuteSqlReturnTType<ReportStateEntity>(sql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
                foreach (ReportStateEntity state in states)
                {
                    state.State = reportProcessManager.GetCurrentStateName(state.State);
                }
                dg.rows = states;
                dg.total = dbManager.Count(countSql);
                return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 根据审批状态参数获取审批列表；
        /// </summary>
        /// <param name="rse"></param>
        /// <returns></returns>
        private string CreateExamingReportStateSql(ReportStateEntity rse,bool flag)
        {
            try
            {
                StringBuilder stateSql = new StringBuilder();
                stateSql.Append(" WHERE 1=1 ");
                if (ReportGlobalConst.IsOrNotRelationTaskAndPaper)
                {
                    if (!StringUtil.IsNullOrEmpty(rse.TaskId))
                    {
                        stateSql.Append(" AND REPORTSTATE_TASKID='" + rse.TaskId + "' ");
                    }

                    if (!StringUtil.IsNullOrEmpty(rse.PaperId))
                    {
                        stateSql.Append(" AND REPORTSTATE_PAPERID='" + rse.PaperId + "' ");
                    }
                }

                if (!StringUtil.IsNullOrEmpty(rse.Nd))
                {
                    stateSql.Append(" AND REPORTSTATE_ND='" + rse.Nd + "' ");
                }

                if (!StringUtil.IsNullOrEmpty(rse.Zq))
                {
                    stateSql.Append(" AND REPORTSTATE_ZQ='" + rse.Zq + "' ");
                }

                if (!StringUtil.IsNullOrEmpty(rse.ReportType))
                {
                    stateSql.Append(" AND REPORTDICTIONARY_CYCLE='" + rse.ReportType + "' ");
                }

                if (!StringUtil.IsNullOrEmpty(rse.CompanyName))
                {
                    stateSql.Append(" AND LSBZDW_DWMC LIKE '%" + rse.CompanyName + "%' ");
                }
                if (!StringUtil.IsNullOrEmpty(rse.ReportName))
                {
                    stateSql.Append(" AND REPORTDICTIONARY_NAME LIKE '%" + rse.ReportName + "%' ");
                }
                if (!StringUtil.IsNullOrEmpty(rse.ReportCode))
                {
                    stateSql.Append(" AND REPORTDICTIONARY_CODE LIKE '%" + rse.ReportCode + "%' ");
                }
                if (flag)
                {
                    stateSql.Append(" AND REPORTSTATE_NEXTSTAGESTATE " + SessoinUtil.GetCurrentPositionCodeSql() + "");
                }
                else
                {
                    stateSql.Append(" AND REPORTSTATE_STAGESTATE " + SessoinUtil.GetCurrentPositionCodeSql() + "");
                }
                stateSql.Append(" AND REPORTSTATE_COMPANYID IN ("+companyService.GetFillReportAuthorityCompaniesIdSql()+")");
                return stateSql.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
     

        /// <summary>
        /// 报表审批和取消审批接口：报表审批包括审批成功和审批失败
        ///    如果审批成功，则审批状态向下扭转，记录审计状态和审计明细；
        ///   ，则审计状态退回到上一审计状态，并填写审计明细；
        /// 
        /// </summary>
        /// <param name="rse"></param>
        public void ExamReportState(ReportStateEntity rse)
        {
            try
            {
                string sql = "SELECT * FROM CT_STATE_REPORTSTATE WHERE REPORTSTATE_ID IN (" + CreateIdSqls(rse.Id,rse.Ids) + ")";
                List<ReportStateEntity> reportStateLists = dbManager.ExecuteSqlReturnTType<ReportStateEntity>(sql);
                foreach (ReportStateEntity state in reportStateLists)
                {
                    WorkFlowDirection wfd=new WorkFlowDirection();
                    ReportStateDetailEntity rsde = new ReportStateDetailEntity();
                    //审批通过
                    if (rse.StageResult == ReportGlobalConst.REPORTEXAM_SUCCESS)
                    {                        
                        if (rse.ExamDirection == ReportGlobalConst.REPORTEXAM_EXAM)
                        {
                            //审核
                            wfd = WorkFlowDirection.Forward;
                            rsde.OperationType = ReportGlobalConst.ReportExamName;
                        }
                        else
                        {
                            //取消审核
                            wfd = WorkFlowDirection.Backward;
                            rsde.OperationType = ReportGlobalConst.ReportCancelExamName;
                        }
                        workFlowDefinitionService.ReportExamine(state, wfd);
                    }
                    else
                    {
                        //审批不通过只更新审批结果状态，其他的维持不变
                        state.State = ReportGlobalConst.REPORTSTATE_EXAMFAIL;
                        rsde.OperationType = ReportGlobalConst.ReportExamNotName;
                    }
                    
                    //更新报表状态
                    state.Creater = SessoinUtil.GetCurrentUser().Id;
                    state.CreateTime = SessoinUtil.GetCurrentDateTime();
                    state.Discription = rse.Discription;
                    UpdateReportState(state);
                    //更新审计报表状态明细                    
                    BeanUtil.CopyBeanToBean(state, rsde);
                    rsde.StateId = state.Id;
                    rsde.Id = Guid.NewGuid().ToString();
                    linqDbManager.InsertEntity<ReportStateDetailEntity>(rsde);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 更新报表状态
        /// </summary>
        /// <param name="rse"></param>
        private void UpdateReportState(ReportStateEntity rse)
        {
            try
            {
                string sql = "UPDATE CT_STATE_REPORTSTATE SET REPORTSTATE_STAGESTATE='" + rse.CurrentStageState + "',REPORTSTATE_PR0STAGESTATE='" + rse.ProStageState + "',REPORTSTATE_NEXTSTAGESTATE='" + rse.NextStageState + "',REPORTSTATE_RESULT='" + rse.StageResult + "',REPORTSTATE_STATE='"+rse.State+"' WHERE REPORTSTATE_ID='" + rse.Id + "'";
                dbManager.ExecuteSql(sql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        
        /// <summary>
        /// 获取审计报表ID的Sql
        /// </summary>
        /// <param name="rse">报表参数</param>
        /// <returns></returns>
        private string CreateIdSqls(string id,string ids)
        {
            try
            {
                StringBuilder sql = new StringBuilder();
                if (!StringUtil.IsNullOrEmpty(id))
                {
                    sql.Append("'");
                    sql.Append(id);
                    sql.Append("'");
                    sql.Append(",");
                }
                if (!StringUtil.IsNullOrEmpty(ids))
                {
                    string[] idsArr = ids.Split(',');
                    foreach (string d in idsArr)
                    {
                        sql.Append("'");
                        sql.Append(d);
                        sql.Append("'");
                        sql.Append(",");
                    }
                }
                sql.Length--;
                return sql.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 获取我的审核列表
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="rsde"></param>
        /// <returns></returns>
        public DataGrid<ReportStateDetailEntity> GetMyExamReportHistoryGrid(DataGrid<ReportStateDetailEntity> dataGrid, ReportStateDetailEntity rsde)
        {
            try
            {
                DataGrid<ReportStateDetailEntity> dg = new DataGrid<ReportStateDetailEntity>();
                string sql = "SELECT REPORTSTATEDETAIL_ID,REPORTDICTIONARY_CODE, REPORTSTATEDETAIL_REPORTID,REPORTSTATEDETAIL_COMPANYID,LSBZDW_DWMC,REPORTSTATEDETAIL_STATE,REPORTSTATEDETAIL_STAGESTATE,REPORTDICTIONARY_NAME,REPORTSTATEDETAIL_NEXTSTAGESTATE,REPORTSTATEDETAIL_PROSTAGESTATE,REPORTSTATEDETAIL_CREATER,REPORTSTATEDETAIL_CREATETIME,REPORTSTATEDETAIL_OPERATION,REPORTSTATEDETAIL_VERIFYDES " +
                " FROM CT_STATE_REPORTSTATEDETAIL INNER JOIN LSBZDW ON REPORTSTATEDETAIL_COMPANYID=LSBZDW_ID INNER JOIN CT_FORMAT_REPORTDICTIONARY ON REPORTSTATEDETAIL_REPORTID=REPORTDICTIONARY_ID ";
                string whereSql = CreateExamedReportStateWhereSql(rsde);

                sql += whereSql;
                string countSql = "SELECT COUNT(*)  FROM CT_STATE_REPORTSTATEDETAIL INNER JOIN LSBZDW ON REPORTSTATEDETAIL_COMPANYID=LSBZDW_ID INNER JOIN CT_FORMAT_REPORTDICTIONARY ON REPORTSTATEDETAIL_REPORTID=REPORTDICTIONARY_ID   " + whereSql;
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<ReportStateDetailEntity>();
                maps.Add("CompanyName", "LSBZDW_DWMC");
                maps.Add("ReportName", "REPORTDICTIONARY_NAME");
                maps.Add("ReportCode", "REPORTDICTIONARY_CODE");
                string sortName = maps[dataGrid.sort];
                dg.rows = dbManager.ExecuteSqlReturnTType<ReportStateDetailEntity>(sql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
                dg.total = dbManager.Count(countSql);
                return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 创建已审批明细列表
        /// </summary>
        /// <param name="rsde"></param>
        /// <returns></returns>
        private string CreateExamedReportStateWhereSql(ReportStateDetailEntity rsde)
        {
            try
            {
                StringBuilder stateSql = new StringBuilder();
                stateSql.Append(" WHERE 1=1 ");
                if (ReportGlobalConst.IsOrNotRelationTaskAndPaper)
                {
                    if (!StringUtil.IsNullOrEmpty(rsde.TaskId))
                    {
                        stateSql.Append(" AND REPORTSTATEDETAIL_TASKID='" + rsde.TaskId + "' ");
                    }

                    if (!StringUtil.IsNullOrEmpty(rsde.PaperId))
                    {
                        stateSql.Append(" AND REPORTSTATEDETAIL_PAPERID='" + rsde.PaperId + "' ");
                    }
                }

                if (!StringUtil.IsNullOrEmpty(rsde.Nd))
                {
                    stateSql.Append(" AND REPORTSTATEDETAIL_ND='" + rsde.Nd + "' ");
                }

                if (!StringUtil.IsNullOrEmpty(rsde.Zq))
                {
                    stateSql.Append(" AND REPORTSTATEDETAIL_ZQ='" + rsde.Zq + "' ");
                }

                if (!StringUtil.IsNullOrEmpty(rsde.ReportType))
                {
                    stateSql.Append(" AND REPORTDICTIONARY_CYCLE='" + rsde.ReportType + "' ");
                }

                if (!StringUtil.IsNullOrEmpty(rsde.CompanyName))
                {
                    stateSql.Append(" AND LSBZDW_DWMC LIKE '%" + rsde.CompanyName + "%' ");
                }
                if (!StringUtil.IsNullOrEmpty(rsde.ReportName))
                {
                    stateSql.Append(" AND REPORTDICTIONARY_NAME LIKE '%" + rsde.ReportName + "%' ");
                }
                if (!StringUtil.IsNullOrEmpty(rsde.ReportCode))
                {
                    stateSql.Append(" AND REPORTDICTIONARY_CODE LIKE '%" + rsde.ReportCode + "%' ");
                }

                stateSql.Append(" AND REPORTSTATEDETAIL_CREATER ='" + SessoinUtil.GetCurrentUser().Id + "'");
                stateSql.Append(" AND REPORTSTATEDETAIL_COMPANYID IN (" + companyService.GetFillReportAuthorityCompaniesIdSql() + ")");
                return stateSql.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 获取当前报表的所有审核历史记录
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="rsde"></param>
        /// <returns></returns>
        public DataGrid<ReportStateDetailEntity> GetAllHistoryGrid(DataGrid<ReportStateDetailEntity> dataGrid, ReportStateDetailEntity rsde)
        {
            try
            {
                DataGrid<ReportStateDetailEntity> dg = new DataGrid<ReportStateDetailEntity>();
                string sql = "SELECT REPORTSTATEDETAIL_ID, REPORTSTATEDETAIL_REPORTID,REPORTSTATEDETAIL_COMPANYID,LSBZDW_DWMC,REPORTSTATEDETAIL_STATE,REPORTSTATEDETAIL_STAGESTATE,REPORTDICTIONARY_NAME,REPORTSTATEDETAIL_NEXTSTAGESTATE,REPORTSTATEDETAIL_PROSTAGESTATE,REPORTSTATEDETAIL_CREATER,REPORTSTATEDETAIL_CREATETIME,REPORTSTATEDETAIL_OPERATION ,SYUSER_MC,REPORTSTATEDETAIL_VERIFYDES " +
                " FROM CT_STATE_REPORTSTATEDETAIL INNER JOIN LSBZDW ON REPORTSTATEDETAIL_COMPANYID=LSBZDW_ID INNER JOIN CT_FORMAT_REPORTDICTIONARY ON REPORTSTATEDETAIL_REPORTID=REPORTDICTIONARY_ID ";
                sql += " INNER JOIN SYUSER ON REPORTSTATEDETAIL_CREATER=SYUSER_ID ";
                string whereSql = CreateAllHistoryWhereSql(rsde);
                
                sql += whereSql;
                string countSql = "SELECT COUNT(*)  FROM CT_STATE_REPORTSTATEDETAIL INNER JOIN LSBZDW ON REPORTSTATEDETAIL_COMPANYID=LSBZDW_ID INNER JOIN CT_FORMAT_REPORTDICTIONARY ON REPORTSTATEDETAIL_REPORTID=REPORTDICTIONARY_ID   " + whereSql;
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<ReportStateDetailEntity>();
                maps.Add("CompanyName", "LSBZDW_DWMC");
                maps.Add("ReportName", "REPORTDICTIONARY_NAME");
                maps.Add("CreaterName", "SYUSER_MC");
                string sortName = maps[dataGrid.sort];
                dg.rows = dbManager.ExecuteSqlReturnTType<ReportStateDetailEntity>(sql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
                dg.total = dbManager.Count(countSql);
                return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        private string CreateAllHistoryWhereSql(ReportStateDetailEntity rsde)
        {
            try
            {
                StringBuilder stateSql = new StringBuilder();
                stateSql.Append(" WHERE 1=1 ");
                if (ReportGlobalConst.IsOrNotRelationTaskAndPaper)
                {
                    if (!StringUtil.IsNullOrEmpty(rsde.TaskId))
                    {
                        stateSql.Append(" AND REPORTSTATEDETAIL_TASKID='" + rsde.TaskId + "' ");
                    }

                    if (!StringUtil.IsNullOrEmpty(rsde.PaperId))
                    {
                        stateSql.Append(" AND REPORTSTATEDETAIL_PAPERID='" + rsde.PaperId + "' ");
                    }
                }

                if (!StringUtil.IsNullOrEmpty(rsde.ReportId))
                {
                    stateSql.Append(" AND REPORTSTATEDETAIL_REPORTID='" + rsde.ReportId + "' ");
                }
                if (!StringUtil.IsNullOrEmpty(rsde.Nd))
                {
                    stateSql.Append(" AND REPORTSTATEDETAIL_ND='" + rsde.Nd + "' ");
                }

                if (!StringUtil.IsNullOrEmpty(rsde.Zq))
                {
                    stateSql.Append(" AND REPORTSTATEDETAIL_ZQ='" + rsde.Zq + "' ");
                }

                if (!StringUtil.IsNullOrEmpty(rsde.ReportType))
                {
                    stateSql.Append(" AND REPORTDICTIONARY_CYCLE='" + rsde.ReportType + "' ");
                }


                if (!StringUtil.IsNullOrEmpty(rsde.CompanyId))
                {
                    stateSql.Append(" AND REPORTSTATEDETAIL_COMPANYID='" + rsde.CompanyId + "' ");
                }

                if (!StringUtil.IsNullOrEmpty(rsde.CompanyName))
                {
                    stateSql.Append(" AND LSBZDW_DWMC LIKE '%" + rsde.CompanyName + "%' ");
                }
                if (!StringUtil.IsNullOrEmpty(rsde.ReportName))
                {
                    stateSql.Append(" AND REPORTDICTIONARY_NAME LIKE '%" + rsde.ReportName + "%' ");
                }
               
                return stateSql.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 获取所有报表数据
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="rse"></param>
        /// <returns></returns>
        public DataGrid<ReportStateEntity> GetAllReportsStateDataGrid(DataGrid<ReportStateEntity> dataGrid, ReportStateEntity rse)
        {
            try
            {
                DataGrid<ReportStateEntity> dg = new DataGrid<ReportStateEntity>();
                string sql = "SELECT REPORTSTATE_ID,REPORTDICTIONARY_CODE, REPORTSTATE_REPORTID,REPORTSTATE_COMPANYID,LSBZDW_DWMC,REPORTSTATE_STATE,REPORTSTATE_STAGESTATE,REPORTDICTIONARY_NAME,REPORTSTATE_NEXTSTAGESTATE,REPORTSTATE_PR0STAGESTATE FROM CT_STATE_REPORTSTATE INNER JOIN LSBZDW ON REPORTSTATE_COMPANYID=LSBZDW_ID INNER JOIN CT_FORMAT_REPORTDICTIONARY ON REPORTSTATE_REPORTID=REPORTDICTIONARY_ID  ";
                string whereSql = CreateAllReportsWhereSql(rse);

                sql += whereSql;
                string authority = " AND "+companyService.GetFillReportAuthorityCompaniesSql();
                sql += authority;
                string countSql = "SELECT COUNT(*)  FROM CT_STATE_REPORTSTATE INNER JOIN LSBZDW ON REPORTSTATE_COMPANYID=LSBZDW_ID INNER JOIN CT_FORMAT_REPORTDICTIONARY ON REPORTSTATE_REPORTID=REPORTDICTIONARY_ID   " + whereSql;
                countSql += authority;
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<ReportStateEntity>();
                maps.Add("CompanyName", "LSBZDW_DWMC");
                maps.Add("ReportName", "REPORTDICTIONARY_NAME");
                maps.Add("ReportCode", "REPORTDICTIONARY_CODE");
                string sortName = maps[dataGrid.sort];
                List<ReportStateEntity> states= dbManager.ExecuteSqlReturnTType<ReportStateEntity>(sql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
                foreach (ReportStateEntity state in states)
                {
                    state.State = reportProcessManager.GetCurrentStateName(state.State);
                }
                dg.rows = states;
                dg.total = dbManager.Count(countSql);
                return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private string CreateAllReportsWhereSql(ReportStateEntity rse)
        {
            try
            {
                StringBuilder stateSql = new StringBuilder();
                stateSql.Append(" WHERE 1=1 ");
                if (!StringUtil.IsNullOrEmpty(rse.TaskId))
                {
                    stateSql.Append(" AND REPORTSTATE_TASKID='" + rse.TaskId + "' ");
                }

                if (!StringUtil.IsNullOrEmpty(rse.PaperId))
                {
                    stateSql.Append(" AND REPORTSTATE_PAPERID='" + rse.PaperId + "' ");
                }

                if (!StringUtil.IsNullOrEmpty(rse.Nd))
                {
                    stateSql.Append(" AND REPORTSTATE_ND='" + rse.Nd + "' ");
                }

                if (!StringUtil.IsNullOrEmpty(rse.Zq))
                {
                    stateSql.Append(" AND REPORTSTATE_ZQ='" + rse.Zq + "' ");
                }

                if (!StringUtil.IsNullOrEmpty(rse.ReportType))
                {
                    stateSql.Append(" AND REPORTDICTIONARY_CYCLE='" + rse.ReportType + "' ");
                }

                if (!StringUtil.IsNullOrEmpty(rse.CompanyName))
                {
                    stateSql.Append(" AND LSBZDW_DWMC LIKE '%" + rse.CompanyName + "%' ");
                }
                if (!StringUtil.IsNullOrEmpty(rse.ReportName))
                {
                    stateSql.Append(" AND REPORTDICTIONARY_NAME LIKE '%" + rse.ReportName + "%' ");
                }
                if (!StringUtil.IsNullOrEmpty(rse.ReportCode))
                {
                    stateSql.Append(" AND REPORTDICTIONARY_CODE LIKE '%" + rse.ReportCode + "%' ");
                }
                return stateSql.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 报表填报资料工作流发布;
        /// 1）保存系统参数配置
        /// 2）更新报表工作流程定义；
        /// </summary>
        /// <param name="ce"></param>
        public void ReportExamineWorkFlowPublish(AuditEntity.ConfigEntity ce)
        {
            try
            {
                if (ce.Name == ReportGlobalConst.REPORTEXAM_CONFIGNAME)
                {
                    ce.Id="02";
                    systemService.Edit(ce);
                    //保存数据库定义
                    WorkFlowDefinition wfd = new WorkFlowDefinition();
                    wfd.Code = ce.Value;
                    wfd = workFlowDefinitionService.GetWorkFlow(wfd);
                    if (wfd == null) throw new Exception("当前工作流不存在");

                    //获取当前数据库中当前流程的状态
                    string sql = "SELECT * FROM CT_STATE_REPORTSTATE WHERE REPORTSTATE_STATE IN ('" + ReportGlobalConst.REPORTSTATE_SELFCHECK + "','" + ReportGlobalConst.REPORTSTATE_EXAMPROCESS + "','" + ReportGlobalConst.REPORTSTATE_EXAMPROCESS + "')";
                    List<ReportStateEntity> states = dbManager.ExecuteSqlReturnTType<ReportStateEntity>(sql);
                    foreach (ReportStateEntity rse in states)
                    {
                        workFlowDefinitionService.ReportExamineWorkFlowPublish(rse, wfd);
                        UpdateReportState(rse);
                    }
                }
                
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion





        #region 上级审核
        /// <summary>
        /// 获取上级审核或者取消审核的数据列表
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="rse"></param>
        /// <param name="flag"></param>
        /// <returns></returns>
        public DataGrid<ReportStateEntity> GetHigherExamOrCancelReportStateDataGrid(DataGrid<ReportStateEntity> dataGrid, ReportStateEntity rse, bool flag)
        {
            try
            {
                DataGrid<ReportStateEntity> dg = new DataGrid<ReportStateEntity>();
                string sql = "SELECT REPORTSTATE_ID,REPORTDICTIONARY_CODE, REPORTSTATE_REPORTID,REPORTSTATE_COMPANYID,LSBZDW_DWMC,REPORTSTATE_STATE,REPORTSTATE_STAGESTATE,REPORTDICTIONARY_NAME,REPORTSTATE_NEXTSTAGESTATE,REPORTSTATE_PR0STAGESTATE,REPORTSTATE_CREATETIME FROM CT_STATE_REPORTSTATE INNER JOIN LSBZDW ON REPORTSTATE_COMPANYID=LSBZDW_ID INNER JOIN CT_FORMAT_REPORTDICTIONARY ON REPORTSTATE_REPORTID=REPORTDICTIONARY_ID  ";
                string whereSql = CreateHigherExamingReportStateSql(rse, flag);

                sql += whereSql;
                string countSql = "SELECT COUNT(*)  FROM CT_STATE_REPORTSTATE INNER JOIN LSBZDW ON REPORTSTATE_COMPANYID=LSBZDW_ID INNER JOIN CT_FORMAT_REPORTDICTIONARY ON REPORTSTATE_REPORTID=REPORTDICTIONARY_ID   " + whereSql;
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<ReportStateEntity>();
                maps.Add("CompanyName", "LSBZDW_DWMC");
                maps.Add("ReportName", "REPORTDICTIONARY_NAME");
                maps.Add("ReportCode", "REPORTDICTIONARY_CODE");
                string sortName = maps[dataGrid.sort];
                List<ReportStateEntity> states = dbManager.ExecuteSqlReturnTType<ReportStateEntity>(sql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
                foreach (ReportStateEntity state in states)
                {
                    state.State = reportProcessManager.GetCurrentStateName(state.State);
                }
                dg.rows = states;
                dg.total = dbManager.Count(countSql);
                return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 根据审批状态参数获取审批列表；
        /// </summary>
        /// <param name="rse"></param>
        /// <returns></returns>
        private string CreateHigherExamingReportStateSql(ReportStateEntity rse, bool flag)
        {
            try
            {
                StringBuilder stateSql = new StringBuilder();
                stateSql.Append(" WHERE 1=1 ");
                if (ReportGlobalConst.IsOrNotRelationTaskAndPaper)
                {
                    if (!StringUtil.IsNullOrEmpty(rse.TaskId))
                    {
                        stateSql.Append(" AND REPORTSTATE_TASKID='" + rse.TaskId + "' ");
                    }

                    if (!StringUtil.IsNullOrEmpty(rse.PaperId))
                    {
                        stateSql.Append(" AND REPORTSTATE_PAPERID='" + rse.PaperId + "' ");
                    }
                }

                if (!StringUtil.IsNullOrEmpty(rse.Nd))
                {
                    stateSql.Append(" AND REPORTSTATE_ND='" + rse.Nd + "' ");
                }

                if (!StringUtil.IsNullOrEmpty(rse.Zq))
                {
                    stateSql.Append(" AND REPORTSTATE_ZQ='" + rse.Zq + "' ");
                }

                if (!StringUtil.IsNullOrEmpty(rse.ReportType))
                {
                    stateSql.Append(" AND REPORTDICTIONARY_CYCLE='" + rse.ReportType + "' ");
                }

                if (!StringUtil.IsNullOrEmpty(rse.CompanyName))
                {
                    stateSql.Append(" AND LSBZDW_DWMC LIKE '%" + rse.CompanyName + "%' ");
                }
                if (!StringUtil.IsNullOrEmpty(rse.ReportName))
                {
                    stateSql.Append(" AND REPORTDICTIONARY_NAME LIKE '%" + rse.ReportName + "%' ");
                }
                if (!StringUtil.IsNullOrEmpty(rse.ReportCode))
                {
                    stateSql.Append(" AND REPORTDICTIONARY_CODE LIKE '%" + rse.ReportCode + "%' ");
                }
                if (flag)
                {
                    stateSql.Append(" AND REPORTSTATE_STATE IN ('" + ReportGlobalConst.REPORTSTATE_SELFCHECK + "','"+ReportGlobalConst.REPORTSTATE_HigherFail+"')");
                }
                else
                {
                    stateSql.Append(" AND REPORTSTATE_STATE= '" + ReportGlobalConst.REPORTSTATE_HigherExam + "'");
                }

                stateSql.Append(" AND REPORTSTATE_COMPANYID " + companyService.GetFillReportAuthorityCompaniesIdSql() + "");
                return stateSql.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 上级审核
        /// </summary>
        /// <param name="rse"></param>
        public void HigherExamReportState(ReportStateEntity rse)
        {
            try
            {
                string sql = "SELECT * FROM CT_STATE_REPORTSTATE WHERE REPORTSTATE_ID IN (" + CreateIdSqls(rse.Id, rse.Ids) + ")";
                List<ReportStateEntity> reportStateLists = dbManager.ExecuteSqlReturnTType<ReportStateEntity>(sql);
                foreach (ReportStateEntity state in reportStateLists)
                {                   
                    ReportStateDetailEntity rsde = new ReportStateDetailEntity();
                    state.State = rse.State;
                    //更新报表状态
                    state.Creater = SessoinUtil.GetCurrentUser().Id;
                    state.CreateTime = SessoinUtil.GetCurrentDateTime();
                    state.Discription = rse.Discription;
                    UpdateHigherReportState(state);
                    //更新操作类型
                    rsde.OperationType = reportProcessManager.GetHigherStateName(state);
                    //更新审计报表状态明细                    
                    BeanUtil.CopyBeanToBean(state, rsde);
                    rsde.StateId = state.Id;
                    rsde.Id = Guid.NewGuid().ToString();
                    linqDbManager.InsertEntity<ReportStateDetailEntity>(rsde);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        private void UpdateHigherReportState(ReportStateEntity rse)
        {
            try
            {
                string sql = "UPDATE CT_STATE_REPORTSTATE SET REPORTSTATE_RESULT='" + rse.StageResult + "',REPORTSTATE_STATE='" + rse.State + "' WHERE REPORTSTATE_ID='" + rse.Id + "'";
                dbManager.ExecuteSql(sql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion
    }
}
