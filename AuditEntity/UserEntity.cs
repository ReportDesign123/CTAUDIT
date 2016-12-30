using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity
{
    [Table(Name="SYUSER")]
  public   class UserEntity
    {
        [Column(Name = "SYUSER_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
        [Column(Name = "SYUSER_USERID")]
        public string Code
        {
            get;
            set;
        }
         [Column(Name = "SYUSER_MC")]
        public string Name
        {
            get;
            set;
        }
         [Column(Name = "SYSUSER_ROLE")]
         public string RoleId
         {
             get;
             set;
         }
         [Column(Name = "SYSUSER_RESPONSIBILITY")]
         public string ResponsibilityId
         {
             get;
             set;
         }
         [Column(Name = "SYUSER_ORGANIZATION")]
         public string OrgnizationId
         {
             get;
             set;
         }
         [Column(Name = "SYSUSER_CREATETIME")]
         public DateTime CreateTime
         {
             get;
             set;
         }
         [Column(Name = "SYUSER_CREATOR")]
         public string Creator
         {
             get;
             set;
         }
          [Column(Name = "SYUSER_PASSWORD")]
         public string Password
         {
             get;
             set;
         }
        
          public string CompanyName
          {
              get;
              set;
          }

          public List<RoleEntity> Rols
          {
              get;
              set;
          }
          public List<PositionEntity> Positions
          {
              get;
              set;
          }

          public string RoleName
          {
              get;
              set;
          }
          public string PositionName
          {
              get;
              set;
          }

    }
}
