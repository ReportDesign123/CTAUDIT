using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity;
using AuditEntity.Authority;

namespace AuditSPI.Authority
{
   public  interface IAuthority
    {
       /// <summary>
       /// 保存编辑用户权限
       /// </summary>
       /// <param name="users"></param>
       /// <param name="companies"></param>
       void SaveAndEditFillReportAuthority(List<UserEntity> users, List<CompanyEntity> companies);
       void SaveAndEditAuditAuthority(List<UserEntity> users, List<CompanyEntity> companies);
       List<CompanyEntity> GetFillReportAuthoriy(UserEntity user);
       List<CompanyEntity> GetAuditAuthority(UserEntity user);
       List<TreeNode> GetFillReportAuthorityCompaniesByUser(UserEntity user);
       List<TreeNode> GetAuditAuthorityCompaniesByUser(UserEntity user);
    }
}
