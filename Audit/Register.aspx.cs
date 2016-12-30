using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AuditEntity;
using AuthorityBinPeng.Service;

namespace Audit
{
    public partial class Register : System.Web.UI.Page
    {
        public ConfigEntity config;
        public AuthorityService aus=new AuthorityService();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (config == null)
                {
                    config = aus.GetAuthority();

                    if (config == null)
                    {
                        config = new ConfigEntity();
                        config.Remark = "尚未注册";
                    }
                    else
                    {
                        config.Remark = "注册成功";
                    }
                }
            }
            catch (Exception ex)
            {
                config = new ConfigEntity();
                config.Remark = ex.Message;
            }
           

        }
    }
}