using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.ExportReport;
using AuditSPI;
using AuditSPI.ExportReport;
using CtTool;
using DbManager;
using AuditSPI.ReportData;
using AuditService.Analysis.Formular;
using GlobalConst;
using System.Data;
using AuditEntity;
using System.IO;

using Aspose.Words;
using Aspose.Words.Attributes;
using Aspose.Words.BuildingBlocks;
using Aspose.Words.Drawing;
using Aspose.Words.Fields;
using Aspose.Words.Fonts;
using Aspose.Words.Layout;
using Aspose.Words.Lists;
using Aspose.Words.Loading;
using Aspose.Words.Markup;
using Aspose.Words.Math;
using Aspose.Words.Properties;
using Aspose.Words.Rendering;
using Aspose.Words.Reporting;
using Aspose.Words.Saving;
using Aspose.Words.Settings;
using Aspose.Words.Tables;

namespace AuditService.ExportReport
{
    public  class CreateReportService:ICreateReport
    {
        private CTDbManager dbManager;
        private LinqDataManager linqDbManager;
        private ReportTemplateService reportTemplateService;
        private FormularService formularService;
        private CompanyService companyService;
        private ReportCycleService reportCycleService;

        public CreateReportService()
        {
            if (dbManager == null)
            {
                dbManager = new CTDbManager();
            }
            if (linqDbManager == null)
            {
                linqDbManager = new LinqDataManager();
            }
            if (reportTemplateService == null)
            {
                reportTemplateService = new ReportTemplateService();
            }
            if (formularService == null)
            {
                formularService = new FormularService();
            }
            if (companyService == null)
            {
                companyService = new CompanyService();
            }
            if (reportCycleService == null)
            {
                reportCycleService = new ReportCycleService();
            }

        }

        #region  生成报告
        /// <summary>
        /// 形成智能报告
        /// 1、获取相关模板的书签
        /// 2、解析相关的书签，并实现书签的插入
        /// </summary>
        /// <param name="templateReportStruct"></param>
        public void CreateReport(CreateTemplateReportStruct templateReportStruct,string filePath)
        {
            try
            {
                //构建宏函数替换辅助参数
                ReportDataParameterStruct rdps = new ReportDataParameterStruct();
                rdps.Year = templateReportStruct.templateLog.Year;
                rdps.Cycle = templateReportStruct.templateLog.Cycle;
                //宏函数
                MacroHelp macro = new MacroHelp();
                macro.ReportParameter = rdps;

                foreach (string  company in templateReportStruct.templates.Keys)
                {
                    rdps.CompanyId = company;
                    List<ReportTemplateEntity> currentTemplates = templateReportStruct.templates[company];
                    foreach (ReportTemplateEntity template in currentTemplates)
                    {
                        //获取模板信息
                        ReportTemplateEntity templateEntity=new ReportTemplateEntity();                        
                        templateEntity = reportTemplateService.GetReportTemplate(template);
                        //获取当前模板的书签
                        List<BookmarkEntity> bookmarks = reportTemplateService.GetBookmarksByTemplateId(template.Id);
                        if(!File.Exists(templateEntity.AttatchAddress))continue;
                        if(StringUtil.IsNullOrEmpty(templateEntity.AttatchAddress))continue;
                        //创建报告
                        Document doc = new Document(templateEntity.AttatchAddress);
                        DocumentBuilder builder = new DocumentBuilder(doc);
                       
                        //初始报表模板生成日志                         
                        templateReportStruct.templateLog.AttatchName = templateEntity.Name +  GetFileExtend(templateEntity);
                          templateReportStruct.templateLog.CompanyId =company;
                          templateReportStruct.templateLog.TemplateId = template.Id;

                        foreach (BookmarkEntity bookmark in bookmarks)
                        {
                            try
                            {
                                builder.MoveToBookmark(bookmark.Name);
                                if (bookmark.Type == CreateReportConst.BOOKMARK_INDEX)
                                {
                                    //替换宏函数
                                    if (bookmark.MacroOrFormular == CreateReportConst.BOOKMARK_MACRO)
                                    {
                                        bookmark.Content = macro.ReplaceMacroVariable(bookmark.Content);
                                    }
                                    else if (bookmark.MacroOrFormular == CreateReportConst.BOOKMARK_FORMULAR)
                                    {
                                        //公式解析
                                        FormularEntity formular = new FormularEntity();
                                        formular.content = bookmark.Content;
                                        formular.FormularDb = bookmark.DataSource;

                                        DataTable table = formularService.GetSingleFatchFormularData(rdps, formular);
                                        if (table.Rows.Count > 0 && !StringUtil.IsNullOrEmpty(table.Rows[0][0]))
                                        {
                                            bookmark.Content = Convert.ToString(table.Rows[0][0]);
                                        }
                                        else
                                        {
                                            bookmark.Content = "0";
                                        }
                                    }
                                    if (bookmark.Thousand == "1")
                                    {
                                        bookmark.Content = FormatValue(bookmark.Content);
                                    }
                                    builder.Write(bookmark.Content);
                                }
                                else if (bookmark.Type == CreateReportConst.BOOKMARK_TABLE)
                                {
                                    FormularEntity formular = new FormularEntity();
                                    formular.content = bookmark.Content;
                                    formular.FormularDb = bookmark.DataSource;

                                    DataTable table = formularService.GetSingleFatchFormularData(rdps, formular);
                                    if (table.Rows.Count > 0)
                                    {
                                        Table wtable = builder.StartTable();
                                        builder.RowFormat.HeadingFormat = true;
                                        builder.ParagraphFormat.FirstLineIndent = 0;
                                        foreach (DataRow row in table.Rows)
                                        {
                                            foreach (DataColumn col in table.Columns)
                                            {
                                                if (!StringUtil.IsNullOrEmpty(row[col.ColumnName]))
                                                {
                                                    builder.InsertCell();
                                                    string value=Convert.ToString(row[col.ColumnName]);
                                                    if (StringUtil.IsOrNotNumber(value))
                                                    {
                                                        value = FormatValue(value);
                                                    }
                                                    builder.Write(value);
                                                }
                                                else
                                                {
                                                    builder.InsertCell();
                                                    builder.Write("0");
                                                }
                                            }
                                            builder.EndRow();
                                        }
                                        builder.EndTable();

                                    }

                                }
                                else if (bookmark.Type == CreateReportConst.BOOKMARK_TEXT)
                                {
                                    builder.MoveToBookmark(bookmark.Name);
                                    if (bookmark.Thousand == "1")
                                    {
                                        bookmark.Content = FormatValue(bookmark.Content);
                                    }
                                    builder.Write(bookmark.Content);
                                }
                                
                            }
                            catch (Exception ex)
                            {
                                throw new Exception("指标【"+bookmark.Name+"】取数公式报错:"+ex.Message);
                            }
                            
                        }
                        //保存相应的模板
                        string instancePath = filePath + Guid.NewGuid().ToString() + GetFileExtend(templateEntity);
                        templateReportStruct.templateLog.InstanceAddress = instancePath;
                        //生成模板保存日志
                        SaveTemplateInstanceLog(templateReportStruct.templateLog);
                        //保存文档
                        doc.Save(instancePath);
                      
                        
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        private string FormatValue(string value)
        {
            StringBuilder sb = new StringBuilder();
            string sValue = value;
            string symbol = sValue.Substring(0, 1);

            if (symbol == "-" || symbol == "+")
            {
                sValue = sValue.Substring(1);
            }
            else
            {
                symbol = "";
            }
            if (true)
            {
                List<string> list = new List<string>();

                string temp = sValue;
               

                bool includeFloat = sValue.LastIndexOf(".") != -1;

                if (includeFloat)
                {
                    //temp = temp.Substring(0, sP);
                    temp = temp.Substring(0, sValue.IndexOf("."));
                }
                int templength = temp.Length;
                if (temp.Length > 3)
                {
                    while (templength > 3)
                    {
                        list.Add(temp.Substring(templength - 3, 3));
                        templength -= 3;
                    }

                    //最前面的添加进来
                    list.Add(temp.Substring(0, temp.Length - list.Count * 3));

                    for (int i = list.Count - 1; i > 0; i--)
                    {
                        sb.Append(list[i] + ",");
                    }
                    sb.Append(list[0]);

                    if (includeFloat)
                    {
                        sb.Append(sValue.Substring(sValue.LastIndexOf(".")));
                    }
                }
                else
                {
                    return sValue;
                }
            }
            return symbol+ sb.ToString();
        }
        /// <summary>
        /// 获取文件的后缀
        /// </summary>
        /// <param name="reportTemplate"></param>
        /// <returns></returns>
        private string GetFileExtend(ReportTemplateEntity reportTemplate)
        {
            try
            {
                if (reportTemplate.ExportType == CreateReportConst.TEMPLATE_PDF)
                {
                    return ".pdf";
                }
                else if (reportTemplate.ExportType == CreateReportConst.TEMPLATE_WORD)
                {
                    return ".doc";
                }
                else
                {
                    return ".doc";
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 保存文件的日志列表
        /// </summary>
        /// <param name="templateLog"></param>
        public void SaveTemplateInstanceLog(TemplateLogEntity templateLog)
        {
            try
            {
                //删除当前模板生成日志
                StringBuilder sql = new StringBuilder();
                sql.Append("SELECT * FROM CT_REPORT_TEMPLATELOG WHERE ");
                sql.Append(" TEMPLATELOG_COMPANYID='"+templateLog.CompanyId+"' ");
                sql.Append(" AND TEMPLATELOG_TEMPLATEID='"+templateLog.TemplateId+"'");
                sql.Append(" AND TEMPLATELOG_YEAR='"+templateLog.Year+"'");
                sql.Append(" AND TEMPLATELOG_CYCLE='"+templateLog.Cycle+"'");
                sql.Append(" AND TEMPLATELOG_TYPE='"+templateLog.CycleType+"'");

                List<TemplateLogEntity> logList = dbManager.ExecuteSqlReturnTType<TemplateLogEntity>(sql.ToString());
                if (logList.Count > 0)
                {
                    if (File.Exists(logList[0].InstanceAddress))
                    {
                        File.Delete(logList[0].InstanceAddress);
                    }
                    sql.Length = 0;
                    sql.Append("UPDATE CT_REPORT_TEMPLATELOG SET TEMPLATELOG_ADDRESS='" + templateLog.InstanceAddress + "',TEMPLATELOG_ATTATCHNAME='" + templateLog.AttatchName + "',TEMPLATELOG_STATE='01'");
                    sql.Append(" WHERE TEMPLATELOG_ID='"+logList[0].Id+"'");
                    dbManager.ExecuteSql(sql.ToString());
                }
                else
                {
                    templateLog.Id = Guid.NewGuid().ToString();
                    templateLog.Creater = SessoinUtil.GetCurrentUser().Id;
                    templateLog.State = "01";                   
                    templateLog.CreateTime = SessoinUtil.GetCurrentDateTime();
                    linqDbManager.InsertEntity<TemplateLogEntity>(templateLog);
                }
                
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion
        #region 获取生成报告单位、获取生成报告年度周期、根据单位获取报告模板
        /// <summary>
        /// 获取智能报告数据
        /// </summary>
        /// <param name="templateLog"></param>
        /// <returns></returns>
        public CreateTemplateReportStruct GetCreateTemplateData(TemplateLogEntity templateLog)
        {
            try
            {
                CreateTemplateReportStruct ctrs = new CreateTemplateReportStruct();
                //获取周期
                ctrs.reportCycleStruct = GetReportTemplateCycle(templateLog);
                //获取单位
               // ctrs.companyTree = GetCompaniesByAuthority();
                
                return ctrs;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 获取有权限的单位
        /// </summary>
        /// <param name="reportTemplate"></param>
        /// <returns></returns>
        public List<CompanyEntity> GetCompaniesByAuthority(CompanyEntity companyEntity)
        {
            try
            {
                StringBuilder sql = new StringBuilder();
                sql.Append("SELECT * FROM LSBZDW WHERE ");
                if (StringUtil.IsNullOrEmpty(companyEntity.Id))
                {
                    sql.Append(" LSBZDW_ID='"+SessoinUtil.GetCurrentUser().OrgnizationId+"'");
                    sql.Append(" AND ");
                }
                else
                {
                    sql.Append(" LSBZDW_PARENTID='"+companyEntity.Id+"'");
                    sql.Append(" AND ");
                }
                sql.Append(companyService.GetNormalAuthorityCompaniesSql());
                List<CompanyEntity> companies = dbManager.ExecuteSqlReturnTType<CompanyEntity>(sql.ToString());
                foreach (CompanyEntity company in companies)
                {
                    sql.Length = 0;
                    sql.Append("SELECT COUNT(*) FROM LSBZDW WHERE LSBZDW_PARENTID='"+company.Id+"' AND ");
                    sql.Append(companyService.GetNormalAuthorityCompaniesSql());
                    int count = dbManager.Count(sql.ToString());
                    if (count > 0) company.state = "closed";
                }

                return companies;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 获取模板根据单位ID
        /// </summary>
        /// <param name="reportTemplate"></param>
        /// <param name="companyId"></param>
        /// <returns></returns>
        public List<ReportTemplateEntity> GetReportTemplatesByCompanyId(TemplateLogEntity templateLogEntity)
        {
            try
            {
                StringBuilder sql = new StringBuilder();
                sql.Append("SELECT * FROM CT_REPORT_TEMPLATE INNER JOIN CT_REPORT_TEMPLATEANDCOMPANY ");
                sql.Append("ON TEMPLATE_ID=TEMPLATEANDCOMPANY_TEMPLATEID ");
                sql.Append("AND ");
                sql.Append("TEMPLATEANDCOMPANY_COMPANYID='"+templateLogEntity.CompanyId+"'");
                List<ReportTemplateEntity> templates = dbManager.ExecuteSqlReturnTType<ReportTemplateEntity>(sql.ToString());
                return templates;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 获取模板对应的年度周期
        /// </summary>
        /// <param name="templateLogEntity"></param>
        /// <returns></returns>
        public ReportCycleStruct GetReportTemplateCycle(TemplateLogEntity templateLogEntity)
        {
            try
            {
                ReportCycleStruct rcs = new ReportCycleStruct();
                rcs.CurrentNd = templateLogEntity.Year;
                rcs.CurrentZq = templateLogEntity.Cycle;
                rcs.ReportType = templateLogEntity.CycleType;
                rcs = reportCycleService.GetReportCycleData(rcs);
                return rcs;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #endregion
        /// <summary>
        /// 获取生成报告的下载记录DataGrid
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="templateLogEntity"></param>
        /// <returns></returns>
        public DataGrid<TemplateLogEntity> GetTemplateLogList(DataGrid<TemplateLogEntity> dataGrid, TemplateLogEntity templateLogEntity)
        {
            try
            {
                return GetTempalteLogListByState(dataGrid, templateLogEntity, ReportTemplateLogStateEnum.All);
                
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public  DataGrid<TemplateLogEntity> GetTempalteLogListByState(DataGrid<TemplateLogEntity> dataGrid, TemplateLogEntity templateLogEntity,ReportTemplateLogStateEnum reportStateType)
        {
            try
            {
                DataGrid<TemplateLogEntity> dg = new DataGrid<TemplateLogEntity>();
                StringBuilder sql = new StringBuilder();
                StringBuilder countSql = new StringBuilder();
                //构造SQL
                sql.Append("SELECT TEMPLATELOG_ID,TEMPLATELOG_COMPANYID,TEMPLATELOG_TEMPLATEID,TEMPLATELOG_YEAR,TEMPLATELOG_CYCLE,TEMPLATELOG_CREATETIME,TEMPLATELOG_TYPE,TEMPLATELOG_ADDRESS,TEMPLATELOG_ATTATCHNAME,TEMPLATELOG_STATE,");
                sql.Append("LSBZDW_DWBH,LSBZDW_DWMC,");
                sql.Append("TEMPLATE_CODE,TEMPLATE_NAME ");
                countSql.Append("SELECT COUNT(*)");
                CreateTemplateLoglisSql(templateLogEntity, sql,reportStateType);
                CreateTemplateLoglisSql(templateLogEntity, countSql,reportStateType);
                //构造映射
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<TemplateLogEntity>();
                maps.Add("CompanyCode", "LSBZDW_DWBH");
                maps.Add("CompanyName", "LSBZDW_DWMC");
                maps.Add("TemplateCode", "TEMPLATE_CODE");
                maps.Add("TemplateName", "TEMPLATE_NAME");
                string sortName = maps[dataGrid.sort];
                dg.rows = dbManager.ExecuteSqlReturnTType<TemplateLogEntity>(sql.ToString(), dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
                foreach (TemplateLogEntity t in dg.rows)
                {
                    t.State = CreateReportConst.GetTemplateSateNameByState(t.State);
                }
                dg.total = dbManager.Count(countSql.ToString());
                return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 构造Sql公式
        /// </summary>
        /// <param name="templateLogEntity"></param>
        /// <param name="sql"></param>
        private void CreateTemplateLoglisSql(TemplateLogEntity templateLogEntity,StringBuilder sql,ReportTemplateLogStateEnum reportStateType)
        {
            try
            {
                sql.Append(" FROM CT_REPORT_TEMPLATELOG INNER JOIN LSBZDW ON TEMPLATELOG_COMPANYID =LSBZDW_ID ");
                sql.Append(" INNER JOIN CT_REPORT_TEMPLATE ON TEMPLATELOG_TEMPLATEID=TEMPLATE_ID ");
                sql.Append(" WHERE 1=1 ");

                if (reportStateType == ReportTemplateLogStateEnum.All)
                {
                }
                else if(reportStateType == ReportTemplateLogStateEnum.Exam)
                {
                    sql.Append(" AND ");
                    sql.Append("( TEMPLATELOG_STATE='01' OR TEMPLATELOG_STATE='03')");
                }
                else if (reportStateType == ReportTemplateLogStateEnum.CancelExam)
                {
                     sql.Append(" AND ");
                    sql.Append(" TEMPLATELOG_STATE='02'");
                }
                else if (reportStateType == ReportTemplateLogStateEnum.Seal)
                {
                    sql.Append(" AND ");
                    sql.Append(" TEMPLATELOG_STATE='02'");
                }
                else if (reportStateType == ReportTemplateLogStateEnum.CancelSeal)
                {
                    sql.Append(" AND ");
                    sql.Append(" TEMPLATELOG_STATE='04'");
                }

                if (!StringUtil.IsNullOrEmpty(templateLogEntity.CycleType))
                {
                    sql.Append(" AND ");
                    sql.Append(" TEMPLATELOG_TYPE = '" + templateLogEntity.CycleType + "'");
                }
                if (!StringUtil.IsNullOrEmpty(templateLogEntity.Year))
                {
                    sql.Append(" AND ");
                    sql.Append(" TEMPLATELOG_YEAR = '" + templateLogEntity.Year + "'");
                }
                if (!StringUtil.IsNullOrEmpty(templateLogEntity.Cycle))
                {
                    sql.Append(" AND ");
                    sql.Append(" TEMPLATELOG_CYCLE = '" + templateLogEntity.Cycle + "'");
                }
                if (!StringUtil.IsNullOrEmpty(templateLogEntity.CompanyCode))
                {
                    sql.Append(" AND ");
                    sql.Append(" LSBZDW_DWBH LIKE '%"+templateLogEntity.CompanyCode+"%'");
                }
                if (!StringUtil.IsNullOrEmpty(templateLogEntity.CompanyName))
                {
                    sql.Append(" AND ");
                    sql.Append(" LSBZDW_DWMC LIKE '%" + templateLogEntity.CompanyName + "%'");
                }
                if (!StringUtil.IsNullOrEmpty(templateLogEntity.TemplateCode))
                {
                    sql.Append(" AND ");
                    sql.Append(" TEMPLATE_CODE LIKE '%" + templateLogEntity.TemplateCode + "%'");
                }
                if (!StringUtil.IsNullOrEmpty(templateLogEntity.TemplateName))
                {
                    sql.Append(" AND ");
                    sql.Append(" TEMPLATE_NAME LIKE '%" + templateLogEntity.TemplateName + "%'");
                }
                if (!StringUtil.IsNullOrEmpty(templateLogEntity.CompanyId))
                {
                    sql.Append(" AND ");
                    sql.Append(" TEMPLATELOG_COMPANYID ='" + templateLogEntity.CompanyId + "'");
                }
                sql.Append(" AND ");
                //增加权限
                sql.Append(companyService.GetNormalAuthorityCompaniesSql());
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 上传日志
        /// </summary>
        /// <param name="templateLog"></param>
        public void UploadLog(TemplateLogEntity templateLog,string filePath)
        {
            try
            {
                templateLog = linqDbManager.GetEntity<TemplateLogEntity>(r => r.Id == templateLog.Id);
                if (File.Exists(templateLog.InstanceAddress))
                {
                    File.Delete(templateLog.InstanceAddress);
                }
                StringBuilder sql = new StringBuilder();
                sql.Append("UPDATE CT_REPORT_TEMPLATELOG SET TEMPLATELOG_ADDRESS='"+filePath+"',");
                sql.Append("TEMPLATELOG_STATE='01' WHERE ");
                sql.Append(" TEMPLATELOG_ID='"+templateLog.Id+"'");
                dbManager.ExecuteSql(sql.ToString());

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 下载日志
        /// </summary>
        /// <param name="templateLog"></param>
        public void DownloadLog(TemplateLogEntity templateLog)
        {
            try
            {
                StringBuilder sql = new StringBuilder();
                sql.Append("UPDATE CT_REPORT_TEMPLATELOG SET TEMPLATELOG_DOWNLOADNUM=TEMPLATELOG_DOWNLOADNUM+1");
                sql.Append(" WHERE ");
                sql.Append(" TEMPLATELOG_ID='" + templateLog.Id + "'");
                dbManager.ExecuteSql(sql.ToString());
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
