using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Linq.Expressions;
using System.Web;
using System.Web.SessionState;
using DbManager;
using AuditEntity;
using AuditSPI;
using AuditSPI.Session;
using CtTool;
using GlobalConst;


namespace AuditService
{
  public    class UserService:IUser
    {
       ILinqDataManager ldm;
       IDbManager dbManager;
        public UserService()
        {
            ldm = new LinqDataManager();
            dbManager = new CTDbManager();
        }
      /// <summary>
      /// 保存用户和角色的关系
      /// </summary>
      /// <param name="userRoleRelation"></param>
        public void SaveUserRoleRelation(UserRoleRelation userRoleRelation)
        {
            try
            {
                if (StringUtil.IsNullOrEmpty(userRoleRelation.Id))
                {
                    userRoleRelation.Id = Guid.NewGuid().ToString();
                }
                ldm.InsertEntity<UserRoleRelation>(userRoleRelation);

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
      /// <summary>
      /// 保存用户和职责的关系
      /// </summary>
      /// <param name="userPositionRelation"></param>
        public void SaveUserPositionRelation(UserPositionRelation userPositionRelation)
        {
            try
            {
                if (StringUtil.IsNullOrEmpty(userPositionRelation.Id))
                {
                    userPositionRelation.Id = Guid.NewGuid().ToString();
                }
                ldm.InsertEntity<UserPositionRelation>(userPositionRelation);

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void SaveUserRols(UserEntity user)
        {
            try
            {
                //删除用户和角色信息
                string sql = "DELETE FROM CT_BASIC_USERROLERELATION WHERE USERROLERELATION_USERID='" + user.Id + "'";
                dbManager.ExecuteSql(sql);
                foreach (RoleEntity re in user.Rols)
                {
                    UserRoleRelation urr = new UserRoleRelation();
                    urr.UserId = user.Id;
                    urr.RoleId = re.Id;
                    SaveUserRoleRelation(urr);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        private void SaveUserPositions(UserEntity user)
        {
            try
            {
                //删除用户职责信息
                string sql = "DELETE FROM CT_BASIC_USERPOSITIONRELATION WHERE USERPOSITIONRELATION_USERID='" + user.Id + "'";
                dbManager.ExecuteSql(sql);
                foreach (PositionEntity pe in user.Positions)
                {
                    UserPositionRelation upr = new UserPositionRelation();
                    upr.UserId = user.Id;
                    upr.Position = pe.Id;
                    SaveUserPositionRelation(upr);
                } 
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void DeleteUserRolesAndPositions(UserEntity user)
        {
            try
            {
                string sql = "DELETE FROM CT_BASIC_USERPOSITIONRELATION WHERE USERPOSITIONRELATION_USERID='" + user.Id + "'";
                dbManager.ExecuteSql(sql);
                sql = "DELETE FROM CT_BASIC_USERROLERELATION WHERE USERROLERELATION_USERID='" + user.Id + "'";
                dbManager.ExecuteSql(sql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void GetUserRolsAndPositions(UserEntity user)
        {
            try
            {
                string sql = "SELECT * FROM  CT_BASIC_USERROLERELATION INNER JOIN CT_BASIC_ROLE ON USERROLERELATION_ROLEID=ROLE_ID WHERE USERROLERELATION_USERID='"+user.Id+"'";
                user.Rols = dbManager.ExecuteSqlReturnTType<RoleEntity>(sql);
                sql = "SELECT * FROM  CT_BASIC_USERPOSITIONRELATION INNER JOIN CT_BASIC_POSITION ON USERPOSITIONRELATION_POSITIONID=POSITION_ID WHERE USERPOSITIONRELATION_USERID='" + user.Id + "'";
                user.Positions = dbManager.ExecuteSqlReturnTType<PositionEntity>(sql);
                user.RoleName = "";
                user.PositionName = "";
                foreach (RoleEntity re in user.Rols)
                {
                    user.RoleName += re.Name + ",";
                }
                if (user.RoleName!=null&& user.RoleName.Length > 0) user.RoleName = user.RoleName.Substring(0, user.RoleName.Length - 1);
                foreach (PositionEntity pe in user.Positions)
                {
                    user.PositionName += pe.Name + ",";
                }
                if (user.PositionName!=null&& user.PositionName.Length > 0) user.PositionName = user.PositionName.Substring(0, user.PositionName.Length - 1);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
      /// <summary>
      /// 保存用户信息
      /// </summary>
      /// <param name="userEntity"></param>
        public void Save(UserEntity userEntity)
        {
            try
            {
                if (StringUtil.IsNullOrEmpty(userEntity.Id))
                {
                    userEntity.Id = Guid.NewGuid().ToString();
                }
                if (!CheckUserExist(userEntity))
                {
                    SetTimeAndUser(userEntity);
                    ldm.InsertEntity<UserEntity>(userEntity);
                    SaveUserRols(userEntity);
                    SaveUserPositions(userEntity); 
                }
                else
                {
                    throw new Exception("该用户已经存在");
                }
                
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public void SaveUserPassword(UserEntity userEntity)
        {
            try
            {
                if (StringUtil.IsNullOrEmpty(userEntity.Id))
                {
                    throw new Exception("传入格式不正确");
                }
                if (StringUtil.IsNullOrEmpty(userEntity.Password))
                {
                    throw new Exception("密码不能为空");
                }
                if (userEntity.Password.Length < 6)
                {
                    throw new Exception("密码长度不能低于6位");
                }
                string updateSql = "UPDATE SYUSER SET SYUSER_PASSWORD='"+userEntity.Password+"',SYUSER_MC='"+userEntity.Name+"' WHERE SYUSER_ID='"+userEntity.Id+"' ";
                dbManager.ExecuteSql(updateSql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
      /// <summary>
      /// 编辑用户信息
      /// </summary>
      /// <param name="userEntity"></param>
        public void Edit(UserEntity userEntity)
        {
            try
            {
                if (StringUtil.IsNullOrEmpty(userEntity.Id))
                {
                    throw new Exception("传入格式不正确");
                }
                if (StringUtil.IsNullOrEmpty(userEntity.Password))
                {
                    throw new Exception("密码不能为空");
                }
                if (userEntity.Password.Length < 6)
                {
                    throw new Exception("密码长度不能低于6位");
                }
                UserEntity ue = Get(userEntity);
                if (ue.Code != userEntity.Code) {
                    if (CheckUserExist(userEntity)) {
                        throw new Exception("该用户已经存在");
                    }
                }
                BeanUtil.CopyBeanToBean(userEntity, ue);
                SetTimeAndUser(ue);
                ldm.UpdateEntity<UserEntity>(ue);
                SaveUserRols(userEntity);
                SaveUserPositions(userEntity); 
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
      /// <summary>
      /// 
      /// </summary>
      /// <param name="userEntity"></param>
      /// <returns></returns>
        private bool CheckUserExist(UserEntity userEntity)
        {
            try
            {
                UserEntity ue = ldm.GetEntity<UserEntity>(r => r.Code == userEntity.Code);
                if (ue == null)
                {
                    return false;
                }
                else
                {
                    return true;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
      /// <summary>
      /// 删除用户信息
      /// </summary>
      /// <param name="userEntity"></param>
        public void Delete(UserEntity userEntity)
        {
            try
            {
                UserEntity ue = Get(userEntity);
                ldm.Delete<UserEntity>(ue);
                DeleteUserRolesAndPositions(userEntity);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
      /// <summary>
      /// 获取用户信息
      /// </summary>
      /// <param name="userEntity"></param>
      /// <returns></returns>
        public UserEntity Get(UserEntity userEntity)
        {
            try
            {
                UserEntity ue= ldm.GetEntity<UserEntity>(r => r.Id == userEntity.Id);
                GetUserRolsAndPositions(ue);
                return ue;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

      
      /// <summary>
      /// 获取用户列表
      /// </summary>
      /// <param name="dataGrid"></param>
      /// <returns></returns>
        public DataGrid<UserEntity> getDataGrid(DataGrid<UserEntity> dataGrid,UserEntity user)
        {
            try
            {
                DataGrid<UserEntity> dg = new DataGrid<UserEntity>();
                string selectSql = BeanUtil.ConvertObjectToSqls<UserEntity>();
                selectSql += ",LSBZDW_DWMC ";
                string sql = "SELECT " + selectSql + " FROM " + " SYUSER S LEFT JOIN LSBZDW L ON S.SYUSER_ORGANIZATION=LSBZDW_ID WHERE 1=1 ";
                List<string> ps = new List<string>();
                ps.Add("Code");
                ps.Add("Name");
                
                string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<UserEntity>(user,ps);
                if (!StringUtil.IsNullOrEmpty(user.CompanyName))
                {
                    if (whereSql != "") whereSql += " AND ";
                    whereSql += " LSBZDW_DWMC LIKE '%"+user.CompanyName+"%'";
                }
                if(whereSql!="")
                 sql +=" AND "+ whereSql;

                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<UserEntity>();
                maps.Add("CompanyName", "LSBZDW_DWMC");

                string countSql = "SELECT COUNT(*) FROM SYUSER S LEFT JOIN LSBZDW L ON S.SYUSER_ORGANIZATION=LSBZDW_ID WHERE 1=1 ";
                if (whereSql != "")
                countSql += " AND "+ whereSql;

                string sortName = maps[dataGrid.sort];
                dg.rows = dbManager.ExecuteSqlReturnTType<UserEntity>(sql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
                dg.total = dbManager.Count(countSql);

                foreach (UserEntity ue in dg.rows)
                {
                    GetUserRolsAndPositions(ue);
                }
                return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void SetTimeAndUser(UserEntity ue)
        {
            ue.CreateTime = CtTool.SessoinUtil.GetDateTime();
            ue.Creator = CtTool.SessoinUtil.GetCurrentUser().Id;
        }
      /// <summary>
      /// 单点登录
      /// </summary>
      /// <param name="userEntity"></param>
      /// <returns></returns>
        public UserEntity SingleLogin(UserEntity userEntity)
        {
            try
            {
                string sql = "SELECT * FROM SYUSER WHERE SYUSER_USERID='" + userEntity.Code + "'";
                List<UserEntity> ues = dbManager.ExecuteSqlReturnTType<UserEntity>(sql);

                if (ues == null || ues.Count == 0)
                {
                    throw new Exception("用户名不存在！");
                }
                GetUserRolsAndPositions(ues[0]);
                return ues[0];

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
      /// <summary>
      /// 用户登录
      /// </summary>
      /// <param name="userEntity"></param>
        public UserEntity Login(UserEntity userEntity)
        {
            try
            {
                if (StringUtil.IsNullOrEmpty( userEntity.Code))
                {
                    throw new Exception("用户名不能为空!");
                }
                if (StringUtil.IsNullOrEmpty( userEntity.Password))
                {
                    throw new Exception("用户密码不能为空!");
                }
              
                string sql = "SELECT * FROM SYUSER WHERE SYUSER_USERID='" + userEntity.Code + "'";
                List<UserEntity> ues = dbManager.ExecuteSqlReturnTType<UserEntity>(sql);
                
                if (ues==null|| ues.Count==0)
                {
                    throw new Exception("用户名不存在！");
                }
                if (userEntity.Password != ues[0].Password)
                {
                    throw new Exception("用户密码不正确!");
                }
                GetUserRolsAndPositions(ues[0]);

                return ues[0];
              
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
      /// <summary>
      /// 用户注销
      /// </summary>
      /// <param name="userEntity"></param>
        public void LoginOut(UserEntity userEntity)
        {
            try
            {
                //DeleteSession();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


    }
}
