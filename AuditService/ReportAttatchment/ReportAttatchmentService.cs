using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;


using AuditEntity.ReportAttatch;
using AuditSPI.ReportAttatchment;
using AuditSPI;
using AuditService;
using DbManager;
using CtTool;
using AuditEntity;
using GlobalConst;
using AuditSPI.ReportData;

using ICSharpCode.SharpZipLib.Core;
using ICSharpCode.SharpZipLib.Zip;




namespace AuditService.ReportAttatchment
{

    public class ReportAttatchmentService : IReportAttatchment
    {

        ILinqDataManager linqDbManager;
        CTDbManager dbManager;
        ReportFormatService reportFormatService;
        CompanyService companyService;
        public ReportAttatchmentService()
        {
            if (linqDbManager == null)
            {
                linqDbManager = new LinqDataManager();
            }
            if (dbManager == null)
            {
                dbManager = new CTDbManager();
            }
            if (reportFormatService == null)
            {
                reportFormatService = new ReportFormatService();
            }
            if (companyService == null)
            {
                companyService = new CompanyService();
            }
        }
        public void AddReportAttatchment(ReportAttatchEntity rae)
        {
            try
            {
                if (StringUtil.IsNullOrEmpty(rae.Id))
                {
                    rae.Id = Guid.NewGuid().ToString();
                }
                rae.Creater = SessoinUtil.GetCurrentUser().Id;
                rae.CreateTime = SessoinUtil.GetCurrentDateTime();
                linqDbManager.InsertEntity<ReportAttatchEntity>(rae);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void DeleteReportAttatchment(ReportAttatchEntity rae)
        {
            try
            {
                // string sql = "delete from [CT_DATA_ATTACHMENT] WHERE ATTACHMENT_ID='" + rae.Id + "'";
                string sql = "update [CT_DATA_ATTACHMENT] set ATTACHMENT_DEL='1'  WHERE ATTACHMENT_ID='" + rae.Id + "'";
                dbManager.ExecuteSql(sql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public ReportAttatchEntity Get(ReportAttatchEntity rae)
        {
            try
            {
                string sql = "SELECT * FROM [CT_DATA_ATTACHMENT] WHERE ATTACHMENT_ID='" + rae.Id + "'";
                List<ReportAttatchEntity> lists = dbManager.ExecuteSqlReturnTType<ReportAttatchEntity>(sql);
                if (lists.Count > 0)
                {
                    return lists[0];
                }
                else
                {
                    return null;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public List<ReportAttatchEntity> GetReportAttatchments(ReportAttatchEntity rae, string pzt)
        {
            try
            {
                Dictionary<string, string> excludes = new Dictionary<string, string>();
                excludes.Add("AttatchNum", "AttatchNum");
                string wherSql = BeanUtil.ConvertObjectToWhereSqls<ReportAttatchEntity>(rae, excludes);
                if (rae.DataItem == null || rae.DataItem == "")
                {
                    wherSql += " and  ISNULL(ATTACHMENT_DATAITEM,'')=''  ";
                }
                if (rae.COLPK == null || rae.COLPK == "")
                {
                    wherSql += " and  ISNULL(ATTACHMENT_COLPK,'')=''  ";
                }

                string sql = "SELECT * FROM CT_DATA_ATTACHMENT WHERE 1=1  AND ATTACHMENT_DEL='" + pzt + "' " + wherSql + " ORDER BY ATTACHMENT_TIME DESC";
                return dbManager.ExecuteSqlReturnTType<ReportAttatchEntity>(sql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public List<ReportAttatchEntity> GetReportAttatchments(string ids)
        {
            try
            {
                string sql = "SELECT * FROM CT_DATA_ATTACHMENT WHERE ATTACHMENT_ID in (" + CreateIdsSql(ids) + ")  ORDER BY ATTACHMENT_TIME DESC";
                return dbManager.ExecuteSqlReturnTType<ReportAttatchEntity>(sql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public void DeleteReportAttatchments(string ids)
        {
            try
            {

                //  string sql = "delete from [CT_DATA_ATTACHMENT] WHERE ATTACHMENT_ID in (" + CreateIdsSql(ids) + ")";
                string sql = " update [CT_DATA_ATTACHMENT] set ATTACHMENT_DEL='1'  WHERE ATTACHMENT_ID in (" + CreateIdsSql(ids) + ")";
                dbManager.ExecuteSql(sql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private string CreateIdsSql(string ids)
        {
            try
            {
                string[] idArr = ids.Split(',');
                StringBuilder sb = new StringBuilder();
                foreach (string id in idArr)
                {
                    sb.Append("'");
                    sb.Append(id);
                    sb.Append("'");
                    sb.Append(",");
                }
                sb.Length--;
                return sb.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 获取报表的状态
        /// </summary>
        /// <param name="reports"></param>
        public void GetReportAttatchments(List<AuditEntity.ReportFormatDicEntity> reports, ReportDataParameterStruct rdps)
        {
            try
            {

                string whereSql = BeanUtil.ConvertListObjectsToInSql<ReportFormatDicEntity>(reports, "ATTACHMENT_REPORTID");
                if (reports.Count == 0) whereSql = " 1=1 ";
                if (ReportGlobalConst.IsOrNotRelationTaskAndPaper)
                {
                    whereSql += " AND ATTACHMENT_TASKID='" + rdps.TaskId + "'";
                    whereSql += " AND ATTACHMENT_PAPERID='" + rdps.PaperId + "'";
                }
                whereSql += " AND ATTACHMENT_ND='" + rdps.Year + "'";
                whereSql += " AND ATTACHMENT_ZQ='" + rdps.Cycle + "'";
                whereSql += " AND ATTACHMENT_COMPANYID='" + rdps.CompanyId + "'";
                string sql = "SELECT COUNT(*) AS ATTATCHNUM,ATTACHMENT_REPORTID FROM CT_DATA_ATTACHMENT WHERE  " + whereSql + " GROUP BY ATTACHMENT_REPORTID";
                Dictionary<string, string> maps = new Dictionary<string, string>();
                maps.Add("AttatchNum", "ATTATCHNUM");
                maps.Add("ReportId", "ATTACHMENT_REPORTID");
                List<ReportAttatchEntity> attatches = dbManager.ExecuteSqlReturnTType<ReportAttatchEntity>(sql, maps);
                foreach (ReportAttatchEntity a in attatches)
                {
                    foreach (ReportFormatDicEntity rfde in reports)
                    {
                        if (rfde.Id == a.ReportId)
                        {
                            rfde.Attatchments = "1";
                            break;
                        }
                    }
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 批量下载
        /// </summary>
        /// <param name="reportParameters"></param>
        public string BatchDownload(ReportDataParameterStruct reportParameters, string fileDirectory, string relativePath)
        {
            try
            {
                //创建文件夹
                if (Directory.Exists(fileDirectory))
                {
                    Directory.Delete(fileDirectory, true);
                    Directory.CreateDirectory(fileDirectory);
                }
                else
                {
                    Directory.CreateDirectory(fileDirectory);
                }
                string destinationPath = fileDirectory + @"\" + "zipDirectory";
                relativePath = relativePath + @"/" + "zipDirectory";
                fileDirectory += @"\" + DateUtil.GetDateShortString(DateTime.Now);


                //创建文件夹
                if (Directory.Exists(fileDirectory))
                {
                    Directory.Delete(fileDirectory, true);
                    Directory.CreateDirectory(fileDirectory);
                }
                else
                {
                    Directory.CreateDirectory(fileDirectory);
                }



                string[] reports = reportParameters.Reports.Split(',');
                string[] companies = reportParameters.Companies.Split(',');

                foreach (string report in reports)
                {
                    //获取报表参数
                    ReportFormatDicEntity reportFormat = reportFormatService.GetReportFormatById(report);



                    foreach (string company in companies)
                    {
                        CompanyEntity temp = new CompanyEntity();
                        temp.Id = company;
                        temp = companyService.get(temp);
                        string reportDirectory = fileDirectory + @"\" + reportFormat.bbName + "_" + temp.Name;
                        if (!Directory.Exists(reportDirectory))
                        {
                            Directory.CreateDirectory(reportDirectory);
                        }
                        //获取报表相关的附件

                        List<ReportAttatchEntity> reportAttatchEnties = dbManager.ExecuteSqlReturnTType<ReportAttatchEntity>(CreateReportAttatchSql(reportParameters, report, company));
                        if (reportAttatchEnties.Count > 0)
                        {
                            //拷贝数据
                            foreach (ReportAttatchEntity attatch in reportAttatchEnties)
                            {
                                if (File.Exists(attatch.Route))
                                {
                                    File.Copy(attatch.Route, reportDirectory + @"\" + attatch.Name, true);
                                }
                            }
                        }
                    }
                }
                if (Directory.Exists(destinationPath))
                {
                    Directory.Delete(destinationPath, true);
                    Directory.CreateDirectory(destinationPath);
                }
                else
                {
                    Directory.CreateDirectory(destinationPath);
                }
                string destinationFile = destinationPath + @"\" + DateUtil.GetDateShortString(DateTime.Now) + ".zip";
                FastZip fastZip = new FastZip();
                fastZip.CreateZip(destinationFile, fileDirectory, true, null);

                relativePath += @"/" + DateUtil.GetDateShortString(DateTime.Now) + ".zip";
                return relativePath;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private string CreateReportAttatchSql(ReportDataParameterStruct reportParameters, string reportId, string companyId)
        {
            try
            {
                StringBuilder sql = new StringBuilder();
                sql.Append("SELECT * FROM CT_DATA_ATTACHMENT WHERE 1=1 ");
                if (!StringUtil.IsNullOrEmpty(reportParameters.TaskId))
                {
                    sql.Append(" AND ATTACHMENT_TASKID='" + reportParameters.TaskId + "' ");
                }
                if (!StringUtil.IsNullOrEmpty(reportParameters.PaperId))
                {
                    sql.Append(" AND ATTACHMENT_PAPERID='" + reportParameters.PaperId + "' ");
                }
                if (!StringUtil.IsNullOrEmpty(reportId))
                {
                    sql.Append(" AND ATTACHMENT_REPORTID='" + reportId + "' ");
                }
                if (!StringUtil.IsNullOrEmpty(companyId))
                {
                    sql.Append(" AND ATTACHMENT_COMPANYID='" + companyId + "' ");
                }
                if (!StringUtil.IsNullOrEmpty(reportParameters.Year))
                {
                    sql.Append(" AND ATTACHMENT_ND='" + reportParameters.Year + "' ");
                }
                if (!StringUtil.IsNullOrEmpty(reportParameters.Cycle))
                {
                    sql.Append(" AND ATTACHMENT_ZQ='" + reportParameters.Cycle + "' ");
                }
                if (!StringUtil.IsNullOrEmpty(reportParameters.Pk))
                {
                    sql.Append(" AND ATTACHMENT_COLPK='" + reportParameters.Pk + "' ");
                }


                return sql.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
