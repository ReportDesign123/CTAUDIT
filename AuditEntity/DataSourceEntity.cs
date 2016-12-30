using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity
{
     [Table(Name = "CT_BASIC_DATASOURCE")]
    public  class DataSourceEntity
    {
          [Column(Name = "DATASOURCE_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
           [Column(Name = "DATASOURCE_NAME")]
        public string Name
        {
            get;
            set;
        }
           [Column(Name = "DATASOURCE_DBTYPE")]
        public string DbType
        {
            get;
            set;
        }
           [Column(Name = "DATASOURCE_CONNECTIONSTRING")]
        public string DbConnection
        {
            get;
            set;
        }
           [Column(Name = "DATASOURCE_DBPROVIDER")]
        public string DbProvider
        {
            get;
            set;
        }
           [Column(Name = "DATASOURCE_SERVER")]
        public string Server
        {
            get;
            set;
        }
           [Column(Name = "DATASOURCE_DB")]
        public string Db
        {
            get;
            set;
        }
          [Column(Name = "DATASOURCE_USERNAME")]
           public string UserName
           {
               get;
               set;
           }
         [Column(Name = "DATASOURCE_USERPASS")]
           public string UserPassword
           {
               get;
               set;
           }
           [Column(Name = "DATASOURCE_DEFAULT")]
         public string Default
         {
             get;
             set;
         }
          [Column(Name = "DATASOURCE_STATE")]
           public string State
           {
               get;
               set;
           }
    }
}
