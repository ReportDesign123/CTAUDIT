using System;
using System.Web;
using System.Web.SessionState;

using GlobalConst;
using AuditEntity;
using AuditSPI.Session;
using CtTool;

namespace Audit.Module
{
    public class FilterModule : IHttpModule
    {
        /// <summary>
        /// You will need to configure this module in the web.config file of your
        /// web and register it with IIS before being able to use it. For more information
        /// see the following link: http://go.microsoft.com/?linkid=8101007
        /// </summary>
        #region IHttpModule Members

        public void Dispose()
        {
            //clean-up code here.
            
        }

        public void Init(HttpApplication context)
        {
            // Below is an example of how you can handle LogRequest event and provide 
            // custom logging implementation for it
   
            context.PostAcquireRequestState += new EventHandler(Context_EndRequest);

           // context.LogRequest += new EventHandler(OnLogRequest);
        }

        #endregion

  

        public void Context_EndRequest(object source, EventArgs e)
        {
            try
            {
                HttpApplication application = (HttpApplication)source;
                HttpSessionState session = application.Context.Session;
                if (session != null)
                {
                    SessionInfo SessionInfo = (SessionInfo)session[BasicGlobalConst.CT_SESSION];
                    if (SessionInfo == null)
                    {
                        string url = application.Context.Request.Url.AbsolutePath;
                     
                        if (!CtTool.SessoinUtil.ExcludeContainUrl(url))
                        {
                            string methodName = CtTool.SessoinUtil.getParam("MethodName", application.Context);


                            if (methodName != null && CtTool.SessoinUtil.ContainMethod(url, methodName))
                            {

                            }
                            else
                            {
                              //  application.Context.Response.Redirect(application.Context.Server.MapPath("~") + @"/Login.aspx");
                            }

                        }

                    }

                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            
        }
    }
}
