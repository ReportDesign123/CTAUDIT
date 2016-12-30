using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.ExportReport;
using AuditEntity;

namespace AuditSPI.ExportReport
{
    public  interface ICreateReport
    {
        //形成报告
        void CreateReport(CreateTemplateReportStruct templateReportStruct, string filePath);
        List<CompanyEntity> GetCompaniesByAuthority(CompanyEntity companyEntity);
        //当前单位下的模板，只穿单位ID
         List<ReportTemplateEntity> GetReportTemplatesByCompanyId(TemplateLogEntity templateLogEntity);
         ReportCycleStruct GetReportTemplateCycle(TemplateLogEntity templateLogEntity);
        //第一次获取数据
         CreateTemplateReportStruct GetCreateTemplateData(TemplateLogEntity templateLog);

        //报告模板下载
         DataGrid<TemplateLogEntity> GetTemplateLogList(DataGrid<TemplateLogEntity> dataGrid, TemplateLogEntity templateLogEntity);
          DataGrid<TemplateLogEntity> GetTempalteLogListByState(DataGrid<TemplateLogEntity> dataGrid, TemplateLogEntity templateLogEntity, ReportTemplateLogStateEnum reportStateType);

         /// <summary>
        /// 上传日志
        /// </summary>
        /// <param name="templateLog"></param>
          void UploadLog(TemplateLogEntity templateLog, string filePath);

             /// <summary>
        /// 下载日志
        /// </summary>
        /// <param name="templateLog"></param>
        void DownloadLog(TemplateLogEntity templateLog);
    }
}
