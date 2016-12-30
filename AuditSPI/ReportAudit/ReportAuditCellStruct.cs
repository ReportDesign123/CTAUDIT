using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.ReportAudit;
using AuditSPI.ReportData;

namespace AuditSPI.ReportAudit
{
   public  class ReportAuditCellStruct
    {    
       /// <summary>
       /// 审计单元格结论
       /// </summary>
       public ReportAuditCellConclusion reportAuditCellConclusion = new ReportAuditCellConclusion();
       /// <summary>
       /// 审计单元格统计信息
       /// </summary>
       public ReportAuditCellStatistic reportAuditCellStatistic = new ReportAuditCellStatistic();
       /// <summary>
       /// 审计单元格评论信息
       /// </summary>
       public List<ReportAuditCellCommentDetail> Comments = new List<ReportAuditCellCommentDetail>();
       /// <summary>
       /// 审计单元格转发信息
       /// </summary>
       public List<ReportAuditCellCommentDetail> transmits = new List<ReportAuditCellCommentDetail>();
      
    }
    /// <summary>
    /// 指标列表
    /// </summary>
   public class RelationsIndexesDataStruct
   {
       public List<ItemDataValueStruct> LastPeriodNumber;
       public List<ItemDataValueStruct> SamePeriodNumber;
       public List<ItemDataValueStruct> RelativeRatio;
       public List<ItemDataValueStruct> SameRatio;
       public RelationsIndexesDataStruct()
       {
           this.LastPeriodNumber = new List<ItemDataValueStruct>();
           this.SamePeriodNumber = new List<ItemDataValueStruct>();
           this.RelativeRatio = new List<ItemDataValueStruct>();
           this.SameRatio = new List<ItemDataValueStruct>();
       }

   }



    
    
}
