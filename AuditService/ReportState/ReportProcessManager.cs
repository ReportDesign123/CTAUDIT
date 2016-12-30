using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditSPI.ReportState;
using GlobalConst;
using CtTool;
using AuditEntity.ReportState;

namespace AuditService.ReportState
{
   public  class ReportProcessManager
    {
       private ReportStateRecord record;
       public ReportProcessManager()
       {
           record = new ReportStateRecord();
           record.ProcessFlow.Add(ReportGlobalConst.REPORTSTATE_TB, "报表填报");
           record.ProcessFlow.Add(ReportGlobalConst.REPORTSTATE_JYTG, "校验通过");
           record.ProcessFlow.Add(ReportGlobalConst.REPORTSTATE_JYBTG, "校验不通过");
           record.ProcessFlow.Add(ReportGlobalConst.REPORTSTATE_SELFCHECK, "本级审核通过");
           record.ProcessFlow.Add(ReportGlobalConst.REPORTSTATE_EXAMPROCESS, "报表数据审批中");
           record.ProcessFlow.Add(ReportGlobalConst.REPORTSTATE_EXAMSUCESS, "报表审批通过");
           record.ProcessFlow.Add(ReportGlobalConst.REPORTSTATE_EXAMFAIL, "报表审批不通过");
           record.ProcessFlow.Add(ReportGlobalConst.REPORTSTATE_HigherExam, "上级审核通过");
           record.ProcessFlow.Add(ReportGlobalConst.REPORTSTATE_HigherFail, "上级审核不通过");     
       }
       /// <summary>
       /// 获取报表的当前状态名称
       /// </summary>
       /// <param name="stateCode"></param>
       /// <returns></returns>
       public string GetCurrentStateName(string stateCode)
       {
           try
           {
               if (record.ProcessFlow.ContainsKey(stateCode))
               {
                   return record.ProcessFlow[stateCode];
               }
               else
               {
                   throw new Exception("报表状态中不包含此状态");
               }
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }
       /// <summary>
       /// 获取报表状态
       /// </summary>
       /// <param name="reportState"></param>
       /// <returns></returns>
       public string GetHigherStateName(ReportStateEntity reportState)
       {
           try
           {
               string result = "";
               if (reportState.State == ReportGlobalConst.REPORTSTATE_HigherExam)
               {
                   result = "上级审核通过";
               }
               else if (ReportGlobalConst.REPORTSTATE_HigherFail == reportState.State)
               {
                   result = "上级审核不通过";
               }
               else if (ReportGlobalConst.REPORTSTATE_SELFCHECK == reportState.State)
               {
                   result = "取消上级审核";
               }
               return result;
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }
       /// <summary>
       /// 能够获取写锁
       /// </summary>
       /// <param name="stateCode"></param>
       /// <returns></returns>
       public bool AllowWrite(string stateCode)
       {
           try
           {
               if (StringUtil.IsNullOrEmpty(stateCode) || stateCode == ReportGlobalConst.REPORTSTATE_TB || stateCode == ReportGlobalConst.REPORTSTATE_JYTG || stateCode == ReportGlobalConst.REPORTSTATE_JYBTG)
               {
                   return true;
               }
               else
               {
                   return false;
               }
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }
       /// <summary>
       /// 本级审核之后是否进行资料审批；
       /// 如果审批流程中的下一步是审批则进行审批，否则不进行流程状态扭转
       /// </summary>
       /// <returns></returns>
       public bool IsOrNotExamReportAfterSelfCheck()
       {
           try
           {
               bool result = false;
               if(record.ProcessFlow.ContainsKey(ReportGlobalConst.REPORTSTATE_EXAMPROCESS)){
                   result = true;
               }
               return result;
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }

    
    }
}
