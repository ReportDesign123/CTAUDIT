using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using sys;
using System.Data;
namespace Audit.ct.DocViewer
{
    public class T_Aduit_FileDate
    {
        public static string DBName = "db1";
        public bool UpdateT_Aduit_File(T_Aduit_FileInfor _T_Aduit_FileInfor)
        {
            try
            {
                var dbo = Env.CreateConn(DBName);
                var sqlproc = "update CT_DATA_ATTACHMENT set ATTACHMENT_SWFFILE='" + _T_Aduit_FileInfor.SwfFile + "', ATTACHMENT_MTIME=getdate() where    ATTACHMENT_ID='" + _T_Aduit_FileInfor.FileId + "' ";
                dbo.Command.CommandTimeout = 1200;
                dbo.ExecuteNonQuery(sqlproc);
                return true;
            }
            catch (Exception ex)
            {
                return false;
                throw new Exception(ex.Message);
            }
        }

        public IList<T_Aduit_FileInfor> SelectT_Aduit_File(string P_id)
        {
            try
            {
                IList<T_Aduit_FileInfor> T_Aduit_FileforList = new List<T_Aduit_FileInfor>();
                var dbo = Env.CreateConn(DBName);
                var sql = "select   *  from  CT_DATA_ATTACHMENT  where   ATTACHMENT_ID='" + P_id + "' ";
                DataTable datelist = null;
                datelist = dbo.GetTable(sql);
                foreach (DataRow dx in datelist.Rows)
                {
                    T_Aduit_FileInfor _T_Aduit_FileInfor = new T_Aduit_FileInfor();
                    _T_Aduit_FileInfor.FileId = dx["ATTACHMENT_ID"].ToString();
                    _T_Aduit_FileInfor.FileName = dx["ATTACHMENT_NAME"].ToString();
                    _T_Aduit_FileInfor.FilePath = dx["ATTACHMENT_ROUTE"].ToString();
                    _T_Aduit_FileInfor.FileType = dx["ATTACHMENT_EXTEND"].ToString();
                    _T_Aduit_FileInfor.SwfFile = dx["ATTACHMENT_SWFFILE"].ToString();
                    T_Aduit_FileforList.Add(_T_Aduit_FileInfor);
                }
                return T_Aduit_FileforList;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }
    }
}