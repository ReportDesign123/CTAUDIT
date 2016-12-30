using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity;

namespace AuditSPI.Session
{
    public  class SessionInfo
    {
        public UserEntity userEntity = new UserEntity();
        public CompanyEntity companyEntity = new CompanyEntity();
        public int FillReportCompaniesCount = 0;
        public int AuditCompaniesCount = 0;
    }
}
