using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Collections.Specialized;
using System.Text;
namespace AduitXm.ct.DocViewer
{
    public partial class FileViewer : System.Web.UI.Page
    {
        public string FileId = "", viewFlag = "1", fileName = "", sbText = "", FileType = "", FilePath = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            FileId = Request.QueryString["fileId"];

            T_Aduit_FileDate _T_Aduit_FilDAL = new T_Aduit_FileDate();
            IList<T_Aduit_FileInfor> _T_Aduit_FileList = _T_Aduit_FilDAL.SelectT_Aduit_File(FileId);
            if (_T_Aduit_FileList != null)
            {
                fileName = _T_Aduit_FileList[0].FileName;
                FileType = _T_Aduit_FileList[0].FileType.ToLower();
                FilePath = _T_Aduit_FileList[0].FilePath.Replace("/", @"\");
            }



            if (FileId == "")
            {
                return;
            }
            string[] fileExts = new string[] { ".txt", ".swf", ".pdf", ".doc", ".docx", ".xls", ".xlsx", ".ppt", ".pptx" };
            StringCollection sc = new StringCollection();

            sc.AddRange(fileExts);
            string basePath = "";
            if (!sc.Contains(FileType))
            {
                viewFlag = "0";
            }
            else if (FileType == ".txt")
            {
                viewFlag = "txt";
                if (!File.Exists(basePath + FilePath))
                {
                    sbText = "文件不存在！";
                }
                else
                {
                    sbText = File.ReadAllText(basePath + FilePath, Encoding.Default);

                    sbText = sbText.Replace("\r\n", "<br/>");
                    sbText = sbText.Replace(" ", "&nbsp;");

                }
            }
            viewFlag = "1";
        }
    }
}