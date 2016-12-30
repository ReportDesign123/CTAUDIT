using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.ExportReport;
using AuditEntity;

namespace AuditSPI.ExportReport
{
    /// <summary>
    /// 形成报告数据结构
    /// </summary>
    public  class CreateTemplateReportStruct
    {

        public TemplateLogEntity templateLog = new TemplateLogEntity();

        public List<TreeNode> companyTree = new List<TreeNode>();
        public Dictionary<string, List<ReportTemplateEntity>> templates = new Dictionary<string, List<ReportTemplateEntity>>();
        //周期
        public ReportCycleStruct reportCycleStruct = new ReportCycleStruct();
    }

    public enum ReportTemplateLogStateEnum
    {
        All,
        Exam,
        CancelExam,
        Seal,
        CancelSeal
    }
}
