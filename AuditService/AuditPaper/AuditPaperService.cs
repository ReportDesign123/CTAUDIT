using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Common;
using System.Data;



using DbManager;
using AuditSPI;
using AuditSPI.AuditPaper;
using AuditEntity;
using AuditEntity.AuditPaper;
using CtTool;
using GlobalConst;
using AuditService.AuditPaper;
using AuditSPI.Format;




namespace AuditService.AuditPaper
{
    public  class AuditPaperService:IAuditPaper,IAuditPaperAndCompanys,IAuditPaperAndReports
    {
        IDbManager dbManager;
        ILinqDataManager linqDbManager;
        CompanyService companyService;
        IReportFormat reportService;
        
        public AuditPaperService()
        {
            dbManager=new CTDbManager();
            linqDbManager = new LinqDataManager();
            companyService = new CompanyService();
            reportService = new ReportFormatService();
        }
        public void Save(AuditPaperEntity ape)
        {
            try
            {
                if (StringUtil.IsNullOrEmpty(ape.Id))
                {
                    ape.Id = Guid.NewGuid().ToString();
                }
                ape.State = AuditPaperGlobalConst.AuditPaperStart;
                ape.CreateTime = SessoinUtil.GetCurrentDateTime();
                linqDbManager.InsertEntity<AuditPaperEntity>(ape);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void Edit(AuditPaperEntity ape)
        {
            try
            {
                AuditPaperEntity temp = Get(ape.Id);
                BeanUtil.CopyBeanToBean(ape, temp);
                temp.CreateTime = SessoinUtil.GetCurrentDateTime();
                linqDbManager.UpdateEntity<AuditPaperEntity>(ape);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void Delete(AuditPaperEntity ape)
        {
            try
            {
                AuditPaperEntity temp = Get(ape.Id);
                linqDbManager.Delete<AuditPaperEntity>(temp);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public AuditPaperEntity Get(string Id)
        {
            try
            {
                AuditPaperEntity ape = linqDbManager.GetEntity<AuditPaperEntity>(r => r.Id == Id);
                return ape;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataGrid<AuditPaperEntity> GetDataGrid(DataGrid<AuditPaperEntity> dg,AuditPaperEntity ape)
        {
            try
            {
                DataGrid<AuditPaperEntity> datagrid = new DataGrid<AuditPaperEntity>();
                string sql = "SELECT * FROM CT_PAPER_AUDITPAPER P LEFT JOIN CT_PAPER_REPORTTEMPLATE R ON P.AUDITPAPER_TEMPLATEID=R.REPORTTEMPLATE_ID";

                string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<AuditPaperEntity>(ape);
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<AuditPaperEntity>();
                maps.Add("TemplateName", "REPORTTEMPLATE_NAME");

                string sortName = maps[dg.sort];
                if (whereSql.Length > 0)
                {
                    sql += " WHERE "+whereSql;
                }
                List<AuditPaperEntity> lists = dbManager.ExecuteSqlReturnTType<AuditPaperEntity>(sql, dg.page, dg.pageNumber, sortName + " " + dg.order, maps);
                sql = "SELECT COUNT(*) FROM CT_PAPER_AUDITPAPER";
                if (whereSql.Length > 0)
                {
                    sql += " WHERE " + whereSql;
                }
                int count = dbManager.Count(sql);
                datagrid.rows = lists;
                datagrid.total = count;
                return datagrid;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #region 审计底稿和组织机构关系接口

        /// <summary>
        /// 获取特定审计底稿的组织权限
        /// </summary>
        /// <param name="ape"></param>
        /// <returns></returns>
        public List<TreeNode> TreeNodesAuditPaperAuthorities(AuditPaperEntity ape)
        {
            try
            {
                CompanyEntity ce = new CompanyEntity();
                List<CompanyEntity> allCompanies = companyService.GetAllCompanys();


                List<AuditPaperAndCompanyEntity> apaces = linqDbManager.getList<AuditPaperAndCompanyEntity>(r => r.AuditPaperId == ape.Id);
                foreach (AuditPaperAndCompanyEntity apace in apaces)
                {
                    foreach (CompanyEntity c in allCompanies)
                    {
                        if (apace.CompanyId == c.Id&&apace.State=="1")
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

        /// <summary>
        /// 批量更新
        /// </summary>
        /// <param name="apaces"></param>
        public void BatchUpdate(List<AuditPaperAndCompanyEntity> apaces, string AuditPaperId)
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
                        string deleteSql = "DELETE FROM CT_PAPER_AUDITPAPERANDCOMPANY WHERE AUDITPAPERANDCOMPANY_PAPERID='" + AuditPaperId+ "'";
                        command.CommandType = CommandType.Text;
                        command.CommandText = deleteSql;
                        command.Transaction = tr;
                        command.ExecuteNonQuery();

                        if (apaces.Count > 0)
                        {

                            string sql = BeanUtil.ConvertBeanToInsertCommandSql<AuditPaperAndCompanyEntity>();
                            foreach (AuditPaperAndCompanyEntity ap in apaces)
                            {
                                if (StringUtil.IsNullOrEmpty(ap.Id))
                                {
                                    ap.Id = Guid.NewGuid().ToString();
                                }
                                string tempString = String.Format(sql, ap.Id, ap.AuditPaperId, ap.CompanyId,ap.State);
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
        #endregion


        #region 审计底稿和报表子集关系

        public List<AuditPaperEntity> GetAuditPaperLists()
        {
            try
            {
                string sql = "SELECT * FROM CT_PAPER_AUDITPAPER WHERE AUDITPAPER_STATE='" + AuditPaperGlobalConst.AuditPaperStart + "' ORDER BY AUDITPAPER_CODE";
                return dbManager.ExecuteSqlReturnTType<AuditPaperEntity>(sql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
         

        public Dictionary<string, List<ReportFormatDicEntity>> GetAuditPaperReports(string AuditPaperId)
        {
            try
            {
                Dictionary<string, List<ReportFormatDicEntity>> dics = new Dictionary<string, List<ReportFormatDicEntity>>();
                //获取所有报表列表
                string reportSql = "SELECT REPORTDICTIONARY_ID,REPORTDICTIONARY_CODE,REPORTDICTIONARY_NAME FROM CT_FORMAT_REPORTDICTIONARY ORDER BY REPORTDICTIONARY_CODE";
                List<ReportFormatDicEntity> allReports = dbManager.ExecuteSqlReturnTType<ReportFormatDicEntity>(reportSql);

                string sql="SELECT * FROM CT_PAPER_AUDITPAPERANDREPORT WHERE AUDITPAPERANDREPORT_AUDITPAPERID='"+AuditPaperId+"' ";
                List<AuditPaperAndReportEntity> relationsReports = dbManager.ExecuteSqlReturnTType<AuditPaperAndReportEntity>(sql);


                List<ReportFormatDicEntity> selectReports = new List<ReportFormatDicEntity>();
                List<ReportFormatDicEntity> unSelectReports = new List<ReportFormatDicEntity>();
                foreach (ReportFormatDicEntity rfde in allReports)
                {
                    bool flag = false;
                    foreach (AuditPaperAndReportEntity apare in relationsReports)
                    {
                        if (rfde.Id == apare.ReportId)
                        {
                            flag = true;
                            selectReports.Add(rfde);
                            break;
                        }
                    }
                    if (!flag)
                    {
                        unSelectReports.Add(rfde);
                    }
                }

                dics.Add("Select", selectReports);
                dics.Add("UnSelect", unSelectReports);
                return dics;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public void BatchUpdataReports(string AuditPaperId, List<AuditPaperAndReportEntity> apares)
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
                        string deleteSql = "DELETE FROM CT_PAPER_AUDITPAPERANDREPORT WHERE AUDITPAPERANDREPORT_AUDITPAPERID='" + AuditPaperId + "'";
                        command.CommandType = CommandType.Text;
                        command.CommandText = deleteSql;
                        command.Transaction = tr;
                        command.ExecuteNonQuery();

                        if (apares.Count > 0)
                        {

                            string sql = BeanUtil.ConvertBeanToInsertCommandSql<AuditPaperAndReportEntity>();
                            foreach (AuditPaperAndReportEntity ap in apares)
                            {
                                if (StringUtil.IsNullOrEmpty(ap.Id))
                                {
                                    ap.Id = Guid.NewGuid().ToString();
                                }
                                string tempString = String.Format(sql, ap.Id, ap.AuditPaperId, ap.ReportId);
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

        public DataGrid<ReportFormatDicEntity> GetReportsByPaperId(DataGrid<ReportFormatDicEntity> dataGrid, string PaperCode,ReportFormatDicEntity rfde)
        {
            try
            {
                DataGrid<ReportFormatDicEntity> dg = new DataGrid<ReportFormatDicEntity>();
                string sql = "SELECT REPORTDICTIONARY_ID,REPORTDICTIONARY_CODE,REPORTDICTIONARY_NAME,REPORTDICTIONARY_CYCLE FROM CT_FORMAT_REPORTDICTIONARY D INNER JOIN CT_PAPER_AUDITPAPERANDREPORT ON D.REPORTDICTIONARY_ID=AUDITPAPERANDREPORT_REPORTID " +
" INNER JOIN CT_PAPER_AUDITPAPER ON AUDITPAPERANDREPORT_AUDITPAPERID=AUDITPAPER_ID ";
                if (!StringUtil.IsNullOrEmpty(PaperCode))
                {
                    sql+=" WHERE AUDITPAPER_CODE= '" + PaperCode + "' ";
                }
              
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<ReportFormatDicEntity>();
                string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<ReportFormatDicEntity>(rfde);
                if (whereSql != "")
                {
                    whereSql = " and " + whereSql;
                }
                sql +=whereSql;

                string sortName = maps[dataGrid.sort];
                List<ReportFormatDicEntity> lists = dbManager.ExecuteSqlReturnTType<ReportFormatDicEntity>(sql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
                sql = "SELECT COUNT(*) FROM CT_FORMAT_REPORTDICTIONARY D INNER JOIN CT_PAPER_AUDITPAPERANDREPORT ON D.REPORTDICTIONARY_ID=AUDITPAPERANDREPORT_REPORTID " +
                    " INNER JOIN CT_PAPER_AUDITPAPER ON AUDITPAPERANDREPORT_AUDITPAPERID=AUDITPAPER_ID ";
                if (!StringUtil.IsNullOrEmpty(PaperCode))
                {
                    sql += "WHERE AUDITPAPER_CODE='" + PaperCode + "'";
                }
                sql += whereSql;
                int count = dbManager.Count(sql);
                dg.rows = lists;
                dg.total = count;
                return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public DataGrid<ReportFormatDicEntity> GetReportsByPaperId2(DataGrid<ReportFormatDicEntity> dataGrid, string PaperId, ReportFormatDicEntity rfde)
        {
            try
            {
                DataGrid<ReportFormatDicEntity> dg = new DataGrid<ReportFormatDicEntity>();
                string sql = "SELECT REPORTDICTIONARY_ID,REPORTDICTIONARY_CODE,REPORTDICTIONARY_NAME,REPORTDICTIONARY_CYCLE FROM CT_FORMAT_REPORTDICTIONARY D INNER JOIN CT_PAPER_AUDITPAPERANDREPORT ON D.REPORTDICTIONARY_ID=AUDITPAPERANDREPORT_REPORTID ";


                if (!StringUtil.IsNullOrEmpty(PaperId))
                {
                    sql += " WHERE AUDITPAPERANDREPORT_AUDITPAPERID= '" + PaperId + "' ";
                }

                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<ReportFormatDicEntity>();
                string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<ReportFormatDicEntity>(rfde);
                if (whereSql != "")
                {
                    whereSql = " and " + whereSql;
                }
                sql += whereSql;

                string sortName = maps[dataGrid.sort];
                List<ReportFormatDicEntity> lists = dbManager.ExecuteSqlReturnTType<ReportFormatDicEntity>(sql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
                sql = "SELECT COUNT(*) FROM CT_FORMAT_REPORTDICTIONARY D INNER JOIN CT_PAPER_AUDITPAPERANDREPORT ON D.REPORTDICTIONARY_ID=AUDITPAPERANDREPORT_REPORTID ";
              
                if (!StringUtil.IsNullOrEmpty(PaperId))
                {
                    sql += "WHERE AUDITPAPERANDREPORT_AUDITPAPERID='" + PaperId + "'";
                }
                sql += whereSql;
                int count = dbManager.Count(sql);
                dg.rows = lists;
                dg.total = count;
                return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion







    }
}
