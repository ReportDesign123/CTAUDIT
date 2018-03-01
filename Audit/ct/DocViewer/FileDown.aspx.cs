using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Collections.Specialized;

namespace Audit.ct.DocViewer
{
    public partial class FileDown : System.Web.UI.Page
    {
        private int BUFFER_SIZE = 10000;
        string FileType = "", FileId = "", fileName = "", FilePath="";
        protected void Page_Load(object sender, EventArgs e)
        {
            string FileId = Request.QueryString["fileId"];

             T_Aduit_FileDate _T_Aduit_FilDAL = new T_Aduit_FileDate();
            IList<T_Aduit_FileInfor> _T_Aduit_FileList = _T_Aduit_FilDAL.SelectT_Aduit_File(FileId);
            if (_T_Aduit_FileList != null)
            {
                fileName = _T_Aduit_FileList[0].FileName;
                FileType = _T_Aduit_FileList[0].FileType;
                FilePath = _T_Aduit_FileList[0].FilePath.Replace("/", @"\");

            }
            StringCollection imgExts = new StringCollection();
            imgExts.AddRange(".mp4|.flv|.gif|.jpg|.jpeg|.png|.bmp".Split('|'));
            System.IO.Stream iStream = null;
            int length;
            long dataToRead;
            
            if (FileId != "")
            {



                if (!File.Exists(FilePath))
                {

                    Response.Write("<script type='text/javascript'>alert('文件不存在，请联系管理员！');</script>");
                    Response.End();
                }

                else
                {
                    if (imgExts.Contains(FileType.ToLower()))
                    {
                        try
                        {
                            Response.Charset = "UTF-8";
                            Response.AddHeader("Content-Type", "application/octet-stream");
                            iStream = new System.IO.FileStream(FilePath, System.IO.FileMode.Open, System.IO.FileAccess.Read, System.IO.FileShare.Read);
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
                        }
                        finally
                        {
                            if (iStream != null)
                            {
                                //Close the file.
                                iStream.Close();
                            }
                        }
                    }

                }
            }
        }
    }
}