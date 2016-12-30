using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AuditSPI;
using AuditService;
using AuditEntity;
using CtTool;

namespace Audit.ct.basic
{
    public partial class AddUser : System.Web.UI.Page
    {
       public  UserEntity userEntity = new UserEntity();
       public string roles = "";
       public string positions = "";
       protected void Page_Load(object sender, EventArgs e)
       {
           UserEntity uen = ActionTool.DeserializeParameters<UserEntity>(Context, GlobalConst.BasicGlobalConst.POSTTYPE_GET);
           if (!StringUtil.IsNullOrEmpty(uen.Id))
           {
               IUser userS = new UserService();
               userEntity = userS.Get(uen);
               string rolesStr = "";
               foreach (RoleEntity role in userEntity.Rols)
               {
                   rolesStr += role.Id+",";
               }
               roles = rolesStr;
               string positionsStr = "";
               foreach (PositionEntity Position in userEntity.Positions)
               {
                   positionsStr += Position.Id+",";
               }
               positions = positionsStr;
           }
       }
    }
}