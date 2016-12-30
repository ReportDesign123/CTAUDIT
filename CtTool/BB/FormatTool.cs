using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CtTool.BB
{
    public  class FormatTool
    {
        /// <summary>
        /// 创建报表表明
        /// </summary>
        /// <param name="bbCode">报表编号</param>
        /// <param name="flag">是否固定标志</param>
        /// <param name="index">区域的数量</param>
        /// <returns>CT_GD_0101或者CT_BD_01_R0002</returns>
        public static string CreateBBTableName(string bbCode, bool flag,int index,string bdCode)
        {
            if (flag)
            {
                return "CT_GD_" + bbCode + index.ToString().PadLeft(2,'0');
            }
            else
            {
                return "CT_BD_" + bbCode + "_"+bdCode;
            }
        }




        public static string GetDataItemType(string tableName)
        {
            return tableName.Substring(3, 2);
        }
        public static string GetBdReportCode(string tableName)
        {
            int index = tableName.LastIndexOf("_");
            return tableName.Substring(index + 1);
        }

        public static string CreateRowColIndex(int row, int col)
        {
            return row.ToString() + "," + col.ToString();
        }
    }
}
