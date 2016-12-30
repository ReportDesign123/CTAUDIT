
    using System;
    using System.Web;
    using System.Xml;
namespace DbManager
{
    public class BackUpConfigManager
    {
        public BackUpStruct GetBackUpConfig()
        {
            BackUpStruct struct3;
            try
            {
                BackUpStruct struct2 = new BackUpStruct();
                XmlDocument document = new XmlDocument();
                document.Load(HttpContext.Current.Server.MapPath("~") + @"\DBConfig.xml");
                XmlElement element = (XmlElement) document.SelectSingleNode("CtConfig").SelectSingleNode("BackUpConfig");
                string str = element.GetAttribute("path").ToString();
                struct2.backUpPath = str;
                struct3 = struct2;
            }
            catch (Exception exception)
            {
                throw exception;
            }
            return struct3;
        }
    }
}

