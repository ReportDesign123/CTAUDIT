using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity
{
      [Table(Name = "CT_FORMAT_ROWCHANGEDICTIONARY")]
    public  class ReportRowChangeEntity
    {
           [Column(Name = "ROWCHANGEDICTIONARY_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
            [Column(Name = "ROWCHANGEDICTIONARY_CODE")]
        public string Code
        {
            get;
            set;
        }
            [Column(Name = "ROWCHANGEDICTIONARY_ROWOFFSET")]
        public int Offset
        {
            get;
            set;
        }
            [Column(Name = "ROWCHANGEDICTIONARY_ROWNUMBER")]
        public int RowNumber
        {
            get;
            set;
        }

            [Column(Name = "ROWCHANGEDICTIONARY_DATACODE")]
        public string DataCode
        {
            get;
            set;
        }
            [Column(Name = "ROWCHANGEDICTIONARY_DATANAME")]
        public string DataName
        {
            get;
            set;
        }
            [Column(Name = "ROWCHANGEDICTIONARY_SORTCOLUMN")]
        public string RowSort
        {
            get;
            set;
        }
            [Column(Name = "ROWCHANGEDICTIONARY_ISORNOTMERGE")]
        public string IsOrNotMerge
        {
            get;
            set;
        }
            [Column(Name = "ROWCHANGEDICTIONARY_REGIONTABLE")]
        public string RegionTable
        {
            get;
            set;
        }

    }
}
