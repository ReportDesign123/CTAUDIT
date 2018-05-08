using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditSPI.Analysis;
using DbManager;
using AuditEntity;
using System.Data;
using CtTool;
using CtTool.BB;
using AuditSPI;
using AuditSPI.ReportData;
using AuditEntity.AuditPaper;
using AuditEntity.AuditTask;



namespace AuditService.Analysis.Formular
{
    //BBHLQS(bbCode:01;company:01;task:01;paper:02;cells:00030002;nd:2014;zq:07;IsOrNotSwap:1)

    public  class ReportRowColFormularAnalysis:IFormularDeserialize
    {
         CTDbManager dbManager;
        LinqDataManager linqDbManager;
        ReportDataParameterStruct rdps = new ReportDataParameterStruct();
        MacroHelp mh;
        public ReportRowColFormularAnalysis()
        {
            if (dbManager == null)
            {
                dbManager = new CTDbManager();
            }
            if (mh == null)
            {
                mh = new MacroHelp();
            }
            if (linqDbManager == null)
            {
                linqDbManager = new LinqDataManager();
            }
        }
        public DataTable DeserializeToSql(FormularEntity fe)
        {
            try
            {
                DataTable dt = new DataTable();
                string reportFormular = fe.content;
                reportFormular = mh.ReplaceMacroVariable(reportFormular);
                string[] paras = reportFormular.Split(';');
                Dictionary<string, string> parameters = new Dictionary<string, string>();
                foreach (string para in paras)
                {
                    string[] arr = para.Split(':');
                    parameters.Add(arr[0], arr[1]);
                   
                }
                if (rdps != null)
                {

                    if (StringUtil.IsNullOrEmpty(parameters["company"]))
                    {                       
                        parameters["company"] = rdps.CompanyId;
                    }
                    if (StringUtil.IsNullOrEmpty(parameters["nd"]))
                    {
                        parameters["nd"] = rdps.Year;
                    }
                    if (StringUtil.IsNullOrEmpty(parameters["zq"]))
                    {
                        parameters["zq"] = rdps.Cycle;
                    }
                    if(int.Parse(parameters["zq"])<0)
                    {
                        try
                        {
                            parameters["zq"] = (int.Parse(rdps.Cycle) + int.Parse(parameters["zq"])).ToString();
                        }
                        catch
                        {
                           int intMonth= int.Parse(rdps.Cycle.Substring(5,2)) + int.Parse(parameters["zq"]);
                           parameters["zq"] = rdps.Cycle.Substring(0, 5) + intMonth.ToString();
                        }
                        
                    }
                    if (StringUtil.IsNullOrEmpty(parameters["task"]))
                    {
                        parameters["task"] = rdps.TaskId;
                    }
                    if (StringUtil.IsNullOrEmpty(parameters["paper"]))
                    {
                        parameters["paper"] = rdps.PaperId;
                    }
                   
                }
                if (!StringUtil.IsNullOrEmpty(parameters["cells"]))
                {
                    parameters["cells"] = Base64.Decode64(parameters["cells"]);
                }
                //存储单元格
                StringBuilder selectCodes = new StringBuilder();

               
                string sql = "";
                if (!StringUtil.IsNullOrEmpty(parameters["task"]))
                {
                    sql = "SELECT AUDITTASK_ID  FROM CT_TASK_AUDITTASK WHERE AUDITTASK_CODE='" + parameters["task"] + "'";
                    List<AuditTaskEntity> tlists = dbManager.ExecuteSqlReturnTType<AuditTaskEntity>(sql);                    
                    parameters["task"] = tlists[0].Id;
                }
                if (!StringUtil.IsNullOrEmpty(parameters["paper"]))
                {
                    sql = "SELECT AUDITPAPER_ID  FROM CT_PAPER_AUDITPAPER WHERE AUDITPAPER_CODE='" + parameters["paper"] + "'";
                    List<AuditPaperEntity> tlists = dbManager.ExecuteSqlReturnTType<AuditPaperEntity>(sql);
                    parameters["paper"] = tlists[0].Id;
                }
                if (!StringUtil.IsNullOrEmpty(parameters["company"]))
                {
                    sql = "SELECT LSBZDW_ID  FROM LSBZDW WHERE LSBZDW_DWBH='" + parameters["company"] + "'";
                    List<CompanyEntity> tlists = dbManager.ExecuteSqlReturnTType<CompanyEntity>(sql);
                    parameters["company"] = tlists[0].Id;
                }
                if (!StringUtil.IsNullOrEmpty(parameters["bbCode"]))
                {
                    sql = "SELECT REPORTDICTIONARY_ID  FROM CT_FORMAT_REPORTDICTIONARY WHERE REPORTDICTIONARY_CODE='" + parameters["bbCode"] + "'";
                    List<ReportFormatDicEntity> tlists = dbManager.ExecuteSqlReturnTType<ReportFormatDicEntity>(sql);
                    parameters["bbCode"] = tlists[0].Id;
                }

                string whereSql = " WHERE DATA_TASKID='" + parameters["task"] + "' AND DATA_MANUSCRIPT='" + parameters["paper"] + "' AND DATA_COMPANYID='" + parameters["company"] + "' AND DATA_REPORTID='" + parameters["bbCode"] + "' AND DATA_YEAR='" + parameters["nd"] + "' AND DATA_CYCLE='" + parameters["zq"] + "'"; 

          
                string tableNamee = GetNmStringByRowCol(parameters["cells"], parameters["bbCode"], selectCodes);
                sql = "SELECT " + selectCodes.ToString() + " FROM " + tableNamee + whereSql;

                DbDataSourceInstance ddsi = DBTool.GetDataSource(fe.FormularDb, dbManager);
                dt = ddsi.ExecuteSqlReturnDataTable(sql);
                if (parameters.ContainsKey("IsOrNotSwap") && !StringUtil.IsNullOrEmpty(parameters["IsOrNotSwap"]))
                {
                    if (parameters["IsOrNotSwap"] == "1")
                    {
                        dt = SwapRowCol(dt);
                    }
                }
                
                return dt;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 根据行列内码获取
        /// </summary>
        /// <param name="cells"></param>
        /// <returns></returns>
        private string GetNmStringByRowCol(string cells,string reportId,StringBuilder selectCodes)
        {
            try
            {
                string tableName="";
                string[] cellsRC = cells.Split(';');
                List<DataItemEntity> items = new List<DataItemEntity>();
                StringBuilder sql = new StringBuilder();
                Dictionary<string, DataItemEntity> itemsMap = new Dictionary<string, DataItemEntity>();
                foreach (string cellRc in cellsRC)
                {
                    if (cellRc.IndexOf(":") != -1)
                    {
                        //解析块对象
                        string temp = cellRc.Substring(1, cellRc.Length - 2);
                        string[] beforeAfter = temp.Split(':');
                        int[] beforeRowCol = DeserializeCellRowCol(beforeAfter[0],false);
                        int[] afterRowCol = DeserializeCellRowCol(beforeAfter[1],false);
                        for (int i = beforeRowCol[0]; i <= afterRowCol[0]; i++)
                        {
                            for (int j = beforeRowCol[1]; j <= afterRowCol[1]; j++)
                            {
                                DataItemEntity item = new DataItemEntity();
                                item.Row = i;
                                item.Col = j;
                                items.Add(item);
                                itemsMap.Add(FormatTool.CreateRowColIndex(i, j), item);
                            }
                        }
                    }
                    else
                    {
                        //解析单个对象
                        int[] rowCol = DeserializeCellRowCol(cellRc,true);
                        DataItemEntity item = new DataItemEntity();
                        item.Row = rowCol[0];
                        item.Col = rowCol[1];
                        items.Add(item);
                        itemsMap.Add(FormatTool.CreateRowColIndex(item.Row, item.Col), item);
                    }
                
                }

                //形成SQL
                sql.Append("SELECT ");
                sql.Append(" DATAITEM_CODE,DATAITEM_TABLENAME,DATAITEM_ROW,DATAITEM_COL ");
                sql.Append(" FROM ");
                sql.Append(" CT_FORMAT_DATAITEM ");
                sql.Append(" WHERE ");
                sql.Append(" DATAITEM_REPORTID ='");
                sql.Append(reportId);
                sql.Append("' ");
                int index = 0;
                foreach (DataItemEntity item in items)
                {
                    if (index == 0) sql.Append(" AND (");
                    else sql.Append(" OR ");
                    sql.Append("(");
                    sql.Append("DATAITEM_ROW");
                    sql.Append("=");
                    sql.Append(item.Row);
                    sql.Append(" AND ");
                    sql.Append("DATAITEM_COL");
                    sql.Append("=");
                    sql.Append(item.Col);
                    sql.Append(")");
                    index++;
                }
                sql.Append(")");
               List<DataItemEntity> itemSets=dbManager.ExecuteSqlReturnTType<DataItemEntity>(sql.ToString());
                sql.Length = 0;
                foreach (DataItemEntity i in itemSets)
                {
                    if (tableName=="")
                        tableName = i.TableName;
                    itemsMap[FormatTool.CreateRowColIndex(i.Row, i.Col)] = i;
                }
                foreach (string key in itemsMap.Keys)
                {
                    selectCodes.Append("[");
                    selectCodes.Append(itemsMap[key].Code);
                    selectCodes.Append("]");
                    selectCodes.Append(",");
                }
                
                if (selectCodes.Length > 0) selectCodes.Length--;
                return tableName;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 解析行列数据
        /// </summary>
        /// <param name="cellRowCol"></param>
        /// <returns></returns>
        private int[] DeserializeCellRowCol(string cellRowCol,bool flag)
        {
            try
            {
                if (flag)
                {
                    cellRowCol = cellRowCol.Substring(1, cellRowCol.Length - 2);
                }
                
                string[] rowCol = cellRowCol.Split(',');
                int[] rowCols = new int[2];
                rowCols[0] = Convert.ToInt32(rowCol[0]);
                rowCols[1] = Convert.ToInt32(rowCol[1]);
                return rowCols;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 行列互换
        /// </summary>
        /// <param name="data"></param>
        private DataTable SwapRowCol(DataTable data)
        {
            try
            {
                DataTable tempTable = new DataTable();
                int rows = data.Columns.Count;
                int cols = data.Rows.Count;

                for (int t = 0; t < cols; t++)
                {
                    DataColumn dc = new DataColumn();
                    dc.DataType = typeof(object);
                    dc.ColumnName = t.ToString();
                    tempTable.Columns.Add(dc);
                }
                for (int row = 0; row < rows; row++)
                {
                    DataRow rowData = tempTable.NewRow();
                    for (int col = 0; col < cols; col++)
                    {
                        rowData[col] = data.Rows[col][row];
                    }
                    tempTable.Rows.Add(rowData);
                }
                return tempTable;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public void SetReportParameters(AuditSPI.ReportData.ReportDataParameterStruct rdps)
        {
            this.rdps = rdps;
            mh.ReportParameter = rdps;
        }
    }
}
