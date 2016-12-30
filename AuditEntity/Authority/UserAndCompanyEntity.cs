using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity.Authority
{
    /// <summary>
    /// 用户权限结构
    /// 1、用户填报权限 01
    /// 2、用户审计权限 02   
    /// </summary>
   [Table(Name = "CT_BASIC_USERCOMPANYRELATION")]
    public   class UserAndCompanyEntity
    {
        [Column(Name = "USERCOMPANYRELATION_ID", IsPrimaryKey = true)]
        public string Id
        {
            get;
            set;
        }
        [Column(Name = "USERCOMPANYRELATION_USERID")]
        public string UserId
        {
            get;
            set;
        }
        [Column(Name = "USERCOMPANYRELATION_COMPANYID")]
        public string CompanyId
        {
            get;
            set;
        }
        [Column(Name = "USERCOMPANYRELATION_TYPE")]
        public string Type
        {
            get;
            set;
        }
    }
    public enum AuthorityTypeEnum
    {
        FillReport,
        Audit,
        Normal
    }
}
