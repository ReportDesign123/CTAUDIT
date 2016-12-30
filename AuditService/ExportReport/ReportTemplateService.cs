using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DbManager;
using CtTool;
using AuditEntity.ExportReport;
using AuditSPI.ExportReport;
using AuditSPI;
using System.IO;
using AuditExportImport.ExportReport;


namespace AuditService.ExportReport
{
    /// <summary>
    /// 报表模板服务
    /// </summary>
    public  class ReportTemplateService:IReportTemplate,IReportTemplateBookmark
    {
        private CTDbManager dbManager;
        private LinqDataManager linqDbManager;
        public ReportTemplateService()
        {
            if (dbManager == null)
            {
                dbManager = new CTDbManager();
            }
            if (linqDbManager == null)
            {
                linqDbManager = new LinqDataManager();
            }

        }

        /// <summary>
        /// 获取审计模板表格列表
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="reportTemplate"></param>
        /// <returns></returns>
        public AuditSPI.DataGrid<ReportTemplateEntity> GetReportTemplateDataGrid(AuditSPI.DataGrid<ReportTemplateEntity> dataGrid, ReportTemplateEntity reportTemplate)
        {
            try
            {
                DataGrid<ReportTemplateEntity> dg = new DataGrid<ReportTemplateEntity>();
                StringBuilder sql = new StringBuilder();
                StringBuilder countSql = new StringBuilder();
                sql.Append("SELECT * FROM CT_REPORT_TEMPLATE ");
                countSql.Append("SELECT COUNT(*) FROM  CT_REPORT_TEMPLATE ");
                string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<ReportTemplateEntity>(reportTemplate);
                sql.Append(AddWhereSql(whereSql));
                countSql.Append(AddWhereSql(whereSql));
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<ReportTemplateEntity>();
                string sortName = maps[dataGrid.sort];
                dg.rows = dbManager.ExecuteSqlReturnTType<ReportTemplateEntity>(sql.ToString(), dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order , maps);
                dg.total = dbManager.Count(countSql.ToString());
                return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 增加Where条件
        /// </summary>
        /// <param name="whereSql"></param>
        /// <returns></returns>
        private string AddWhereSql(string whereSql)
        {
            try
            {
                if (!StringUtil.IsNullOrEmpty(whereSql))
                {
                    return " WHERE  " + whereSql;
                }
                else
                {
                    return "";
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 保存报告模板
        /// </summary>
        /// <param name="reportTemplate"></param>
        public void SaveReportTemplate(ReportTemplateEntity reportTemplate)
        {
            try
            {
                if (StringUtil.IsNullOrEmpty(reportTemplate.Id))
                {
                    reportTemplate.Id = Guid.NewGuid().ToString();
                    reportTemplate.Creater = SessoinUtil.GetCurrentUser().Id;
                    reportTemplate.CreateTime = SessoinUtil.GetCurrentDateTime();
                }
                linqDbManager.InsertEntity<ReportTemplateEntity>(reportTemplate);

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 编辑报告模板
        /// </summary>
        /// <param name="reportTemplate"></param>
        public void EditReportTemplate(ReportTemplateEntity reportTemplate)
        {
            try
            {
                ReportTemplateEntity temp = linqDbManager.GetEntity<ReportTemplateEntity>(r=>r.Id==reportTemplate.Id);
                reportTemplate.Creater = SessoinUtil.GetCurrentUser().Id;
                reportTemplate.CreateTime = SessoinUtil.GetCurrentDateTime();
                BeanUtil.CopyBeanToBean(reportTemplate, temp);
                linqDbManager.UpdateEntity<ReportTemplateEntity>(temp);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 删除模板
        /// 1、删除模板与报表的关联
        /// 2、删除模板与单位的关联
        /// 3、删除模板关联的附件
        /// 4、删除模板的当前内容
        /// </summary>
        /// <param name="reportTemplate"></param>
        public void DeleteReportTemplate(ReportTemplateEntity reportTemplate)
        {
            try
            {
                ReportTemplateEntity temp = linqDbManager.GetEntity<ReportTemplateEntity>(r => r.Id == reportTemplate.Id);
                //删除关系
                string sql = "DELETE FROM CT_REPORT_TEMPLATEANDREPORT WHERE TEMPLATEANDREPORT_TEMPLATEID='"+reportTemplate.Id+"'";
                dbManager.ExecuteSql(sql);
                sql = "DELETE FROM CT_REPORT_TEMPLATEANDCOMPANY WHERE TEMPLATEANDCOMPANY_TEMPLATEID='"+reportTemplate.Id+"'";
                dbManager.ExecuteSql(sql);
                //删除报告模板
                if (File.Exists(reportTemplate.AttatchAddress))
                {
                    File.Delete(reportTemplate.AttatchAddress);
                }
                sql = "DELETE FROM CT_REPORT_TEMPLATE WHERE TEMPLATE_ID='"+reportTemplate.Id+"'";
                dbManager.ExecuteSql(sql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public ReportTemplateEntity GetReportTemplate(ReportTemplateEntity reportTemplate)
        {
            try
            {
                return linqDbManager.GetEntity<ReportTemplateEntity>(r => r.Id == reportTemplate.Id);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 获取审计底稿模板的书签设置
        /// </summary>
        /// <param name="reportTemplate"></param>
        /// <returns></returns>
        public WordTemplateStruct GetWordTemplateStruct(ReportTemplateEntity reportTemplate)
        {
            try
            {
                ReportTemplateEntity template = GetReportTemplate(reportTemplate);
                //获取Word书签
                WordTemplateStruct wts = new WordTemplateStruct();
                wts.Bookmarks = GetBookmarks(template);
                
                //获取Word内容                
                if (File.Exists(template.HtmlAddress))
                {
                    wts.wordContent = "../../ct/attatchs/ExportReportAttatch/Template/" + template.Id + ".htm";
                }
                return wts;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        private List<BookmarkEntity> GetBookmarks(ReportTemplateEntity reportTemplate)
        {
            try
            {
                //获取Word中的标签
                List<BookmarkEntity> bookMarks = WordTool.ExportWordBookmarks(reportTemplate);
                string sql = "SELECT * FROM CT_REPORT_BOOKMARK WHERE BOOKMARK_TEMPLATEID='" + reportTemplate.Id + "'";
                List<BookmarkEntity> realBookmarks = dbManager.ExecuteSqlReturnTType<BookmarkEntity>(sql);
                if (realBookmarks.Count > 0)
                {
                    for (int i = 0; i < realBookmarks.Count; i++)
                    {
                        for (int j = 0; j < bookMarks.Count; j++)
                        {
                            if (realBookmarks[i].Name == bookMarks[j].Name)
                            {
                                bookMarks[j] = realBookmarks[i];
                                break;
                            }
                        }
                    }
                }
                return bookMarks;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 获取对应模板的书签设置
        /// </summary>
        /// <param name="templateId"></param>
        /// <returns></returns>
        public List<BookmarkEntity> GetBookmarksByTemplateId(string templateId)
        {
            try
            {
                string sql = "SELECT * FROM CT_REPORT_BOOKMARK WHERE BOOKMARK_TEMPLATEID='" + templateId + "'";
                List<BookmarkEntity> realBookmarks = dbManager.ExecuteSqlReturnTType<BookmarkEntity>(sql);
                return realBookmarks;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }



        /// <summary>
        /// 保存报告模板设计
        /// </summary>
        /// <param name="wordTemplate"></param>
        public void SaveWordTemplateStruct(WordTemplateStruct wordTemplate)
        {
            try
            {               
              
                foreach (BookmarkEntity bookMark in wordTemplate.Bookmarks)
                {
                    bookMark.TemplateId = wordTemplate.reportTemplate.Id;
                    if (StringUtil.IsNullOrEmpty(bookMark.Id))
                    {
                        bookMark.Id = Guid.NewGuid().ToString();
                        bookMark.Creater = SessoinUtil.GetCurrentUser().Id;
                        bookMark.CreateTime = SessoinUtil.GetCurrentDateTime();
                        bookMark.TemplateId = wordTemplate.reportTemplate.Id;
                        linqDbManager.InsertEntity<BookmarkEntity>(bookMark);
                    }
                    else
                    {
                        string sql = "UPDATE CT_REPORT_BOOKMARK SET BOOKMARK_TYPE='"+bookMark.Type
                            +"',BOOKMARK_CONTENT='"+bookMark.Content
                            + "',BOOKMARK_DATASOURCE='" + bookMark.DataSource + "',BOOKMARK_MACROORFORMULAR='" + bookMark.MacroOrFormular
                            + "',BOOKMARK_THOUSAND='"+bookMark.Thousand+"' WHERE BOOKMARK_ID='" + bookMark.Id + "'";
                        dbManager.ExecuteSql(sql);
                    }
                   
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public void UpdateReportTemplateBookmarks(ReportTemplateEntity reportTemplate,List<string> bookmarks)
        {
            try
            {

                string sql = "";
                if (reportTemplate.IsOrNotOverwrite == "1")
                {
                    sql = "DELETE FROM CT_REPORT_BOOKMARK WHERE BOOKMARK_TEMPLATEID='" + reportTemplate.Id + "'";
                    dbManager.ExecuteSql(sql);
                }
                else
                {
                    sql= "SELECT * FROM CT_REPORT_BOOKMARK WHERE BOOKMARK_TEMPLATEID='" + reportTemplate.Id + "'";
                    List<BookmarkEntity> oldBookMarks = dbManager.ExecuteSqlReturnTType<BookmarkEntity>(sql);
                    List<BookmarkEntity> deleteBookmarks = new List<BookmarkEntity>();
            
                    //获取已经删除的书签
                    foreach (BookmarkEntity ob in oldBookMarks)
                    {
                        bool flag = false;
                        foreach (string nb in bookmarks)
                        {
                            if (ob.Name == nb)
                            {
                                flag = true;
                            }
                        }
                        if (!flag)
                        {
                            deleteBookmarks.Add(ob);
                        }
                    }
                    //删除没有的标签
                    if(deleteBookmarks.Count>0){
                        string inSql = BeanUtil.ConvertListObjectsToInSql<BookmarkEntity>(deleteBookmarks, "BOOKMARK_ID");
                        sql = "DELETE FROM CT_REPORT_BOOKMARK WHERE "+inSql;
                        dbManager.ExecuteSql(sql);
                    }
                    
                }
                  
               
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
