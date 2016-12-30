using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity
{
        [Table(Name = "CT_FORMULAR")]
   public   class FormularEntity
    {
               [Column(Name = "FORMULAR_ID", IsPrimaryKey = true)]
            public string Id
            {
                get;
                set;
            }
                [Column(Name = "FORMULAR_REPORTCODE")]
            public string ReportCode
            {
                get;
                set;
            }
            [Column(Name = "FORMULAR_BEGINROW")]
                public int firstRow
            {
                get;
                set;
            }
            /// <summary>
            /// 接受数据的区块
            /// </summary>
            [Column(Name = "FORMULAR_BEGINCOLUMN")]
            public int firstCol
            {
                get;
                set;
            }
            /// <summary>
            /// 接受数据的区块
            /// </summary>
             [Column(Name = "FORMULAR_ENDROW")]
            public int lastRow
            {
                get;
                set;
            }
            /// <summary>
            /// 接受数据的区块
            /// </summary>
               [Column(Name = "FORMULAR_ENDCOLUMN")]
             public int lastCol
                {
                    get;
                    set;
                }
            /// <summary>
            /// 公式的内容
            /// </summary>
                [Column(Name = "FORMULAR_CONTENT")]
               public string content
            {
                get;
                set;
            }
                [Column(Name = "FORMULAR_PARAMETERS")]
            public string Parameters
            {
                get;
                set;
            }
            /// <summary>
            /// 公式解析参数
            /// </summary>
                [Column(Name = "FORMULAR_DE")]
            public string DeserializeContent
            {
                get;
                set;
            }
                [Column(Name = "FORMULAR_ISORNOTTAKE")]
                public string isOrNotTake
            {
                get;
                set;
            }
                [Column(Name = "FORMULAR_ISORNOTCACULATION")]
                public string isOrNotCaculate
            {
                get;
                set;
            }
                [Column(Name = "FORMULAR_ISORNOTBATCH")]
                public string isOrNotBatch
            {
                get;
                set;
            }
                [Column(Name = "FORMULAR_OPTION")]
                public string option
            {
                get;
                set;
            }
                [Column(Name = "FORMULAR_SEQUENCE")]
                public int sequence
            {
                get;
                set;
            }
                [Column(Name = "FORMULAR_CREATER")]
            public string Creater
            {
                get;
                set;
            }
                [Column(Name = "FORMULAR_CREATETIME")]
            public string CreateTime
            {
                get;
                set;
            }
            /// <summary>
            /// 公式数据源，用于跨表取数
            /// </summary>
              [Column(Name = "FORMULAR_DB")]
                public string FormularDb
                {
                    get;
                    set;
                }
            /// <summary>
            /// 固定区或者变动区类型；固定区F；变动行R;变动列C
            /// </summary>
             [Column(Name = "FORMULAR_FIXORCHANGEREGION")]
              public string FixOrChangeRegion
              {
                  get;
                  set;
              }
            /// <summary>
            /// 数据表
            /// </summary>
            [Column(Name = "FORMULAR_REGIONTABLENAME")]
             public string RegionTableName
             {
                 get;
                 set;
             }
            /// <summary>
            /// 校验公式信息
            /// </summary>
             [Column(Name = "FORMULAR_ERRORINFO")]
            public string ErrorInfo
            {
                get;
                set;
            }
            /// <summary>
            /// 取数公式的级次，影响计算的顺序
            /// </summary>
             [Column(Name = "FORMULAR_LEVEL")]
             public int FormularLevel
             {
                 get;
                 set;
             }
            /// <summary>
            /// 直接子级公式
            /// </summary>
            public List<FormularEntity> Children = new List<FormularEntity>();
            /// <summary>
            /// 是否已经计算过
            /// </summary>
            public bool Caculated = false;
    }
}
