using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using AuditService;
using AuditSPI;
using CtTool;
using AuditEntity;
using System.Web.SessionState;
using AuditSPI.Session;
using GlobalConst;
using DbManager;
using AuthorityBinPeng.Service;
using AuthorityBinPeng.SPI;



namespace Audit.Actions
{
    public class UserAction :BaseAction
    {
        IUser userService;
        IRole roleService;
        ICompanyService companyService;
        IPositionService positionService;
        CTDbManager dbManager;
        SystemService systemService;
        AuthorityService authorityService;
        SingleLoginService singleLoginService;
        ICycleService dicService;
        public UserAction()
        {
            userService = new UserService();
            roleService = new RoleService();
            companyService = new CompanyService();
            positionService = new PositionService();
            dbManager = new CTDbManager();
            systemService = new SystemService();
            authorityService = new AuthorityService();
            singleLoginService = new SingleLoginService();
            dicService = new CycleService();



        }

        /// <summary>
        /// 中控器
        /// </summary>
        /// <param name="methodName"></param>
        public override void GoToMethod(string methodName)
        {
            switch (methodName)
            {
                //获取功能菜单菜单
                case "DataGrid":
                    DataGrid<UserEntity> dg = new DataGrid<UserEntity>();
                    dg = ActionTool.DeserializeParametersByFields<DataGrid<UserEntity>>(context, actionType);
                    UserEntity userEntity = ActionTool.DeserializeParameters<UserEntity>(context, actionType);
                    DataGrid(dg, userEntity);
                    break;
                case "Save":
                case "Edit":
                    string entity = Convert.ToString(ActionTool.DeserializeParameter("entity", context));
                    ActionTool.InvokeObjMethod<UserAction>(this, methodName, entity);
                    break;
                case "SingleData":
                    List<string> Sparas=new List<string>();
                    Sparas.Add("AuditType");
                    Sparas.Add("AuditTask");
                    Sparas.Add("AuditPaper");
                    Sparas.Add("AuditCycle");
                    Sparas.Add("AuditDate");
                    Sparas.Add("AuditReport");
                   // string dataStr = ActionTool.DeserializeParameter("dataStr", context).ToString();
                    object[] sparaobjs = ActionTool.DeserializeParameters(Sparas, context, actionType);
                    ActionTool.InvokeObjMethod<UserAction>(this, methodName, sparaobjs);
                    break;
                case "SingleLogin":
                case "Delete":
                case "Login":
                case "LoginOut":
                    UserEntity re = ActionTool.DeserializeParameters<UserEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<UserAction>(this, methodName, re);
                    break;
                case  "SaveNewPassWord":
                    re = ActionTool.DeserializeParameters<UserEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<UserAction>(this, methodName, re);
                    break;
                case "RoleCombox":
                case "GetCurrentUserInfo":
                    ActionTool.InvokeObjMethod<UserAction>(this, methodName, null);
                    break;

            }
        }
        public void SingleData(string AuditType, string AuditTask, string AuditPaper,string AuditCycle,string AuditDate,string AuditReport)
        {
            JsonStruct js = new JsonStruct();
            SingleLoginEntity entity = new SingleLoginEntity();
            try
            {
                singleLoginService.GetEntity(ref entity, AuditType, AuditTask, AuditPaper, AuditReport);
                entity.AuditDate = AuditDate;//DateTime.Now.ToString("yyyy-MM-dd");
                entity.AuditYear = DateTime.Parse(AuditDate).Year.ToString();
                if (AuditCycle == "05")
                {
                    CycleEntity de = dicService.GetCycleInfor(entity.AuditDate);
                    if (de!=null)
                    {
                        entity.WeekRpId = de.Id;
                        entity.WeekRpJsrq = de.JSRQ;
                        entity.WeekRpKsrq = de.KSRQ;
                        entity.WeekRpName = de.Name;
                        entity.AuditZq = de.Code;
                    }
                }
                if (AuditCycle == "01")
                    entity.AuditZq = entity.AuditYear;

                if (AuditCycle == "03")
                    entity.AuditZq = DateTime.Parse(AuditDate).Month.ToString();
                if (AuditCycle == "04")
                    entity.AuditZq = entity.AuditDate;

                js.success = true;
                js.obj = entity;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }

        /// <summary>
        /// 保存新密码
        /// </summary>
        /// <param name="user"></param>
        public void SaveNewPassWord(UserEntity user)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                userService.SaveUserPassword(user);
                js.sMeg = "保存成功";
                js.success = true;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 获取当前用户基本信息
        /// </summary>
        /// <param name="user"></param>
        public void GetCurrentUserInfo()
        {
            JsonStruct js = new JsonStruct();
            try
            {
                UserEntity user = new UserEntity();
                user.Id = GetCurrentUser().Id;
                user = userService.Get(user);
                js.obj = user;
                js.success = true;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        public void Save(string entity)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                UserEntity userEntity = JsonTool.DeserializeObject<UserEntity>(entity);
                userService.Save(userEntity);
                js.success = true;
                js.sMeg = "保存成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        public void Edit(string entity)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                UserEntity userEntity = JsonTool.DeserializeObject<UserEntity>(entity);
                userService.Edit(userEntity);
                js.success = true;
                js.sMeg = "保存成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        public void Delete(UserEntity userEntity)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                userService.Delete(userEntity);
                js.success = true;
                js.sMeg = "保存成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
       
        public void DataGrid(DataGrid<UserEntity> dg,UserEntity user)
        {
            try
            {
                JsonTool.WriteJson<DataGrid<UserEntity>>(userService.getDataGrid(dg,user),context);

            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);

            }
        }

        public void RoleCombox()
        {
            try
            {
                JsonTool.WriteJson<List<RoleEntity>>(roleService.GetList(),context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);

            }
        }
        /// <summary>
        /// 单点登录
        /// </summary>
        public void SingleLogin(UserEntity userEnitiy)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                UserEntity ue = userService.SingleLogin(userEnitiy);
                HttpCookie cookie = new HttpCookie("UserInfo");
                cookie.Values["UserId"] = ue.Id;
                cookie.Values["DataBase"] = dbManager.GetDatabase();
                context.Response.Cookies.Add(cookie);
                LogEntity le = new LogEntity();
                le.UserId = ue.Id;
                le.UserCode = ue.Code;
                le.UserName = ue.Name;
                systemService.SaveLog(le);
                js.obj = ue;
                js.success = true;
                SaveSessoin(ue);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;

            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 用户登录
        /// </summary>
        /// <param name="userEnitiy"></param>
        public void Login(UserEntity userEnitiy)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                ConfigEntity config = authorityService.GetAuthority();
              //  if (config == null) throw new Exception("软件尚未授权，请注册授权！");
               UserEntity ue= userService.Login(userEnitiy);
               HttpCookie cookie = new HttpCookie("UserInfo");
               cookie.Values["UserId"] = ue.Id;
               cookie.Values["DataBase"] = dbManager.GetDatabase();
               context.Response.Cookies.Add(cookie);

               LogEntity le = new LogEntity();
               le.UserId = ue.Id;
               le.UserCode = ue.Code;
               le.UserName = ue.Name;
               systemService.SaveLog(le);
                js.success = true;
                SaveSessoin(ue);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
               
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }

        public void LoginOut(UserEntity userEntity)
        {
            JsonStruct js = new JsonStruct();
            try
            {
               // userService.LoginOut(userEntity);
                js.success = true;
                DeleteSession();
               // context.Response.Redirect("index.aspx");
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.StackTrace;
             
               
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }

        /// <summary>
        /// 存储Session
        /// </summary>
        /// <param name="userEntity"></param>
        private void SaveSessoin(UserEntity userEntity)
        {
            try
            {
                HttpSessionState hss = context.Session;
                if (hss != null)
                {
                    SessionInfo si = new SessionInfo();
                    si.userEntity = userEntity;
                    CompanyEntity ce=new CompanyEntity();
                    ce.Id=userEntity.OrgnizationId;
                    si.companyEntity = companyService.get(ce);
                    si.FillReportCompaniesCount = companyService.GetFillReportCompaniesCount(userEntity.Id);
                    si.AuditCompaniesCount = companyService.GetAuditCompaniesCount(userEntity.Id);
                    hss[BasicGlobalConst.CT_SESSION] =si;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 获取当前用户信息
        /// </summary>
        /// <returns></returns>
        private UserEntity GetCurrentUser()
        {
            try
            {
                HttpSessionState hss = context.Session;
                if (hss != null)
                {
                    SessionInfo si = new SessionInfo();
                    si =(SessionInfo) hss[BasicGlobalConst.CT_SESSION];
                    if (si != null)
                    {
                        return si.userEntity;
                    }
                }
                return new UserEntity();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 清空Session
        /// </summary>
        private void DeleteSession()
        {
            try
            {
                HttpSessionState hss = context.Session; ;
                if (hss != null)
                {
                    hss.Remove(BasicGlobalConst.CT_SESSION);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}