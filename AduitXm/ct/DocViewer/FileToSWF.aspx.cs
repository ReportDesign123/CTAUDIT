using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.IO;

namespace AduitXm.ct.DocViewer
{
    public partial class FileToSWF : System.Web.UI.Page
    {
        public string SwfPath = "", SwFilecreate = "", FileType = "", FilePath = "", SwfFolder = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            int length;
            long dataToRead;
            string fileId = Request.QueryString["fileId"];
            T_Aduit_FileDate _T_Aduit_FilDAL = new T_Aduit_FileDate();
            IList<T_Aduit_FileInfor> _T_Aduit_FileList = _T_Aduit_FilDAL.SelectT_Aduit_File(fileId);
            T_Aduit_FileInfor _T_Aduit_FileInfor = new T_Aduit_FileInfor();
            if (_T_Aduit_FileList != null)
            {
                // fileName = _T_Aduit_FileList[0].FileName;
                FileType = _T_Aduit_FileList[0].FileType.ToLower();
                FilePath = _T_Aduit_FileList[0].FilePath.Replace("/", @"\");
                SwfFolder = _T_Aduit_FileList[0].SwfFile;

                _T_Aduit_FileInfor.FileId = fileId;
            }

            string root = HttpContext.Current.Server.MapPath("~") + @"\ueditor\net\";
            string SavePath = "", basePath = "";
            string swfName = DateTime.Now.ToString("yyyy-MM-dd-HH-mm-ss-ffff");
            basePath = "";//获取服务器文件存放路径
            if (ConfigurationManager.AppSettings["FlexPaperRoot"] != null)
                SavePath = ConfigurationManager.AppSettings["FlexPaperRoot"];
            string FolderName = DateTime.Now.ToString("yyyy年MM月");
            string TempFolder = SavePath + @"FlexPaper\" + FolderName;
            string SwfTempFolder = "";
            string TempFolders = @"FlexPaper\" + FolderName;
            System.IO.Stream iStream = null;


            try
            {
                if (!System.IO.Directory.Exists(TempFolder))
                {
                    //生成文件完整目录
                    System.IO.Directory.CreateDirectory(TempFolder);
                }

                Response.Charset = "UTF-8";
                Response.AddHeader("Content-Type", "application/octet-stream");
                Response.AddHeader("Content-Disposition", "attachment;filename=\"" + Server.UrlEncode(swfName + ".swf") + "\"");
                Response.ContentType = "application/x-shockwave-flash";

                SwfPath = TempFolder + "\\" + swfName + ".swf";
                SwfTempFolder = TempFolders + "\\" + swfName + ".swf";
                _T_Aduit_FileInfor.SwfFile = SwfTempFolder;
                //判断文件是否生成
                if (SwfFolder == "" || SwfFolder.Length == 0)
                {
                    #region 如果文件还没有生成

                    string pdfName = TempFolder + "\\" + swfName + ".pdf";
                    if (FileType.EndsWith(".pdf"))
                    {
                        File.Copy(basePath + FilePath, pdfName, true);

                        PDF2SWF.PDFToSWF(pdfName, SwfPath);

                        _T_Aduit_FilDAL.UpdateT_Aduit_File(_T_Aduit_FileInfor);

                    }
                    else if (FileType.EndsWith(".doc") || FileType.EndsWith(".docx"))
                    {
                        Aspose.Words.Document doc = new Aspose.Words.Document(basePath + FilePath);

                        Aspose.Words.Saving.PdfSaveOptions opt = new Aspose.Words.Saving.PdfSaveOptions();
                        doc.Save(pdfName, opt);

                        if (File.Exists(pdfName))
                        {
                            PDF2SWF.PDFToSWF(pdfName, SwfPath);
                            _T_Aduit_FilDAL.UpdateT_Aduit_File(_T_Aduit_FileInfor);

                        }
                        else
                        {

                            Response.Write("<script type='text/javascript'>alert('生成swf找不到文件" + pdfName + "');</script>");
                        }
                    }
                    else if (FileType.EndsWith(".xls") || FileType.EndsWith(".xlsx"))
                    {
                        Aspose.Cells.Workbook doc = new Aspose.Cells.Workbook(basePath + FilePath);

                        Aspose.Cells.PdfSaveOptions op = new Aspose.Cells.PdfSaveOptions();
                        op.AllColumnsInOnePagePerSheet = true;
                        op.OnePagePerSheet = true;
                        doc.Save(pdfName, op);

                        PDF2SWF.PDFToSWF(pdfName, SwfPath);
                        _T_Aduit_FilDAL.UpdateT_Aduit_File(_T_Aduit_FileInfor);

                    }
                    else if (FileType.EndsWith(".ppt") || FileType.EndsWith(".pptx"))
                    {
                        Aspose.Slides.Presentation ppt = new Aspose.Slides.Presentation(basePath + FilePath);
                        ppt.Save(pdfName, Aspose.Slides.Export.SaveFormat.Pdf);

                        PDF2SWF.PDFToSWF(pdfName, SwfPath);
                        _T_Aduit_FilDAL.UpdateT_Aduit_File(_T_Aduit_FileInfor);


                    }
                    else
                    {
                        Response.Write("<script type='text/javascript'>alert('文件格式不支持在线预览');</script>");
                        Response.End();
                    }
                    #endregion
                }
                else
                {
                    string viewBase = "";
                    if (ConfigurationManager.AppSettings["FlexPaperRoot"] != null)
                        viewBase = ConfigurationManager.AppSettings["FlexPaperRoot"];
                    SwfPath = viewBase + SwfFolder;
                }
                #region 下载文件
                int BUFFER_SIZE = 4096;
                iStream = new System.IO.FileStream(SwfPath, System.IO.FileMode.Open, System.IO.FileAccess.Read, System.IO.FileShare.Read);
                dataToRead = iStream.Length;
                Response.AddHeader("Content-Length", dataToRead.ToString());
                byte[] buffer = new byte[BUFFER_SIZE];
                while (dataToRead > 0)
                {
                    if (Response.IsClientConnected)
                    {
                        length = iStream.Read(buffer, 0, BUFFER_SIZE);
                        Response.OutputStream.Write(buffer, 0, length);
                        Response.Flush();
                        buffer = new Byte[BUFFER_SIZE];
                        dataToRead = dataToRead - length;
                    }
                    else
                    {
                        dataToRead = -1;
                    }
                }

                //记录日志

                #endregion

                if (iStream != null)
                {
                    iStream.Close();
                }

            }
            catch (Exception ex)
            {

                Response.Write("生成SWF文件时出错 : " + ex.Message);
            }


        }
    }
}