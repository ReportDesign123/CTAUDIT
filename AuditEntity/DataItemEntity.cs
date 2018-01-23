using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity
{
     [Table(Name = "CT_FORMAT_DATAITEM")]
    public  class DataItemEntity
    {
           [Column(Name = "DATAITEM_ID", IsPrimaryKey = true)]
         public string Id
         {
             get;
             set;

         }
           [Column(Name = "DATAITEM_ROW")]
         public int  Row
         {
             get;
             set;

         }
           [Column(Name = "DATAITEM_COL")]
         public int  Col
         {
             get;
             set;

         }
           [Column(Name = "DATAITEM_TABLENAME")]
         public string TableName
         {
             get;
             set;

         }
           [Column(Name = "DATAITEM_NAME")]
         public string Name
         {
             get;
             set;

         }
           [Column(Name = "DATAITEM_REPORTID")]
         public string ReportId
         {
             get;
             set;

         }
           [Column(Name = "DATAITEM_CODE")]
         public string Code
         {
             get;
             set;

         }
           [Column(Name = "DATAITEM_INDEX")]
         public string Index
         {
             get;
             set;

         }
           [Column(Name = "DATAITEM_MACRO")]
         public string Macro
         {
             get;
             set;

         }
           [Column(Name = "DATAITEM_HELP")]
         public string Help
         {
             get;
             set;

         }
           [Column(Name = "DATAITEM_CELLTYPE")]
         public string CellType
         {
             get;
             set;

         }
           [Column(Name = "DATAITEM_CELLDATATYPE")]
         public string CellDataType
         {
             get;
             set;

         }
           [Column(Name = "DATAITEM_THOUSANDTH")]
         public string Thousand
         {
             get;
             set;

         }
           [Column(Name = "DATAITEM_CURRENCY")]
         public string Currency
         {
             get;
             set;

         }
           [Column(Name = "DATAITEM_ZERO")]
         public string Zero
         {
             get;
             set;

         }
           [Column(Name = "DATAITEM_LOCK")]
         public string Lock
         {
             get;
             set;

         }
           [Column(Name = "DATAITEM_SMBOL")]
         public string Smbol
         {
             get;
             set;

         }
           [Column(Name = "DATAITEM_LENGTH")]
         public int Length
         {
             get;
             set;

         }
           public object Value
           {
               get;
               set;
           }
         [Column(Name = "DATAITEM_Aggregation")]
           public string CellAggregation
           {
               get;
               set;
           }

         [Column(Name = "DATAITEM_AggregationType")]
         public string CellAggregationType
         {
             get;
             set;
         }

         [Column(Name = "DATAITEM_Primary")]
         public string CellPrimary
         {
             get;
             set;
         }
         [Column(Name = "DATAITEM_Digits")]
         public int DigitNumber
         {
             get;
             set;
         }
           [Column(Name = "DATAITEM_ParaValue")]
         public string ParaValue
         {
             get;
             set;
         }
        [Column(Name = "DATAITEM_ReqValue")]
        public string ReqValue
        {
            get;
            set;
        }
        public string UpdateState = "";//1为新添加；2为编辑状态


    }
}
