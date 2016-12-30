using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity;

namespace AuditSPI
{
    public  interface ICompanyService
    {
        List<CompanyEntity> GetCompanyList(CompanyEntity company);
        void Save(CompanyEntity company);
        void Edit(CompanyEntity company);
        void Delete(CompanyEntity company);
        CompanyEntity get(CompanyEntity company);
        List<TreeNode> ParentCombo();
        List<CompanyEntity> GetAllCompanys();
        List<CompanyEntity> GetCompaniesByAuditPaperAndAuthority(string auditPaperId);
        
        //获取带有权限的组织机构列表
        List<CompanyEntity> GetCompanysByAuthority();
        //获取带有权限的组织机构列表
        List<CompanyEntity> GetCompanysByAuthority(CompanyEntity company);
        //获取带有权限单位的组织机构树
         List<TreeNode> ParentComboAuthority( );
        
         DataGrid<CompanyEntity> CompanyDataGrid(DataGrid<CompanyEntity> dataGrid, CompanyEntity ce);

        /// <summary>
        /// 获取填报权限单位数量
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
         int GetFillReportCompaniesCount(string userId);

         int GetAuditCompaniesCount(string userId);
    }
}
