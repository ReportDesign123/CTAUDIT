using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditSPI.Format;
using AuditSPI;
using DbManager;
using System.Data.Common;
using AuditEntity;
using CtTool;
using AuditService.Analysis.Formular;
using CtTool.BB;
using System.Data;
using AuditService.ReportData;
using AuditSPI.ReportData;
using System.Text.RegularExpressions;
using AuditEntity.ReportState;
using AuditService.ReportState;
using GlobalConst;
using AuditSPI.Analysis;

namespace AuditService
{
    public  class FormularService:IFormular
    {

        public CTDbManager dbManager;
        FormularAnalysisFactory formularFactory;
        FillReportService fillReportService;
        LinqDataManager linqDbManager;
        ReportStateService reportStateService;
        ReportVerifyService reportVerifyService;
        ReportProcessManager reportProcessManager;
        public FormularService()
        {
            dbManager = new CTDbManager();
            formularFactory = new FormularAnalysisFactory();
            fillReportService = new FillReportService();
            linqDbManager = new LinqDataManager();
            if (reportStateService == null)
            {
                reportStateService = new ReportStateService();
            }
            if (reportVerifyService == null)
            {
                reportVerifyService = new ReportVerifyService();
            }
            reportProcessManager = new ReportProcessManager();
        }
        /// <summary>
        /// 公式保存
        /// </summary>
        /// <param name="formulars"></param>
        /// <param name="formularStr"></param>
        public void SaveFormulars(List<AuditEntity.FormularEntity> formulars, string formularStr,string reportCode)
        {
            //获取报表的单元格信息
            string sql = "SELECT REPORTDICTIONARY_DATAINFO FROM CT_FORMAT_REPORTDICTIONARY WHERE REPORTDICTIONARY_CODE='" + reportCode + "'";
            List<ReportFormatDicEntity> reports = dbManager.ExecuteSqlReturnTType<ReportFormatDicEntity>(sql);
            BBData bbData = JsonTool.DeserializeObject<BBData>(reports[0].itemStr);

             DbConnection connection = dbManager.GetDbConnection();
            DbCommand command = dbManager.getDbCommand();
            dbManager.Open();
            DbTransaction transactoin = connection.BeginTransaction();    
            try{
                command.Transaction = transactoin;
                //保存公式列表
                string deleteSql = "DELETE FROM CT_FORMULAR WHERE FORMULAR_REPORTCODE='" + reportCode + "' ";
                command.CommandText = deleteSql;
                command.ExecuteNonQuery();

                foreach (FormularEntity fe in formulars)
                {
                    if (StringUtil.IsNullOrEmpty(fe.Id))
                    {
                        fe.Id = Guid.NewGuid().ToString();
                    }
                    fe.ReportCode = reportCode;
                    fe.Creater = SessoinUtil.GetCurrentUser().Id;
                    fe.CreateTime = SessoinUtil.GetCurrentDateTime();
                    if (fe.isOrNotCaculate == "1" || fe.isOrNotBatch == "1")
                    {
                        if (!fe.content.Contains("CCGC"))
                            fe.DeserializeContent = DeserializeFormular(fe, bbData);
                        
                    }

                    fe.content = Base64.Encode64(fe.content);
                    if (fe.FixOrChangeRegion == "F")
                    {
                        fe.RegionTableName = FormatTool.CreateBBTableName(fe.RegionTableName, true, 1, null);
                    }
                    else if (fe.FixOrChangeRegion == "R")
                    {
                        string[] codes = fe.RegionTableName.Split(',');
                        fe.RegionTableName=FormatTool.CreateBBTableName(codes[0],false,1,codes[1]);
                    }
                    else if (fe.FixOrChangeRegion == "C")
                    {
                        string[] codes = fe.RegionTableName.Split(',');
                        fe.RegionTableName = FormatTool.CreateBBTableName(codes[0], false, 1, codes[1]);
                    }
                    List<DbParameter> parameters=new List<DbParameter>();
                    sql = dbManager.ConvertBeanToInsertCommandSql<FormularEntity>(fe, parameters);
                    foreach (DbParameter p in parameters)
                    {
                        command.Parameters.Add(p);
                    }
                    command.CommandText = sql;
                    command.ExecuteNonQuery();
                    command.Parameters.Clear();
                }

               
                //保存公式列表信息
                if (StringUtil.IsNullOrEmpty(formularStr)) return;
                formularStr = Base64.Encode64(formularStr);
                string upSql = "UPDATE CT_FORMAT_REPORTDICTIONARY SET REPORTDICTIONARY_FORMULARINFO='"+formularStr+"' WHERE REPORTDICTIONARY_CODE='"+reportCode+"'";
                command.CommandText = upSql;
                command.ExecuteNonQuery();

                transactoin.Commit();
                dbManager.Close();
            }
            catch (Exception ex)
            {
                transactoin.Rollback();
                command.Parameters.Clear();
                dbManager.Close();
                throw ex;
            }
        }

        public string DeserializeCellFormular(string formular)
        {
            string formularContent = formular;
            StringBuilder sb = new StringBuilder();
            int startIndex, lastIndex;
            startIndex = 0;
            lastIndex = 0;
            while (formularContent.IndexOf("[") != -1)
            {
                startIndex = formularContent.IndexOf("[");
                lastIndex = formularContent.IndexOf("]", startIndex);
                string formularCell = formularContent.Substring(startIndex + 1, lastIndex - startIndex - 1);

                if (formularCell.IndexOf(":") != -1)
                {
                    string[] befAft = formularCell.Split(':');
                    string[] befCell = befAft[0].Split(',');
                    string[] aftCell = befAft[1].Split(',');
                    int befRow = Convert.ToInt32(befCell[0]);
                    int befCol = Convert.ToInt32(befCell[1]);

                    int aftRow = Convert.ToInt32(aftCell[0]);
                    int aftCol = Convert.ToInt32(aftCell[1]);
                    for (int i = befRow; i <= aftRow; i++)
                    {
                        for (int j = befCol; j <= aftCol; j++)
                        {
                            string code = i.ToString() + "," + j.ToString();
                            sb.Append(code);
                            sb.Append(";");
                        }
                    }
                }
                else
                {
                    sb.Append(formularCell);
                    sb.Append(";");
                }

                formularContent = formularContent.Substring(lastIndex + 1);
            }
            if (sb.Length > 0) sb.Length--;
            return sb.ToString();
        }
        public string DeserializeFormular(FormularEntity fe,BBData bbData)
        {
            try
            {
                string formularContent=fe.content;

                StringBuilder sb = new StringBuilder();
                int startIndex,lastIndex;
                startIndex=0;
                lastIndex=0;
                while (formularContent.IndexOf("[") != -1)
                {
                    startIndex = formularContent.IndexOf("[");
                    lastIndex = formularContent.IndexOf("]", startIndex);
                    string formularCell = formularContent.Substring(startIndex + 1, lastIndex - startIndex - 1);
                    if (fe.isOrNotCaculate == "1")
                    {
                        if (formularCell.IndexOf(":") != -1)
                        {
                            string[] befAft = formularCell.Split(':');
                            string[] befCell = befAft[0].Split(',');
                            string[] aftCell = befAft[1].Split(',');
                            int befRow = Convert.ToInt32(befCell[0]);
                            int befCol = Convert.ToInt32(befCell[1]);

                            int aftRow = Convert.ToInt32(aftCell[0]);
                            int aftCol = Convert.ToInt32(aftCell[1]);
                            for (int i = befRow; i <= aftRow; i++)
                            {
                                for (int j = befCol; j <= aftCol; j++)
                                {
                                    string code = i.ToString() + "," + j.ToString();
                                    sb.Append(code);
                                    sb.Append(";");
                                }
                            }
                        }
                        else
                        {
                            sb.Append(formularCell);
                            sb.Append(";");
                        }
                       
                    }
                    else if (fe.isOrNotBatch == "1")
                    {
                        sb.Append(formularCell);
                        sb.Append(";");
                    }
                   
                    
                    formularContent = formularContent.Substring(lastIndex + 1);
                }
                if (sb.Length > 0) sb.Length--;
                return sb.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        private string CreateNm(string nmstr)
        {
            try
            {
                string[] nms = nmstr.Split(',');
                return nms[0].PadLeft(4, '0') + nms[1].PadLeft(4, '0');
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 获取报表内码
        /// </summary>
        /// <param name="nmstr"></param>
        /// <param name="bbData"></param>
        /// <returns></returns>
        private string CreateNm(string nmstr,BBData bbData)
        {
            try
            {
                string[] nms = nmstr.Split(',');
                return bbData.bbData[Convert.ToInt16(nms[0])][Convert.ToInt16(nms[1])].CellCode;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 获取报表Cell信息
        /// </summary>
        /// <param name="nmstr"></param>
        /// <param name="bbData"></param>
        /// <returns></returns>
        private Cell CreateCell(string nmstr,BBData bbData){
            try
            {
                 string[] nms = nmstr.Split(',');
                 return bbData.bbData[Convert.ToInt16(nms[0])][Convert.ToInt16(nms[1])];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 获取报表内码
        /// </summary>
        /// <param name="row"></param>
        /// <param name="col"></param>
        /// <param name="bbData"></param>
        /// <returns></returns>
        private string GetNm(int row, int col, BBData bbData)
        {
            try
            {
                return bbData.bbData[row][col].CellCode;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public List<DataSourceEntity> GetDataSourceList()
        {
            try
            {
                string sql = "SELECT * FROM CT_BASIC_DATASOURCE";
                List<DataSourceEntity> lists = dbManager.ExecuteSqlReturnTType<DataSourceEntity>(sql);
                return lists;
            }
            catch (Exception ex)
            { 
                throw ex;
            }
        }
        /// <summary>
        /// 获取单个公式的公式内容
        /// </summary>
        /// <param name="rdps"></param>
        /// <returns></returns>
        public DataTable GetSingleFatchFormularData(ReportDataParameterStruct rdps,FormularEntity fe)
        {
            try
            {
                formularFactory.SetReportParameters(rdps);
                DataTable dt = formularFactory.DeserializeToSql(fe);
                return dt;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 报表取数
        /// </summary>
        /// <param name="rds"></param>
        public void DeserializeFatchFormular(ReportDataStruct rds)
        {
            try
            {
                string sql = "SELECT * FROM CT_FORMULAR WHERE FORMULAR_ISORNOTTAKE='1' AND FORMULAR_REPORTCODE='" + rds.rdps.ReportCode + "' ORDER BY FORMULAR_LEVEL  ";
                List<FormularEntity> formularEs = dbManager.ExecuteSqlReturnTType<FormularEntity>(sql);


                //获取报表的单元格信息
                sql = "SELECT REPORTDICTIONARY_DATAINFO FROM CT_FORMAT_REPORTDICTIONARY WHERE REPORTDICTIONARY_ID='" + rds.rdps.ReportId + "'";
                List<ReportFormatDicEntity> reports = dbManager.ExecuteSqlReturnTType<ReportFormatDicEntity>(sql);
                BBData bbData = JsonTool.DeserializeObject<BBData>(reports[0].itemStr);

                foreach (FormularEntity fe in formularEs)
                {
                    fe.content = Base64.Decode64(fe.content);
                    try
                    {
                        DeserializeFatchFormular(rds, fe, bbData);
                    }
                    catch (Exception ex)
                    {
                       string message=fe.firstRow+"行"+fe.firstCol+"列"+"公式报错.报错信息:"+ex.Message;
                        throw new Exception(message);
                    }
                }
                
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 解析单个的取数公式
        /// 1、获取数据
        /// 2、对于固定区或者变动区数据进行替换；
        /// 3、
        /// </summary>
        /// <param name="rds"></param>
        /// <param name="fe"></param>
        /// <param name="bbData"></param>
        private void DeserializeFatchFormular(ReportDataStruct rds,FormularEntity fe,BBData bbData)
        {
            try
            {
                formularFactory.SetReportParameters(rds.rdps);
                DataTable dt = formularFactory.DeserializeToSql(fe);

                if (fe.FixOrChangeRegion == "F")
                {
                    int dtRow = 0;
                    int dtCol = 0;
                    for (int row = fe.firstRow; row <= fe.lastRow; row++)
                    {
                        dtRow = row - fe.firstRow;
                        for (int col = fe.firstCol; col <= fe.lastCol; col++)
                        {
                            dtCol = col - fe.firstCol;
                            string rowColNm = GetNm(row, col, bbData);
                            if (dt.Rows.Count > dtRow && dt.Columns.Count > dtCol && rds.Gdq.ContainsKey(rowColNm))
                            {
                                rds.Gdq[rowColNm].value = dt.Rows[dtRow][dt.Columns[dtCol].ColumnName];
                                rds.Gdq[rowColNm].isOrNotUpdate = "1";
                            }

                        }
                    }
                    fillReportService.SaveReportDatas(rds);
                }
                else if (fe.FixOrChangeRegion == "R" || fe.FixOrChangeRegion == "C")
                {
                    //变动区报表数据
                    DataTable bdData = new DataTable();
                    //相关数据项列表
                    List<Cell> items = new List<Cell>();
                    //主键列
                    List<Cell> masterKeys = new List<Cell>();
                    //变动区中主键列的位置
                    Dictionary<string, int> maps = new Dictionary<string, int>();
                    string bdqCode = "";
                    if (fe.FixOrChangeRegion == "R")
                    {
                        ReportRowChangeEntity rrce = linqDbManager.GetEntity<ReportRowChangeEntity>(r => r.RegionTable == fe.RegionTableName);
                        bdqCode = rrce.Code;

                    }
                    else if (fe.FixOrChangeRegion == "C")
                    {
                        ReportColChangeEntity rcce = linqDbManager.GetEntity<ReportColChangeEntity>(r => r.RegionTable == fe.RegionTableName);
                        bdqCode = rcce.Code;
                    }

                    //获取主键列
                    masterKeys = GetMasterKeys(fe, bbData, items, maps, fe.FixOrChangeRegion);

                    if (masterKeys.Count == 0)
                    {
                        //如果没有主键列，则删除当前单位的报表数据
                        DeleteCurrentCompanyChangeRegionData(fe, rds);
                    }
                    else
                    {
                        //如果存在主列，则获取已有的数据列
                        string selectSql = ConvertListCellToSql(items);
                        selectSql += ",DATA_ID";
                        bdData = fillReportService.LoadReportItems(selectSql, fe.RegionTableName, rds.rdps, "");
                    }
                    //数据初始                   
                    rds.BdqData[rds.bdMaps[bdqCode]].Clear();
                    //创建变动区数据
                    CreateBdqDataStructs(dt, bdData, masterKeys, items, rds, bdqCode, maps);
                    fillReportService.SaveReportDatas(rds);
                }
                
            }
            catch (Exception ex)
            {
                throw ex;
            }

         }

        /// <summary>
        /// 获取主键列对象
        /// </summary>
        /// <param name="fe"></param>
        /// <param name="bbData"></param>
        /// <returns></returns>
        private List<Cell> GetMasterKeys(FormularEntity fe, BBData bbData, List<Cell> items,Dictionary<string,int>maps,string type)
        {
            try
            {
                List<Cell> masterKeys = new List<Cell>();
                for (int i = fe.firstRow; i <= fe.lastRow; i++)
                {
                    for (int j = fe.firstCol; j <= fe.lastCol; j++)
                    {
                        Cell cell = null;
                        try
                        {
                            cell = bbData.bbData[i][j];
                        }
                        catch (Exception)
                        {
                            
                            throw;
                        }
                        if (cell.CellPrimary == "1")
                        {
                            masterKeys.Add(cell);                           
                        }
                        if (type == "R")
                        {
                            maps.Add(cell.CellCode, j - fe.firstCol);
                        }
                        else if (type == "C")
                        {
                            maps.Add(cell.CellCode, i - fe.firstRow);
                        }

                        items.Add(cell);
                    }
                }
                return masterKeys;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 删除当前单位的报表数据
        /// </summary>
        /// <param name="fe"></param>
        /// <param name="rds"></param>
        private void DeleteCurrentCompanyChangeRegionData(FormularEntity fe, ReportDataStruct rds)
        {
            try
            {
                string whereSql = CreateWhereSql(rds.rdps);
                string sql = "DELETE FROM " + fe.RegionTableName + whereSql;
                dbManager.ExecuteSql(sql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 创建单元格列表
        /// </summary>
        /// <param name="cells"></param>
        /// <returns></returns>
        private string ConvertListCellToSql(List<Cell> cells)
        {
            try
            {
                StringBuilder sql = new StringBuilder();
                foreach (Cell cell in cells)
                {
                    sql.Append("[");
                    sql.Append(cell.CellCode);
                    sql.Append("]");
                    sql.Append(",");
                }
                if (sql.Length > 0) sql.Length--;
                return sql.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 创建报表删除的条件
        /// </summary>
        /// <param name="rdps"></param>
        /// <returns></returns>
        private string CreateWhereSql(ReportDataParameterStruct rdps)
        {
            try
            {

                string sql = "";
                if (ReportGlobalConst.IsOrNotRelationTaskAndPaper)
                {
                    sql = " WHERE DATA_TASKID='" + rdps.TaskId + "' AND DATA_MANUSCRIPT='" + rdps.PaperId + "' AND DATA_COMPANYID='" + rdps.CompanyId + "' AND DATA_REPORTID='" + rdps.ReportId + "' AND DATA_YEAR='" + rdps.Year + "' AND DATA_CYCLE='" + rdps.Cycle + "'";
                }
                else
                {
                    sql = " WHERE  DATA_COMPANYID='" + rdps.CompanyId + "' AND DATA_REPORTID='" + rdps.ReportId + "' AND DATA_YEAR='" + rdps.Year + "' AND DATA_CYCLE='" + rdps.Cycle + "'";
                }

                return sql;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 创建变动区数据结构,
        /// 并且创建数据
        /// </summary>
        /// <param name="newDataSource"></param>
        /// <param name="oldDtaSource"></param>
        /// <param name="primaryKeys"></param>
        private void CreateBdqDataStructs(DataTable newDataSource, DataTable oldDataSource, List<Cell> primaryKeys,List<Cell>items,ReportDataStruct rds,string bdCode,Dictionary<string,int> itemIndexMap)
        {
            try
            {
                foreach (DataRow nrow in newDataSource.Rows)
                {
                    //获取相同主键的数据列
                    DataRow orow = FindOldDataRow(oldDataSource, primaryKeys, nrow,itemIndexMap);
                    Dictionary<string, ItemDataValueStruct> itemMap;
                    //增加数据结构
                    itemMap = new Dictionary<string, ItemDataValueStruct>();
                    ItemDataValueStruct idItem = new ItemDataValueStruct();
                    idItem.cellDataType = "01";
                    if (orow == null)
                    {
                        idItem.value = "";
                    }
                    else
                    {
                        idItem.value = orow["DATA_ID"];
                    }
                   
                    itemMap.Add("DATA_ID", idItem);
                    foreach (Cell cell in items)
                    {
                        ItemDataValueStruct temp = new ItemDataValueStruct();
                        temp.cellDataType = cell.CellDataType;
                        if (orow != null)
                        {
                            temp.value = orow[cell.CellCode];
                        }
                        if (nrow.ItemArray.Length>itemIndexMap[cell.CellCode]&& !StringUtil.IsNullOrEmpty(nrow[itemIndexMap[cell.CellCode]]) )
                        {
                            temp.value = nrow[itemIndexMap[cell.CellCode]];
                            temp.isOrNotUpdate = "1";
                        }
                        itemMap.Add(cell.CellCode,temp);
                    }                  
                    rds.BdqData[rds.bdMaps[bdCode]].Add(itemMap);   
                
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 获取相同主键的数据行数据
        /// </summary>
        /// <param name="oldDataSource"></param>
        /// <param name="primaryKeys"></param>
        /// <param name="newRow"></param>
        /// <returns></returns>
        private DataRow FindOldDataRow(DataTable oldDataSource, List<Cell> primaryKeys, DataRow newRow,Dictionary<string,int> primaryIndexMaps)
        {
            try
            {
                if (oldDataSource == null || oldDataSource.Rows.Count == 0) { return null; }
                
                foreach (DataRow dr in oldDataSource.Rows)
                {
                    bool flag = true;
                    foreach (Cell cell in primaryKeys)
                    {
                        if (Convert.ToString(newRow[primaryIndexMaps[cell.CellCode]]) != Convert.ToString(dr[cell.CellCode]))
                        {
                            flag = false;
                            break;
                        }
                    }
                    if (flag == true) { return dr; }
                }

              
                return null;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 获取变动区信息
        /// </summary>
        /// <param name="bbData"></param>
        /// <param name="cellCode"></param>
        /// <returns></returns>
        private Bdq GetBdq(BBData bbData, Cell cell)
        {
            try
            {
                for (int i = 0; i < bbData.bdq.Bdqs.Count; i++)
                {
                    Bdq temp = bbData.bdq.Bdqs[i];
                    if (temp!=null&& temp.BdType == ReportGlobalConst.Report_ChangeRow&&temp.Offset==cell.CellRow)
                    {
                        return temp;                        
                    }
                    else if (temp!=null&&temp.BdType == ReportGlobalConst.Report_ChangeCol && temp.Offset == cell.CellCol)
                    {
                        return temp;
                    }

                }
                return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 报表计算
        /// </summary>
        /// <param name="rds"></param>
        public void DeserializeCaculateFormular(ReportDataStruct rds)
        {
            try
            {
                
                string sql = "SELECT * FROM CT_FORMULAR WHERE FORMULAR_ISORNOTCACULATION='1' AND FORMULAR_REPORTCODE='"+rds.rdps.ReportCode+"'";
                List<FormularEntity> formulars = dbManager.ExecuteSqlReturnTType<FormularEntity>(sql);
                //获取报表的单元格信息
                sql = "SELECT REPORTDICTIONARY_DATAINFO FROM CT_FORMAT_REPORTDICTIONARY WHERE REPORTDICTIONARY_ID='"+rds.rdps.ReportId+"'";
                List<ReportFormatDicEntity> reports = dbManager.ExecuteSqlReturnTType<ReportFormatDicEntity>(sql);
                BBData bbData = JsonTool.DeserializeObject<BBData>(reports[0].itemStr);
                //获取报表的全部数据
                rds = fillReportService.LoadReportDatas(rds.rdps, true);
                //形成计算公式的顺序,通过左右巡算法获取公式的计算优先级；
                CaculateFormularCascadeManager cfcm = new CaculateFormularCascadeManager(bbData,rds);
             
                foreach (FormularEntity fe in formulars)
                {
                    if (!fe.Caculated)
                    {
                        cfcm.FormularCascadeHandler(fe, formulars, CaculateSingleFormular);
                    }
                 }
              
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
        /// <summary>
        /// 处理单个的计算公式
        /// 1、获取固定区、变动区对象字典；
        /// 2、快公式解析；
        /// 3、固定区、变动区数据解析
        /// 4、存储到数据对象中
        /// </summary>      
        private void CaculateSingleFormular(FormularEntity fe, BBData bbData, ReportDataStruct rds)
        {
            try
            {
                string strFullformularConten = string.Empty;
                string nmFcode = "";//公式左边行列内码

                //针对固定表、变动表的混合进行操作；获取公式相关单元格的内容；<变动表名，<数据项编号，数据项位置>>
                Dictionary<string, Dictionary<string, string>> bdItems = new Dictionary<string, Dictionary<string, string>>();
                //固定区数据对象<固定表名，<数据项编号，数据项位置>>
                Dictionary<string, Dictionary<string, string>> gdItems = new Dictionary<string, Dictionary<string, string>>();
                StringBuilder itemsSql = new StringBuilder();//sql构造对象
                DataTable dt = null;//报表数据
                string formularContent = "";//报表公式内容
                //公式计算解析
                if (!StringUtil.IsNullOrEmpty(fe.DeserializeContent)|| Base64.Decode64(fe.content).Contains("CCGC"))
                {
                    //获取固定区或者变动区对象的内码字典
                    nmFcode = GetNm(fe.firstRow, fe.firstCol, bbData);
                    string cellCoordinate = fe.firstRow.ToString() + "," + fe.firstCol.ToString();
                    //存储过程处理
                    if (Base64.Decode64(fe.content).Contains("CCGC"))
                    {
                        fe.content = Base64.Decode64(fe.content);
                        formularFactory.SetReportParameters(rds.rdps);
                        DataTable dtValue = formularFactory.DeserializeToSql(fe);
                        if (dtValue != null && dtValue.Rows.Count > 0)
                            rds.Gdq[nmFcode].value = dtValue.Rows[0][0];
                        //保存计算结果
                        fillReportService.SaveReportDatas(rds);
                        return;
                    }

                    string[] itemCodes = fe.DeserializeContent.Split(';');
                    Cell cell = CreateCell(cellCoordinate, bbData);
                    Bdq bdq = GetBdq(bbData, cell);
                    //构造对象字典
                    foreach (string itemCode in itemCodes)
                    {
                        GetGdqOrBdqItems(bbData, itemCode, gdItems, bdItems);
                    }

                    //公式的内容解析
                    CaculateBlockFormularDeserialize cbfd = new CaculateBlockFormularDeserialize();//解析块公式
                    CaculateIfFormularDeserialize cifd = new CaculateIfFormularDeserialize();//解析IF公式  
                    //初始块公式内容
                    cbfd.FormularAnalysis = formularFactory;

                    if (bdq!=null)
                    {

                        //解析报表公式
                        string formularContenTemp=Base64.Decode64(fe.content);
                        
                        FormularDeserializeStruct fds = cbfd.DeserializeCacularFormular(formularContenTemp, dt, bbData);
                        formularContenTemp = fds.FormularCondent;

                        //解析变动单元格中的固定单元格信息
                        foreach (string tableName in gdItems.Keys)
                        {
                            //获取固定表单元格的信息
                            itemsSql.Length = 0;
                            foreach (string itemCode in gdItems[tableName].Keys)
                            {
                                itemsSql.Append("[");
                                itemsSql.Append(itemCode);
                                itemsSql.Append("]");
                                itemsSql.Append(",");
                            }
                            if (itemsSql.Length > 0)
                            {
                                //获取固定单元格的数据
                                itemsSql.Length--;
                                dt = fillReportService.LoadReportItems(itemsSql.ToString(), tableName, rds.rdps, "");
                            }
                        }

                        foreach (string tableName in gdItems.Keys)
                        {
                            //固定区数据替换
                            foreach (string itemCode in gdItems[tableName].Keys)
                            {
                                //如果固定区的数据为空则需要退出
                                if (StringUtil.IsNullOrEmpty(formularContenTemp)) break;
                                //固定区公式的替换
                                formularContenTemp = ReplaceGdFormular(formularContenTemp, dt, gdItems[tableName][itemCode], itemCode);
                            }
                        }

                        //变动区单元格信息
                        foreach (string tableName in bdItems.Keys)
                        {
                            itemsSql.Length = 0;
                            foreach (string itemCode in bdItems[tableName].Keys)
                            {
                                itemsSql.Append("[");
                                itemsSql.Append(itemCode);
                                itemsSql.Append("]");
                                itemsSql.Append(",");
                            }
                            if (itemsSql.Length > 0)
                            {
                                itemsSql.Append("DATA_ID,");
                                //变动区数据获取
                                itemsSql.Length--;
                                dt = fillReportService.LoadReportItems(itemsSql.ToString(), tableName, rds.rdps, "");
                                int i = 0;
                                //变动表数据校验
                                foreach (DataRow row in dt.Rows)
                                {
                                    //块公式解析
                                    formularContent = formularContenTemp;
                                    Boolean isOrNotIf = formularContent.Substring(0, 2).ToUpper() == "IF" ? true : false;
                                    
                                    //数据替换
                                    foreach (DataColumn col in dt.Columns)
                                    {
                                        if (col.ColumnName == "DATA_ID") continue;
                                        //变动区报表数据的替换
                                        formularContent = ReplaceBdFormular(formularContent, bdItems[tableName][col.ColumnName], row, col);
                                    }


                                    if (isOrNotIf)
                                    {
                                        //IF条件公式运算                                       
                                        object value = cifd.DeserializeIfFormular(formularContent, formularFactory);
                                        SetBdqData(tableName, nmFcode, value, rds, row);
                                    }
                                    else
                                    {
                                        //普通公式运算                                      
                                        object value = formularFactory.ExpressParse(formularContent);
                                        SetBdqData(tableName, nmFcode, value, rds, row);
                                    }
                                    //数据保存
                                    rds.BdqData[rds.bdMaps[FormatTool.GetBdReportCode(tableName)]][i][nmFcode].isOrNotUpdate = "1";
                                    i++;
                                }
                            }
                        }
                    }
                    else
                    {

                        //块公式解析
                        formularContent = Base64.Decode64(fe.content);
                        strFullformularConten = formularContent;
                        Boolean isOrNotIf = formularContent.Substring(0, 2).ToUpper() == "IF" ? true : false;
                        FormularDeserializeStruct fds = new FormularDeserializeStruct();
                        //固定区单元格数据的计算
                        foreach (string tableName in gdItems.Keys)
                        {
                            //获取固定表单元格的信息
                            itemsSql.Length = 0;
                            foreach (string itemCode in gdItems[tableName].Keys)
                            {
                                itemsSql.Append("[");
                                itemsSql.Append(itemCode);
                                itemsSql.Append("]");
                                itemsSql.Append(",");
                            }
                            if (itemsSql.Length > 0)
                            {
                                //获取固定单元格的数据
                                itemsSql.Length--;
                                dt = fillReportService.LoadReportItems(itemsSql.ToString(), tableName, rds.rdps, "");
                            }
                        }


                        fds = cbfd.DeserializeCacularFormular(formularContent, dt, bbData);
                        formularContent = fds.FormularCondent;
                        foreach (string tableName in gdItems.Keys)
                        {
                            //固定区数据替换
                            foreach (string itemCode in gdItems[tableName].Keys)
                            {
                                //如果固定区的数据为空则需要退出
                                if (StringUtil.IsNullOrEmpty(formularContent)) break;
                                //固定区公式的替换
                                formularContent = ReplaceGdFormular(formularContent, dt, gdItems[tableName][itemCode], itemCode);
                            }
                        }

                        //固定区公式中含有变动区数据的单元格 
                        //区分取数单元格和条件单元格

                        string GDCellNum = string.Empty;
                        string BDCellNum = string.Empty;
                        if (strFullformularConten.Split(';').Length > 0)
                            GDCellNum = DeserializeCellFormular(strFullformularConten.Split(';')[0]);
                        if (strFullformularConten.Split(';').Length > 1)
                            BDCellNum = DeserializeCellFormular(strFullformularConten.Split(';')[1]);
                        foreach (string tName in bdItems.Keys)
                        {
                            itemsSql.Length = 0;
                            StringBuilder whereSql = new StringBuilder();
                            //解析取数单元格
                            foreach (string itemCode in bdItems[tName].Keys)
                            {
                                if (GDCellNum.Contains(bdItems[tName][itemCode]))
                                {
                                    itemsSql.Append(fds.BdHzType);
                                    itemsSql.Append("([");
                                    itemsSql.Append(itemCode);
                                    itemsSql.Append("]) AS [");
                                    itemsSql.Append(itemCode);
                                    itemsSql.Append("],");
                                }
                                if (BDCellNum.Contains(bdItems[tName][itemCode]))
                                {
                                    if (fds.FormularCondition != "")
                                    {
                                        whereSql.Append(" AND ");
                                        fds.FormularCondition = fds.FormularCondition.Replace("==", "=");
                                        // whereSql.Append("[" + itemCode + "]" + fds.FormularCondition);
                                        whereSql.Append(fds.FormularCondition.Replace("[" + bdItems[tName][itemCode] + "]", "[" + itemCode + "]"));
                                    }
                                }
                            }
                            //获取变动区数据，并替换相应的数据
                            if (itemsSql.Length > 0) itemsSql.Length--;
                            dt = fillReportService.LoadReportItems(itemsSql.ToString(), tName, rds.rdps, whereSql.ToString());


                            foreach (string itemCode in bdItems[tName].Keys)
                            {
                                //固定区中变动单元格数据进行替换；
                                formularContent = ReplaceGdFormular(formularContent, dt, bdItems[tName][itemCode], itemCode);
                            }

                        }
                        if (isOrNotIf)
                        {
                            //If公式计算
                            rds.Gdq[nmFcode].value = cifd.DeserializeIfFormular(formularContent, formularFactory);
                        }
                        else
                        {
                            //普通公式计算
                            rds.Gdq[nmFcode].value = formularFactory.ExpressParse(formularContent);
                        }


                        rds.Gdq[nmFcode].isOrNotUpdate = "1";
                    }
                    //保存计算结果
                    fillReportService.SaveReportDatas(rds);
                }

            }
            catch (Exception ex)
            {
                string message = "计算公式" + fe.firstRow.ToString() + "行" + fe.firstCol.ToString() + "列报错.详细错误:" + ex.Message;
                throw new Exception(message);
            }
        }
        /// <summary>
        /// 设置变动区中单行数据的信息
        /// </summary>
        /// <param name="tableName"></param>
        /// <param name="nmCode"></param>
        /// <param name="value"></param>
        private void SetBdqData(string tableName, string nmCode, object value,ReportDataStruct rds,DataRow row)
        {
            try
            {
                object index=row["DATA_ID"];
                foreach (Dictionary<string, ItemDataValueStruct> nameValues in rds.BdqData[rds.bdMaps[FormatTool.GetBdReportCode(tableName)]])
                {
                    if (index.ToString() == nameValues["DATA_ID"].value.ToString())
                    {
                        nameValues[nmCode].value = value;
                        break;
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 固定表普通数据公式的替换
        /// </summary>
        /// <param name="formularContent"></param>
        /// <param name="dt"></param>
        /// <param name="nm"></param>
        /// <param name="sourceNm"></param>
        /// <param name="code"></param>
        /// <returns></returns>
        private string ReplaceGdFormular(string formularContent, DataTable dt, string sourceNm,string code)
        {
            try
            {
                if (dt!=null&&dt.Rows.Count > 0 && dt.Columns.Contains(code) && Convert.ToString(dt.Rows[0][code]) != "")
                {
                    formularContent = formularContent.Replace("[" + sourceNm + "]", Convert.ToString(dt.Rows[0][code]));
                }
                else
                {
                    formularContent = formularContent.Replace("[" + sourceNm + "]", "0");
                }
                return formularContent;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 变动表普通公式的替换
        /// </summary>
        /// <param name="formularContent"></param>
        /// <param name="sourceNm"></param>
        /// <param name="row"></param>
        /// <param name="column"></param>
        /// <returns></returns>
        private string ReplaceBdFormular(string formularContent,string sourceNm,DataRow row,DataColumn column)
        {
            try
            {
                if (Convert.ToString(row[column.ColumnName]) != "")
                {
                    formularContent = formularContent.Replace("[" + sourceNm + "]", Convert.ToString(row[column.ColumnName]));
                }
                else
                {
                    formularContent = formularContent.Replace("[" + sourceNm + "]", "0");
                }
                return formularContent;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
     
        private void DeserializeSingeCaculateFormular()
        {
            try
            {
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 解析报表校验公式
        /// 1、解析报表校验公式
        /// 2、保存报表状态
        /// </summary>
        /// <param name="rds"></param>
        /// <returns></returns>
        public string DeserializeVarifyFormular(ReportDataStruct rds)
        {
            try
            {
                //获取校验公式
                string result="";
                string sql = "SELECT * FROM CT_FORMULAR WHERE FORMULAR_ISORNOTBATCH='1' AND FORMULAR_REPORTCODE='" + rds.rdps.ReportCode + "'";
                List<FormularEntity> formulars = dbManager.ExecuteSqlReturnTType<FormularEntity>(sql);

                //获取报表的单元格信息
                sql = "SELECT REPORTDICTIONARY_DATAINFO FROM CT_FORMAT_REPORTDICTIONARY WHERE REPORTDICTIONARY_ID='" + rds.rdps.ReportId + "'";
                List<ReportFormatDicEntity> reports = dbManager.ExecuteSqlReturnTType<ReportFormatDicEntity>(sql);
                BBData bbData = JsonTool.DeserializeObject<BBData>(reports[0].itemStr);
                //获取报表的全部数据
                rds = fillReportService.LoadReportDatas(rds.rdps, true);
                //报表校验问题
                List<VerifyProblemEntity> vpes = new List<VerifyProblemEntity>();

                foreach (FormularEntity fe in formulars)
                {
                    try
                    {                       

                        string nmFcode = "";//公式左边行列内码

                        //针对固定表、变动表的混合进行操作；获取公式相关单元格的内容；<变动表名，<数据项编号，数据项位置>>
                        Dictionary<string, Dictionary<string, string>> bdItems = new Dictionary<string, Dictionary<string, string>>();
                        //固定区数据对象<固定表名，<数据项编号，数据项位置>>
                        Dictionary<string, Dictionary<string, string>> gdItems = new Dictionary<string, Dictionary<string, string>>();
                        StringBuilder itemsSql = new StringBuilder();//sql构造对象
                        DataTable dt = null;//报表数据
                        string formularContent = "";//报表公式内容

                       
                        
                        if (!StringUtil.IsNullOrEmpty(fe.DeserializeContent))
                        {
                            //获取固定区或者变动区对象的内码字典
                            string[] itemCodes = fe.DeserializeContent.Split(';');
                            if (fe.firstRow != -1 && fe.firstCol != -1)
                            {
                                nmFcode = fe.firstRow.ToString() + "," + fe.firstCol.ToString();
                                GetGdqOrBdqItems(bbData, nmFcode, gdItems, bdItems);                               
                            }
                            //构造对象字典
                            foreach (string itemCode in itemCodes)
                            {
                                GetGdqOrBdqItems(bbData, itemCode, gdItems, bdItems);
                            }

                            if (gdItems.Count == 0 && bdItems.Count > 0)
                            {
                                //变动区数据的数据校验
                                foreach (string tableName in bdItems.Keys)
                                {
                                    itemsSql.Length=0;
                                    foreach (string itemCode in bdItems[tableName].Keys)
                                    {
                                        itemsSql.Append("[");
                                        itemsSql.Append(itemCode);
                                        itemsSql.Append("]");
                                        itemsSql.Append(",");
                                    }
                                    if (itemsSql.Length > 0)
                                    {
                                        //变动区数据获取
                                        itemsSql.Length--;
                                        dt = fillReportService.LoadReportItems(itemsSql.ToString(), tableName, rds.rdps, "");
                                        int i = 0;
                                        //变动表数据校验
                                        foreach (DataRow row in dt.Rows)
                                        {
                                            if (fe.firstCol == -1 && fe.firstRow == -1)
                                            {
                                                formularContent = Base64.Decode64(fe.content);
                                            }
                                            else
                                            {
                                                formularContent = "[" + nmFcode + "]" + fe.option + Base64.Decode64(fe.content);
                                            }
                                            bool flag = true;                                           
                                            foreach (DataColumn col in dt.Columns)
                                            {
                                                if (Convert.ToString(row[col.ColumnName]) != "")
                                                {
                                                    formularContent = formularContent.Replace("[" + bdItems[tableName][col.ColumnName] + "]", Convert.ToString(row[col.ColumnName]));
                                                }
                                                else
                                                {
                                                    flag = false;
                                                }
                                            }
                                            if (flag)
                                            {
                                                if (!Convert.ToBoolean(formularFactory.ExpressParse(formularContent)))
                                                {
                                                    if (fe.firstCol == -1 && fe.firstRow == -1)
                                                    {
                                                        formularContent = Base64.Decode64(fe.content);
                                                    }
                                                    else
                                                    {
                                                        formularContent = "[" + nmFcode + "]" + fe.option + Base64.Decode64(fe.content);
                                                    }
                                                 
                                                    result += "【" + formularContent + "】;"+fe.ErrorInfo+"|";
                                                    //记录问题校验问题
                                                    CreateVerifyProblemEntity(rds, fe.ErrorInfo, formularContent, fe, vpes);
                                                }
                                            }
                                            else
                                            {
                                                if (fe.firstCol == -1 && fe.firstRow == -1)
                                                {
                                                    formularContent = Base64.Decode64(fe.content);
                                                }
                                                else
                                                {
                                                    formularContent = "[" + nmFcode + "]" + fe.option + Base64.Decode64(fe.content);
                                                }
                                                result += "【" +formularContent + "】;没有数据，不能通过校验|";
                                                //记录问题校验问题
                                                CreateVerifyProblemEntity(rds, "没有数据，不能通过校验", formularContent, fe, vpes);
                                            }
                                            i++;
                                        }
                                    }
                                }
                                
                            }
                            else
                            {
                                //固定区或者变动区数据的校验
                                itemsSql.Length = 0;
                                foreach (string gdTableName in gdItems.Keys)
                                {
                                    if (fe.firstCol == -1 && fe.firstRow == -1)
                                    {
                                        formularContent = Base64.Decode64(fe.content);
                                    }
                                    else
                                    {
                                        formularContent = "[" + nmFcode + "]" + fe.option + Base64.Decode64(fe.content);
                                    }
                                    foreach (string itemCode in gdItems[gdTableName].Keys)
                                    {
                                        itemsSql.Append("[");
                                        itemsSql.Append(itemCode);
                                        itemsSql.Append("]");
                                        itemsSql.Append(",");
                                    }

                                    if (itemsSql.Length > 0)
                                    {
                                        itemsSql.Length--;
                                        dt = fillReportService.LoadReportItems(itemsSql.ToString(), gdTableName, rds.rdps, "");
                                        bool flag = true;
                                        foreach (string itemCode in gdItems[gdTableName].Keys)
                                        {
                                            if (dt != null && dt.Rows.Count > 0 && Convert.ToString(dt.Rows[0][itemCode]) != "")
                                            {
                                                formularContent = formularContent.Replace("[" + gdItems[gdTableName][itemCode] + "]", Convert.ToString(dt.Rows[0][itemCode]));
                                            }
                                            else
                                            {
                                                flag = false;
                                            }
                                        }
                                          if (flag)
                                            {
                                                if (!Convert.ToBoolean(formularFactory.ExpressParse(formularContent)))
                                                {
                                                    if (fe.firstCol == -1 && fe.firstRow == -1)
                                                    {
                                                        formularContent = Base64.Decode64(fe.content);
                                                    }
                                                    else
                                                    {
                                                        formularContent = "[" + nmFcode + "]" + fe.option + Base64.Decode64(fe.content);
                                                    }                                                   

                                                  
                                                    result += "【" + formularContent + "】;"+fe.ErrorInfo+"|";
                                                    //记录问题校验问题
                                                    CreateVerifyProblemEntity(rds, fe.ErrorInfo, formularContent, fe, vpes);
                                                }
                                            }
                                            else
                                            {
                                                if (fe.firstCol == -1 && fe.firstRow == -1)
                                                {
                                                    formularContent = Base64.Decode64(fe.content);
                                                }
                                                else
                                                {
                                                    formularContent = "[" + nmFcode + "]" + fe.option + Base64.Decode64(fe.content);
                                                }
                                                result += "【" +formularContent + "】;没有数据，不能通过校验|";
                                                //记录问题校验问题
                                                CreateVerifyProblemEntity(rds, "没有数据，不能通过校验", formularContent, fe, vpes);
                                            }                                        
                                        }
                                    }
                                }
                        }


                    }
                    catch (Exception ex)
                    {
                        string message = "校验公式具体错误信息:" + ex.Message;
                        throw new Exception(message);
                    }
                }
                //更新报表状态
                ReportStateEntity rse = GetReportStateEntity(rds);
                ReportStateDetailEntity rsde = GetReportStateDetailEntity(rds);
                if (result == "")
                {
                    rse.State = ReportGlobalConst.REPORTSTATE_JYTG;
                    rsde.State = ReportGlobalConst.REPORTSTATE_JYTG;
                    rsde.OperationType = reportProcessManager.GetCurrentStateName(ReportGlobalConst.REPORTSTATE_JYTG);
                }
                else
                {
                    rse.State = ReportGlobalConst.REPORTSTATE_JYBTG;
                    rsde.State = ReportGlobalConst.REPORTSTATE_JYBTG;
                    rsde.Discription = result;
                    rsde.OperationType = reportProcessManager.GetCurrentStateName(ReportGlobalConst.REPORTSTATE_JYBTG);
                }
               
                //保存报表校验状态
                reportStateService.SaveReportSate(rse, rsde);
                                        //保存校验问题
                        SaveVerifyProblems(rds.rdps, vpes);
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 报表校验问题保存
        /// </summary>
        /// <param name="rdps"></param>
        /// <param name="vpes"></param>
        private void SaveVerifyProblems(ReportDataParameterStruct rdps, List<VerifyProblemEntity> vpes)
        {
            try
            {
                //删除以前的校验问题
                reportVerifyService.DeleteReportVerifies(rdps);
                if (vpes.Count > 0)
                {
                    reportVerifyService.SaveReportVerifies(vpes);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 初始化问题校验
        /// </summary>
        /// <param name="rds"></param>
        /// <returns></returns>
        private void  CreateVerifyProblemEntity(ReportDataStruct rds,string Problem,string formularContent,FormularEntity fe,List<VerifyProblemEntity>vpes)
        {
            try
            {
                VerifyProblemEntity vpe = new VerifyProblemEntity();
                vpe.TaskId = rds.rdps.TaskId;
                vpe.PaperId = rds.rdps.PaperId;
                vpe.CompanyId = rds.rdps.CompanyId;
                vpe.ReportId = rds.rdps.ReportId;
                vpe.Year = rds.rdps.Year;
                vpe.Cycle = rds.rdps.Cycle;
                vpe.Row = fe.firstRow.ToString()+"行";
                vpe.Col = fe.firstCol.ToString()+"列";
                vpe.Problem = Problem;
                vpe.FormularContent =formularContent;
                vpes.Add(vpe);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 获取固定区或者变动区Items
        /// </summary>
        /// <param name="bbData"></param>
        /// <param name="cellCoordinate"></param>
        /// <param name="gdqItems"></param>
        /// <param name="bdItems"></param>
        private void GetGdqOrBdqItems(BBData bbData, string cellCoordinate, Dictionary<string, Dictionary<string, string>> gdqItems, Dictionary<string, Dictionary<string, string>> bdItems)
        {
            try
            {
                Cell cell = CreateCell(cellCoordinate, bbData);

                Bdq bdq = GetBdq(bbData, cell);
                if (bdq == null)
                {
                    //规定区编号
                    string tableName = FormatTool.CreateBBTableName(bbData.bbCode, true, 1, "");
                    if (gdqItems.Keys.Contains(tableName))
                    {
                        if (!gdqItems[tableName].ContainsKey(cell.CellCode))
                        {
                            gdqItems[tableName].Add(cell.CellCode, cellCoordinate);
                        }
                    }
                    else
                    {
                        Dictionary<string, string> nmWz = new Dictionary<string, string>();
                        nmWz.Add(cell.CellCode, cellCoordinate);
                        gdqItems.Add(tableName, nmWz);
                    }
                }
                else
                {
                    //变动区编号
                    string tableName = FormatTool.CreateBBTableName(bbData.bbCode, false, 1, bdq.Code);
                    if (bdItems.Keys.Contains(tableName))
                    {
                        if (!bdItems[tableName].ContainsKey(cell.CellCode))
                        {
                            bdItems[tableName].Add(cell.CellCode, cellCoordinate);
                        }

                    }
                    else
                    {
                        Dictionary<string, string> nmWz = new Dictionary<string, string>();
                        nmWz.Add(cell.CellCode, cellCoordinate);
                        bdItems.Add(tableName, nmWz);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private ReportStateEntity GetReportStateEntity(ReportDataStruct rds)
        {
            try
            {
                ReportStateEntity rse = reportStateService.ConvertReportDataParameterToStateEntity(rds.rdps);
                return rse;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private ReportStateDetailEntity GetReportStateDetailEntity(ReportDataStruct rds)
        {
            try
            {
                ReportStateDetailEntity rsde = reportStateService.ConvertReportDataParameterToStateDetailEntity(rds.rdps);
                return rsde;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #region 批量取数、批量计算、批量校验
        /// <summary>
        /// 批量取数
        /// 1、构造报表取数的数据结构
        /// 2、报表取数执行
        /// </summary>
        /// <param name="rdps"></param>
        /// <returns></returns>
        public string BatchDeserializeFatchFormular(ReportDataParameterStruct rdps)
        {
            try
            {
                StringBuilder sb = new StringBuilder();
                string[] reports = rdps.Reports.Split(',');
                string[] companies = rdps.Companies.Split(',');
                string[] codes = rdps.ReportCodes.Split(',');
                int i = 0;
                foreach (string report in reports)
                {
                    foreach (string company in companies)
                    {
                        try
                        {
                            ReportDataParameterStruct temp = new ReportDataParameterStruct();
                            BeanUtil.CopyBeanToBean(rdps, temp);
                            temp.ReportId = report;
                            temp.CompanyId = company;
                            temp.ReportCode = codes[i];
                            ReportDataStruct rds = fillReportService.LoadReportDatas(temp);
                            DeserializeFatchFormular(rds);
                        }
                        catch (Exception ex)
                        {
                            sb.Append(ex.Message);
                        }
                    }
                    i++;
                }
                return sb.ToString();
               
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 批量计算
        /// 1、构造报表计算的数据结构
        /// 2、执行报表计算
        /// </summary>
        /// <param name="rdps"></param>
        /// <returns></returns>
        public string BatchDeserializeCaculateFormular(ReportDataParameterStruct rdps)
        {
            try
            {
                StringBuilder sb = new StringBuilder();
                string[] reports = rdps.Reports.Split(',');
                string[] companies = rdps.Companies.Split(',');
                string[] codes = rdps.ReportCodes.Split(',');
                int i = 0;
                foreach (string report in reports)
                {
                    foreach (string company in companies)
                    {
                        try
                        {
                            ReportDataParameterStruct temp = new ReportDataParameterStruct();
                            BeanUtil.CopyBeanToBean(rdps, temp);
                            temp.ReportId = report;
                            temp.CompanyId = company;
                            temp.ReportCode = codes[i];
                            ReportDataStruct rds = fillReportService.LoadReportDatas(temp);
                            DeserializeCaculateFormular(rds);
                            
                        }
                        catch (Exception ex)
                        {
                            sb.Append(ex.Message);
                        }
                    }
                    i++;
                }
                return sb.ToString();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 批量校验
        /// 1、构造报表校验的数据结构
        /// 2、报表校验执行
        /// </summary>
        /// <param name="rdps"></param>
        /// <returns></returns>
        public string BatchDeserializeVerifyFormular(ReportDataParameterStruct rdps)
        {
            try
            {
                StringBuilder sb = new StringBuilder();
                string[] reports = rdps.Reports.Split(',');
                string[] companies = rdps.Companies.Split(',');
                string[] codes = rdps.ReportCodes.Split(',');
                int i = 0;
                foreach (string report in reports)
                {
                    foreach (string company in companies)
                    {
                        try
                        {
                            ReportDataParameterStruct temp = new ReportDataParameterStruct();
                            BeanUtil.CopyBeanToBean(rdps, temp);
                            temp.ReportId = report;
                            temp.CompanyId = company;
                            temp.ReportCode = codes[i];
                            ReportDataStruct rds = fillReportService.LoadReportDatas(temp);
                           sb.Append( DeserializeVarifyFormular(rds));
                        }
                        catch (Exception ex)
                        {
                            sb.Append(ex.Message);
                        }
                    }
                    i++;
                }
                return sb.ToString();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion
    }
}
