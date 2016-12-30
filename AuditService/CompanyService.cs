using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity;
using AuditService;
using AuditSPI;
using DbManager;
using CtTool;
using GlobalConst;
using AuditSPI.Session;
using AuditEntity.Authority;

namespace AuditService
{
    public  class CompanyService:ICompanyService
    {
        ILinqDataManager ldbManager;
        IDbManager dbManager;

        public CompanyService()
        {
            ldbManager = new LinqDataManager();
            dbManager = new CTDbManager();

        }

        public List<CompanyEntity> GetCompanyList(CompanyEntity company)
        {
            try
            {
                List<CompanyEntity> companys = new List<CompanyEntity>();
                string sql ="";
                if (StringUtil.IsNullOrEmpty(company.Id))
                {
                    sql= "SELECT * FROM LSBZDW WHERE LSBZDW_PARENTID IS NULL OR LSBZDW_PARENTID='' ORDER BY LSBZDW_SEQUENCE";
                    companys = dbManager.ExecuteSqlReturnTType<CompanyEntity>(sql);
                }
                else
                {
                    sql = "SELECT * FROM LSBZDW WHERE  LSBZDW_PARENTID='"+company.Id+"' ORDER BY LSBZDW_SEQUENCE";
                    companys = dbManager.ExecuteSqlReturnTType<CompanyEntity>(sql);
                }
                foreach (CompanyEntity ce in companys)
                {
                    if (ce.Mx == 0)
                    {
                        ce.state = "closed";
                    }
                }
                return companys;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void Save(CompanyEntity company)
        {
            try
            {

                if (StringUtil.IsNullOrEmpty(company.Id))
                {
                    company.Id = Guid.NewGuid().ToString();
                }
                CompanyEntity test = ldbManager.GetEntity<CompanyEntity>(r => r.Code == company.Code);
                if (test != null)
                {
                    throw new Exception("编号重复");
                }
                //内码计算
                int js = 0;
                if (!StringUtil.IsNullOrEmpty(company.ParentId))
                {
                    CompanyEntity parentC = ldbManager.GetEntity<CompanyEntity>(r => r.Id == company.ParentId);
                    js = parentC.Js+1;
                   company.Nm = parentC.Nm;
                    parentC.Mx = 0;
                    ldbManager.UpdateEntity<CompanyEntity>(parentC);
                }
                else
                {
                    js = 1;
                }
                List<CompanyEntity> lists = ldbManager.getList<CompanyEntity>(r => r.ParentId==company.ParentId);
                company.Nm += GetNm(lists);
                company.Js = js;
                company.Mx = 1;
                ldbManager.InsertEntity<CompanyEntity>(company);
               
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private string GetNm(List<CompanyEntity> lists)
        {
            int nm=-1;
            int maxNm=0;
            foreach (CompanyEntity ce in lists)
            {
                nm=Convert.ToInt32(ce.Nm.Substring(ce.Nm.Length-4,4));
                if(maxNm<nm){
                 maxNm=nm;
                }
            }
            return (maxNm+1).ToString().PadLeft(4,'0');
        }
        public void Edit(CompanyEntity company)
        {
            try
            {
                if (company.Id == company.ParentId)
                {
                    throw new Exception("不能够循环引用");
                }
                List<CompanyEntity> listst = ldbManager.getList<CompanyEntity>(r => r.Code == company.Code);
                if (listst.Count >1)
                {
                    throw new Exception("编号重复");
                }
                //原有组织结构
                CompanyEntity ce = ldbManager.GetEntity<CompanyEntity>(r => r.Id == company.Id);

                if (company.ParentId == ce.ParentId)
                {
                    BeanUtil.CopyBeanToBean(company, ce);
                    ldbManager.UpdateEntity<CompanyEntity>(ce);
                }
                else
                {
                    int js = 0;
                    CompanyEntity curParent = ldbManager.GetEntity<CompanyEntity>(r => r.Id == company.ParentId);// 当前父节点
                    js = curParent.Js + 1;
                    List<CompanyEntity> children = ldbManager.getList<CompanyEntity>(r => r.ParentId == company.ParentId);
                    string curNm = curParent.Nm + GetNm(children);

                    if (children.Count == 0)
                    {
                        dbManager.ExecuteSql("UPDATE LSBZDW SET LSBZDW_MX=0 WHERE LSBZDW_ID='"+company.ParentId+"'");
                    }

                    List<CompanyEntity> oldChildren = ldbManager.getList<CompanyEntity>(r => r.ParentId == ce.ParentId);
                    if (oldChildren.Count == 1)
                    {
                        dbManager.ExecuteSql("UPDATE LSBZDW SET LSBZDW_MX=1 WHERE LSBZDW_ID='" + ce.ParentId + "'");
                    }
                    //查找当前节点的所有子集节点包括当前节点;
                    List<CompanyEntity> curNodeChildren = dbManager.ExecuteSqlReturnTType<CompanyEntity>("SELECT * FROM LSBZDW WHERE LSBZDW_DWNM LIKE '" + ce.Nm + "%'");
                    foreach (CompanyEntity temp in curNodeChildren)
                    {
                        if(temp.Id==company.Id)continue;
                        temp.Js = temp.Js - ce.Js + js;
                        temp.Nm = curNm + temp.Nm.Substring(ce.Nm.Length);
                        dbManager.ExecuteSql("UPDATE LSBZDW SET LSBZDW_DWNM='" + temp.Nm + "',LSBZDW_JS=" + temp.Js + " WHERE LSBZDW_ID='"+temp.Id+"'");
                    }
                    company.Nm = curNm;
                    company.Js = js;
                    BeanUtil.CopyBeanToBean(company, ce);
                    ldbManager.UpdateEntity<CompanyEntity>(ce);
                    
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void Delete(CompanyEntity company)
        {
            try
            {
                string sql = "Delete FROM LSBZDW WHERE LSBZDW_DWNM LIKE '"+company.Nm+"%'";
                dbManager.ExecuteSql(sql);
                if (!StringUtil.IsNullOrEmpty(company.ParentId))
                {
                    sql = "SELECT COUNT(*) FROM LSBZDW WHERE LSBZDW_PARENTID='"+company.ParentId+"'";
                    int count = dbManager.Count(sql);
                    if (count == 0)
                    {
                        sql = "UPDATE LSBZDW SET LSBZDW_MX=1 WHERE LSBZDW_ID='" + company.ParentId + "'";
                        dbManager.ExecuteSql(sql);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public CompanyEntity get(CompanyEntity company)
        {
            try
            {
                CompanyEntity ce = ldbManager.GetEntity<CompanyEntity>(r => r.Id == company.Id);
                return ce;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public  List<TreeNode> ParentCombo()
        {
            try
            {
                List<CompanyEntity> lists = ldbManager.getList<CompanyEntity>();
                List<TreeNode> nodes = new List<TreeNode>();
                BeanUtil.ConvertTTypeToTreeNode<CompanyEntity>(lists, nodes, "Id", "Name", "ParentId");
                return nodes;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        
        /// <summary>
        ///获取所有的单位数据，不带权限
        /// </summary>
        /// <returns></returns>
        public List<CompanyEntity> GetAllCompanys()
        {
            try
            {
                string sql = "SELECT * FROM LSBZDW";
                return dbManager.ExecuteSqlReturnTType<CompanyEntity>(sql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public List<TreeNode> ParentComboAuthority()
        {
            try
            {
                List<CompanyEntity> lists = GetCompanysByAuthority();
                List<TreeNode> nodes = new List<TreeNode>();
                BeanUtil.ConvertTTypeToTreeNode<CompanyEntity>(lists, nodes, "Id", "Name", "ParentId");
                return nodes;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public List<CompanyEntity> GetCompaniesByAuditPaperAndAuthority(string auditPaperId)
        {
            try
            {
                //审计底稿带权限的单位；
                //string sql = " SELECT * FROM LSBZDW WHERE LSBZDW_ID IN( SELECT AUDITPAPERANDCOMPANY_COMPANYID FROM CT_PAPER_AUDITPAPERANDCOMPANY WHERE AUDITPAPERANDCOMPANY_PAPERID='"+auditPaperId+"' AND AUDITPAPERANDCOMPANY_COMPANYID IN("+GetAuthorityCompanies()+"))";
                string sql = " SELECT * FROM LSBZDW WHERE " + GetFillReportAuthorityCompaniesSql();
                List<CompanyEntity> companies = dbManager.ExecuteSqlReturnTType<CompanyEntity>(sql);
               // List<TreeNode> nodes = new List<TreeNode>();
               // BeanUtil.ConvertTTypeToTreeNode<CompanyEntity>(companies, nodes, "Id", "Name", "ParentId");
                return companies;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #region 权限SQL
        /// <summary>
        /// 获取填报组织机构权限
        /// </summary>
        /// <returns></returns>
        public    string GetFillReportAuthorityCompaniesSql()
        {
            try
            {
              return  GetAuthorityCompaniesSql(AuthorityTypeEnum.FillReport);
               
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 获取单位Id权限Sql
        /// </summary>
        /// <returns></returns>
        public string GetFillReportAuthorityCompaniesIdSql()
        {
            try
            {
              return  GetAuthorityCompaniesIdSql(AuthorityTypeEnum.FillReport);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 获取单位Id权限Sql
        /// </summary>
        /// <returns></returns>
        public string GetAuditAuthorityCompaniesIdSql()
        {
            try
            {
                return GetAuthorityCompaniesIdSql(AuthorityTypeEnum.Audit);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 获取正常报表的数据权限
        /// </summary>
        /// <returns></returns>
        public string GetNormalAuthorityCompaniesSql()
        {
            try
            {
                SessionInfo si = SessoinUtil.GetCurrentSession();
                return " LSBZDW_DWNM LIKE '" + si.companyEntity.Nm + "'" + dbManager.Join() + "'%'";
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 获取正常报表的数据权限
        /// </summary>
        /// <returns></returns>
        public string GetNormalAuthorityCompaniesSqlId()
        {
            try
            {
                SessionInfo si = SessoinUtil.GetCurrentSession();
                return " IN (SELECT LSBZDW_ID FROM LSBZDW WHERE  LSBZDW_DWNM LIKE '" + si.companyEntity.Nm + "'" + dbManager.Join() + "'%')";
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 获取权限的基本函数
        /// </summary>
        /// <param name="authority"></param>
        /// <returns></returns>
        private string GetAuthorityCompaniesSql(AuthorityTypeEnum authority)
        {
            try
            {
                string type = "";
                bool flag = false;
                 SessionInfo si = SessoinUtil.GetCurrentSession();
                if (authority == AuthorityTypeEnum.FillReport)
                {
                    type = BasicGlobalConst.Authoriy_FillReport;
                    if (si.FillReportCompaniesCount > 0)
                    {
                        flag = true;
                    }
                    else
                    {
                        flag = false;
                    }
                }
                else if (authority == AuthorityTypeEnum.Audit)
                {
                    type = BasicGlobalConst.Authority_Audit;
                    if (si.AuditCompaniesCount > 0)
                    {
                        flag = true;
                    }
                    else
                    {
                        flag = false;
                    }
                }
               
                if (flag)
                {
                    return "  LSBZDW_ID IN ( SELECT USERCOMPANYRELATION_COMPANYID FROM CT_BASIC_USERCOMPANYRELATION WHERE USERCOMPANYRELATION_USERID='" + si.userEntity.Id + "' AND USERCOMPANYRELATION_TYPE='" +type + "')";
                }
                else
                {
                    return " LSBZDW_DWNM LIKE '" + si.companyEntity.Nm + "'" + dbManager.Join() + "'%'";
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 获取填报
        /// </summary>
        /// <param name="authority"></param>
        /// <returns></returns>
        private string GetAuthorityCompaniesIdSql(AuthorityTypeEnum authority)
        {
            try
            {
              
                SessionInfo si = SessoinUtil.GetCurrentSession();
                string type = "";
                bool flag = false;
              
                if (authority == AuthorityTypeEnum.FillReport)
                {
                    type = BasicGlobalConst.Authoriy_FillReport;
                    if (si.FillReportCompaniesCount > 0)
                    {
                        flag = true;
                    }
                    else
                    {
                        flag = false;
                    }
                }
                else if (authority == AuthorityTypeEnum.Audit)
                {
                    type = BasicGlobalConst.Authority_Audit;
                    if (si.AuditCompaniesCount > 0)
                    {
                        flag = true;
                    }
                    else
                    {
                        flag = false;
                    }
                }
                if (flag)
                {
                    return "   IN ( SELECT USERCOMPANYRELATION_COMPANYID FROM CT_BASIC_USERCOMPANYRELATION WHERE USERCOMPANYRELATION_USERID='" + si.userEntity.Id + "' AND USERCOMPANYRELATION_TYPE='" + type + "')";
                }
                else
                {
                    return " IN (SELECT LSBZDW_ID FROM LSBZDW WHERE  LSBZDW_DWNM LIKE '" + si.companyEntity.Nm + "'" + dbManager.Join() + "'%')";
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 获取填报权限单位数量
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public int GetFillReportCompaniesCount(string userId)
        {
            try
            {
                string sql = "SELECT COUNT(*) FROM CT_BASIC_USERCOMPANYRELATION WHERE USERCOMPANYRELATION_USERID='" + userId + "' AND USERCOMPANYRELATION_TYPE ='" + BasicGlobalConst.Authoriy_FillReport + "'";
                return dbManager.Count(sql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 获取审计权限报表数量
       /// </summary>
       /// <param name="userId"></param>
       /// <returns></returns>
        public int GetAuditCompaniesCount(string userId)
        {
            try
            {
                string sql = "SELECT COUNT(*) FROM CT_BASIC_USERCOMPANYRELATION WHERE USERCOMPANYRELATION_USERID='" + userId + "' AND USERCOMPANYRELATION_TYPE ='" + BasicGlobalConst.Authority_Audit + "'";
                return dbManager.Count(sql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion

        /// <summary>
        /// 获取有权限的单位列表
        /// </summary>
        /// <returns></returns>
        public List<CompanyEntity> GetCompanysByAuthority()
        {
            try
            {
                       
             
                string sql = " SELECT * FROM LSBZDW WHERE "+GetFillReportAuthorityCompaniesSql();              

                List<CompanyEntity> companies = dbManager.ExecuteSqlReturnTType<CompanyEntity>(sql);
              
                return companies;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public DataGrid<CompanyEntity> CompanyDataGrid(DataGrid<CompanyEntity> dataGrid, CompanyEntity ce)
        {
            try
            {
                DataGrid<CompanyEntity> dg = new DataGrid<CompanyEntity>();
                string csql = "SELECT * FROM LSBZDW";
                string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<CompanyEntity>(ce);
                if (!StringUtil.IsNullOrEmpty(whereSql))
                {
                    whereSql = " WHERE 1=1 AND " + whereSql;
                }
                else
                {
                    whereSql = "";
                }
                csql += whereSql;
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<CompanyEntity>();
                string countSql = "SELECT COUNT(*) FROM LSBZDW";
                countSql += whereSql;
                string sortName = maps[dataGrid.sort];
                dg.rows = dbManager.ExecuteSqlReturnTType<CompanyEntity>(csql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
                dg.total = dbManager.Count(countSql);
                return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 获取带有权限的组织机构列表
        /// </summary>
        /// <param name="company"></param>
        /// <returns></returns>
        public List<CompanyEntity> GetCompanysByAuthority(CompanyEntity company)
        {
            try
            {
                string sql = " SELECT * FROM LSBZDW WHERE " + GetFillReportAuthorityCompaniesSql();
                string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<CompanyEntity>(company);
                if (whereSql.Length > 0)
                {
                    sql += " AND "+whereSql;
                }
                List<CompanyEntity> companies = dbManager.ExecuteSqlReturnTType<CompanyEntity>(sql);
               
                return companies;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


      
    }
}
