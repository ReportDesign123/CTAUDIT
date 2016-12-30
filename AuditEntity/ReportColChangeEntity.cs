using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity
{
     [Table(Name = "CT_FORMAT_COLUMNCHANGEDICTIONARY")]
   public  class ReportColChangeEntity
    {
        [Column(Name = "COLUMNCHANGEDICTIONARY_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
        [Column(Name = "COLUMNCHANGEDICTIONARY_CODE")]
        public string Code
        {
            get;
            set;
        }
        [Column(Name = "COLUMNCHANGEDICTIONARY_COLUMNOFFSET")]
        public int Offset
        {
            get;
            set;
        }
        [Column(Name = "COLUMNCHANGEDICTIONARY_COLUMNNUMBER")]
        public int ColNumber
        {
            get;
            set;
        }

        [Column(Name = "COLUMNCHANGEDICTIONARY_DATACODE")]
        public string DataCode
        {
            get;
            set;
        }
        [Column(Name = "COLUMNCHANGEDICTIONARY_DATANAME")]
        public string DataName
        {
            get;
            set;
        }
        [Column(Name = "COLUMNCHANGEDICTIONARY_ROWSORT")]
        public string ColSort
        {
            get;
            set;
        }
        [Column(Name = "COLUMNCHANGEDICTIONARY_ISORNOTMERGE")]
        public string IsOrNotMerge
        {
            get;
            set;
        }
        [Column(Name = "COLUMNCHANGEDICTIONARY_REGIONTABLE")]
        public string RegionTable
        {
            get;
            set;
        }

    }
}
