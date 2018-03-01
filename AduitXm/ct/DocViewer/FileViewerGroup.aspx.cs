using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Text;
using System.Collections.Specialized;
namespace AduitXm.ct.DocViewer
{
    public partial class FileViewerGroup : System.Web.UI.Page
    {
        public StringBuilder sbList = new StringBuilder();
        public string firstLink = "", fileTitle = "", FileType = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            string appId = "";// Request.QueryString["appId"];
            string fileId = Request.QueryString["fileId"];
            T_Aduit_FileDate _T_Aduit_FilDAL = new T_Aduit_FileDate();
            IList<T_Aduit_FileInfor> _T_Aduit_FileList = _T_Aduit_FilDAL.SelectT_Aduit_File(fileId);
            if (_T_Aduit_FileList != null)
            {
                fileTitle = _T_Aduit_FileList[0].FileName;
                FileType = _T_Aduit_FileList[0].FileType.ToLower();
            }


            StringCollection sc = new StringCollection();
            sc.AddRange(".txt|.swf|.pdf|.doc|.docx|.xls|.xlsx|.ppt|.pptx".Split('|'));

            StringCollection scPic = new StringCollection();
            scPic.AddRange(".bmp|.jpg|.jpeg|.gif|.png|.tif".Split('|'));
            if (appId == "" && fileId != "")
            {


                if (scPic.Contains(FileType))
                {
                    firstLink = "FileView_Pic.aspx?fileId=" + fileId;
                }
                else
                {
                    firstLink = "FileViewer.aspx?fileId=" + fileId;
                }

                if (sc.Contains(FileType))
                {
                    if (fileTitle == "")
                    {
                        firstLink = "FileViewer.aspx?fileId=" + fileId;
                    }

                    sbList.AppendFormat("<li class='{2}'><a href='FileViewer.aspx?fileId={0}' title='{1}' target='view'>{1}</a></li>"
                        , fileId
                        , fileTitle
                        , "sellink"
                        );
                }
            }
        }
    }
}