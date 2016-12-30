using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.ReportLink;
using AuditSPI.ReportLink;
using DbManager;
using CtTool;
using AuditEntity.ReportAudit;
using AuditSPI.ReportAudit;
using AuditService.ReportAudit;
using AuditService.ReportData;
using GlobalConst;
using AuditEntity;
using AuditSPI.ReportData;
using AuditService;
using System.Data;

namespace AuditService.ReportLink
{
   public  class ReportLinkService:IReportLink
    {
       private CTDbManager dbManager;
       private LinqDataManager linqDbManager;
       private FillReportService fillReportService;
       private ReportFormatService reportFormatService;
       private FormularService formularService;
       public ReportLinkService()
       {
           if (dbManager == null)
           {
               dbManager = new CTDbManager();
           }
           if (linqDbManager == null)
           {
               linqDbManager = new LinqDataManager();
           }
           if (fillReportService == null)
           {
               fillReportService = new FillReportService();
           }
           if (reportFormatService == null)
           {
               reportFormatService = new ReportFormatService();
           }
           if (formularService == null)
           {
               formularService = new FormularService();
           }
       }
       /// <summary>
       /// 报表联查定义保存
       /// 1、如果当前定义已经存在，则
       /// </summary>
       /// <param name="ReportLinkEntities"></param>
        public void SaveReportLink(ReportLinkEntity reportLinkEntity)
        {
            try
            {
                StringBuilder sql = new StringBuilder();

                    //判断当前定义是否存在当前单元格的定义
                    sql.Append("SELECT REPORTLINK_ID,REPORTLINK_REPORTID,REPORTLINK_INDEXCODE FROM CT_REPORTLINK ");
                    sql.Append(" WHERE  REPORTLINK_ID='" + reportLinkEntity.Id + "'");
                    List<ReportLinkEntity> links = dbManager.ExecuteSqlReturnTType<ReportLinkEntity>(sql.ToString());
                    if (links.Count > 0)
                    {
                        sql.Length = 0;
                        sql.Append("UPDATE CT_REPORTLINK SET REPORTLINK_DEFINITION='" + reportLinkEntity.Definition + "', REPORTLINK_CODE='"+reportLinkEntity.Code+"' ,REPORTLINK_NAME='"+reportLinkEntity.Name+"',REPORTLINK_TYPE='"+reportLinkEntity.Type+"',REPORTLINK_INDEXCODE='"+reportLinkEntity.IndexCode+"'");
                        sql.Append(" WHERE  REPORTLINK_ID='"+reportLinkEntity.Id+"'");
                        dbManager.ExecuteSql(sql.ToString());
                    }
                    else
                    {
                        ReportLinkEntity reportLink = reportLinkEntity;
                        if(StringUtil.IsNullOrEmpty(reportLink.Id)){
                            reportLink.Id = Guid.NewGuid().ToString();
                            reportLink.Creater = SessoinUtil.GetCurrentUser().Id;
                            reportLink.CreateTime = SessoinUtil.GetCurrentDateTime();
                        }
                        linqDbManager.InsertEntity<ReportLinkEntity>(reportLink);
                    }

         
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private string CreateLinkWhereSql(ReportLinkEntity link)
        {
            try
            {
                return "WHERE REPORTLINK_REPORTID='" + link.ReportId + "' AND REPORTLINK_INDEXCODE='" + link.IndexCode + "' AND REPORTLINK_CODE='"+link.Code+"'";
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        private string CreateLinkListWhereSql(ReportLinkEntity link)
        {
            try
            {
                return "WHERE REPORTLINK_REPORTID='" + link.ReportId + "' AND REPORTLINK_INDEXCODE='" + link.IndexCode + "'";
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }




        public List<ReportLinkEntity> GetReportLinkList(ReportLinkEntity reportLink)
        {
            try
            {
                StringBuilder sql = new StringBuilder();
                sql.Append("SELECT * FROM CT_REPORTLINK ");
                sql.Append(CreateLinkListWhereSql(reportLink));
                return dbManager.ExecuteSqlReturnTType<ReportLinkEntity>(sql.ToString());

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public void DeleteReportLink(ReportLinkEntity reportLink)
        {
            try
            {
                string sql = "DELETE FROM CT_REPORTLINK WHERE REPORTLINK_ID='"+reportLink.Id+"'";
                dbManager.ExecuteSql(sql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 获取联查报表的数据
       /// </summary>
       /// <param name="cell"></param>
       /// <param name="reportLinkStruct"></param>
       /// <returns></returns>
        public ReportAuditStruct GetReportLinkData(ReportCellStruct cell, ReportLinkStruct reportLinkStruct)
        {
            try
            {
                ReportAuditStruct ras = new ReportAuditStruct();
                if (ReportGlobalConst.IsOrNotRelationTaskAndPaper)
                {
                    if (StringUtil.IsNullOrEmpty(reportLinkStruct.reportParameter.TaskId))
                    {
                        reportLinkStruct.reportParameter.TaskId = cell.reportParameter.TaskId;
                    }
                    if (StringUtil.IsNullOrEmpty(reportLinkStruct.reportParameter.PaperId))
                    {
                        reportLinkStruct.reportParameter.PaperId = cell.reportParameter.PaperId;
                    }
                }

                if (StringUtil.IsNullOrEmpty(reportLinkStruct.reportParameter.ReportId))
                {
                    reportLinkStruct.reportParameter.ReportId = cell.reportParameter.ReportId;
                }
                if (StringUtil.IsNullOrEmpty(reportLinkStruct.reportParameter.CompanyId))
                {
                    reportLinkStruct.reportParameter.CompanyId = cell.reportParameter.CompanyId;
                }
                if (StringUtil.IsNullOrEmpty(reportLinkStruct.reportParameter.Year))
                {
                    reportLinkStruct.reportParameter.Year = cell.reportParameter.Year;
                }
                if (StringUtil.IsNullOrEmpty(reportLinkStruct.reportParameter.Cycle))
                {
                    reportLinkStruct.reportParameter.Cycle = cell.reportParameter.Cycle;
                }
                ras.reportFormat = reportFormatService.LoadReportFormat(reportLinkStruct.reportParameter.ReportId);
                ras.reportData = fillReportService.LoadReportDatas(reportLinkStruct.reportParameter);

                return ras;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 获取自定义联查报表的数据
       /// </summary>
       /// <param name="cell"></param>
       /// <param name="customLink"></param>
       /// <returns></returns>
        public CustomerGridDataStruct GetCustomLinkData(ReportCellStruct cell, CustomLinkStruct customLink)
        {
            try
            {
        

                CustomerGridDataStruct dataGrid = new CustomerGridDataStruct();
                ReportDataParameterStruct rdps = new ReportDataParameterStruct();
                rdps.TaskId = cell.reportParameter.TaskId;
                rdps.PaperId = cell.reportParameter.PaperId;
                rdps.ReportId = cell.reportParameter.ReportId;
                rdps.CompanyId = cell.reportParameter.CompanyId;
                rdps.Year = cell.reportParameter.Year;
                rdps.Cycle = cell.reportParameter.Cycle;


                FormularEntity formular = new FormularEntity();
                formular.content = customLink.Content;
                formular.FormularDb = customLink.DbType;
                DataTable dataTable = formularService.GetSingleFatchFormularData(rdps, formular);
                foreach (DataRow row in dataTable.Rows)
                {
                    Dictionary<string, object> rowD = new Dictionary<string, object>();
                    foreach (DataColumn column in dataTable.Columns)
                    {
                        rowD.Add(column.ColumnName, row[column.ColumnName]);
                    }
                    dataGrid.Rows.Add(rowD);
                }

                foreach (DataColumn column in dataTable.Columns)
                {
                    dataGrid.Columns.Add(column.ColumnName);
                }
                return dataGrid;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public ReportLinkEntity GetReportLinkEntity(string id)
        {
            try
            {
                return linqDbManager.GetEntity<ReportLinkEntity>(r => r.Id == id);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }


}
