using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Audit.ct.DocViewer
{
    
    public class T_Aduit_FileInfor
    {

        private string _FileId;
        private string _FileName;
        private string _FilePath;
        private string _FileType;
        private string _SwfFile;
        //private DateTime _Swfdate;
        //public string Swfdate
        //{
        //    set { _Swfdate = value; }
        //    get { return _Swfdate; }
        //}
        public string SwfFile
        {
            set { _SwfFile = value; }
            get { return _SwfFile; }
        }
        public string FileType
        {
            set { _FileType = value; }
            get { return _FileType; }
        }
        public string FilePath
        {
            set { _FilePath = value; }
            get { return _FilePath; }
        }
        public string FileName
        {
            set { _FileName = value; }
            get { return _FileName; }
        }
        public string FileId
        {
            set { _FileId = value; }
            get { return _FileId; }
        }
    }
}