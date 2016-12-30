using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.WorkFlow;
using AuditEntity.ReportState;

namespace AuditSPI.WorkFlow
{
    /// <summary>
    /// 工作流程定义
    /// 工作流程业务对象定义
    /// </summary>
    public  interface IWorkFlowDefinition
    {
        void EditWorkFlowEntity(WorkFlowDefinition wfd);
        WorkFlowDefinition GetWorkFlow(WorkFlowDefinition wfd);
        DataGrid<WorkFlowDefinition> DataGridWorkFlow(WorkFlowDefinition wfd,DataGrid<WorkFlowDefinition> dataGrid);
        void DeleteWorkFlow(WorkFlowDefinition wfd);
        void AddWorkFlow(WorkFlowDefinition wfd);
        void ReportExamine(ReportStateEntity rse,WorkFlowDirection wfd);
        void ReportExamineWorkFlowPublish(ReportStateEntity rse, WorkFlowDefinition wfd);
        List<WorkFlowDefinition> GetWorkFlowDefinitionLists(WorkFlowDefinition wfd);
    }

    public enum WorkFlowDirection{
        Forward,
        Backward
    }

    public enum StageResult
    {
        Success,
        Fail
    }
}
