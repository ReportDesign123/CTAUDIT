using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CtTool;
using AuditSPI;

namespace Audit.Actions
{
    public class Test
    {
        public Test()
        {
            JsonStruct js = new JsonStruct();
            try
            {

                js.success = true;
                js.sMeg = "保存成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, null);



            try
            {
             
              
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
               
            }
        }
    }
}