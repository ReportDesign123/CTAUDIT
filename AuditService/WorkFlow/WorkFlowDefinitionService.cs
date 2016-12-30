using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.WorkFlow;
using AuditSPI.WorkFlow;
using AuditSPI;
using DbManager;
using CtTool;
using GlobalConst;
using AuditEntity;
using AuditService;
using AuditEntity.ReportState;

namespace AuditService.WorkFlow
{
   public  class WorkFlowDefinitionService:IWorkFlowBusinessDefinition,IWorkFlowDefinition
    {
       ILinqDataManager linqDbManager;
       CTDbManager dbManager;
       SystemService systemService;
       public WorkFlowDefinitionService()
       {
           if (linqDbManager == null)
           {
               linqDbManager = new LinqDataManager();
           }
           if (dbManager == null)
           {
               dbManager = new CTDbManager();
           }
           if (systemService == null)
           {
               systemService = new SystemService();
           }
       }
        public void EditBusinessEntity(WorkFlowBusinessEntity wfbe)
        {
            try
            {
                WorkFlowBusinessEntity temp = GetBusinessEntity(wfbe);
                BeanUtil.CopyBeanToBean(wfbe, temp);
                linqDbManager.UpdateEntity<WorkFlowBusinessEntity>(temp);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public WorkFlowBusinessEntity GetBusinessEntity(WorkFlowBusinessEntity wfbe)
        {
            try
            {
                return linqDbManager.GetEntity<WorkFlowBusinessEntity>(r => r.Id == wfbe.Id);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public AuditSPI.DataGrid<WorkFlowBusinessEntity> DataGridBusinessEntity(WorkFlowBusinessEntity wfbe, AuditSPI.DataGrid<WorkFlowBusinessEntity> dataGrid)
        {
            try
            {
                string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<WorkFlowBusinessEntity>(wfbe);
                if (!StringUtil.IsNullOrEmpty(whereSql))
                {
                    whereSql = " WHERE " + whereSql;
                }

                DataGrid<WorkFlowBusinessEntity> dg = new DataGrid<WorkFlowBusinessEntity>();
                string sql = "SELECT * FROM CT_WORKFLOW_BUSINESS   " + whereSql;
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<WorkFlowBusinessEntity>();
                string countSql = "SELECT COUNT(*) FROM CT_WORKFLOW_BUSINESS  " + whereSql;
                string sortName = maps[dataGrid.sort];
                dg.rows = dbManager.ExecuteSqlReturnTType<WorkFlowBusinessEntity>(sql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
                dg.total = dbManager.Count(countSql);
                return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void EditWorkFlowEntity(AuditEntity.WorkFlow.WorkFlowDefinition wfd)
        {
            try
            {
                WorkFlowDefinition temp = GetWorkFlow(wfd);
                BeanUtil.CopyBeanToBean(wfd, temp);
                wfd.Creater = SessoinUtil.GetCurrentUser().Id;
                wfd.CreateTime = SessoinUtil.GetCurrentDateTime();
                linqDbManager.UpdateEntity<WorkFlowDefinition>(temp);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public AuditEntity.WorkFlow.WorkFlowDefinition GetWorkFlow(AuditEntity.WorkFlow.WorkFlowDefinition wfd)
        {
            try
            {
                if (!StringUtil.IsNullOrEmpty(wfd.Code))
                {
                    return linqDbManager.GetEntity<WorkFlowDefinition>(r => r.Code == wfd.Code);
                }
                return linqDbManager.GetEntity<WorkFlowDefinition>(r => r.Id == wfd.Id );
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public AuditSPI.DataGrid<AuditEntity.WorkFlow.WorkFlowDefinition> DataGridWorkFlow(AuditEntity.WorkFlow.WorkFlowDefinition wfd, AuditSPI.DataGrid<AuditEntity.WorkFlow.WorkFlowDefinition> dataGrid)
        {
            try
            {
                string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<WorkFlowDefinition>(wfd);
                if (!StringUtil.IsNullOrEmpty(whereSql))
                {
                    whereSql = " WHERE " + whereSql;
                }

                DataGrid<WorkFlowDefinition> dg = new DataGrid<WorkFlowDefinition>();
                string sql = "SELECT * FROM CT_WORKFLOW_DEFINITION   " + whereSql;
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<WorkFlowDefinition>();
                string countSql = "SELECT COUNT(*) FROM CT_WORKFLOW_DEFINITION  " + whereSql;
                string sortName = maps[dataGrid.sort];
                dg.rows = dbManager.ExecuteSqlReturnTType<WorkFlowDefinition>(sql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
                dg.total = dbManager.Count(countSql);
                return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public void DeleteBusinessEntity(WorkFlowBusinessEntity wfbe)
        {
            try
            {
                WorkFlowBusinessEntity temp = GetBusinessEntity(wfbe);
                linqDbManager.Delete<WorkFlowBusinessEntity>(temp);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public void DeleteWorkFlow(WorkFlowDefinition wfd)
        {
            try
            {
                WorkFlowDefinition temp = GetWorkFlow(wfd);
                linqDbManager.Delete<WorkFlowDefinition>(temp);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public void AddBusinessEntity(WorkFlowBusinessEntity wfbe)
        {
            try
            {
                if (StringUtil.IsNullOrEmpty(wfbe.Id))
                {
                    wfbe.Id = Guid.NewGuid().ToString();
                }
                wfbe.BeginTime = SessoinUtil.GetCurrentDateTime();
                linqDbManager.InsertEntity<WorkFlowBusinessEntity>(wfbe);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public void AddWorkFlow(WorkFlowDefinition wfd)
        {
            try
            {
                if (StringUtil.IsNullOrEmpty(wfd.Id))
                {
                    wfd.Id = Guid.NewGuid().ToString();
                }
                wfd.CreateTime = SessoinUtil.GetCurrentDateTime();
                wfd.Creater = SessoinUtil.GetCurrentUser().Id;
                linqDbManager.InsertEntity<WorkFlowDefinition>(wfd);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

       /// <summary>
       /// 报表资料审批和反审批
       /// 1、获取报表流程顺序
       /// 2、根据当前的报表状态更新流程状态信息；
       /// 3、返回报表状态
       /// 孙海东
       /// </summary>
       /// <param name="rse">报表当前状态</param>
       /// <param name="wfd">报表审批方向：前进还是后退</param>       
        public void ReportExamine(AuditEntity.ReportState.ReportStateEntity rse, WorkFlowDirection wfd)
        {
            try
            {
                //获取报表审批系统配置
                ConfigEntity ce = systemService.GetConfigByName(ReportGlobalConst.REPORTEXAM_CONFIGNAME);
                if (ce == null) return;
                WorkFlowDefinition wfdd = new WorkFlowDefinition();
                //获取审批流程
                wfdd.Code = ce.Value;
                wfdd = GetWorkFlow(wfdd);
                if (wfdd == null) return;

                //根据报表状态和方向设置流程信息
                string[] nameValueArr=wfdd.WorkFlowOrder.Split(';');
                string[] valuesArr = nameValueArr[0].Split(',');

                switch (wfd)
                {
                    case WorkFlowDirection.Forward:
                        if (StringUtil.IsNullOrEmpty(rse.CurrentStageState))
                        {
                            //开始审批
                            rse.CurrentStageState = ReportGlobalConst.REPORTEXAM_START;
                            rse.State = ReportGlobalConst.REPORTSTATE_EXAMPROCESS;
                        }
                        else
                        {
                            //正常审批
                            rse.ProStageState = rse.CurrentStageState;
                            rse.CurrentStageState = rse.NextStageState;
                        }
                        //获取下一审批阶段
                        int index = GetCurrentIndex(rse.CurrentStageState, valuesArr)+1;
                        rse.NextStageState = valuesArr[index];
                        if (rse.NextStageState == ReportGlobalConst.REPORTEXAM_END)
                        {
                            rse.State = ReportGlobalConst.REPORTSTATE_EXAMSUCESS;
                        }
                        break;
                    case WorkFlowDirection.Backward:
                        //如果当前审批正好为结束阶段
                        if (rse.NextStageState == ReportGlobalConst.REPORTEXAM_END)
                        {
                            rse.State = ReportGlobalConst.REPORTSTATE_EXAMPROCESS;
                        }
                        //正常取消审批
                        rse.NextStageState = rse.CurrentStageState;
                        rse.CurrentStageState = rse.ProStageState;
                        //如果审批阶段为起初阶段
                        if (rse.CurrentStageState == ReportGlobalConst.REPORTEXAM_START)
                        {
                            rse.ProStageState = "";
                            rse.State = ReportGlobalConst.REPORTSTATE_SELFCHECK;
                        }
                        else
                        {
                            index = GetCurrentIndex(rse.CurrentStageState, valuesArr) - 1;
                            rse.ProStageState = valuesArr[index];
                          
                        }
                        break;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private int GetCurrentIndex(string currentState, string[] stateArr)
        {
            try
            {
                for (int i = 0; i < stateArr.Length-1; i++)
                {
                    if (stateArr[i] == currentState)
                    {
                        return i;
                    }
                }
                return -1;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

       /// <summary>
       /// 功能：报表资料审批流程发布
       /// 如果报表状态为本级审核通过，则进行工作流的启动；并更新当前宝宝状态为审批中；
       /// 如果报表当前状态存在于当前工作流状态中，则进行报表的流程状态更新；
       /// 如果报表的状态为最后一个状态，需要更新当前的报表状态为审批结束。
       /// 
       /// 第二次更新：
       /// 如果系统中存在报表状态，且报表状态为本级审核通过、
       /// 审批中、审批通过和审批不通过这四种情况下才进行审批流程的部署，
       /// 部署为审批流程的第一个阶段；
       /// </summary>
       /// <param name="wfd"></param>
        public void ReportExamineWorkFlowPublish(ReportStateEntity rse, WorkFlowDefinition wfd)
        {
            try
            {

                //根据报表状态和方向设置流程信息
                string[] nameValueArr=wfd.WorkFlowOrder.Split(';');
                string[] valuesArr = nameValueArr[0].Split(',');
                //报表为本级审核通过
                //只有是刚刚进行审批、审批中的单据才能够进行部署
                if (rse.State == ReportGlobalConst.REPORTSTATE_SELFCHECK||rse.State==ReportGlobalConst.REPORTSTATE_EXAMPROCESS||rse.State==ReportGlobalConst.REPORTSTATE_EXAMSUCESS||rse.State==ReportGlobalConst.REPORTSTATE_EXAMFAIL)
                {
                    rse.CurrentStageState = ReportGlobalConst.REPORTEXAM_START;
                    rse.NextStageState = valuesArr[1];
                    rse.State=ReportGlobalConst.REPORTSTATE_EXAMPROCESS;
                }
                //else
                //{

                //    //如果报表当前状态在报表工作流中
                //    int currentIndex = GetCurrentIndex(rse.CurrentStageState, valuesArr);
                //   // rse.ProStageState = valuesArr[currentIndex - 1];
                //    rse.NextStageState = valuesArr[currentIndex + 1];
                //    if (rse.NextStageState == ReportGlobalConst.REPORTEXAM_END)
                //    {
                //        rse.State = ReportGlobalConst.REPORTSTATE_EXAMSUCESS;
                //    }
                //}

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

       /// <summary>
       /// 获取工作流内审系统
       /// </summary>
       /// <param name="wfd"></param>
       /// <returns></returns>
        public List<WorkFlowDefinition> GetWorkFlowDefinitionLists(WorkFlowDefinition wfd)
        {
            try
            {
                string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<WorkFlowDefinition>(wfd);
                if (whereSql.Length > 0)
                {
                    whereSql = " WHERE " + whereSql;
                }
                else
                {
                    whereSql = "";
                }
                string sql = "SELECT DEFINITION_CODE,DEFINITION_NAME FROM CT_WORKFLOW_DEFINITION "+whereSql;
                List<WorkFlowDefinition> wfdlists = dbManager.ExecuteSqlReturnTType<WorkFlowDefinition>(sql);
                return wfdlists;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
