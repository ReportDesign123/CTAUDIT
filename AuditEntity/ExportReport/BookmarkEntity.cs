using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;


namespace AuditEntity.ExportReport
{
    [Table(Name = "CT_REPORT_BOOKMARK")]
    public  class BookmarkEntity
    {
         [Column(Name = "BOOKMARK_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;

        }
          [Column(Name = "BOOKMARK_CODE")]
        public string Code
        {
            get;
            set;
        }
          [Column(Name = "BOOKMARK_NAME")]
        public string Name
        {
            get;
            set;
        }
          [Column(Name = "BOOKMARK_TYPE")]
        public string Type
        {
            get;
            set;
        }
          [Column(Name = "BOOKMARK_CONTENT")]
        public string Content
        {
            get;
            set;
        }
          [Column(Name = "BOOKMARK_TEMPLATEID")]
        public string TemplateId
        {
            get;
            set;
        }
          [Column(Name = "BOOKMARK_CREATER")]
        public string Creater
        {
            get;
            set;
        }
          [Column(Name = "BOOKMARK_CREATETIME")]
        public string CreateTime
        {
            get;
            set;
        }
          [Column(Name = "BOOKMARK_DATASOURCE")]
          public string DataSource
          {
              get;
              set;
          }
        [Column(Name = "BOOKMARK_MACROORFORMULAR")]
          public string MacroOrFormular
          {
              get;
              set;
          }
        [Column(Name = "BOOKMARK_THOUSAND")]
        public string Thousand
        {
            get;
            set;
        }

    }
}
