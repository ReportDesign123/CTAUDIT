using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity
{
    [Table(Name = "CT_FORMAT_LOCKITEM")]
    public class ReportCompFormatDicEntity
    {
        [Column(Name = "LOCKITEM_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
        [Column(Name = "LOCKITEM_CompID", IsPrimaryKey = true)]
        public string CompID
        {
            get;
            set;
        }
        [Column(Name = "LOCKITEM_TABLENAME", IsPrimaryKey = true)]
        public string BBName
        {
            get;
            set;
        }
        [Column(Name = "LOCKITEM_ROW", IsPrimaryKey = true)]
        public int BBRow
        {
            get;
            set;
        }
        [Column(Name = "LOCKITEM_COL", IsPrimaryKey = true)]
        public int BBCol
        {
            get;
            set;
        }
    }
     [Table(Name = "CT_FORMAT_REPORTDICTIONARY")]
    public  class ReportFormatDicEntity
    {
        [Column(Name = "REPORTDICTIONARY_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
          [Column(Name = "REPORTDICTIONARY_CODE")]
        public string bbCode
        {
            get;
            set;
        }
          [Column(Name = "REPORTDICTIONARY_NAME")]
        public string bbName
        {
            get;
            set;
        }
          [Column(Name = "REPORTDICTIONARY_CREATER")]
        public string creater
        {
            get;
            set;
        }
          [Column(Name = "REPORTDICTIONARY_CREATETIME")]
        public string  createTime
        {
            get;
            set;
        }
          [Column(Name = "REPORTDICTIONARY_CYCLE")]
        public string bbCycle
        {
            get;
            set;
        }
          [Column(Name = "REPORTDICTIONARY_ROWNUMBER")]
        public int bbRows
        {
            get;
            set;
        }
          [Column(Name = "REPORTDICTIONARY_COLUMNNUMBER")]
        public int  bbCols
        {
            get;
            set;
        }
          [Column(Name = "REPORTDICTIONARY_INSTRUCTION")]
        public string bbInstruction
        {
            get;
            set;
        }
            [Column(Name = "REPORTDICTIONARY_REMARKS")]
          public string bbRemarks
          {
              get;
              set;
          }
          [Column(Name = "REPORTDICTIONARY_FORMATINFO")]
        public string formatStr
        {
            get;
            set;
        }
          [Column(Name = "REPORTDICTIONARY_FORMATINFO1")]
          public string formatCalcuStr
          {
              get;
              set;
          }
          [Column(Name = "REPORTDICTIONARY_DATAINFO")]
        public string itemStr
        {
            get;
            set;
        }
             [Column(Name = "REPORTDICTIONARY_FIXTABLENAME")]
          public string fixTableName
          {
              get;
              set;
          }
          [Column(Name = "REPORTDICTIONARY_FORMULARINFO")]
             public string formularStr
             {
                 get;
                 set;
             }
         /// <summary>
         /// 报表分类ID
         /// </summary>
          public string ReportClassifyId
          {
              get;
              set;
          }
         /// <summary>
         /// 报表分类名称
         /// </summary>
          public string ReportClassifyName
          {
              get;
              set;
          }
         /// <summary>
         /// 报表状态
         /// </summary>
          public string ReportState
          {
              get;
              set;
          }
         /// <summary>
         /// 是否包含附件
         /// </summary>
          public string Attatchments
          {
              get;
              set;
          }
         
    }
}
