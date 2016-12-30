using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditSPI.ReportAggregation;
using DbManager;
using AuditEntity;
using CtTool.BB;
using AuditSPI.ReportData;
using CtTool;
using AuditService.ReportData;
using GlobalConst;
using System.Data;
using AuditEntity.ReportAggregation;
using System.Data.Common;
using AuditSPI;
using AuditEntity.ReportAudit;
using AuditSPI.ReportAudit;
using AuditService;
using AuditService.ReportAudit;



namespace AuditService.ReportAggregation
{
    /// <summary>
    /// 报表汇总
    /// </summary>
   public   class ReportAggregationService:IReportAggregation
    {
       CTDbManager dbManager;
       IFillReport fillReportService;
       LinqDataManager linqDataManager;
       IReportCycle reportCyle;
       ReportAuditCellIndexData reportCellIndexDataService;
       ReportFormatService reportFormatService;
       CompanyService companyService;
      
       public ReportAggregationService()
       {
           if (dbManager == null)
           {
               dbManager = new CTDbManager();
               linqDataManager = new LinqDataManager();
           }
           if (fillReportService == null)
           {
               fillReportService = new FillReportService();
           }
           if (reportCyle == null)
           {
               reportCyle = new ReportCycleService();
           }
           if (reportCellIndexDataService == null)
           {
               reportCellIndexDataService = new ReportAuditCellIndexData();
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

       /// <summary>
       /// 报表汇总
       /// 1、获取报表数据单元格；
       /// 2、汇总固定区数据；
       ///     固定区中的数值数据进行汇总；
       ///     固定区中的字符数据不进行汇总；
       /// 3、汇总变动区数据；
       ///     变动区中的数值数据进行汇总；
       ///     汇总的依据是
       /// 4、保存报表数据；      
       /// 5、循环上面的1-5步骤
       /// 7、保存报表汇总记录
       /// </summary>
       /// <param name="ras">报表汇总基本参数</param>
        public void ReportAggregation(ReportAggregationStruct ras)
        {
            try
            {
                foreach (string ri in ras.ReportItems)
                {
                    //获取报表数据单元格信息
                    string sql = "SELECT * FROM CT_FORMAT_DATAITEM WHERE DATAITEM_REPORTID='" + ri + "'";
                    List<DataItemEntity> items = dbManager.ExecuteSqlReturnTType<DataItemEntity>(sql);
                    Dictionary<string, List<DataItemEntity>> tableItems = new Dictionary<string, List<DataItemEntity>>();
                    foreach (DataItemEntity die in items)
                    {
                        if(StringUtil.IsNullOrEmpty(die.Code))continue;
                        if (tableItems.ContainsKey(die.TableName))
                        {
                            tableItems[die.TableName].Add(die);
                        }
                        else
                        {
                            List<DataItemEntity> listItems = new List<DataItemEntity>();
                            listItems.Add(die);
                            tableItems.Add(die.TableName, listItems);
                        }
                    }
                    ReportDataStruct rds = new ReportDataStruct();
                    rds.rdps.TaskId = ras.TaskId;
                    rds.rdps.PaperId = ras.PaperId;
                    rds.rdps.ReportId = ri;
                    rds.rdps.Year =ras.Year;
                    rds.rdps.Cycle = ras.Cycle;
                    //汇总的单位采用汇总模板的ID
                    rds.rdps.CompanyId = SessoinUtil.GetCurrentCompanyId();

                    //汇总数据
                    foreach (string tableName in tableItems.Keys)
                    {
                        string dataType = FormatTool.GetDataItemType(tableName);
                        if (dataType == "GD")
                        {
                            //固定区报表数据汇总
                            AggregationFixRegionDatas(rds, tableItems[tableName], tableName, ras, ri);
                        }
                        else if (dataType == "BD")
                        {
                            //变动区报表数据汇总
                            AggregationChangeRegionDatas(rds, tableItems[tableName], tableName, ras, ri);
                        }
                    }

                    //保存报表数据
                    fillReportService.SaveReportDatas(rds);                    
                    
                }
                //保存报表汇总的记录
                SaveReportAggregationLog(ras);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }



        #region 报表汇总辅助方法
       /// <summary>
       /// 报表汇总日志
       /// </summary>
       /// <param name="ras"></param>
        private void SaveReportAggregationLog(ReportAggregationStruct ras)
        {
            try
            {
                StringBuilder deleteSql = new StringBuilder();
                deleteSql.Append("DELETE FROM CT_AGGREGATE_LOG ");
                deleteSql.Append(" WHERE ");
                deleteSql.Append("LOG_YEAR='" + ras.Year + "'");
                deleteSql.Append(" AND ");
                deleteSql.Append("LOG_CYCLE='" + ras.Cycle + "'");
                deleteSql.Append(" AND ");
                deleteSql.Append("LOG_CompanyId='" + SessoinUtil.GetCurrentCompanyId() + "'");
                deleteSql.Append(" AND ");
                deleteSql.Append(" LOG_TEMPLATEID='" + ras.templateId + "' ");
                dbManager.ExecuteSql(deleteSql.ToString());

              

                StringBuilder sqlSb = new StringBuilder();
                sqlSb.Append("SELECT * FROM CT_AGGREGATE_LOG ");
                sqlSb.Append(" WHERE ");
                sqlSb.Append("LOG_YEAR='"+ras.Year+"'");
                sqlSb.Append(" AND ");
                sqlSb.Append("LOG_CYCLE='"+ras.Cycle+"'");
                sqlSb.Append(" AND ");
                sqlSb.Append("LOG_CompanyId='" + SessoinUtil.GetCurrentCompanyId() + "'");
                sqlSb.Append(" AND ");
                sqlSb.Append(" LOG_TEMPLATEID='"+ras.templateId+"' ");
                List<AggregationLogEntity> logs = dbManager.ExecuteSqlReturnTType<AggregationLogEntity>(sqlSb.ToString());

                AggregationLogEntity ale = new AggregationLogEntity();
                ale.Year = ras.Year;
                ale.CompanyId = SessoinUtil.GetCurrentCompanyId();
                ale.Cycle = ras.Cycle;
                ale.TemplateId = ras.templateId;
                ale.TaskId = ras.TaskId;
                ale.Paper = ras.PaperId;
                ale.ReportType = ras.ReportType;

                if (logs.Count > 0)
                {
                    ale.Id = logs[0].Id;
                    
                }                               
                SaveAggregationLog(ale);
              
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 固定区数据汇总
       /// </summary>
       /// <param name="rds"></param>
       /// <param name="Items"></param>
       /// <param name="tableName"></param>
       /// <param name="ras"></param>
       /// <param name="ri"></param>
        private void AggregationFixRegionDatas(ReportDataStruct rds, List<DataItemEntity> Items, string tableName, ReportAggregationStruct ras, string reportId)
        {
            try
            {
                StringBuilder gdsql = new StringBuilder();      
                rds.GdbTableName=tableName;
                string id = fillReportService.ExistReportFormat(rds.rdps,tableName);
                if (id != null)
                {
                    rds.GdbId = id;
                }
                foreach (DataItemEntity die in Items)
                {
                    if (die.CellDataType == ReportGlobalConst.DATATYPE_NUMBER)
                    {
                        if (die.CellAggregation != "0")
                        {
                            gdsql.Append(GetAggregationType(die.CellAggregationType));
                            gdsql.Append("([");
                            gdsql.Append(die.Code);
                            gdsql.Append("])  AS [" + die.Code + "],");
                            ItemDataValueStruct idvs = new ItemDataValueStruct();
                            idvs.value = die.Value;
                            idvs.cellDataType = die.CellDataType;
                            idvs.isOrNotUpdate = "1";
                            rds.Gdq.Add(die.Code, idvs);
                        }
                    }
                }
                if (gdsql.Length > 0)
                {
                    gdsql.Length--;
                    string whereSql=CreateWhereSql(ras,reportId);


                    string sql = "SELECT " + gdsql.ToString() + " FROM " + tableName + whereSql;
                    DataTable dt = dbManager.ExecuteSqlReturnDataTable(sql);
                    foreach (DataRow dr in dt.Rows)
                    {
                        foreach (DataColumn dc in dt.Columns)
                        {
                            rds.Gdq[dc.ColumnName].value = dr[dc.ColumnName];
                        }
                    }
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public string GetAggregationType(string type)
        {
            string at = "";
            switch(type){
                case "01":
                    at = "SUM";
                    break;
                case"02":
                    at = "AVG";
                    break;
                case "03":
                    at = "MAX";
                    break;
                case "04":
                    at = "MIN";
                    break;
                default:
                    at = "SUM";
                        break;
            }
            return at;
        }
       /// <summary>
       /// 变动区数据汇总
       /// </summary>
       /// <param name="rds"></param>
       /// <param name="Items"></param>
       /// <param name="tableName"></param>
       /// <param name="ras"></param>
       /// <param name="ri"></param>
        private void AggregationChangeRegionDatas(ReportDataStruct rds, List<DataItemEntity> Items, string tableName, ReportAggregationStruct ras, string reportId)
        {
            try
            {
              
                string bdCode = FormatTool.GetBdReportCode(tableName);
                rds.bdMaps.Add(bdCode, rds.bdMaps.Count);
                rds.bdIndexMaps.Add((rds.bdIndexMaps.Count).ToString(), bdCode);                              
                rds.bdTableNames.Add(bdCode, tableName);
                List<Dictionary<string, ItemDataValueStruct>> BdqItems = new List<Dictionary<string, ItemDataValueStruct>>();
                rds.BdqData.Add(BdqItems);
                //汇总字段
                StringBuilder bdSql = new StringBuilder();
                StringBuilder groupBySql = new StringBuilder();
                StringBuilder orderBy = new StringBuilder();

                Dictionary<string ,DataItemEntity> bdItems=new Dictionary<string,DataItemEntity>();


                //获取标识变动列
                string sql = "SELECT * FROM CT_FORMAT_DATAITEM WHERE DATAITEM_TABLENAME='" + tableName + "' AND DATAITEM_PRIMARY='1'";
                List<DataItemEntity> primaries = dbManager.ExecuteSqlReturnTType<DataItemEntity>(sql);
                if (primaries.Count > 0)
                {
                    foreach (DataItemEntity p in primaries)
                    {
                        groupBySql.Append("[" + p.Code + "]");
                        groupBySql.Append(",");
                        bdSql.Append("([");
                        bdSql.Append(p.Code);
                        bdSql.Append("])  AS [" + p.Code + "],");
                        bdItems.Add(p.Code, p);
                    }

                }

                foreach (DataItemEntity die in Items)
                {
                    if (die.CellAggregation != "0")
                    {
                        if (die.CellDataType == ReportGlobalConst.DATATYPE_NUMBER)
                        {
                            bdSql.Append(GetAggregationType(die.CellAggregationType));
                            bdSql.Append("([");
                            bdSql.Append(die.Code);
                            bdSql.Append("])  AS [" + die.Code + "],");
                        }
                        else if (die.CellDataType == ReportGlobalConst.DATATYPE_TEXT && die.CellPrimary != "1")
                        {
                            groupBySql.Append("[" + die.Code + "]");
                            groupBySql.Append(",");
                            bdSql.Append("([");
                            bdSql.Append(die.Code);
                            bdSql.Append("])  AS [" + die.Code + "],");
                        }
                        else
                        {
                            continue;
                        }
                        if (bdItems.ContainsKey(die.Code) == false)
                            bdItems.Add(die.Code, die);
                    }
                   
                   
                }
                //获取排序字段
                string sorts = reportFormatService.GetBdqSortCode(tableName);
                if (!StringUtil.IsNullOrEmpty(sorts))
                {
                    string[] arrOrder = sorts.Split(',');
                    orderBy.Append(" ORDER BY ");
                    foreach (string o in arrOrder)
                    {
                        orderBy.Append(" ");
                        orderBy.Append(o);
                        orderBy.Append(",");
                    }
                    orderBy.Length--;

                }
               

                if (bdSql.Length > 0)
                {
                    bdSql.Length--;
                    if (groupBySql.Length > 0) groupBySql.Length--;
                    string whereSql=CreateWhereSql(ras,reportId);

                     sql = "SELECT "+bdSql.ToString()+" FROM "+tableName+whereSql;
                    if (groupBySql.ToString() != "")
                    {
                        sql += " GROUP BY " + groupBySql.ToString();
                    }
                    if (orderBy.ToString() != "")
                    {
                        sql += orderBy.ToString();
                    }
                    DataTable dt = dbManager.ExecuteSqlReturnDataTable(sql);
                    foreach (DataRow dr in dt.Rows)
                    {
                        Dictionary<string, ItemDataValueStruct> row = new Dictionary<string, ItemDataValueStruct>();
                        foreach (DataColumn dc in dt.Columns)
                        {
                            ItemDataValueStruct idvs = new ItemDataValueStruct();
                            idvs.cellDataType = bdItems[dc.ColumnName].CellDataType;
                            idvs.value = dr[dc.ColumnName];
                            idvs.isOrNotUpdate = "1";
                            row.Add(dc.ColumnName, idvs);

                        }
                        BdqItems.Add(row);
                        row.Add("DATA_ID", new ItemDataValueStruct());
                    }
                   
                }
                string  delesql = "DELETE FROM " + tableName + " WHERE DATA_TASKID='" + rds.rdps.TaskId + "' AND DATA_MANUSCRIPT='" + rds.rdps.PaperId + "' AND DATA_COMPANYID='" + rds.rdps.CompanyId + "' AND DATA_REPORTID='" + rds.rdps.ReportId + "' AND DATA_YEAR='" + rds.rdps.Year + "' AND DATA_CYCLE='" + rds.rdps.Cycle + "'";
                dbManager.ExecuteSql(delesql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private string CreateWhereSql(ReportAggregationStruct ras, string reportId)
        {
            try
            {
                StringBuilder whereSql = new StringBuilder();
                whereSql.Append(" WHERE 1=1 ");
                whereSql.Append(" AND DATA_TASKID='");
                whereSql.Append(ras.TaskId);
                whereSql.Append("'");
                whereSql.Append(" AND DATA_MANUSCRIPT='");
                whereSql.Append(ras.PaperId);
                whereSql.Append("'");
                whereSql.Append(" AND DATA_REPORTID='");
                whereSql.Append(reportId);
                whereSql.Append("'");
                whereSql.Append(" AND DATA_YEAR='");
                whereSql.Append(ras.Year);
                whereSql.Append("'");
                whereSql.Append(" AND DATA_CYCLE='");
                whereSql.Append(ras.Cycle);
                whereSql.Append("'");
                if (ras.Companies.Count > 0)
                {
                    whereSql.Append(" AND DATA_COMPANYID IN (");

                    foreach (string companyid in ras.Companies)
                    {
                        whereSql.Append("'");
                        whereSql.Append(companyid);
                        whereSql.Append("',");
                    }
                    whereSql.Length--;
                    whereSql.Append("),");

                }
                whereSql.Length--;
                return whereSql.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion

        #region 报表汇总分类
       /// <summary>
       /// 保存报表汇总记录
       /// </summary>
       /// <param name="ale"></param>
        public void SaveAggregationLog(AuditEntity.ReportAggregation.AggregationLogEntity ale)
        {
            try
            {
                string sql = "";                
                if (StringUtil.IsNullOrEmpty(ale.Id))
                {
                    ale.Id = Guid.NewGuid().ToString();
                    ale.Creater = SessoinUtil.GetCurrentUser().Id;
                    ale.CreateTime = SessoinUtil.GetCurrentDateTime();
                    List<DbParameter> parameters = new List<DbParameter>();
                    sql = dbManager.ConvertBeanToInsertCommandSql<AggregationLogEntity>(ale, parameters);
                    dbManager.ExecuteSql(sql, parameters);
                }
                else
                {
                    string whereSql=" WHERE LOG_ID='"+ale.Id+"'";
                    sql = "UPDATE CT_AGGREGATE_LOG SET LOG_TEMPLATEID='" + ale.TemplateId + "'" + whereSql;
                    dbManager.ExecuteSql(sql);
                }  
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #region 汇总模板相关的方法
        /// <summary>
       /// 保存汇总模板
       /// </summary>
       /// <param name="ate"></param>
        public void SaveAggregationTemplate(AuditEntity.ReportAggregation.AggregationTemplateEntity ate)
        {
            try
            {
                if (StringUtil.IsNullOrEmpty(ate.Id))
                {
                    ate.Id = Guid.NewGuid().ToString();
                    ate.Creater = SessoinUtil.GetCurrentUser().Id;
                    ate.CreateTime = SessoinUtil.GetCurrentDateTime();
                  
                }
                     List<DbParameter> parameters = new List<DbParameter>();
                    string sql = dbManager.ConvertBeanToInsertCommandSql<AggregationTemplateEntity>(ate, parameters);
                    dbManager.ExecuteSql(sql, parameters);
                
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 更新报表汇总模板
       /// </summary>
       /// <param name="ate"></param>
        public void UpdateAggregationTemplate(AuditEntity.ReportAggregation.AggregationTemplateEntity ate)
        {
            try
            {
                string whereSql = " WHERE TEMPLATE_ID='"+ate.Id+"'";
                List<DbParameter> parameters = new List<DbParameter>();
                List<string> excludes=new List<string>();
                excludes.Add("Id");
                excludes.Add("Creater");
                excludes.Add("CreateTime");
                string sql = dbManager.ConvertBeanToUpdateSql<AggregationTemplateEntity>(ate, whereSql, parameters, excludes);
                dbManager.ExecuteSql(sql, parameters);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 删除报表汇总模板
       /// </summary>
       /// <param name="ate"></param>
        public void DeleteAggregationTemplate(AuditEntity.ReportAggregation.AggregationTemplateEntity ate)
        {
            try
            {
                string sql="";
                DbParameter parameter = dbManager.GetDbParameter();
                sql = dbManager.ConvertBeanToDeleteCommandSql<AggregationTemplateEntity>(ate, "Id", parameter);
                List<DbParameter>parameters=new List<DbParameter>();
                parameters.Add(parameter);
                dbManager.ExecuteSql(sql, parameters);

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 获取汇总模板列表
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="ate"></param>
        /// <returns></returns>
        public AuditSPI.DataGrid<AggregationTemplateEntity> GetAggregationTemplates(AuditSPI.DataGrid<AggregationTemplateEntity> dataGrid, AggregationTemplateEntity ate)
        {
            try
            {
                DataGrid<AggregationTemplateEntity> dg = new DataGrid<AggregationTemplateEntity>();
                string csql = "SELECT * FROM CT_AGGREGATE_TEMPLATE";
                string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<AggregationTemplateEntity>(ate);
                if (!StringUtil.IsNullOrEmpty(whereSql))
                {
                    whereSql = " WHERE 1=1 AND " + whereSql;
                }
                else
                {
                    whereSql = "";
                }
                csql += whereSql;
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<AggregationTemplateEntity>();
                string countSql = "SELECT COUNT(*) FROM CT_AGGREGATE_TEMPLATE";
                countSql += whereSql;
                string sortName = maps[dataGrid.sort];
                dg.rows = dbManager.ExecuteSqlReturnTType<AggregationTemplateEntity>(csql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
                dg.total = dbManager.Count(countSql);
                return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion
        #region 报表汇总分类相关方法
        /// <summary>
       /// 保存报表汇总模板
       /// </summary>
       /// <param name="ace"></param>
        public void SaveAggregationTemplateClassify(AuditEntity.ReportAggregation.AggregationClassifyEntity ace)
        {
            try
            {
                if (StringUtil.IsNullOrEmpty(ace.Id))
                {
                    ace.Id = Guid.NewGuid().ToString();
                    ace.Creater = SessoinUtil.GetCurrentUser().Id;
                    ace.CreateTime = SessoinUtil.GetCurrentDateTime();
                }
                List<DbParameter> parameters = new List<DbParameter>();
                string sql = dbManager.ConvertBeanToInsertCommandSql<AggregationClassifyEntity>(ace, parameters);
                dbManager.ExecuteSql(sql, parameters);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 更新报表汇总模板
       /// </summary>
       /// <param name="ace"></param>
        public void UpdateAggregationTemplateClassify(AuditEntity.ReportAggregation.AggregationClassifyEntity ace)
        {
            try
            {
                string whereSql = " WHERE TEMPLATECLASSIFY_ID='" + ace.Id + "'";
                List<DbParameter> parameters = new List<DbParameter>();
                List<string> excludes = new List<string>();
                excludes.Add("Id");
                excludes.Add("Creater");
                excludes.Add("CreateTime");
                string sql = dbManager.ConvertBeanToUpdateSql<AggregationClassifyEntity>(ace, whereSql, parameters, excludes);
                dbManager.ExecuteSql(sql, parameters);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 删除报表汇总模板
       /// </summary>
       /// <param name="ace"></param>
        public void DeleteAggregationTemplateClassify(AuditEntity.ReportAggregation.AggregationClassifyEntity ace)
        {
            try
            {
                string sql = "";
                DbParameter parameter = dbManager.GetDbParameter();
                sql = dbManager.ConvertBeanToDeleteCommandSql<AggregationClassifyEntity>(ace, "Id", parameter);
                List<DbParameter> parameters = new List<DbParameter>();
                parameters.Add(parameter);
                dbManager.ExecuteSql(sql, parameters);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

       /// <summary>
       /// 获取报表汇总分类列表
       /// </summary>
       /// <param name="ace"></param>
       /// <returns></returns>
        public List<AggregationClassifyEntity> GetAggregationClassifys(AggregationClassifyEntity ace)
        {
            try
            {
                string whereSql = BeanUtil.ConvertObjectToWhereSqls<AggregationClassifyEntity>(ace);
                string sql = "SELECT * FROM CT_AGGREGATE_TEMPLATECLASSIFY ";
                if (whereSql.Length > 0)
                {
                    sql += whereSql;
                }
                sql += " ORDER BY TEMPLATECLASSIFY_CODE";
                List<AggregationClassifyEntity> cLists = dbManager.ExecuteSqlReturnTType<AggregationClassifyEntity>(sql);
                return cLists;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion
      
        #endregion




       /// <summary>
       /// 获取上次的汇总模板
       /// </summary>
       /// <returns></returns>
        public AggregationTemplateEntity GetPreAggregationLogEntity()
        {
            try
            {
                string companyId = SessoinUtil.GetCurrentCompanyId();
                string sql = "SELECT TOP 1 * FROM CT_AGGREGATE_LOG WHERE LOG_COMPANYID='"+companyId+"' ORDER BY LOG_CREATETIME DESC";
                List<AggregationLogEntity> logs = dbManager.ExecuteSqlReturnTType<AggregationLogEntity>(sql);
                
                if(logs.Count>0){
                    sql = "SELECT * FROM CT_AGGREGATE_TEMPLATE WHERE TEMPLATE_ID='"+logs[0].TemplateId+"'";
                   List<AggregationTemplateEntity> ates = dbManager.ExecuteSqlReturnTType<AggregationTemplateEntity>(sql);

                   if (!StringUtil.IsNullOrEmpty(ates[0].ClassifyId))
                   {
                       AggregationClassifyEntity ace = linqDataManager.GetEntity<AggregationClassifyEntity>(r => r.Id == ates[0].ClassifyId);
                       ates[0].TemplateName = ace.Name;
                   }
                  
                    return ates[0];
                }else{
                    return null;
                }
               
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }



       /// <summary>
       /// 获取报表汇总日志列表
       /// </summary>
       /// <param name="dataGrid"></param>
       /// <param name="ale"></param>
       /// <returns></returns>
        public DataGrid<AggregationLogEntity> GetAggregationLogEnties(DataGrid<AggregationLogEntity> dataGrid, AggregationLogEntity ale)
        {
            try
            {
                DataGrid<AggregationLogEntity> dg = new DataGrid<AggregationLogEntity>();
                string csql = "SELECT * FROM CT_AGGREGATE_LOG"+ " INNER JOIN  LSBZDW ON LOG_COMPANYID=LSBZDW_ID " +
 " INNER JOIN CT_AGGREGATE_TEMPLATE ON LOG_TEMPLATEID=TEMPLATE_ID WHERE "+companyService.GetNormalAuthorityCompaniesSql();
                string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<AggregationLogEntity>(ale);
                if (!StringUtil.IsNullOrEmpty(whereSql))
                {
                    whereSql = "  AND " + whereSql;
                }
                else
                {
                    whereSql = "";
                }
                csql += whereSql;
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<AggregationLogEntity>();
                maps.Add("CompanyName", "LSBZDW_DWMC");
                maps.Add("TemplateName", "TEMPLATE_NAME");
                maps.Add("TemplateCode", "TEMPLATE_CODE");
                string countSql = "SELECT COUNT(*) FROM CT_AGGREGATE_LOG" + " INNER JOIN  LSBZDW ON LOG_COMPANYID=LSBZDW_ID " +
 " INNER JOIN CT_AGGREGATE_TEMPLATE ON LOG_TEMPLATEID=TEMPLATE_ID WHERE " + companyService.GetNormalAuthorityCompaniesSql(); 
                countSql += whereSql;
                string sortName = maps[dataGrid.sort];
                dg.rows = dbManager.ExecuteSqlReturnTType<AggregationLogEntity>(csql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
                dg.total = dbManager.Count(countSql);
                
                return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public AggregationTemplateEntity GetAggregationTemplate(AggregationTemplateEntity ate)
        {
            try
            {
                string sql = "SELECT * FROM CT_AGGREGATE_TEMPLATE WHERE 1=1 ";
                string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<AggregationTemplateEntity>(ate);
                if (whereSql.Length > 0)
                {
                    sql += " AND " + whereSql;
                }
                List<AggregationTemplateEntity> lists = dbManager.ExecuteSqlReturnTType<AggregationTemplateEntity>(sql);
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

       /// <summary>
       /// 获取汇总报表单元格的历史趋势
       /// </summary>
       /// <param name="reportAuditCellConclusion"></param>
       /// <returns></returns>
        public AuditSPI.ReportAudit.ChartDataStruct GetReportCellDataTrend(AuditEntity.ReportAudit.ReportAuditCellConclusion reportAuditCellConclusion)
        {
            try
            {
                IndexTrendStruct its = new IndexTrendStruct();
                if (StringUtil.IsNullOrEmpty(reportAuditCellConclusion.ReportType)) throw new Exception("报表周期不能为空");
                its.DurationType = reportCyle.GetAgggregationReportTrendType(reportAuditCellConclusion.ReportType);
                ChartDataStruct cds = reportCellIndexDataService.GetIndexTrend(reportAuditCellConclusion, its);
                return cds;
               
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }



       /// <summary>
       /// 获取汇总单元格的报表构成
       /// </summary>
       /// <param name="reportAuditCellConclusion"></param>
       /// <param name="companies"></param>
       /// <returns></returns>
        public List<CompanyItemStruct> GetAggregationReportCellConstitute(ReportAuditCellConclusion reportAuditCellConclusion, List<CompanyItemStruct> companies)
        {
            try
            {
                return fillReportService.GetAggregationReportCellConstituteData(reportAuditCellConclusion, companies);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
