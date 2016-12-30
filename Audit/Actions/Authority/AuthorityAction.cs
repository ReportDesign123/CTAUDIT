using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using AuditEntity.Authority;
using AuditService.Authoriy;
using AuditSPI.Authority;
using AuditEntity;
using AuditSPI;
using CtTool;
namespace Audit.Actions.Authority
{
    public class AuthorityAction:BaseAction
    {
        IAuthority userCompanyRelationService;
        public AuthorityAction()
        {
            if (userCompanyRelationService == null)
            {
                userCompanyRelationService = new UserCompanyRelationService();
            }
        }
        public override void GoToMethod(string methodName)
        {
            switch (methodName)
            {
                case "SaveAndEditFillReportAuthority"://保存填报权限
                    string users = Convert.ToString(ActionTool.DeserializeParameter("users",context));
                    string companies = Convert.ToString(ActionTool.DeserializeParameter("companies", context));
                    SaveAndEditFillReportAuthority(users, companies);
                    break;
                case "SaveAndEditAuditAuthority"://保存审计权限
                    users = Convert.ToString(ActionTool.DeserializeParameter("users", context));
                    companies = Convert.ToString(ActionTool.DeserializeParameter("companies", context));
                    SaveAndEditAuditAuthority(users, companies);
                    break;
                case "GetFillReportAuthoriy"://获取填报权限
                case "GetAuditAuthority"://获取审计权限
                case "GetFillReportAuthorityCompaniesByUser":
                case "GetAuditAuthorityCompaniesByUser":
                    UserEntity user = ActionTool.DeserializeParameters<UserEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<AuthorityAction>(this, methodName, user);
                    break;
            
            }
        }
        /// <summary>
        /// 保存填报权限
        /// </summary>
        /// <param name="userStr"></param>
        /// <param name="companieStr"></param>
        public void SaveAndEditFillReportAuthority(string userStr, string companieStr) {
            JsonStruct js = new JsonStruct();
            try
            {
                List<UserEntity> users = JsonTool.DeserializeObject<List<UserEntity>>(userStr);
                List<CompanyEntity> companies = JsonTool.DeserializeObject<List<CompanyEntity>>(companieStr);
                userCompanyRelationService.SaveAndEditFillReportAuthority(users, companies);
                js.success = true;
                js.sMeg = "保存成功";
            }
            catch (Exception ex){
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.StackTrace;

            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 保存审计权限
        /// </summary>
        /// <param name="userStr"></param>
        /// <param name="companieStr"></param>
        public void SaveAndEditAuditAuthority(string userStr, string companieStr)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                List<UserEntity> users = JsonTool.DeserializeObject<List<UserEntity>>(userStr);
                List<CompanyEntity> companies = JsonTool.DeserializeObject<List<CompanyEntity>>(companieStr);
                userCompanyRelationService.SaveAndEditAuditAuthority(users, companies);
                js.success = true;
                js.sMeg = "保存成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.StackTrace;

            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 获取填报权限
        /// </summary>
        /// <param name="user"></param>
        public void GetFillReportAuthoriy(UserEntity user)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                 List<CompanyEntity> data = userCompanyRelationService.GetFillReportAuthoriy(user);
                 js.obj = data;
                 js.success = true;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.StackTrace;

            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 获取审计权限
        /// </summary>
        /// <param name="user"></param>
        public void GetAuditAuthority(UserEntity user)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                List<CompanyEntity> data = userCompanyRelationService.GetAuditAuthority(user);
                js.obj = data;
                js.success = true;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.StackTrace;

            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 获取填报权限下的单位
        /// </summary>
        /// <param name="user"></param>
        public void GetFillReportAuthorityCompaniesByUser(UserEntity user)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                List<TreeNode> obj = userCompanyRelationService.GetFillReportAuthorityCompaniesByUser(user);
                js.obj = obj;
                js.success = true;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.StackTrace;

            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        /// <summary>
        /// 获取审计权限下的单位
        /// </summary>
        /// <param name="user"></param>
        public void GetAuditAuthorityCompaniesByUser(UserEntity user)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                List<TreeNode> obj = userCompanyRelationService.GetAuditAuthorityCompaniesByUser(user);
                js.obj = obj;
                js.success = true;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.StackTrace;

            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
    }
}