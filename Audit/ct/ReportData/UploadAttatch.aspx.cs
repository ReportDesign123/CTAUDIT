using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using AuditService.ReportAttatchment;
using AuditEntity.ReportAttatch;
using AuditEntity.ReportState;
using CtTool;
using AuditSPI.ReportData;
using AuditService.ReportState;
using AuditSPI.ReportState;

namespace Audit.ct.ReportData
{
    public partial class UploadAttatch : System.Web.UI.Page
    {
        public List<ReportAttatchEntity> attatches = new List<ReportAttatchEntity>();
        public List<ReportStateEntity> ReportState = new List<ReportStateEntity>();
        public ReportAttatchEntity para = new ReportAttatchEntity();
        public ReportStateEntity para1 = new ReportStateEntity();
        public string JState = "0";
        public string Str = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            ReportAttatchmentService ras = new ReportAttatchmentService();
            ReportStateService ste = new ReportStateService();

            para = ActionTool.DeserializeParameters<ReportAttatchEntity>(Context, "get");

            para1 = ActionTool.DeserializeParameters<ReportStateEntity>(Context, "get");
            string State = "0";
            attatches = ras.GetReportAttatchments(para, "0");
            //获取报表的状态
            ReportState = ste.GetReportsStateNew(para1);
            if (ReportState.Count > 0)
            {
                if (ReportState[0].State == "01" || ReportState[0].State == "02")
                {
                    State = "0";

                }
                else
                {
                    State = "1";
                }

            }
            JState = State;
            //    .GetReportsStateNew(rdps);
            //获取报表的附件状态
            //  GetList();

            Response.Write("<Script>var BCount='" + attatches.Count.ToString() + "';var State='" + State + "';</Script>");
        }



        protected void upLoadBtn_Click(object sender, EventArgs e)
        {
            if (JState == "1")
            {
                Response.Write("<Script> alert('状态为填报才可以进行上传操作');</Script>");
                return;
            }




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

                    attatches = ras.GetReportAttatchments(para, "0");
                    Response.Write("<Script>var BCount='" + attatches.Count.ToString() + "';</Script>");
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        //protected void CheckBox1_CheckedChanged(object sender, EventArgs e)
        //{
        //    ReportAttatchmentService ras = new ReportAttatchmentService();
        //    if (CheckBox1.Checked == true)
        //    {
        //        attatches = ras.GetReportAttatchments(para, "1");
        //    }
        //    else
        //    {
        //        attatches = ras.GetReportAttatchments(para, "0");
        //    }

        //    GetList();

        //}

        public void GetList()
        {
            Str = "";
            for (int i = 0; i < attatches.Count; i++)
            {

                AuditEntity.ReportAttatch.ReportAttatchEntity rae = attatches[i];
                Str += " <tr>";
                Str += "   <td>   <input type='checkbox' objid='" + rae.Id + "' id='check" + i.ToString() + "' name='check' /></td>";
                Str += "   <td>" + rae.Name + "</td>";
                Str += "<td><input id='Pre" + i.ToString() + "' objid='" + rae.Id + "' type='button' value='预览' onclick='Preview(this)'/><input id='Dow" + i.ToString() + "' objid='" + rae.Id + "' type='button' value='下载' onclick='Download(this)'/>";
                Str += "   <input id='Del" + i.ToString() + "' objid='" + rae.Id + "' type='button' value='删除' onclick='Delete(this)'/></td>";
                Str += "   </tr>";
            }
        }

    }
}