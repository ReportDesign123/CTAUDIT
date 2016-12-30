using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity;
using AuditEntity.Authority;
using AuditSPI.Authority;
using CtTool;
using DbManager;
using GlobalConst;
using AuditSPI;
using AuditService;

namespace AuditService.Authoriy
{

    /// <summary>
    /// 用户权限
    /// </summary>
  public    class UserCompanyRelationService:IAuthority
    {
      private CTDbManager dbManager;
      private LinqDataManager linqDbManager;
      private ICompanyService companyService;
      public UserCompanyRelationService()
      {
          if (dbManager == null)
          {
              dbManager = new CTDbManager();
          }
          if (linqDbManager == null)
          {
              linqDbManager = new LinqDataManager();
          }
          if (companyService == null)
          {
              companyService = new CompanyService();
          }
      }
      private void SaveUserCompanyRelationEntity(UserAndCompanyEntity userCompany)
      {
          try
          {
              if (StringUtil.IsNullOrEmpty(userCompany.Id))
              {
                  userCompany.Id = Guid.NewGuid().ToString();
              }
              linqDbManager.InsertEntity<UserAndCompanyEntity>(userCompany);
          }
          catch (Exception ex)
          {
              throw ex;
          }
      }
      /// <summary>
      /// 保存和编辑用户权限
      /// </summary>
      /// <param name="users"></param>
      /// <param name="companies"></param>
      public void SaveAndEditAuthority(List<UserEntity> users, List<CompanyEntity> companies,AuthorityTypeEnum ate)
      {
          try
          {
              string type = ate == AuthorityTypeEnum.FillReport ? BasicGlobalConst.Authoriy_FillReport : BasicGlobalConst.Authority_Audit;
              //删除用户的权限
              foreach (UserEntity user in users)
              {
                  string sql = "";
                  sql = "DELETE FROM CT_BASIC_USERCOMPANYRELATION WHERE USERCOMPANYRELATION_USERID='"+user.Id+"' AND USERCOMPANYRELATION_TYPE='"+type+"'";
                  dbManager.ExecuteSql(sql);
              }
              foreach (UserEntity user in users)
              {
                  foreach (CompanyEntity company in companies)
                  {
                      UserAndCompanyEntity uac = new UserAndCompanyEntity();
                      uac.UserId = user.Id;
                      uac.CompanyId = company.Id;
                      uac.Type = type;
                      SaveUserCompanyRelationEntity(uac);
                  }
              }
          }
          catch (Exception ex)
          {
              throw ex;
          }
      }
      /// <summary>
      /// 保存填报权限
      /// </summary>
      /// <param name="users"></param>
      /// <param name="companies"></param>
      public void SaveAndEditFillReportAuthority(List<UserEntity> users, List<CompanyEntity> companies)
      {
          try
          {
              SaveAndEditAuthority(users, companies, AuthorityTypeEnum.FillReport);
          }
          catch (Exception ex)
          {
              throw ex;
          }
      }
      /// <summary>
      /// 保存审计权限
      /// </summary>
      /// <param name="users"></param>
      /// <param name="companies"></param>
      public void SaveAndEditAuditAuthority(List<UserEntity> users, List<CompanyEntity> companies)
      {
          try
          {
              SaveAndEditAuthority(users, companies, AuthorityTypeEnum.Audit);
          }
          catch (Exception ex)
          {
              throw ex;
          }
      }
      public List<CompanyEntity> GetAuthority(UserEntity user, AuthorityTypeEnum ate)
      {
          try
          {
              string type = ate == AuthorityTypeEnum.FillReport ? BasicGlobalConst.Authoriy_FillReport : BasicGlobalConst.Authority_Audit;
              string sql = "DELETE FROM CT_BASIC_USERCOMPANYRELATION WHERE USERCOMPANYRELATION_USERID='"+user.Id+"' AND USERCOMPANYRELATION_TYPE='"+type+"'";
              List<CompanyEntity> companies = dbManager.ExecuteSqlReturnTType<CompanyEntity>(sql);
              return companies;
          }
          catch (Exception ex)
          {
              throw ex;
          }
      }

      public List<CompanyEntity> GetFillReportAuthoriy(UserEntity user)
      {
          try
          {
              return GetAuthority(user, AuthorityTypeEnum.FillReport);
          }
          catch (Exception ex)
          {
              throw ex;
          }
      }

      public List<CompanyEntity> GetAuditAuthority(UserEntity user)
      {
          try
          {
              return GetAuthority(user, AuthorityTypeEnum.Audit);
          }
          catch (Exception ex)
          {
              throw ex;
          }
      }

      /// <summary>
      /// 根据用户获取组织机构
      /// </summary>
      /// <param name="user"></param>
      /// <returns></returns>
      private  List<AuditSPI.TreeNode> GetAuthorityCompaniesByUserAndType(UserEntity user,AuthorityTypeEnum ate)
      {
          try
          {
              List<CompanyEntity> companies = companyService.GetAllCompanys();
               string type = ate == AuthorityTypeEnum.FillReport ? BasicGlobalConst.Authoriy_FillReport : BasicGlobalConst.Authority_Audit;
              List<UserAndCompanyEntity> relations = linqDbManager.getList<UserAndCompanyEntity>(r => r.UserId == user.Id && r.Type==type);
             
                  foreach (UserAndCompanyEntity r in relations)
                  {
                      foreach (CompanyEntity company in companies)
                      {
                          if (r.CompanyId == company.Id) {
                              company.isOrNotChecked = true;
                              break;
                          }
                      }
                  }
                  List<TreeNode> nodes = new List<TreeNode>();
                  BeanUtil.ConvertTTypeToTreeNode<CompanyEntity>(companies, nodes, "Id", "Name", "ParentId");
                  return nodes;
            
          }
          catch (Exception ex)
          {
              throw ex;
          }
      }


      public List<TreeNode> GetFillReportAuthorityCompaniesByUser(UserEntity user)
      {
          try
          {
              return  GetAuthorityCompaniesByUserAndType(user, AuthorityTypeEnum.FillReport);
          }
          catch (Exception ex)
          {
              throw ex;
          }
      }

      public List<TreeNode> GetAuditAuthorityCompaniesByUser(UserEntity user)
      {
          try
          {
              return GetAuthorityCompaniesByUserAndType(user, AuthorityTypeEnum.Audit);
          }
          catch (Exception ex)
          {
              throw ex;
          }
      }
    }
}
