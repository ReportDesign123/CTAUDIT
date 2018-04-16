using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.Common;
using System.Collections;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using AuditSPI.ReportData;
using AuditEntity.AuditPaper;
using AuditEntity;
using DbManager;
using CtTool.BB;
using CtTool;
using AuditService.Analysis.Formular;
using AuditEntity.ReportState;
using AuditSPI.ReportState;
using AuditService.ReportState;
using GlobalConst;
using AuditSPI;
using AuditService.ReportAudit;
using AuditEntity.ReportAudit;
using AuditService.ReportAttatchment;
using AuditSPI.ReportAudit;
using AuditSPI.ReportAggregation;

namespace AuditService.ReportData
{
    public class FillReportService : IFillReport
    {
        CTDbManager dbManager;
        IReportState reportStateService;
        ReportCycleService reportCycleService;
        ReportAuditService reportAuditService;
        CompanyService companyService;
        ReportAttatchmentService attatchmentService;
        ReportFormatService reportFormatService;
        LinqDataManager linqDbManager;
        ReportProcessManager reportProcessManager;
        string strCon = string.Empty;
        public FillReportService()
        {
            dbManager = new CTDbManager();
            if (reportStateService == null)
            {
                reportStateService = new ReportStateService();
            }
            if (reportCycleService == null)
            {
                reportCycleService = new ReportCycleService();
            }
            if (reportAuditService == null)
            {
                reportAuditService = new ReportAuditService();
            }
            if (companyService == null)
            {
                companyService = new CompanyService();
            }
            if (attatchmentService == null)
            {
                attatchmentService = new ReportAttatchmentService();
            }
            if (reportFormatService == null)
            {
                reportFormatService = new ReportFormatService();
            }
            if (linqDbManager == null)
            {
                linqDbManager = new LinqDataManager();
            }
            if (reportProcessManager == null)
            {
                reportProcessManager = new ReportProcessManager();
            }
        }

        #region 加载报表相关信息，如审计底稿、报表、单位等

        /// <summary>
        /// 报表填报首次加载时
        /// </summary>
        /// <param name="rdps"></param>
        /// <returns></returns>
        public ReportFirstLoadStruct GetReportFirstLoadStruct(ReportDataParameterStruct rdps, ReportFormatDicEntity rfde)
        {
            try
            {
                ReportFirstLoadStruct rfls = new ReportFirstLoadStruct();
                //获取报表周期
                ReportCycleStruct rcs = new ReportCycleStruct();
                rcs.CurrentNd = rdps.Year;
                rcs.CurrentZq = rdps.Cycle;
                rcs.ReportType = rdps.ReportType;
                rfls.reportCycle = reportCycleService.GetReportCycleData(rcs);

                //获取报表单位；
                rfls.companies = companyService.GetCompaniesByAuditPaperAndAuthority(rdps.PaperId);
                //设置当前审计底稿下的报表列表；
                rfls.reports = GetReportsByAuditPaper(rfde, rdps.PaperId);
                //获取报表的状态
                reportStateService.GetReportsState(rfls.reports, rdps);
                //获取报表的附件状态
                attatchmentService.GetReportAttatchments(rfls.reports, rdps);
                return rfls;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 报表批量运算时数据的获取
        /// </summary>
        /// <param name="rdps"></param>
        /// <param name="rfde"></param>
        /// <returns></returns>
        public ReportFirstLoadStruct GetReportBatchProcessStruct(ReportDataParameterStruct rdps, ReportFormatDicEntity rfde)
        {
            try
            {
                ReportFirstLoadStruct rfls = new ReportFirstLoadStruct();
                //获取报表单位
                rfls.companies = companyService.GetCompaniesByAuditPaperAndAuthority(rdps.PaperId);
                //获取批量报表
                rfls.reports = GetReportsByAuditPaper(rfde, rdps.PaperId);
                return rfls;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<ReportFormatDicEntity> GetReportWithStateAndAttatch(ReportDataParameterStruct rdps, ReportFormatDicEntity rfde)
        {
            try
            {
                List<ReportFormatDicEntity> reports = GetReportsByAuditPaper(rfde, rdps.PaperId);
                //获取报表的状态
                reportStateService.GetReportsState(reports, rdps);
                //获取报表的附件状态
                attatchmentService.GetReportAttatchments(reports, rdps);
                return reports;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 加载审计任务下的审计底稿列表；
        /// 用途：报表填报
        /// </summary>
        /// <param name="TaskId"></param>
        /// <returns></returns>
        public List<AuditEntity.AuditPaper.AuditPaperEntity> GetAuditPaperByAuditTask(string TaskId)
        {
            try
            {
                string sql = "SELECT AUDITPAPER_ID,AUDITPAPER_NAME,AUDITPAPER_ZQ FROM CT_PAPER_AUDITPAPER P " +
                " INNER JOIN CT_TASK_AUDITTASKANDAUDITPAPER R ON P.AUDITPAPER_ID=R.AUDITTASKANDAUDITPAPER_PAPERID AND R.AUDITTASKANDAUDITPAPER_TASKID='" + TaskId + "'";
                List<AuditPaperEntity> papers = dbManager.ExecuteSqlReturnTType<AuditPaperEntity>(sql);
                return papers;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 获取特定报表任务下的审计底稿列表；能够根据审计底稿进行检索
        /// 作用：报表汇总中审计底稿的选择
        /// </summary>
        /// <param name="TaskId"></param>
        /// <param name="ape"></param>
        /// <param name="datagrid"></param>
        /// <returns></returns>
        public AuditSPI.DataGrid<AuditPaperEntity> GetAuditPaperByAuditTask(string TaskId, AuditPaperEntity ape, AuditSPI.DataGrid<AuditPaperEntity> datagrid)
        {
            try
            {
                DataGrid<AuditPaperEntity> dg = new DataGrid<AuditPaperEntity>();
                string sql = "SELECT AUDITPAPER_ID,AUDITPAPER_NAME,AUDITPAPER_CODE,AUDITPAPER_ZQ FROM CT_PAPER_AUDITPAPER P " +
               " INNER JOIN CT_TASK_AUDITTASKANDAUDITPAPER R ON P.AUDITPAPER_ID=R.AUDITTASKANDAUDITPAPER_PAPERID AND R.AUDITTASKANDAUDITPAPER_TASKID='" + TaskId + "'"
               ;

                string countSql = "SELECT COUNT(*) FROM CT_PAPER_AUDITPAPER P " +
               " INNER JOIN CT_TASK_AUDITTASKANDAUDITPAPER R ON P.AUDITPAPER_ID=R.AUDITTASKANDAUDITPAPER_PAPERID AND R.AUDITTASKANDAUDITPAPER_TASKID='" + TaskId + "'"
               ;
                string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<AuditPaperEntity>(ape);
                if (whereSql.Length > 0)
                {
                    sql += " WHERE " + whereSql;
                    countSql += " WHERE " + whereSql;
                }
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<AuditPaperEntity>();
                string sortName = maps[datagrid.sort];
                dg.rows = dbManager.ExecuteSqlReturnTType<AuditPaperEntity>(sql, dg.page, dg.pageNumber, sortName + " " + dg.order, maps);
                dg.total = dbManager.Count(countSql);
                return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 加载审计底稿及其对应的报表；
        /// 用途：报表填报用
        /// </summary>
        /// <param name="AuditPapers"></param>
        /// <returns></returns>
        public Dictionary<string, List<AuditEntity.ReportFormatDicEntity>> GetReportsByAuditPapers(List<AuditEntity.AuditPaper.AuditPaperEntity> AuditPapers)
        {
            try
            {
                Dictionary<string, List<ReportFormatDicEntity>> dic = new Dictionary<string, List<ReportFormatDicEntity>>();
                foreach (AuditPaperEntity ape in AuditPapers)
                {
                    string sql = "SELECT REPORTDICTIONARY_ID,REPORTDICTIONARY_NAME FROM CT_FORMAT_REPORTDICTIONARY D INNER JOIN  " +
" CT_PAPER_AUDITPAPERANDREPORT R ON D.REPORTDICTIONARY_ID=R.AUDITPAPERANDREPORT_REPORTID AND R.AUDITPAPERANDREPORT_AUDITPAPERID='" + ape.Id + "'";
                    List<ReportFormatDicEntity> reports = dbManager.ExecuteSqlReturnTType<ReportFormatDicEntity>(sql);
                    dic.Add(ape.Id, reports);
                }
                return dic;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 根据审计日期获取
        /// </summary>
        /// <param name="ape"></param>
        /// <param name="auditReportDate"></param>
        /// <returns></returns>
        public List<ReportFormatStruct> GetReportFormatStructsByAuditPaper(AuditPaperEntity ape, ReportFormatDicEntity rfde)
        {
            try
            {
                List<ReportFormatStruct> rfsl = new List<ReportFormatStruct>();
                string sql = "SELECT REPORTDICTIONARY_ID,REPORTDICTIONARY_NAME,REPORTDICTIONARY_CYCLE,REPORTDICTIONARY_CODE FROM CT_FORMAT_REPORTDICTIONARY D INNER JOIN  " +
" CT_PAPER_AUDITPAPERANDREPORT R ON D.REPORTDICTIONARY_ID=R.AUDITPAPERANDREPORT_REPORTID AND R.AUDITPAPERANDREPORT_AUDITPAPERID='" + ape.Id + "'";
                rfde.Id = "";
                string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<ReportFormatDicEntity>(rfde);
                if (whereSql.Length > 0)
                {
                    sql += " WHERE " + whereSql;
                }
                sql = sql + " ORDER BY REPORTDICTIONARY_CODE";
                List<ReportFormatDicEntity> reports = dbManager.ExecuteSqlReturnTType<ReportFormatDicEntity>(sql);
                foreach (ReportFormatDicEntity report in reports)
                {
                    ReportFormatStruct rf = new ReportFormatStruct();
                    rf.ReportFormat = report;
                    rfsl.Add(rf);
                }
                return rfsl;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public string ExistReportFormat(ReportDataParameterStruct rdps, string tableName)
        {
            try
            {
                string sql = "SELECT DATA_ID FROM " + tableName + "  " + CreateWhereSql(rdps);
                DataTable dt = dbManager.ExecuteSqlReturnDataTable(sql);
                if (dt.Rows.Count > 0 && dt.Columns.Contains("DATA_ID"))
                {
                    return dt.Rows[0]["DATA_ID"].ToString();
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
        /// 根据审计底稿获取审计底稿相关的报表信息；
        /// </summary>
        /// <param name="rcde"></param>
        /// <returns></returns>
        public List<ReportFormatDicEntity> GetReportsByAuditPaper(ReportFormatDicEntity rcde, string auditPaperId)
        {
            try
            {
                string sql = "SELECT REPORTDICTIONARY_ID,REPORTDICTIONARY_NAME,REPORTDICTIONARY_CODE,CLASSIFY_NAME FROM CT_FORMAT_REPORTDICTIONARY D " +
 " INNER JOIN  CT_PAPER_AUDITPAPERANDREPORT R ON D.REPORTDICTIONARY_ID=R.AUDITPAPERANDREPORT_REPORTID AND R.AUDITPAPERANDREPORT_AUDITPAPERID ='" + auditPaperId + "' " +
 " LEFT JOIN CT_FORMAT_RELATION E ON D.REPORTDICTIONARY_ID=E.RELATION_REPORTID " +
 "LEFT JOIN  CT_FORMAT_CLASSIFY C ON E.RELATION_CLASSIFYID=C.CLASSIFY_ID ";
                string whereSql = " WHERE 1=1 ";
                if (!StringUtil.IsNullOrEmpty(rcde.ReportClassifyId))
                {
                    whereSql += " AND  E.RELATION_CLASSIFYID=''";
                }
                if (!StringUtil.IsNullOrEmpty(rcde.bbCode))
                {
                    whereSql += " AND D.REPORTDICTIONARY_CODE LIKE '%" + rcde.bbCode + "%' ";
                }
                if (!StringUtil.IsNullOrEmpty(rcde.bbName))
                {
                    whereSql += " AND D.REPORTDICTIONARY_NAME LIKE '%" + rcde.bbName + "%'";
                }

                sql += whereSql;
                sql += " ORDER BY REPORTDICTIONARY_CODE";
                Dictionary<string, string> nameMaps = new Dictionary<string, string>();
                nameMaps.Add("Id", "REPORTDICTIONARY_ID");
                nameMaps.Add("bbCode", "REPORTDICTIONARY_CODE");
                nameMaps.Add("bbName", "REPORTDICTIONARY_NAME");
                nameMaps.Add("ReportClassifyName", "CLASSIFY_NAME");
                return dbManager.ExecuteSqlReturnTType<ReportFormatDicEntity>(sql, nameMaps);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion

        #region 加载报表数据、保存更新报表数据

        /// <summary>
        /// 加载固定区或者变动区报表数据
        /// </summary>
        /// <param name="items"></param>
        /// <param name="tableName"></param>
        /// <param name="rdps"></param>
        /// <returns></returns>
        public DataTable LoadReportItems(string items, string tableName, ReportDataParameterStruct rdps, string whereSql)
        {
            try
            {
                string sql = "SELECT " + items + " FROM " + tableName + CreateWhereSql(rdps) + whereSql;
                return dbManager.ExecuteSqlReturnDataTable(sql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 获取宏函数值
        /// </summary>
        /// <param name="rdps"></param>
        /// <param name="strMacro"></param>
        /// <returns></returns>
        public string GetMarcoName(ReportDataParameterStruct rdps, string strMacro)
        {
            string MarcoName = string.Empty;
            try
            {
                ReportDataStruct rds = new ReportDataStruct();
                rds.rdps = rdps;
                MacroHelp mh = new MacroHelp();

                if (!StringUtil.IsNullOrEmpty(strMacro))
                {
                    mh.ReportParameter = rdps;
                    MarcoName = mh.ReplaceMacroVariable(mh.ReplaceMacroVariable(strMacro));
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return MarcoName;
        }
        /// <summary>
        /// 获取宏函数及其他内容的数据字典
        /// </summary>
        /// <returns></returns>
        public ItemDataValueStruct GetReportDataItem(ReportDataParameterStruct rdps)
        {
            string sql = "SELECT * FROM CT_FORMAT_DATAITEM WHERE DATAITEM_REPORTID='" + rdps.ReportId + "' and DATAITEM_ROW='"+ rdps.Row+ "' and DATAITEM_COL='"+ rdps.Col+ "'";
            List<DataItemEntity> items = dbManager.ExecuteSqlReturnTType<DataItemEntity>(sql);
            string tableName = "";
            ReportDataStruct rds = new ReportDataStruct();
            rds.rdps = rdps;
            MacroHelp mh = new MacroHelp();
            ItemDataValueStruct idvs = new ItemDataValueStruct();
            if (items != null & items.Count == 1)
            {
                mh.ReportParameter = rdps;
                ReplaceMarchPara(items[0], mh);
                string itemType = FormatTool.GetDataItemType(items[0].TableName);

                if (StringUtil.IsNullOrEmpty(items[0].Code)) return null;
                tableName = items[0].TableName;
                idvs.cellDataType = items[0].CellDataType;
                idvs.row = items[0].Row;
                idvs.col = items[0].Col;
                idvs.ParaValue = items[0].ParaValue;
                idvs.UrlValue = items[0].UrlValue;
                //处理宏函数
                if (!StringUtil.IsNullOrEmpty(items[0].Macro))
                {
                    idvs.value = mh.ReplaceMacroVariable(mh.ReplaceMacroVariable(items[0].Macro));
                }
            }
            return idvs;
        }
        /// <summary>
        /// 加载报表数据
        /// </summary>
        /// <param name="rdps"></param>
        /// <returns></returns>
        public ReportDataStruct LoadReportDatas(ReportDataParameterStruct rdps,bool selectAll=true)
        {
            try
            {
                string sql = "SELECT * FROM CT_FORMAT_DATAITEM WHERE DATAITEM_REPORTID='" + rdps.ReportId + "'";
                List<DataItemEntity> items = dbManager.ExecuteSqlReturnTType<DataItemEntity>(sql);

                ReportDataStruct rds = new ReportDataStruct();
                rds.rdps = rdps;

                List<Dictionary<string, DataItemEntity>> BdqItems = new List<Dictionary<string, DataItemEntity>>();
                string tableName = "";
                MacroHelp mh = new MacroHelp();
                foreach (DataItemEntity die in items)
                {
                    mh.ReportParameter = rdps;
                    ReplaceMarchPara(die, mh);
                    string itemType = FormatTool.GetDataItemType(die.TableName);
                    if (itemType == "GD")
                    {
                        if (StringUtil.IsNullOrEmpty(die.Code)) continue;
                        tableName = die.TableName;
                        ItemDataValueStruct idvs = new ItemDataValueStruct();
                        idvs.cellDataType = die.CellDataType;
                        idvs.row = die.Row;
                        idvs.col = die.Col;
                        idvs.ParaValue   =die.ParaValue;
                        idvs.UrlValue = die.UrlValue;
                        if (rds.Gdq.ContainsKey(die.Code))
                        {
                            throw new Exception("单元格内码【" + die.Code + "】重复，请调整报表格式");
                        }
                        rds.Gdq.Add(die.Code, idvs);
                        //处理宏函数
                        if (!StringUtil.IsNullOrEmpty(die.Macro))
                        {
                            //mh.ReportParameter = rdps;
                            idvs.value = mh.ReplaceMacroVariable(mh.ReplaceMacroVariable(die.Macro));
                        }
                    }
                    else if (itemType == "BD")
                    {
                        string bdCode = FormatTool.GetBdReportCode(die.TableName);
                        if (!rds.bdMaps.ContainsKey(bdCode))
                        {
                            rds.bdMaps.Add(bdCode, BdqItems.Count);
                            rds.bdIndexMaps.Add(BdqItems.Count.ToString(), bdCode);
                            Dictionary<string, DataItemEntity> bd = new Dictionary<string, AuditEntity.DataItemEntity>();
                            BdqItems.Add(bd);
                            if (rds.bdTableNames.ContainsKey(bdCode))
                            {
                                throw new Exception("单元格内码【" + bdCode + "】重复，请调整报表格式");
                            }
                            rds.bdTableNames.Add(bdCode, die.TableName);

                        }
                        BdqItems[rds.bdMaps[bdCode]].Add(die.Code, die);
                    }
                }
                //获取数据库数据
                if (tableName != "")
                {
                    GetGdqDatas(rds, rdps, tableName);
                    rds.GdbTableName = tableName;
                }
                if (rds.bdTableNames.Count > 0)
                {
                    GetBdqDatas(rds, BdqItems,selectAll);
                }

                return rds;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 替换超链接中的宏函数
        /// </summary>
        /// <param name="die"></param>
        private void ReplaceMarchPara(DataItemEntity die, MacroHelp mh)
        {
            string strUrl = die.UrlValue;
            if (strUrl==null||strUrl == "")
                return;
            int QMarkIndex = strUrl.IndexOf('?');
            if (QMarkIndex == -1)
                return;
            if (QMarkIndex == strUrl.Length - 1)
                return;
            string ps = strUrl.Substring(QMarkIndex + 1);
            Regex re = new Regex(@"(^|&)?(\w+)=([^&]+)(&|$)?", RegexOptions.Compiled);

            MatchCollection mc = re.Matches(ps);
            Dictionary<string, string> DParas = new Dictionary<string, string>();
            foreach (Match m in mc)
            {
                  string strValue=m.Result("$3");
                  if (strValue.Split('@')[0] == "0")
                  {
                     string strMarcro=  mh.ReplaceMacroVariable(mh.ReplaceMacroVariable(strValue.Split('@')[1]));
                     die.UrlValue= die.UrlValue.Replace(strValue, strMarcro);
                  }
            }     
        }
        /// <summary>
        /// 获取固定区数据
        /// </summary>
        /// <param name="rds"></param>
        /// <param name="rdps"></param>
        /// <param name="tableName"></param>
        private void GetGdqDatas(ReportDataStruct rds, ReportDataParameterStruct rdps, string tableName)
        {
            try
            {
                StringBuilder sb = new StringBuilder();
                foreach (string code in rds.Gdq.Keys)
                {
                    sb.Append("[" + code + "]");
                    sb.Append(",");
                }
                sb.Append("DATA_ID");
                sb.Append(",");
                if (sb.Length > 0) sb.Length--;

                if (sb.Length > 0)
                {
                    string sql = "SELECT " + sb.ToString() + " FROM " + tableName + CreateWhereSql(rdps);
                    DataTable dt = dbManager.ExecuteSqlReturnDataTable(sql);
                    foreach (DataRow dr in dt.Rows)
                    {
                        foreach (DataColumn dc in dt.Columns)
                        {
                            if (dc.ColumnName == "DATA_ID")
                            {
                                rds.GdbId = dr[dc.ColumnName].ToString();
                            }
                            else
                            {
                                if (rds.Gdq[dc.ColumnName].value != null) continue;
                                rds.Gdq[dc.ColumnName].value = dr[dc.ColumnName];
                            }

                        }
                    }
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void GetBdqDatas(ReportDataStruct rds, List<Dictionary<string, DataItemEntity>> BdqItems,bool selectAll=false)
        {
            try
            {
                StringBuilder selectSql = new StringBuilder();
                StringBuilder countSql = new StringBuilder();
                int i = 0;
                foreach (string tableCode in rds.bdTableNames.Keys)
                {
                    Dictionary<string, DataItemEntity> bdqItems = BdqItems[i];
                    selectSql.Length = 0;
                    countSql.Length = 0;
                    countSql.Append("SELECT COUNT(*) FROM ");
                    string topSql = "SELECT TOP 100 ";
                    if (selectAll||rds.rdps.bdqMaps.ContainsKey(tableCode))
                    {
                        if (rds.rdps.bdqMaps!=null&&rds.rdps.bdqMaps.ContainsKey(tableCode)&& rds.rdps.bdqMaps[tableCode].isOrNotLoadAll == "1")
                        {
                            topSql = "SELECT ";
                            rds.rdps.bdqMaps[tableCode].loadNumber = 100;
                        }
                        if (selectAll)
                        {
                            topSql = "SELECT ";
                        }

                    }
                    selectSql.Append(" DATA_ID");
                    selectSql.Append(",");
                    foreach (string columnName in bdqItems.Keys)
                    {
                        selectSql.Append("[");
                        selectSql.Append(columnName);
                        selectSql.Append("]");
                        selectSql.Append(",");
                    }
                    selectSql.Length--;
                    selectSql.Append(" FROM ");


                    selectSql.Append(rds.bdTableNames[tableCode]);
                    selectSql.Append(CreateBDWhereSql(rds.rdps, rds.bdTableNames[tableCode]));

                    countSql.Append(rds.bdTableNames[tableCode]);
                    countSql.Append(CreateBDWhereSql(rds.rdps, rds.bdTableNames[tableCode]));

                    int count = dbManager.Count(countSql.ToString());
                    if (count > 100)
                    {
                        if (!rds.rdps.bdqMaps.ContainsKey(tableCode))
                        {
                            BdqData bdDa = new BdqData();
                            bdDa.isOrNotLoadAll = "0";
                            bdDa.loadNumber = 100;
                            bdDa.totalNumber = count;
                            rds.rdps.bdqMaps.Add(tableCode, bdDa);
                        }
                        else
                        {
                            rds.rdps.bdqMaps[tableCode].loadNumber = 100;
                            rds.rdps.bdqMaps[tableCode].totalNumber = count;
                        }
                    }

                    //获取变动区    
                    string orderSql = "";
                    ReportRowChangeEntity rrce = new ReportRowChangeEntity();
                    List<ReportRowChangeEntity> temps = dbManager.ExecuteSqlReturnTType<ReportRowChangeEntity>("SELECT * FROM CT_FORMAT_ROWCHANGEDICTIONARY WHERE ROWCHANGEDICTIONARY_REGIONTABLE='"+ rds.bdTableNames[tableCode]+"'");
                    if (temps.Count > 0)
                    {
                        rrce = temps[0];
                    }
                    else
                    {
                        rrce = null;
                    }
                    if (rrce == null)
                    {
                        ReportColChangeEntity rcce = linqDbManager.GetEntity<ReportColChangeEntity>(r => r.RegionTable == rds.bdTableNames[tableCode]);
                        //设置排序方式
                        if (rrce!=null&&!StringUtil.IsNullOrEmpty(rcce.ColSort) && rcce.ColSort != "0")
                        {
                            orderSql = " ORDER BY [" + rcce.ColSort + "] ";
                        }
                        else
                        {
                            orderSql = " ORDER BY DATA_TIME ASC";
                        }
                    }
                    else
                    {
                        //设置排序方式
                        if (!StringUtil.IsNullOrEmpty(rrce.RowSort) && rrce.RowSort != "0")
                        {
                            orderSql = " ORDER BY [" + rrce.RowSort + "] ";
                        }
                        else
                        {
                            orderSql = " ORDER BY DATA_TIME ASC";
                        }
                    }
                    selectSql.Append(orderSql);
                    DataTable dt = dbManager.ExecuteSqlReturnDataTable(topSql + selectSql.ToString());
                    List<Dictionary<string, ItemDataValueStruct>> bdqData = new List<Dictionary<string, ItemDataValueStruct>>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        Dictionary<string, ItemDataValueStruct> row = new Dictionary<string, ItemDataValueStruct>();
                        foreach (DataColumn dc in dt.Columns)
                        {
                            ItemDataValueStruct idv = new ItemDataValueStruct();
                            idv.value = dr[dc.ColumnName];
                            if (dc.ColumnName == "DATA_ID")
                            {
                                idv.cellDataType = "01";
                            }
                            else
                            {
                                idv.cellDataType = bdqItems[dc.ColumnName].CellDataType;
                            }
                            if (dc.ColumnName != "DATA_ID")
                            {
                                if (bdqItems[dc.ColumnName].CellType == "04")
                                  // idv.ParaValue = bdqItems[dc.ColumnName].ParaValue;
                                idv.UrlValue = bdqItems[dc.ColumnName].UrlValue;
                            }
                            if (string.IsNullOrEmpty(idv.value.ToString()) && bdqItems[dc.ColumnName].Macro == "<!NGUID!>")
                                idv.value = Guid.NewGuid();
                            row.Add(dc.ColumnName, idv);
                        }
                        bdqData.Add(row);
                    }
                    if (bdqData.Count == 0)
                    {
                        Dictionary<string, ItemDataValueStruct> row = new Dictionary<string, ItemDataValueStruct>();
                        foreach (string columnName in bdqItems.Keys)
                        {
                            ItemDataValueStruct idv = new ItemDataValueStruct();
                            idv.value = "";
                            idv.UrlValue= bdqItems[columnName].UrlValue;
                            idv.cellDataType = bdqItems[columnName].CellDataType;
                            if (bdqItems[columnName].Macro == "<!NGUID!>")
                                idv.value = Guid.NewGuid();
                            row.Add(columnName, idv);

                        }
                        ItemDataValueStruct temp = new ItemDataValueStruct();
                        temp.value = "";
                        temp.cellDataType = "01";
                        //if (bdqItems["Macro"].Macro == "<!NGUID!>")
                        //    temp.value = Guid.NewGuid();
                        row.Add("DATA_ID", temp);
                        bdqData.Add(row);
                    }
                    rds.BdqData.Add(bdqData);

                    i++;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private string CreateWhereSql(ReportDataParameterStruct rdps)
        {
            try
            {

                string sql = "";
                if (ReportGlobalConst.IsOrNotRelationTaskAndPaper)
                {
                    //string strCylcle = string.Empty;
                    //if(int.Parse(rdps.Cycle)<0)

                    sql = " WHERE DATA_TASKID='" + rdps.TaskId + "' AND DATA_MANUSCRIPT='" + rdps.PaperId + "' AND DATA_COMPANYID='" + rdps.CompanyId + "' AND DATA_REPORTID='" + rdps.ReportId + "' AND DATA_YEAR='" + rdps.Year + "' AND DATA_CYCLE='" + rdps.Cycle + "' " ;
                }
                else
                {
                    sql = " WHERE  DATA_COMPANYID='" + rdps.CompanyId + "' AND DATA_REPORTID='" + rdps.ReportId + "' AND DATA_YEAR='" + rdps.Year + "' AND DATA_CYCLE='" + rdps.Cycle + "' " ;
                }

                return sql;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        private string GetTableCol(string table,string Rows,string Col, string values)
        {
            string sql = string.Empty;
            if(string.IsNullOrEmpty(values))
                return "";
            string SWhere = string.Empty;
            try
            {
                sql = string.Format("select DATAITEM_CODE,DATAITEM_CELLDATATYPE from    CT_FORMAT_DATAITEM  where DATAITEM_tablename='{0}' and DATAITEM_ROW={1}  and DATAITEM_Col={2} ", table, Rows, Col);
                DataTable dt = dbManager.ExecuteSqlReturnDataTable(sql);

                if (dt.Rows.Count == 0)
                    return "";
                if (dt.Rows[0][1].ToString() == "01")
                    SWhere =string.Format( " and [{0}] like '%{1}%' ",dt.Rows[0][0].ToString(),values) ;
                else
                    SWhere = string.Format(" and [{0}] = {1} ", dt.Rows[0][0].ToString(), values);
              
                return SWhere;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        private string CreateBDWhereSql(ReportDataParameterStruct rdps,string table)
        {
            try
            {

                string sql = "";
                if (ReportGlobalConst.IsOrNotRelationTaskAndPaper)
                {
                    sql = " WHERE DATA_TASKID='" + rdps.TaskId + "' AND DATA_MANUSCRIPT='" + rdps.PaperId + "' AND DATA_COMPANYID='" + rdps.CompanyId + "' AND DATA_REPORTID='" + rdps.ReportId + "' AND DATA_YEAR='" + rdps.Year + "' AND DATA_CYCLE='" + rdps.Cycle + "' ";
                }
                else
                {
                    sql = " WHERE  DATA_COMPANYID='" + rdps.CompanyId + "' AND DATA_REPORTID='" + rdps.ReportId + "' AND DATA_YEAR='" + rdps.Year + "' AND DATA_CYCLE='" + rdps.Cycle + "' " ;
                }
                if(!string.IsNullOrEmpty(rdps.Where))
                    sql=sql+ GetTableCol(table, rdps.Where.Split('&')[0], rdps.Where.Split('&')[1], rdps.Where.Split('&')[2]);
                return sql;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        private string CreateWhereSql(string id)
        {
            try
            {
                string sql = " WHERE DATA_ID='" + id + "'";
                return sql;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }



        public void SaveReportDatas(ReportDataStruct rds)
        {
            //DbConnection connection = dbManager.GetDbConnection();
            try
            {
            //using (connection)
            //{
            //        DbCommand command = dbManager.getDbCommand();
            //        dbManager.Open();
                   
            //        DbTransaction tr = connection.BeginTransaction();
                    try
                    {
                        try
                        {
                            //command.CommandType = CommandType.Text;
                            //command.Transaction = tr;

                            //保存固定表数据
                            SaveGdbDatas(rds);
                            //保存变动表数据
                           // SaveBdbData(rds, command);
                            QsaveBdbData(rds);
                             //tr.Commit();
                        }
                        catch (Exception ex)
                        {
                           // tr.Rollback();
                            throw ex;
                        }

                        //保存报表状态
                        SaveBBState(rds);
                        //保存报表审计状态
                        SaveReportAudit(rds);

                       
                    }
                    catch (Exception ex)
                    {

                        throw ex;
                    }
            }
            //}
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public void SaveReportFormat(string BBID, string strFormula)
        {
            string sql = string.Empty;
            try
            {
                
                sql = string.Format("update CT_FORMAT_REPORTDICTIONARY set REPORTDICTIONARY_FORMATINFO1='{0}' where REPORTDICTIONARY_ID='{1}'",strFormula,BBID);
                dbManager.ExecuteSql(sql);
               
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        private void SaveGdbDatas(ReportDataStruct rds)
        {
            try
            {

                if (rds.Gdq.Count == 0) return;
                List<DbParameter> parameters = new List<DbParameter>();
                string sql = "";
                if (StringUtil.IsNullOrEmpty(rds.GdbId))
                {
                    rds.GdbId = Guid.NewGuid().ToString();
                    sql = ConvertDictionaryToInsertSql(rds.rdps, parameters, rds.GdbTableName, rds.Gdq, rds.GdbId);
                }
                else
                {
                    sql = ConvertDictinaryToUpdateSql(rds.Gdq, parameters, rds.GdbTableName, CreateWhereSql(rds.GdbId));
                    if (sql == "") return;
                }
                //command.CommandText = sql;
                //foreach (DbParameter p in parameters)
                //{
                //    command.Parameters.Add(p);
                //}
                strCon = dbManager.GetDbConnection().ConnectionString;
                dbManager.ExecuteSql(sql, parameters);
                //command.ExecuteNonQuery();
                //command.Parameters.Clear();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private string ConvertDictionaryToInsertSql(ReportDataParameterStruct rdps, List<DbParameter> parameters, string tableName, Dictionary<string, ItemDataValueStruct> dics, string id)
        {
            try
            {
                StringBuilder insertNames = new StringBuilder();
                StringBuilder insertValues = new StringBuilder();
                insertNames.Append("INSERT INTO ");
                insertNames.Append(tableName);
                insertNames.Append("(");

                insertValues.Append(" VALUES(");


                //插入固定列
                insertNames.Append("DATA_ID,");
                if (ReportGlobalConst.IsOrNotRelationTaskAndPaper)
                {
                    insertNames.Append("DATA_TASKID,");
                    insertNames.Append("DATA_MANUSCRIPT,");
                }

                insertNames.Append("DATA_COMPANYID,");
                insertNames.Append("DATA_REPORTID,");
                insertNames.Append("DATA_YEAR,");
                insertNames.Append("DATA_CYCLE,");
                insertNames.Append("DATA_TIME,");
                insertNames.Append("DATA_CREATER,");

                insertValues.Append("'" + id + "',");
                if (ReportGlobalConst.IsOrNotRelationTaskAndPaper)
                {
                    insertValues.Append("'" + rdps.TaskId + "',");
                    insertValues.Append("'" + rdps.PaperId + "',");
                }

                insertValues.Append("'" + rdps.CompanyId + "',");
                insertValues.Append("'" + rdps.ReportId + "',");
                insertValues.Append("'" + rdps.Year + "',");
                insertValues.Append("'" + rdps.Cycle + "',");
                insertValues.Append("'" + SessoinUtil.GetTimeTicks() + "',");
                insertValues.Append("'" + SessoinUtil.GetCurrentUser().Id + "',");
                int i = 0;
                foreach (string code in dics.Keys)
                {
                    if (StringUtil.IsNullOrEmpty(dics[code].value) || dics[code].isOrNotUpdate == "0") continue;
                    insertNames.Append("[" + code + "]");
                    insertNames.Append(",");
                    insertValues.Append("{" + i.ToString() + "}");
                    insertValues.Append(",");
                    i++;

                    DbParameter parameter = dbManager.GetDbParameter();
                    parameter.ParameterName = code;
                    switch (dics[code].cellDataType)
                    {
                        case "01":
                            parameter.DbType = DbType.String;
                            parameter.Value = Convert.ToString(dics[code].value);
                            break;
                        case "02":
                            parameter.DbType = DbType.Decimal;
                            if (StringUtil.IsNullOrEmpty(dics[code].value.ToString().Trim())) dics[code].value = 0.0;
                            parameter.Value = Convert.ToDecimal(dics[code].value.ToString().Trim());
                            break;
                    }
                    parameters.Add(parameter);
                    dics[code].isOrNotUpdate = "0";
                }
                insertNames.Length--;
                insertValues.Length--;
                insertNames.Append(")");
                insertValues.Append(")");
                string sql = insertNames.ToString() + insertValues.ToString();
                sql = DBTool.ReplaceDbSqlPrameters(sql, parameters);
                return sql;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private string ConvertDictionaryToInsertSql(ReportDataParameterStruct rdps, string tableName, Dictionary<string, ItemDataValueStruct> dics, string id)
        {
            try
            {
                StringBuilder insertNames = new StringBuilder();
                StringBuilder insertValues = new StringBuilder();
                insertNames.Append("INSERT INTO ");
                insertNames.Append(tableName);
                insertNames.Append("(");

                insertValues.Append(" VALUES(");


                //插入固定列
                insertNames.Append("DATA_ID,");
                if (ReportGlobalConst.IsOrNotRelationTaskAndPaper)
                {
                    insertNames.Append("DATA_TASKID,");
                    insertNames.Append("DATA_MANUSCRIPT,");
                }

                insertNames.Append("DATA_COMPANYID,");
                insertNames.Append("DATA_REPORTID,");
                insertNames.Append("DATA_YEAR,");
                insertNames.Append("DATA_CYCLE,");
                insertNames.Append("DATA_TIME,");
                insertNames.Append("DATA_CREATER,");

                insertValues.Append("'" + id + "',");
                if (ReportGlobalConst.IsOrNotRelationTaskAndPaper)
                {
                    insertValues.Append("'" + rdps.TaskId + "',");
                    insertValues.Append("'" + rdps.PaperId + "',");
                }

                insertValues.Append("'" + rdps.CompanyId + "',");
                insertValues.Append("'" + rdps.ReportId + "',");
                insertValues.Append("'" + rdps.Year + "',");
                insertValues.Append("'" + rdps.Cycle + "',");
                insertValues.Append("'" + SessoinUtil.GetTimeTicks() + "',");
                insertValues.Append("'" + SessoinUtil.GetCurrentUser().Id + "',");
            
                foreach (string code in dics.Keys)
                {
                    if (StringUtil.IsNullOrEmpty(dics[code].value) || dics[code].isOrNotUpdate == "0") continue;
                    insertNames.Append("[" + code + "]");
                    insertNames.Append(",");

                    switch (dics[code].cellDataType)
                    {
                        case "01":
                            insertValues.Append("'" + Convert.ToString(dics[code].value) + "'");
                            insertValues.Append(",");
                            break;
                        case "02":

                            if (StringUtil.IsNullOrEmpty(dics[code].value.ToString().Trim())) dics[code].value = 0.0;
                            insertValues.Append("" + Convert.ToDecimal(dics[code].value.ToString().Trim()) + "");
                            insertValues.Append(",");
                            break;
                    }
                    dics[code].isOrNotUpdate = "0";

                }
                insertNames.Length--;
                insertValues.Length--;
                insertNames.Append(")");
                insertValues.Append(")");
                string sql = insertNames.ToString() + insertValues.ToString();
                return sql;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private string ConvertDictinaryToUpdateSql(Dictionary<string, ItemDataValueStruct> dics, List<DbParameter> parameters, string tableName, string whereSql)
        {
            try
            {
                StringBuilder updateSql = new StringBuilder();
                updateSql.Append("UPDATE ");
                updateSql.Append(tableName);
                updateSql.Append(" SET ");
                int i = 0;

                StringBuilder tempSql = new StringBuilder();
                foreach (string code in dics.Keys)
                {
                    if (dics[code].isOrNotUpdate == "0") continue;
                    tempSql.Append("[");
                    tempSql.Append(code);
                    tempSql.Append("]");
                    tempSql.Append("=");
                    tempSql.Append("{");
                    tempSql.Append(i.ToString());
                    tempSql.Append("}");
                    tempSql.Append(",");
                    i++;

                    DbParameter parameter = dbManager.GetDbParameter();
                    parameter.ParameterName = code;
                    switch (dics[code].cellDataType)
                    {
                        case "01":
                            parameter.DbType = DbType.String;
                            parameter.Value = Convert.ToString(dics[code].value);
                            break;
                        case "02":
                            parameter.DbType = DbType.Decimal;
                            if (StringUtil.IsNullOrEmpty(dics[code].value.ToString().Trim())) dics[code].value = 0.0;
                            parameter.Value = Convert.ToDecimal(dics[code].value.ToString().Trim());
                            break;
                    }
                    parameters.Add(parameter);
                    dics[code].isOrNotUpdate = "0";
                }
                if (tempSql.Length == 0) return "";
                updateSql.Append(tempSql.ToString());
                updateSql.Length--;
                updateSql.Append(whereSql);
                string sql = updateSql.ToString();
                sql = DBTool.ReplaceDbSqlPrameters(sql, parameters);
                return sql;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private string ConvertDictinaryToUpdateSql(Dictionary<string, ItemDataValueStruct> dics, string tableName, string whereSql)
        {
            try
            {
                StringBuilder updateSql = new StringBuilder();
                updateSql.Append("UPDATE ");
                updateSql.Append(tableName);
                updateSql.Append(" SET ");
               

                StringBuilder tempSql = new StringBuilder();
                foreach (string code in dics.Keys)
                {
                    if (dics[code].isOrNotUpdate == "0") continue;
                    tempSql.Append("[");
                    tempSql.Append(code);
                    tempSql.Append("]");
                    tempSql.Append("=");



                    switch (dics[code].cellDataType)
                    {
                        case "01":
                            tempSql.Append("'");
                            tempSql.Append(Convert.ToString(dics[code].value));
                            tempSql.Append("'");
                            tempSql.Append(",");

                            break;
                        case "02":
                            if (StringUtil.IsNullOrEmpty(dics[code].value.ToString().Trim())) dics[code].value = 0.0;
                            tempSql.Append(Convert.ToDecimal(dics[code].value.ToString().Trim()));
                            tempSql.Append(",");
                            break;
                    }

                }
                if (tempSql.Length == 0) return "";
                updateSql.Append(tempSql.ToString());
                updateSql.Length--;
                updateSql.Append(whereSql);
                string sql = updateSql.ToString();
                return sql;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private DataTable getBdhTable(string tableName,ReportDataStruct rds)
        {
            string sql = string.Empty;
            DataTable table = null;
            string strCol = string.Empty;
            try
            {
                if (string.IsNullOrEmpty(strCon))
                   strCon = dbManager.GetDbConnection().ConnectionString;
                sql = string.Format("select * from {0} where DATA_TASKID='{1}' and DATA_COMPANYID='{2}' and DATA_REPORTID='{3}' and DATA_CYCLE='{4}' ", tableName, rds.rdps.TaskId, rds.rdps.CompanyId, rds.rdps.ReportId, rds.rdps.Cycle);
                table= dbManager.ExecuteSqlReturnDataTable(sql);
                foreach(DataColumn col in table.Columns)
                {
                    strCol += col.ColumnName + ",";
                }
                strCol = strCol.Substring(0, strCol.Length - 1);
                table.ExtendedProperties.Add("SQL", sql);
               // table.ExtendedProperties.Add("SQL", string.Format("select {0} from {1} ",strCol,tableName));
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return table;
        }
        private void ConvertDictionaryToDataRow(ReportDataParameterStruct rdps, string tableName, Dictionary<string, ItemDataValueStruct> dics, string id,ref DataTable table)
        {
            try
            {
                DataRow row = table.NewRow();
                foreach (DataColumn col in table.Columns)
                {
                    bool IsExit = false;
                    switch (col.ColumnName)
                    {
                        case "DATA_ID":
                            row["DATA_ID"] = id;
                            IsExit = true;
                            break;
                        case "DATA_TASKID":
                            row["DATA_TASKID"] = rdps.TaskId;
                            IsExit = true;
                            break;
                        case "DATA_MANUSCRIPT":
                            row["DATA_MANUSCRIPT"] = rdps.PaperId;
                            IsExit = true;
                            break;
                        case "DATA_COMPANYID":
                            row["DATA_COMPANYID"] = rdps.CompanyId;
                            IsExit = true;
                            break;
                        case "DATA_REPORTID":
                            row["DATA_REPORTID"] = rdps.ReportId;
                            IsExit = true;
                            break;
                        case "DATA_YEAR":
                            row["DATA_YEAR"] = rdps.Year;
                            IsExit = true;
                            break;
                        case "DATA_CYCLE":
                            row["DATA_CYCLE"] = rdps.Cycle;
                            IsExit = true;
                            break;
                        case "DATA_TIME":
                            row["DATA_TIME"] = SessoinUtil.GetTimeTicks();
                            IsExit = true;
                            break;
                        case "DATA_CREATER":
                            row["DATA_CREATER"] = SessoinUtil.GetCurrentUser().Id;
                            IsExit = true;
                            break;
                    }
                    if (IsExit == true)
                        continue;
                    foreach (string code in dics.Keys)
                    {
                        if (StringUtil.IsNullOrEmpty(dics[code].value) || dics[code].isOrNotUpdate == "0") continue;
                        string colName= code ;
                        if (col.ColumnName == colName)
                        {
                            switch (dics[code].cellDataType)
                            {
                                case "01":
                                    row[colName] = Convert.ToString(dics[code].value);
                                    break;
                                case "02":
                                    if (StringUtil.IsNullOrEmpty(dics[code].value.ToString().Trim())) dics[code].value = 0.0;
                                    row[colName]= Convert.ToDecimal(dics[code].value.ToString().Trim());
                                    break;
                            }
                            dics[code].isOrNotUpdate = "0";
                        }
                    }

                }
                table.Rows.Add(row);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
      
        private void ConvertDictinaryToUpTableRow(Dictionary<string, ItemDataValueStruct> dics, string tableName, string id, ref DataTable table)
        {
            try
            {
              
                foreach (DataRow row in table.Rows)
                {
                    if (row["DATA_ID"].ToString()== id)
                    {
                        foreach (DataColumn col in table.Columns)
                        {

                            foreach (string code in dics.Keys)
                            {

                                if (dics[code].isOrNotUpdate == "0") continue;
                                string colName = code;
                                if (col.ColumnName == colName)
                                {
                                    switch (dics[code].cellDataType)
                                    {
                                        case "01":
                                            row[colName] = Convert.ToString(dics[code].value);
                                            break;
                                        case "02":
                                            if (StringUtil.IsNullOrEmpty(dics[code].value.ToString().Trim())) dics[code].value = 0.0;
                                            row[colName] = Convert.ToDecimal(dics[code].value.ToString().Trim());
                                            break;
                                    }
                                }
                            }
                        }
                    }
                }
              
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void QsaveBdbData(ReportDataStruct rds)
        {
            try
            {
                bool isUpdate = false;
                foreach (string bdCode in rds.bdMaps.Keys)
                {
                    if (rds.BdqData.Count == 0) return;
                    List<Dictionary<string, ItemDataValueStruct>> bdqDatas = rds.BdqData[rds.bdMaps[bdCode]];
                    string tableName = rds.bdTableNames[bdCode];
                    

                    DataTable BdhUpdateTable = getBdhTable(tableName, rds);
                    DataTable BdhInsertTable = BdhUpdateTable.Clone();
                    
                    if (bdqDatas.Count > 0)
                    {
                        
                        foreach (Dictionary<string, ItemDataValueStruct> rowData in bdqDatas)
                        {
                            if (rowData == null) continue;
                            if (!rowData.ContainsKey("DATA_ID")) break;
                            string dataId = Convert.ToString(rowData["DATA_ID"].value);
                            
                            if (StringUtil.IsNullOrEmpty(dataId))
                            {
                                dataId = Guid.NewGuid().ToString();
                                rowData["DATA_ID"].value = dataId;
                                ConvertDictionaryToDataRow(rds.rdps, tableName, rowData, dataId, ref BdhInsertTable);
                               // sql = ConvertDictionaryToInsertSql(rds.rdps, tableName, rowData, dataId);
                            }
                            else
                            {
                                ConvertDictinaryToUpTableRow(rowData, tableName, dataId, ref BdhUpdateTable);
                                isUpdate = true;
                                //sql = ConvertDictinaryToUpdateSql(rowData, tableName, CreateWhereSql(dataId));
                                //if (sql == "") continue;
                            }
                        }
                    }
                    if (BdhInsertTable != null && BdhInsertTable.Rows.Count > 0)
                      dbManager.  BulkToDB(tableName, BdhInsertTable);
                    if (isUpdate == true && BdhUpdateTable.Rows.Count>0)
                        dbManager.BulkToUpdateDB(tableName, BdhUpdateTable);

                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        private void SaveBdbData(ReportDataStruct rds, DbCommand command)
        {
            try
            {
                foreach (string bdCode in rds.bdMaps.Keys)
                {
                    if (rds.BdqData.Count == 0) return;
                    List<Dictionary<string, ItemDataValueStruct>> bdqDatas = rds.BdqData[rds.bdMaps[bdCode]];

                    if (bdqDatas.Count > 0)
                    {
                        string tableName = rds.bdTableNames[bdCode];
                        //DataTable BdhTable = getBdhTable(tableName);
                        StringBuilder sqlSb = new StringBuilder();
                        int i = 0;
                        foreach (Dictionary<string, ItemDataValueStruct> rowData in bdqDatas)
                        {
                            string sql = "";

                            if (rowData == null) continue;
                            if (!rowData.ContainsKey("DATA_ID")) break;
                            string dataId = Convert.ToString(rowData["DATA_ID"].value);
                            if (StringUtil.IsNullOrEmpty(dataId))
                            {
                                dataId = Guid.NewGuid().ToString();
                                rowData["DATA_ID"].value = dataId;
                                sql = ConvertDictionaryToInsertSql(rds.rdps, tableName, rowData, dataId);
                            }
                            else
                            {
                                sql = ConvertDictinaryToUpdateSql(rowData, tableName, CreateWhereSql(dataId));
                                if (sql == "") continue;
                            }
                            sqlSb.Append(sql);
                            sqlSb.Append(";");
                            i++;
                            if (i == ReportGlobalConst.BatchExecuteSql)
                            {
                                command.CommandText = sqlSb.ToString();
                                command.ExecuteNonQuery();
                                i = 0;
                                sqlSb.Length = 0;
                            }

                        }
                        if (sqlSb.Length > 0)
                        {
                            command.CommandText = sqlSb.ToString();
                            command.ExecuteNonQuery();
                            i = 0;
                            sqlSb.Length = 0;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public void SaveBBState(ReportDataStruct rds)
        {
            try
            {
                ReportStateEntity rse = reportStateService.ConvertReportDataParameterToStateEntity(rds.rdps);
                rse.State = ReportGlobalConst.REPORTSTATE_TB;


                ReportStateDetailEntity rsde = reportStateService.ConvertReportDataParameterToStateDetailEntity(rds.rdps);
                rsde.State = ReportGlobalConst.REPORTSTATE_TB;
                rsde.OperationType = reportProcessManager.GetCurrentStateName(ReportGlobalConst.REPORTSTATE_TB);

                reportStateService.SaveReportSate_Tb(rse, rsde);



            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public void SaveReportAudit(ReportDataStruct rds)
        {
            try
            {
                ReportAuditEntity rae = new ReportAuditEntity();
                rae.TaskId = rds.rdps.TaskId;
                rae.PaperId = rds.rdps.PaperId;
                rae.ReportId = rds.rdps.ReportId;
                rae.CompanyId = rds.rdps.CompanyId;
                rae.Year = rds.rdps.Year;
                rae.Zq = rds.rdps.Cycle;
                reportAuditService.InsertReportAudit(rae);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public void DeleteBdqData(string id, string tableName)
        {
            try
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("DELETE FROM ");
                sb.Append(tableName);
                sb.Append(CreateWhereSql(id));
                dbManager.ExecuteSql(sb.ToString());
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion










        public List<ReportFormatDicEntity> GetReportsByAuditPaper(ReportFormatDicEntity rcde)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// 清空报表数据
        /// </summary>
        /// <param name="rdps"></param>
        public void ClearReportData(ReportDataParameterStruct rdps)
        {
            try
            {
                //创建Where条件
                string whereSql = CreateWhereSql(rdps);
                StringBuilder sql = new StringBuilder();
                List<string> tables = reportFormatService.GetReportTables(rdps.ReportId);
                foreach (string table in tables)
                {
                    sql.Length = 0;
                    sql.Append("DELETE FROM ");
                    sql.Append(table);
                    sql.Append(" ");
                    sql.Append(whereSql);
                    dbManager.ExecuteSql(sql.ToString());
                }

                reportStateService.DeleteReportState(rdps);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// 获取报表相关的指标
        /// 上期数、同期数
        /// 同比、环比
        /// </summary>
        /// <param name="reportAuditCellConclusion"></param>
        /// <param name="indexRelationsStruct"></param>
        /// <returns></returns>
        public AuditSPI.ReportAudit.RelationsIndexesDataStruct GetRelationsIndexesData(ReportAuditCellConclusion reportAuditCellConclusion, AuditSPI.ReportAudit.IndexRelationsStruct indexRelationsStruct)
        {
            try
            {
                RelationsIndexesDataStruct rids = new RelationsIndexesDataStruct();
                StringBuilder sql = new StringBuilder();
                sql.Append("SELECT * FROM CT_FORMAT_DATAITEM WHERE DATAITEM_REPORTID='" + reportAuditCellConclusion.ReportId + "' AND DATAITEM_CODE='" + reportAuditCellConclusion.CellCode + "'");
                List<DataItemEntity> items = dbManager.ExecuteSqlReturnTType<DataItemEntity>(sql.ToString());
                if (items.Count > 0)
                {
                    StringBuilder itemStr = new StringBuilder();
                    //如果存在标识列，则需要构造Where条件
                    StringBuilder whereSql = new StringBuilder();
                    CreateReportBdPrimaryWhereSql(reportAuditCellConclusion.BdPrimary, whereSql);

                    foreach (IndexRelationsIndexDefinition irid in indexRelationsStruct.Indexs)
                    {
                        itemStr.Length = 0;

                        ReportCycleStruct rcs = new ReportCycleStruct();
                        rcs.CurrentNd = reportAuditCellConclusion.Year;
                        rcs.CurrentZq = reportAuditCellConclusion.Cycle;
                        rcs.ReportType = reportAuditCellConclusion.ReportType;

                        //获取指标数据
                        ReportDataParameterStruct rdps = new ReportDataParameterStruct();
                        rdps.TaskId = reportAuditCellConclusion.TaskId;
                        rdps.PaperId = reportAuditCellConclusion.PaperId;
                        rdps.ReportId = reportAuditCellConclusion.ReportId;
                        rdps.CompanyId = reportAuditCellConclusion.CompanyId;
                        //获取指标年度和周期
                        if (irid.Code == ReportGlobalConst.LastPeriodNumber_Code)
                        {
                            rids.LastPeriodNumber = GetIndexData(rcs, RelationIndexesType.LastPeriod, rdps, itemStr, items, whereSql.ToString());
                        }
                        else if (irid.Code == ReportGlobalConst.SamePeriodNumber_Code)
                        {
                            rids.SamePeriodNumber = GetIndexData(rcs, RelationIndexesType.SamePeriod, rdps, itemStr, items, whereSql.ToString());
                        }
                        else if (irid.Code == ReportGlobalConst.RelativeRatio_Code && items[0].CellDataType == ReportGlobalConst.DATATYPE_NUMBER)
                        {
                            
                            //环比
                            if (rids.LastPeriodNumber == null || rids.LastPeriodNumber.Count == 0)
                            {
                                rids.LastPeriodNumber = GetIndexData(rcs, RelationIndexesType.LastPeriod, rdps, itemStr, items, whereSql.ToString());
                            }
                            //已经计算同期数
                            List<ItemDataValueStruct> values = new List<ItemDataValueStruct>();
                            rdps.Year = reportAuditCellConclusion.Year;
                            rdps.Cycle = reportAuditCellConclusion.Cycle;
                            itemStr.Append("[");
                            itemStr.Append(items[0].Code);
                            itemStr.Append("]");
                            DataTable dt = LoadReportItems(itemStr.ToString(), items[0].TableName, rdps, whereSql.ToString());
                            int i = 0;
                            foreach (DataRow row in dt.Rows)
                            {
                                if (rids.LastPeriodNumber.Count>i&&!StringUtil.IsNullOrEmpty(rids.LastPeriodNumber[i].value))
                                {
                                    if (StringUtil.IsNullOrEmpty(row[0])) continue;
                                    if (Convert.ToDecimal(rids.LastPeriodNumber[i].value) == 0) continue;
                                    ItemDataValueStruct idvs = new ItemDataValueStruct();
                                    idvs.value = (Convert.ToDecimal(row[0]) - Convert.ToDecimal(rids.LastPeriodNumber[i].value)) / Convert.ToDecimal(rids.LastPeriodNumber[i].value) * 100;
                                    rids.RelativeRatio.Add(idvs);
                                }
                                i++;
                            }


                        }
                        else if (irid.Code == ReportGlobalConst.SameRatio_Code && items[0].CellDataType == ReportGlobalConst.DATATYPE_NUMBER)
                        {
                            //同比
                            if (rids.SamePeriodNumber == null || rids.SamePeriodNumber.Count == 0)
                            {
                                rids.SamePeriodNumber = GetIndexData(rcs, RelationIndexesType.SamePeriod, rdps, itemStr, items, whereSql.ToString());
                            }
                            //已经计算同期数
                            List<ItemDataValueStruct> values = new List<ItemDataValueStruct>();
                            rdps.Year = reportAuditCellConclusion.Year;
                            rdps.Cycle = reportAuditCellConclusion.Cycle;
                            itemStr.Append("[");
                            itemStr.Append(items[0].Code);
                            itemStr.Append("]");
                            DataTable dt = LoadReportItems(itemStr.ToString(), items[0].TableName, rdps, whereSql.ToString());
                            int i = 0;
                            foreach (DataRow row in dt.Rows)
                            {
                                if (rids.SamePeriodNumber.Count>i&&!StringUtil.IsNullOrEmpty(rids.SamePeriodNumber[i].value))
                                {
                                    if (Convert.ToDecimal(rids.SamePeriodNumber[i].value) == 0) continue;
                                    ItemDataValueStruct idvs = new ItemDataValueStruct();
                                    idvs.value = (Convert.ToDecimal(row[0]) - Convert.ToDecimal(rids.SamePeriodNumber[i].value)) / Convert.ToDecimal(rids.SamePeriodNumber[i].value) * 100;
                                    rids.SameRatio.Add(idvs);
                                }
                                i++;
                            }
                        }
                    }
                }
                return rids;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 获取指标标识列的Where条件
        /// </summary>
        /// <param name="reportAuditCellConclusion"></param>
        /// <param name="whereSql"></param>
        private void CreateReportBdPrimaryWhereSql(string primaries, StringBuilder whereSql)
        {
            try
            {
                if (!StringUtil.IsNullOrEmpty(primaries))
                {
                    string[] primariesArr =primaries.Split(',');
                    foreach (string p in primariesArr)
                    {
                        string[] nv = p.Split(':');

                        whereSql.Append(" AND ");
                        whereSql.Append(" [");
                        whereSql.Append(nv[0]);
                        whereSql.Append("]");
                        whereSql.Append("=");
                        whereSql.Append("'");
                        whereSql.Append(nv[1]);
                        whereSql.Append("'");
                    }
  
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void CreateReportBdPrimariesWhereSql(string bdPrimaries, StringBuilder whereSql)
        {
            try
            {
                if (!StringUtil.IsNullOrEmpty(bdPrimaries))
                {
                    string [] primeries=bdPrimaries.Split(';');
                    
                    int i = 0;
                    bool flag = false;
                    foreach (string primary in primeries)
                    {
                        if (StringUtil.IsNullOrEmpty(primary)) continue;
                        string[] primarieArr = primary.Split(',');
                        if (i == 0)
                        {
                            whereSql.Append(" AND ");
                            whereSql.Append("(");
                            flag = true;
                        }
                        else whereSql.Append(" OR ");
                        whereSql.Append("(");
                        foreach (string p in primarieArr)
                        {
                            string[] nv = p.Split(':');
                           
                            whereSql.Append(" [");
                            whereSql.Append(nv[0]);
                            whereSql.Append("]");
                            whereSql.Append("=");
                            whereSql.Append("'");
                            whereSql.Append(nv[1]);
                            whereSql.Append("'");
                        }
                        whereSql.Append(")");
                        i++;
                    }
                    if (flag)
                    {
                        whereSql.Append(")");
                    }
                   
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 获取指标数据
        /// </summary>
        /// <param name="rit"></param>
        /// <param name="rcs"></param>
        /// <returns></returns>
        private List<ItemDataValueStruct> GetIndexData(ReportCycleStruct rcs, RelationIndexesType rit, ReportDataParameterStruct rdps, StringBuilder itemStr, List<DataItemEntity> items, string whereSql)
        {
            try
            {
                List<ItemDataValueStruct> values = new List<ItemDataValueStruct>();
                reportCycleService.GetReportIndexCycleByIndexType(rcs, rit);
                rdps.Year = rcs.CurrentNd;
                rdps.Cycle = rcs.CurrentZq;
                itemStr.Append("[");
                itemStr.Append(items[0].Code);
                itemStr.Append("]");
                DataTable dt = LoadReportItems(itemStr.ToString(), items[0].TableName, rdps, whereSql);
                foreach (DataRow row in dt.Rows)
                {
                    ItemDataValueStruct idvs = new ItemDataValueStruct();
                    idvs.value = row[0];
                    values.Add(idvs);
                }
                return values;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 获取趋势图形的数据
        /// </summary>
        /// <param name="reportAuditCellConclusion"></param>
        /// <param name="indexTrendStruct"></param>
        /// <returns></returns>
        public ChartDataStruct GetIndexTrendChartData(ReportAuditCellConclusion reportAuditCellConclusion, IndexTrendStruct indexTrendStruct)
        {
            try
            {
                List< Dictionary<string,decimal>> data = GetIndexTrendData(reportAuditCellConclusion, indexTrendStruct);
                ChartDataStruct cds = new ChartDataStruct();                
                string suffix = reportCycleService.GetReportCycleSuffix(reportAuditCellConclusion.ReportType);
                int i = 0;
                foreach (Dictionary<string,decimal> chartDatas in data)
                {
                    SeriesData sd = new SeriesData();
                    foreach (string cycle in chartDatas.Keys)
                    {
                        if (i == 0)
                        {
                            cds.XSeries.Add(cycle + suffix);
                        }
                        sd.seriesData.Add(chartDatas[cycle]);
                    }
                    cds.series.Add(sd);                   
                    i++;
                }               
                return cds;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// 获取相关指标的趋势
        /// </summary>
        /// <param name="reportAuditCellConclusion"></param>
        /// <param name="indexTrendStruct"></param>
        /// <returns></returns>
        public List<Dictionary<string, decimal>> GetIndexTrendData(ReportAuditCellConclusion reportAuditCellConclusion, IndexTrendStruct indexTrendStruct)
        {
            try
            {
                List<Dictionary<string, decimal>> result = new List<Dictionary<string, decimal>>();
                StringBuilder sql = new StringBuilder();
                StringBuilder whereSql = new StringBuilder();
                string[] codes=reportAuditCellConclusion.CellCode.Split(',');//单元格内码
                
                string[] primaries =null;//变动格标识
                if(!StringUtil.IsNullOrEmpty(reportAuditCellConclusion.BdPrimary)){
                    primaries = reportAuditCellConclusion.BdPrimary.Split(';');
                }



                sql.Append("SELECT * FROM CT_FORMAT_DATAITEM WHERE DATAITEM_REPORTID='" + reportAuditCellConclusion.ReportId + "' AND DATAITEM_CODE IN(" + StringUtil.ConvertArrayStringToInSql(codes) + ") AND DATAITEM_CELLDATATYPE='"+ ReportGlobalConst.DATATYPE_NUMBER+"'");
                List<DataItemEntity> items = dbManager.ExecuteSqlReturnTType<DataItemEntity>(sql.ToString());

              
               

                //获取指标的数据趋势
                if (items.Count>0)
                {
                    int i = 0;
                    foreach (string code in codes)
                    {
                        sql.Length = 0;
                        whereSql.Length = 0;
                        //获取周期
                        ReportCycleStruct rcs = new ReportCycleStruct();
                        rcs.CurrentNd = reportAuditCellConclusion.Year;
                        rcs.CurrentZq = reportAuditCellConclusion.Cycle;
                        rcs.ReportType = reportAuditCellConclusion.ReportType;
                        List<string> cycles = reportCycleService.GetReportCyclesByDurationType(rcs, indexTrendStruct.DurationType);
                        string tableName = "";
                        //获取当前指标的表格名
                        foreach (DataItemEntity item in items)
                        {
                            if (item.Code == code)
                            {
                                tableName = item.TableName;
                                break;
                            }
                        }
                        //创建周期数据
                        whereSql.Append(" AND ");
                        whereSql.Append(" DATA_CYCLE ");
                        whereSql.Append(" IN (");
                        foreach (string c in cycles)
                        {
                            //创建数据
                            whereSql.Append("'");
                            whereSql.Append(c);
                            whereSql.Append("'");
                            whereSql.Append(",");
                        }

                        //初始化单个指标的数据
                        Dictionary<string, decimal> chart = new Dictionary<string, decimal>();
                        foreach (string c in cycles)
                        {
                            chart.Add(c, 0);
                        }
                        result.Add( chart);


                        if (whereSql.Length > 0)
                        {
                            whereSql.Length--;
                            whereSql.Append(") ");
                        }
                        //创建获取数据的SQL
                        sql.Length = 0;
                        sql.Append("SELECT ");
                        sql.Append("DATA_CYCLE");
                        sql.Append(",");                       
                        sql.Append("[");
                        sql.Append(code);
                        sql.Append("] ");
                       

                        sql.Append(" FROM ");
                        sql.Append(tableName);
                        sql.Append(" WHERE 1=1 ");

                        if (ReportGlobalConst.IsOrNotRelationTaskAndPaper)
                        {
                            sql.Append(" AND  DATA_TASKID='" + reportAuditCellConclusion.TaskId + "' AND DATA_MANUSCRIPT='" + reportAuditCellConclusion.PaperId + "' AND DATA_COMPANYID='" + reportAuditCellConclusion.CompanyId + "' AND DATA_REPORTID='" + reportAuditCellConclusion.ReportId + "' AND DATA_YEAR='" + reportAuditCellConclusion.Year + "'");
                        }
                        else
                        {
                            sql.Append(" AND  DATA_COMPANYID='" + reportAuditCellConclusion.CompanyId + "' AND DATA_REPORTID='" + reportAuditCellConclusion.ReportId + "' AND DATA_YEAR='" + reportAuditCellConclusion.Year + "'");

                        }
                        //获取变动区数据标识
                        if (primaries!=null&&!StringUtil.IsNullOrEmpty(primaries[i]))
                        {
                            CreateReportBdPrimariesWhereSql(primaries[i], whereSql);
                        }
                        sql.Append(whereSql.ToString());

                        DataTable dt = dbManager.ExecuteSqlReturnDataTable(sql.ToString());

                        foreach (DataRow row in dt.Rows)
                        {
                            foreach (DataColumn column in dt.Columns)
                            {
                                if (column.ColumnName == "DATA_CYCLE") continue;
                                if (!StringUtil.IsNullOrEmpty(row[column.ColumnName]))
                                {
                                    chart[Convert.ToString(row[0])] = Convert.ToDecimal(row[column.ColumnName]);
                                }
                                else
                                {
                                    chart[Convert.ToString(row[0])] = 0;
                                }
                            }
                          
                        }
                        i++;
                    }
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        //private DataTable GetSameTableData(string[]Codes
        /// <summary>
        /// 获取指标构成属性
        /// </summary>
        /// <param name="reportAuditCellConclusion"></param>
        /// <param name="indexConstitution"></param>
        /// <returns></returns>
        public List<IndexConstitutionCellDifinition> GetIndexConstitutionCellDefinitionData(ReportAuditCellConclusion reportAuditCellConclusion, IndexConstitutionStruct indexConstitution)
        {
            try
            {
                StringBuilder sql = new StringBuilder();
                //获取指标
                foreach (IndexConstitutionCellDifinition iccd in indexConstitution.Indexs)
                {
                    sql.Length = 0;
                    //获取
                    sql.Append("SELECT ");
                    sql.Append(" * ");
                    sql.Append(" FROM ");
                    sql.Append("CT_FORMAT_DATAITEM ");
                    sql.Append(" WHERE ");
                    sql.Append(" DATAITEM_REPORTID ='");
                    sql.Append(iccd.Parameters.ReportId);
                    sql.Append("'");
                    sql.Append(" AND ");
                    sql.Append(" DATAITEM_CODE='");
                    sql.Append(iccd.IndexCode);
                    sql.Append("'");

                    List<DataItemEntity> dies = dbManager.ExecuteSqlReturnTType<DataItemEntity>(sql.ToString());
                    if (dies.Count > 0)
                    {
                        sql.Length = 0;
                        sql.Append("SELECT ");
                        sql.Append("[");
                        sql.Append(iccd.IndexCode);
                        sql.Append("] ");
                        sql.Append(" FROM ");
                        sql.Append(dies[0].TableName);
                        //创建Where条件
                       
                        //创建Where条件
                        if (ReportGlobalConst.IsOrNotRelationTaskAndPaper)
                        {
                            if (StringUtil.IsNullOrEmpty(iccd.Parameters.TaskId))
                            {
                                iccd.Parameters.TaskId = reportAuditCellConclusion.TaskId;
                            }
                            if (StringUtil.IsNullOrEmpty(iccd.Parameters.PaperId))
                            {
                                iccd.Parameters.PaperId = reportAuditCellConclusion.PaperId;
                            }
                        }

                        if (StringUtil.IsNullOrEmpty(iccd.Parameters.ReportId))
                        {
                            iccd.Parameters.ReportId = reportAuditCellConclusion.ReportId;
                        }
                        if (StringUtil.IsNullOrEmpty(iccd.Parameters.CompanyId))
                        {
                            iccd.Parameters.CompanyId = reportAuditCellConclusion.CompanyId;
                        }
                        if (StringUtil.IsNullOrEmpty(iccd.Parameters.Year))
                        {
                            iccd.Parameters.Year = reportAuditCellConclusion.Year;
                        }
                        if (StringUtil.IsNullOrEmpty(iccd.Parameters.Cycle))
                        {
                            iccd.Parameters.Cycle = reportAuditCellConclusion.Cycle;
                        }

                       sql.Append( CreateWhereSql(iccd.Parameters));
                          
                        if (!StringUtil.IsNullOrEmpty(reportAuditCellConclusion.BdPrimary))
                        {
                            CreateReportBdPrimaryWhereSql(reportAuditCellConclusion.BdPrimary, sql);

                        }
                        DataTable itemData = dbManager.ExecuteSqlReturnDataTable(sql.ToString());
                        if (itemData != null && itemData.Rows.Count > 0)
                        {
                            iccd.value = itemData.Rows[0][0];
                        }
                        else {
                            iccd.value = "";
                        }

                    }
                }
                return indexConstitution.Indexs;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        
        }
        /// <summary>
        /// 报表审计
        /// </summary>
        /// <param name="reportAuditCellConclusion"></param>
        /// <param name="companies"></param>
        /// <returns></returns>
        public List<CompanyItemStruct> GetAggregationReportCellConstituteData(ReportAuditCellConclusion reportAuditCellConclusion, List<CompanyItemStruct> companies)
        {
            try
            {
                List<CompanyItemStruct> result = new List<CompanyItemStruct>();
                Dictionary<string, CompanyItemStruct> dic = new Dictionary<string, CompanyItemStruct>();
                string[] codes = reportAuditCellConclusion.CellCode.Split(',');
                string[] primaries = reportAuditCellConclusion.BdPrimary.Split(';');
                foreach (CompanyItemStruct c in companies)
                {
                    dic.Add(c.id, c);
                }
                StringBuilder sql = new StringBuilder();
                sql.Append("SELECT ");
                sql.Append(" * ");
                sql.Append(" FROM ");
                sql.Append("CT_FORMAT_DATAITEM ");
                sql.Append(" WHERE ");
                sql.Append(" DATAITEM_REPORTID ='");
                sql.Append(reportAuditCellConclusion.ReportId);
                sql.Append("'");
                sql.Append(" AND ");
                sql.Append(" DATAITEM_CODE IN (");
                sql.Append(StringUtil.ConvertArrayStringToInSql(codes));
                sql.Append(")");


                 List<DataItemEntity> dies = dbManager.ExecuteSqlReturnTType<DataItemEntity>(sql.ToString());
                 if (dies.Count > 0)
                 {
                     ReportDataParameterStruct rdps = new ReportDataParameterStruct();
                     sql.Length = 0;
                     sql.Append("SELECT ");
                     int m = 0;
                     foreach (string code in codes)
                     {
                         sql.Append("[");
                         sql.Append(code);
                         sql.Append("] ");
                         sql.Append(" AS ");
                         sql.Append("[");
                         sql.Append(code+m.ToString());
                         sql.Append("]");
                         sql.Append(",");                         
                         m++;
                     }                    
                    
                     sql.Append("DATA_COMPANYID");

                     AddPrimaryCell(sql, primaries);
                     sql.Append(" FROM ");
                     sql.Append(dies[0].TableName);
                     CreateAggregationCellConstituteWhereSql(sql, reportAuditCellConclusion, companies);
                     DataTable itemData = dbManager.ExecuteSqlReturnDataTable(sql.ToString());
                     foreach (DataRow row in itemData.Rows)
                     {
                         string companyId = Convert.ToString(row[codes.Length]);
                         if (!StringUtil.IsNullOrEmpty(companyId))
                         {
                             int i = 0;
                             foreach (string code in codes)
                             {
                                 if (!StringUtil.IsNullOrEmpty(row[code + i.ToString()]))
                                 {
                                     if (!StringUtil.IsNullOrEmpty(primaries[i]))
                                     {
                                         string[] pArr = primaries[i].Split(',');
                                         bool flag = true;
                                         foreach (string p in pArr)
                                         {
                                             string[] nv = p.Split(':');
                                             if (row[nv[0]].ToString() != nv[1])
                                             {
                                                 flag = false;
                                                 break;
                                             }
                                         }
                                         if (flag) dic[companyId].values[code + primaries[i]] = row[code + i.ToString()];
                                     }
                                     else
                                     {
                                         dic[companyId].values[code + primaries[i]] = row[code + i.ToString()];
                                     }
                                     
                                 }
                                 else
                                 {
                                     dic[companyId].values[code+primaries[i]] = "";
                                 }
                                 i++;
                             }
                            
                            
                         }
                       
                     }
                 }
                 
                 foreach (CompanyItemStruct cis in dic.Values)
                 {
                     result.Add(cis);
                 }
                 return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        private void AddPrimaryCell(StringBuilder sql, string[] primaries)
        {
            try
            {
                int i = 0;
                foreach (string p in primaries)
                {
                    if (StringUtil.IsNullOrEmpty(p)) continue;
                    if (i == 0) sql.Append(",");
                    string[] pArr = p.Split(',');
                    foreach (string pi in pArr)
                    {
                        string[] nv = pi.Split(':');
                        sql.Append("[");
                        sql.Append(nv[0]);
                        sql.Append("]");
                        sql.Append(",");

                    }
                    i++;
                }
                if (i > 0) sql.Length--;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 汇总单元格数据构成
        /// </summary>
        /// <param name="sql"></param>
        /// <param name="racc"></param>
        /// <param name="companies"></param>
        private void CreateAggregationCellConstituteWhereSql(StringBuilder sql, ReportAuditCellConclusion racc, List<CompanyItemStruct> companies)
        {
            try
            {
                sql.Append(" WHERE 1=1 ");
                if (ReportGlobalConst.IsOrNotRelationTaskAndPaper)
                {
                    if (!StringUtil.IsNullOrEmpty(racc.TaskId))
                    {
                        sql.Append(" AND ");
                        sql.Append(" DATA_TASKID ");
                        sql.Append("=");
                        sql.Append("'");
                        sql.Append(racc.TaskId);
                        sql.Append("'");
                    }

                     if (!StringUtil.IsNullOrEmpty(racc.PaperId))
                    {
                        sql.Append(" AND ");
                        sql.Append(" DATA_MANUSCRIPT ");
                        sql.Append("=");
                        sql.Append("'");
                        sql.Append(racc.PaperId);
                        sql.Append("'");
                    }
                }

                if (!StringUtil.IsNullOrEmpty(racc.ReportId))
                {
                    sql.Append(" AND ");
                    sql.Append(" DATA_REPORTID ");
                    sql.Append("=");
                    sql.Append("'");
                    sql.Append(racc.ReportId);
                    sql.Append("'");
                }


                if (!StringUtil.IsNullOrEmpty(racc.Year))
                {
                    sql.Append(" AND ");
                    sql.Append(" DATA_YEAR ");
                    sql.Append("=");
                    sql.Append("'");
                    sql.Append(racc.Year);
                    sql.Append("'");
                }


                if (!StringUtil.IsNullOrEmpty(racc.Cycle))
                {
                    sql.Append(" AND ");
                    sql.Append(" DATA_CYCLE ");
                    sql.Append("=");
                    sql.Append("'");
                    sql.Append(racc.Cycle);
                    sql.Append("'");
                }
                if (!StringUtil.IsNullOrEmpty(racc.BdPrimary))
                {                    
                    CreateReportBdPrimariesWhereSql(racc.BdPrimary, sql);

                }
                if (companies.Count > 0)
                {
                    sql.Append(" AND ");
                    sql.Append(" DATA_COMPANYID ");
                    sql.Append(" IN ");
                    sql.Append("(");
                    foreach (CompanyItemStruct cis in companies)
                    {
                        sql.Append("'");
                        sql.Append(cis.id);
                        sql.Append("'");
                        sql.Append(",");
                    }
                    sql.Length--;
                    sql.Append(")");
                }
              

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

    }
}
