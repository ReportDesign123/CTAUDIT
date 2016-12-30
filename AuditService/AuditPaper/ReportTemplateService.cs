using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditSPI.AuditPaper;
using AuditEntity.AuditPaper;
using DbManager;
using CtTool;
using AuditSPI;

namespace AuditService.AuditPaper
{
    /// <summary>
    /// 审计底稿模板
    /// 目前将对其进行作废处理
    /// </summary>
   public  class ReportTemplateService:IReportTemplate
    {
       LinqDataManager linqDataManager;
       CTDbManager dbManager;
       public ReportTemplateService()
       {
           linqDataManager = new LinqDataManager();
           dbManager = new CTDbManager();
       }
       /// <summary>
       /// 保存底稿报告模板
       /// </summary>
       /// <param name="reportTemplate"></param>
        public void Save(AuditEntity.AuditPaper.ReportTemplateEntity reportTemplate)
        {
            try
            {
                if (StringUtil.IsNullOrEmpty(reportTemplate.Id))
                {
                    reportTemplate.Id = Guid.NewGuid().ToString();
                }
                reportTemplate.CreateTime = SessoinUtil.GetCurrentDateTime();
                linqDataManager.InsertEntity<ReportTemplateEntity>(reportTemplate);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 编辑底稿报告模板
       /// </summary>
       /// <param name="reportTemplate"></param>
        public void Edit(AuditEntity.AuditPaper.ReportTemplateEntity reportTemplate)
        {
            try
            {
                ReportTemplateEntity rte = linqDataManager.GetEntity<ReportTemplateEntity>(r=>r.Id==reportTemplate.Id);
                BeanUtil.CopyBeanToBean(reportTemplate, rte);
                reportTemplate.CreateTime = SessoinUtil.GetCurrentDateTime();
                linqDataManager.UpdateEntity<ReportTemplateEntity>(rte);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 删除底稿报告模板
       /// </summary>
       /// <param name="reportTemplate"></param>
        public void Delete(AuditEntity.AuditPaper.ReportTemplateEntity reportTemplate)
        {
            try
            {
                ReportTemplateEntity rte = linqDataManager.GetEntity<ReportTemplateEntity>(r => r.Id == reportTemplate.Id);
                linqDataManager.Delete<ReportTemplateEntity>(rte);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public AuditSPI.DataGrid<ReportTemplateEntity> getDataGrid(AuditSPI.DataGrid<ReportTemplateEntity> dataGrid,ReportTemplateEntity rte)
        {
            try
            {
                DataGrid<ReportTemplateEntity> dg = new DataGrid<ReportTemplateEntity>();
                string sql = "SELECT * FROM CT_PAPER_REPORTTEMPLATE";
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<ReportTemplateEntity>();
                string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<ReportTemplateEntity>(rte);
                if (whereSql.Length > 0)
                {
                    sql += " WHERE "+whereSql;
                }
                string sortName = maps[dataGrid.sort];
                List<ReportTemplateEntity> lists = dbManager.ExecuteSqlReturnTType<ReportTemplateEntity>(sql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
                sql = "SELECT COUNT(*) FROM CT_PAPER_REPORTTEMPLATE";
                if (whereSql.Length > 0)
                {
                    sql += " WHERE " + whereSql;
                }
                int count = dbManager.Count(sql);
                dg.rows = lists;
                dg.total = count;
                return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public ReportTemplateEntity Get(string id)
        {
            try
            {
                return linqDataManager.GetEntity<ReportTemplateEntity>(r => r.Id == id);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
