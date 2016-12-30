using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditSPI.ExportReport;
using CtTool;
using AuditEntity.ExportReport;
using DbManager;
using GlobalConst;
using AuditSPI;

namespace AuditService.ExportReport
{
  public   class BookmarkTemplateService:IBookmarkTemplate
    {
        private CTDbManager dbManager;
        public LinqDataManager linqDbManager;
        public BookmarkTemplateService()
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
        public AuditSPI.DataGrid<AuditEntity.ExportReport.BookmarkTemplateEntity> GetBookmarkTemplateDataGrid(AuditSPI.DataGrid<AuditEntity.ExportReport.BookmarkTemplateEntity> dataGrid, AuditEntity.ExportReport.BookmarkTemplateEntity bookmarkTempalte)
        {
            try
            {
                DataGrid<BookmarkTemplateEntity> dg = new DataGrid<BookmarkTemplateEntity>();
                StringBuilder sql = new StringBuilder();
                StringBuilder countSql = new StringBuilder();
                sql.Append("SELECT * FROM CT_REPORT_BOOKMARKTEMPLATE LEFT JOIN CT_REPORT_TEMPLATE ON BOOKMARKTEMPLATE_TEMPLATEID=TEMPLATE_ID ");
                countSql.Append("SELECT COUNT(*) FROM  CT_REPORT_BOOKMARKTEMPLATE  LEFT JOIN CT_REPORT_TEMPLATE ON BOOKMARKTEMPLATE_TEMPLATEID=TEMPLATE_ID ");
                string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<BookmarkTemplateEntity>(bookmarkTempalte);
                if (!StringUtil.IsNullOrEmpty(bookmarkTempalte.TemplateCode))
                {
                    whereSql += " AND TEMPLATE_CODE LIKE '%"+bookmarkTempalte.Code+"%'";
                }
                if (!StringUtil.IsNullOrEmpty(bookmarkTempalte.TemplateName))
                {
                    whereSql += " AND TEMPLATE_NAME LIKE '%" + bookmarkTempalte.TemplateName + "%'";
                }
                sql.Append(AddWhereSql(whereSql));
                countSql.Append(AddWhereSql(whereSql));
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<BookmarkTemplateEntity>();
                string sortName = maps[dataGrid.sort];
                dg.rows = dbManager.ExecuteSqlReturnTType<BookmarkTemplateEntity>(sql.ToString(), dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
                dg.total = dbManager.Count(countSql.ToString());
                return dg;
            }catch(Exception ex){
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
        public void SaveBookmarkTemplate(AuditEntity.ExportReport.BookmarkTemplateEntity bookmarkTemplate)
        {
            try
            {
                if (bookmarkTemplate.IsOrNotContinue != null && bookmarkTemplate.IsOrNotContinue == "1")
                {
                    //直接通过
                }
                else
                {
                    List<BookmarkTemplateEntity> temps = dbManager.ExecuteSqlReturnTType<BookmarkTemplateEntity>("SELECT * FROM CT_REPORT_BOOKMARKTEMPLATE WHERE BOOKMARKTEMPLATE_NAME='" + bookmarkTemplate.Name + "'");
                    if (temps != null && temps.Count > 0)
                    {
                        throw new MyException("已经具有同名的书签模板【" + temps[0].Name + "】,是否继续保存?", "1");
                    }
                }
              

               

                if (StringUtil.IsNullOrEmpty(bookmarkTemplate.Id))
                {
                    bookmarkTemplate.Id = Guid.NewGuid().ToString();
                    bookmarkTemplate.Creater = SessoinUtil.GetCurrentUser().Id;
                    bookmarkTemplate.CreateTime = SessoinUtil.GetCurrentDateTime();
                }
                
                linqDbManager.InsertEntity<BookmarkTemplateEntity>(bookmarkTemplate);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void UpdateBookmarkTempalte(AuditEntity.ExportReport.BookmarkTemplateEntity bookmarkTempalte)
        {
            try
            {
                bookmarkTempalte.Creater = SessoinUtil.GetCurrentUser().Id;
                bookmarkTempalte.CreateTime = SessoinUtil.GetCurrentDateTime();
                BookmarkTemplateEntity temp = linqDbManager.GetEntity<BookmarkTemplateEntity>(r => r.Id == bookmarkTempalte.Id);
                BeanUtil.CopyBeanToBean(bookmarkTempalte, temp);
                linqDbManager.UpdateEntity<BookmarkTemplateEntity>(temp);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void DeleteBookmarkTemplate(AuditEntity.ExportReport.BookmarkTemplateEntity bookmarkTemplate)
        {
            try
            {
                string sql = "DELETE FROM CT_REPORT_BOOKMARKTEMPLATE WHERE BOOKMARKTEMPLATE_ID='"+bookmarkTemplate.Id+"'";
                dbManager.ExecuteSql(sql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public AuditEntity.ExportReport.BookmarkTemplateEntity GetBookmarkTemplateEntity(AuditEntity.ExportReport.BookmarkTemplateEntity bookmarkTemplate)
        {
            try
            {
                 bookmarkTemplate = linqDbManager.GetEntity<BookmarkTemplateEntity>(r => r.Id == bookmarkTemplate.Id);
                 return bookmarkTemplate;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
