using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditSPI;
using AuditEntity.ExportReport;
using AuditSPI.ExportReport;
using CtTool;
using DbManager;
using AuditService;
using AuditEntity;
using System.Data.Common;
using System.Data;


namespace AuditService.ExportReport
{
    public  class TemplateAndCompanieyService:ITemplateAndCompany
    {
        private CTDbManager dbManager;
        private ICompanyService companyService;
        private LinqDataManager linqDbManager;
        public TemplateAndCompanieyService()
        {
            if (dbManager == null)
            {
                dbManager = new CTDbManager();
            }
            if (companyService == null)
            {
                companyService = new CompanyService();
            }
            if (linqDbManager == null)
            {
                linqDbManager = new LinqDataManager();
            }
        }

        /// <summary>
        /// 获取模板关联的报表
        /// </summary>
        /// <param name="reportTemplate"></param>
        /// <returns></returns>
        public List<TreeNode> TemplateAndCompanies(ReportTemplateEntity reportTemplate)
        {
            try
            {
                CompanyEntity ce = new CompanyEntity();
                List<CompanyEntity> allCompanies = companyService.GetAllCompanys();


                List<TemplateAndCompanyRelationEntity> apaces = linqDbManager.getList<TemplateAndCompanyRelationEntity>(r=>r.TemplateId==reportTemplate.Id);
                foreach (TemplateAndCompanyRelationEntity apace in apaces)
                {
                    foreach (CompanyEntity c in allCompanies)
                    {
                        if (apace.CompanyId == c.Id && apace.State == "1")
                        {
                            c.isOrNotChecked = true;
                            break;
                        }
                    }
                }
                List<TreeNode> nodes = new List<TreeNode>();
                BeanUtil.ConvertTTypeToTreeNode<CompanyEntity>(allCompanies, nodes, "Id", "Name", "ParentId");
                return nodes;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void BatchUpdate(List<TemplateAndCompanyRelationEntity> lists, string templateId)
        {
 

            DbConnection connection = dbManager.GetDbConnection();
            try
            {
                using (connection)
                {
                    DbCommand command = dbManager.getDbCommand();
                    dbManager.Open();
                    DbTransaction tr = connection.BeginTransaction();
                    try
                    {
                        string deleteSql = "DELETE FROM CT_REPORT_TEMPLATEANDCOMPANY WHERE TEMPLATEANDCOMPANY_TEMPLATEID='" + templateId + "'";
                        command.CommandType = CommandType.Text;
                        command.CommandText = deleteSql;
                        command.Transaction = tr;
                        command.ExecuteNonQuery();

                        if (lists.Count > 0)
                        {

                            string sql = BeanUtil.ConvertBeanToInsertCommandSql<TemplateAndCompanyRelationEntity>();
                            foreach (TemplateAndCompanyRelationEntity ap in lists)
                            {
                                if (StringUtil.IsNullOrEmpty(ap.Id))
                                {
                                    ap.Id = Guid.NewGuid().ToString();
                                }
                                string tempString = String.Format(sql, ap.Id, templateId, ap.CompanyId, ap.State);
                                command.CommandText = tempString;
                                command.ExecuteNonQuery();
                            }

                        }
                        tr.Commit();
                    }
                    catch (Exception ex)
                    {
                        tr.Rollback();
                        throw ex;
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
