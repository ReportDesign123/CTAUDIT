using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using AuditService.ReportAttatchment;
using AuditEntity.ReportAttatch;
using CtTool;
using AuditSPI.ReportData;

namespace Audit.ct.ReportData
{
    public partial class UploadAttatch : System.Web.UI.Page
    {
        public List<ReportAttatchEntity> attatches = new List<ReportAttatchEntity>();
        public ReportAttatchEntity para = new ReportAttatchEntity();
        protected void Page_Load(object sender, EventArgs e)
        {
            ReportAttatchmentService ras = new ReportAttatchmentService();
            para = ActionTool.DeserializeParameters<ReportAttatchEntity>(Context, "get");
            attatches = ras.GetReportAttatchments(para);
        }



        protected void upLoadBtn_Click(object sender, EventArgs e)
        {
            string path = Server.MapPath("~/ct/attatchs/ReportDataAttatch");

            if (FileUpload1.HasFile)
            {
                if (!Directory.Exists(path))
                {
                    Directory.CreateDirectory(path);
                }
                try
                {
                    ReportAttatchEntity rae = ActionTool.DeserializeParameters<ReportAttatchEntity>(Context, "post");                    
                    BeanUtil.CopyBeanToBean(rae, para);

                    HttpPostedFile hpf = FileUpload1.PostedFile;
                    ReportAttatchmentService ras = new ReportAttatchmentService();
                    rae.Name = FileUpload1.FileName;
                    rae.Extend = Path.GetExtension(rae.Name);
                    // rae.Length = hpf.ContentLength;
                    rae.Id = Guid.NewGuid().ToString();
                    rae.Route = path + @"\" + rae.Id + rae.Extend;
                    ras.AddReportAttatchment(rae);
                    hpf.SaveAs(rae.Route);

                    attatches = ras.GetReportAttatchments(para);

                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }
    }
}