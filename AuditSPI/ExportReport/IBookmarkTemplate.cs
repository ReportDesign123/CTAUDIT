using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity.ExportReport;
using AuditEntity;
using AuditSPI;


namespace AuditSPI.ExportReport
{
    public  interface IBookmarkTemplate
    {
        DataGrid<BookmarkTemplateEntity> GetBookmarkTemplateDataGrid(DataGrid<BookmarkTemplateEntity> dataGrid, BookmarkTemplateEntity bookmarkTempalte);
        void SaveBookmarkTemplate(BookmarkTemplateEntity bookmarkTemplate);
        void UpdateBookmarkTempalte(BookmarkTemplateEntity bookmarkTempalte);
        void DeleteBookmarkTemplate(BookmarkTemplateEntity bookmarkTemplate);
        BookmarkTemplateEntity GetBookmarkTemplateEntity(BookmarkTemplateEntity bookmarkTemplate);
    }
}
