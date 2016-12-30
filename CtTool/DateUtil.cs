using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CtTool
{
   public class DateUtil
    {
       public static string GetDateShortString(DateTime date)
       {
           return date.ToString("yyyy-MM-dd");
       }
    }
}
