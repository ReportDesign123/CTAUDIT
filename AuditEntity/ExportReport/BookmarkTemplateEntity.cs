using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;


namespace AuditEntity.ExportReport
{
    [Table(Name = "CT_REPORT_BOOKMARKTEMPLATE")]
 public  class BookmarkTemplateEntity 
    {
         [Column(Name = "BOOKMARKTEMPLATE_ID", IsPrimaryKey = true)]
     public string Id
     {
         get;
         set;
     }
         [Column(Name = "BOOKMARKTEMPLATE_NAME")]
     public string Name
     {
         get;
         set;
     }
         [Column(Name = "BOOKMARKTEMPLATE_CODE")]
         public string Code
         {
             get;
             set;
         }
         [Column(Name = "BOOKMARKTEMPLATE_TYPE")]
     public string Type
     {
         get;
         set;
     }
         [Column(Name = "BOOKMARKTEMPLATE_CONTENT")]
     public string Content
     {
         get;
         set;
     }
         [Column(Name = "BOOKMARKTEMPLATE_TEMPLATEID")]
     public string TemplateId
     {
         get;
         set;
     }
         [Column(Name = "BOOKMARKTEMPLATE_CREATER")]
     public string Creater
     {
         get;
         set;
     }
         [Column(Name = "BOOKMARKTEMPLATE_CREATETIME")]
     public string CreateTime
     {
         get;
         set;
     }

         [Column(Name = "BOOKMARKTEMPLATE_DATASOURCE")]
         public string DataSource
         {
             get;
             set;
         }
         [Column(Name = "BOOKMARKTEMPLATE_MACROORFORMULAR")]
         public string MacroOrFormular
         {
             get;
             set;
         }
         [Column(Name = "BOOKMARKTEMPLATE_THOUSAND")]
         public string Thousand
         {
             get;
             set;
         }
         public string TemplateName
         {
             get;
             set;
         }
         public string TemplateCode
         {
             get;
             set;
         }
         public string IsOrNotContinue
         {
             get;
             set;
         }
    }
}
