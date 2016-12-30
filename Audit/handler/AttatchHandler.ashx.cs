using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using AuditEntity.ReportAttatch;
using AuditService.ReportAttatchment;
using CtTool;
using System.IO;
using System.IO.Compression;
using ICSharpCode.SharpZipLib.Core;
using ICSharpCode.SharpZipLib.Zip;
using System.Web.SessionState;

namespace Audit.handler
{
    /// <summary>
    /// Summary description for AttatchHandler
    /// </summary>
    public class AttatchHandler : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            string method = Convert.ToString(ActionTool.DeserializeParameter("method", context));
            if (!StringUtil.IsNullOrEmpty(method))
            {
                ReportAttatchmentService ras = new ReportAttatchmentService();
               
                //单个文件加载数据结构
                ReportAttatchEntity rae = ActionTool.DeserializeParameters<ReportAttatchEntity>(context, "grid");
                ReportAttatchEntity old = ras.Get(rae);
               

                //多个文件处理方法
                List<ReportAttatchEntity>attatches=new List<ReportAttatchEntity>();
                string ids=Convert.ToString(ActionTool.DeserializeParameter("ids", context));
                if(!StringUtil.IsNullOrEmpty(ids)){
                    attatches=ras.GetReportAttatchments(ids);
                }
               
                if (method == "delete")
                {
                    if (File.Exists(old.Route))
                    {
                        File.Delete(old.Route);
                    }
                   
                    ras.DeleteReportAttatchment(rae);
                    rae.Id = "";
                    attatches = ras.GetReportAttatchments(rae);
                    JsonTool.WriteJson<List<ReportAttatchEntity>>(attatches, context);
                    return;
                }
                else if (method == "download")
                {
                    FileInfo fi = new FileInfo(old.Route);
                    context.Response.ClearContent();
                    context.Response.ClearHeaders();
                    context.Response.ContentType = "application/octet-stream";
                    context.Response.AddHeader("Content-Disposition", "attachment;filename=" + context.Server.UrlPathEncode(old.Name));
                    context.Response.AddHeader("Content-Length", fi.Length.ToString());
                    context.Response.AddHeader("Content-Transfer-Encoding", "binary");
                    context.Response.ContentEncoding = System.Text.Encoding.GetEncoding("gb2312");
                    context.Response.WriteFile(fi.FullName);
                    context.Response.Flush();
                    context.Response.End();
                }
                else if (method == "deleteAll")
                {
                    foreach (ReportAttatchEntity a in attatches)
                    {
                        File.Delete(a.Route);
                    }
                    ras.DeleteReportAttatchments(ids);
                    attatches = ras.GetReportAttatchments(rae);
                    JsonTool.WriteJson<List<ReportAttatchEntity>>(attatches, context);
                }
                else if (method == "downAll")
                {
                    string zipDir = context.Server.MapPath("~/ct/attatchs/zipDir/Zip");
                    if (Directory.Exists(zipDir))
                    {
                        Directory.Delete(zipDir, true);
                        Directory.CreateDirectory(zipDir);
                    }
                    else
                    {
                        Directory.CreateDirectory(zipDir);
                    }
                    string zipName = SessoinUtil.GetSystemDate() + ".zip";
                    string zipFile = context.Server.MapPath("~/ct/attatchs/zipDir/"+zipName);
                    foreach (ReportAttatchEntity a in attatches)
                    {
                        if (File.Exists(a.Route))
                        {
                            File.Copy(a.Route, zipDir + @"\" + a.Name, true);
                        }
                       
                    }
                    //File.Create(zipFile);
                    FastZip fz = new FastZip();
                    fz.CreateZip(zipFile, zipDir, false, null);

                    FileInfo fi = new FileInfo(zipFile);
                    context.Response.ClearContent();
                    context.Response.ClearHeaders();
                    context.Response.ContentType = "application/octet-stream";
                    context.Response.AddHeader("Content-Disposition", "attachment;filename=" +context.Server.UrlPathEncode(zipName));
                    context.Response.AddHeader("Content-Length", fi.Length.ToString());
                    context.Response.AddHeader("Content-Transfer-Encoding", "binary");
                    context.Response.ContentEncoding = System.Text.Encoding.GetEncoding("gb2312");
                    context.Response.WriteFile(fi.FullName);
                    context.Response.Flush();
                    context.Response.End();
                }
                else if (method == "upload")
                {
                    HttpFileCollection hfc = context.Request.Files;
                    string path = context.Server.MapPath("~/ct/attatchs/ReportDataAttatch");

                    if (!Directory.Exists(path))
                    {
                        Directory.CreateDirectory(path);
                    }

                                      
                    for (int i = 0; i < hfc.Count; i++)
                    {
                        HttpPostedFile hpf = hfc[i];
                        if (hpf.ContentLength > 0)
                        {
                            
                            int index = hpf.FileName.LastIndexOf("\\");
                            rae.Name = hpf.FileName.Substring(index + 1);
                            int point=rae.Name.LastIndexOf(".");

                            rae.Extend = rae.Name.Substring(point);
                            rae.Id = Guid.NewGuid().ToString();
                            rae.Route = path + @"\" + rae.Id + rae.Extend;
                            ras.AddReportAttatchment(rae);
                            hpf.SaveAs(rae.Route);
                           
                        }
                    }
                }
            }

        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}