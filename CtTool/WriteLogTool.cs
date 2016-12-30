using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using System.IO;

namespace CtTool
{
    /// <summary>
    /// 文本读写工具
    /// </summary>
   public   class WriteLogTool
    {
      static TextWriter tw;
       public WriteLogTool()
       {
           if (tw==null)
               tw = File.CreateText(@"c:\log.txt");          
           
       }
       /// <summary>
       /// 写日志
       /// </summary>
       /// <param name="log"></param>
       public void WriteLog(string log)
       {
         
           tw.WriteLine(log);
       }
       /// <summary>
       /// 关闭日志
       /// </summary>
       public void EndLog()
       {
           tw.Close();
       }
    }
}
