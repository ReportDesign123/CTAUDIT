using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Diagnostics;
namespace Audit.ct.DocViewer
{
    public class PDF2SWF
    {
   
     
        public static void PDFToSWF(string pdfName, string SwfPath)
        {
            string cmdStr = HttpContext.Current.Server.MapPath("~") + @"\ct\DocViewer\pdf2swf.exe";
           string args = "  -t " + pdfName + "  -o " + SwfPath + "";
           PDF2SWF.ExecutCmd(cmdStr, args);
        }
    
     public static void ExecutCmd(string cmd,string args)
    {
        using(Process p=new Process())
        {
            p.StartInfo.FileName=cmd;
            p.StartInfo.Arguments=args;
            p.StartInfo.UseShellExecute=false;
            p.StartInfo.RedirectStandardOutput=false;
            p.StartInfo.CreateNoWindow=true;
            p.Start();
            p.PriorityClass=ProcessPriorityClass.Normal;
            p.WaitForExit();
        }
    }
    }
}