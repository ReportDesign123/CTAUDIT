using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.Management;
using GlobalConst;

namespace CtTool.NetTool
{
    public  class MacTool
    {
        /// <summary>
        /// 获取MAC地址s
        /// </summary>
        /// <returns></returns>
        public static string GetLocalMacAddress()
        {
            try
            {
                string hostname = Dns.GetHostName();
                IPHostEntry ipEntry = Dns.GetHostEntry(hostname);
                IPAddress[] addresses = ipEntry.AddressList;
                ManagementObjectSearcher searcher = new ManagementObjectSearcher("SELECT * FROM Win32_NetworkAdapterConfiguration");
                ManagementObjectCollection collection = searcher.Get();
                foreach (ManagementObject obj in collection)
                {
                    if (obj["IPEnabled"].ToString() == "True")
                    {
                        return obj["MacAddress"].ToString().Substring(0,AuthorityGlobal.AuthorityLength);
                    }
                }
                return "";
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
