using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CtTool
{
    public  class SqlUtil
    {
        public static string AddWhereSql(string whereSql)
        {
            try
            {
                if (whereSql != null && whereSql != "")
                {
                    return " Where " + whereSql;
                }
                else
                {
                    return "";
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
