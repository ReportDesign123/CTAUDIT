using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditSPI.Analysis;
using DbManager;
using AuditEntity;
using System.Data;
using CtTool;
using AuditSPI;
using AuditSPI.ReportData;
using AuditEntity.AuditPaper;
using AuditEntity.AuditTask;



namespace AuditService.Analysis.Formular
{

    //BBQS(bbCode:01;company:01;task:01;paper:02;cells:00030002;nd:2014;zq:07;IsOrNotSwap:1)
    class ReportFormularAnalysis:IFormularDeserialize
    {
        CTDbManager dbManager;
        LinqDataManager linqDbManager;
        ReportDataParameterStruct rdps = new ReportDataParameterStruct();
        MacroHelp mh;
        public ReportFormularAnalysis()
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
                    if (StringUtil.IsNullOrEmpty(parameters["task"]))
                    {
                        parameters["task"] = rdps.TaskId;
                    }
                    if (StringUtil.IsNullOrEmpty(parameters["paper"]))
                    {
                        parameters["paper"] = rdps.PaperId;
                    }
                }
                StringBuilder itemCodes = new StringBuilder();
                StringBuilder selectCodes = new StringBuilder();
                string[] nmArr = parameters["cells"].Split(',');
                foreach (string nm in nmArr)
                {
                    itemCodes.Append("'");
                    itemCodes.Append(nm);
                    itemCodes.Append("'");
                    itemCodes.Append(",");

                    selectCodes.Append("[");
                    selectCodes.Append(nm);
                    selectCodes.Append("]");
                    selectCodes.Append(",");
                }
                itemCodes.Length--;
                selectCodes.Length--;
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

                string whereSql = " WHERE DATA_TASKID='" + parameters["task"] + "' AND DATA_MANUSCRIPT='" + parameters["paper"] + "' AND DATA_COMPANYID='" + parameters["company"] + "' AND DATA_REPORTID='" + parameters["bbCode"] + "' AND DATA_YEAR='" + parameters["nd"] + "' AND DATA_CYCLE='" + parameters["zq"] + "'"; ;

                sql = "SELECT * FROM CT_FORMAT_DATAITEM WHERE DATAITEM_REPORTID='" + parameters["bbCode"] + "' AND  DATAITEM_CODE IN ("+itemCodes.ToString()+") ";
                List<DataItemEntity> items = dbManager.ExecuteSqlReturnTType<DataItemEntity>(sql);
                string tableNamee = items[0].TableName;
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
