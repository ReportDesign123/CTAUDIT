using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DbManager;
using CtTool;
using AuditSPI.ReportData;
using System.Data;
using AuditSPI.Analysis;
using AuditService.Analysis.Formular;
using AuditService;
using AuditEntity;
using AuditSPI;
using AuditSPI.Format;
using AuditExportImport.ExportExcel;
using AuditEntity.AuditTask;
using AuditEntity.AuditPaper;
using CtTool.BB;

namespace AuditService.Analysis.Formular
{
    /// <summary>
    /// 区块
    /// </summary>
    public class CellBlock
    {
        public int FirstRow;
        public int FirstCol;
        public Dictionary<int, Dictionary<int, ItemDataValueStruct>> cells = new Dictionary<int, Dictionary<int, ItemDataValueStruct>>();
    }
    /// <summary>
    /// 公式区块解析
    /// </summary>
   public   class FormularBlockAnalysis:IFormularDeserialize
    {
       //01表格 02 行优先 03 列优先
        //BBQKQS(bbCode:01;company:01;task:01;paper:02;cells:00030002;nd:2014;zq:07;IsOrNotSwap:1,layoutType:01)
       private CTDbManager dbManager;
       private LinqDataManager linqDbManager;
       MacroHelp macroHelp;
       ReportDataParameterStruct rdps = new ReportDataParameterStruct();
       ReportFormatService reportFormatService;
       public FormularBlockAnalysis()
       {
           if (dbManager == null)
           {
               dbManager = new CTDbManager();
           }
           if (linqDbManager == null)
           {
               linqDbManager = new LinqDataManager();
           }
           if (macroHelp == null)
           {
               macroHelp = new MacroHelp();
           }
           if (reportFormatService == null)
           {
               reportFormatService = new ReportFormatService();
           }
       }


       /// <summary>
       /// 报表区块公式解析
       /// 1、形成数据单元格的布局引用
       /// 2、解析表格的格式，获取布局引用表格
       /// 3、获取报表格式中的数据，填充布局引用表格
       /// 4、获取报表数据
       /// 5、根式引用单元格获形成Table数据
       /// </summary>
       /// <param name="fe"></param>
       /// <returns></returns>
       public DataTable DeserializeToSql(AuditEntity.FormularEntity fe)
       {
           try
           {
               //数据单元格
               DataTable dt = new DataTable();
               //报表单元格的引用索引
               Dictionary<int, Dictionary<int, ItemDataValueStruct>> referenceDataTables = new Dictionary<int, Dictionary<int, ItemDataValueStruct>>();
               //数据项与数据格式的索引
               Dictionary<string,DataItemEntity> itemIndexes=new Dictionary<string,DataItemEntity>();
               //数据项的表格索引
               Dictionary<string,List<DataItemEntity>> tableItems=new Dictionary<string,List<DataItemEntity>>();
               int maxColumns=0;

         
               Dictionary<int, Dictionary<int, ItemDataValueStruct>> referenceColIndex = new Dictionary<int, Dictionary<int, ItemDataValueStruct>>();

               StringBuilder sql = new StringBuilder();
               //报表单元格列表
               List<AuditSPI.Format.Cell> dataCells = new List<AuditSPI.Format.Cell>();
               string fparameter = fe.content;
               fparameter = macroHelp.ReplaceMacroVariable(fparameter);
               //获取参数
               string[] paras = fparameter.Split(';');
               Dictionary<string, string> parameters = new Dictionary<string, string>();
               foreach (string para in paras)
               {
                   string[] arr = para.Split(':');
                   parameters.Add(arr[0], arr[1]);

               }
               //设置默认参数
               SetDefaultParameters(parameters);
               //形成数据单元格的布局引用               
               CreateTableIndexes(referenceDataTables, parameters["cells"], parameters["layoutType"],referenceColIndex);
               //解析表格格式并且将单元格的数据进行赋值
               ReportFormatDicEntity reportFormat = reportFormatService.LoadReportCellFormat(parameters["bbCode"]);
               string FlexCellGridXml = Base64.Decode64ByUtf8(reportFormat.formatStr);
               List<AuditExportImport.ExportExcel.Cell> flexCells = FlexGridTool.ConvertFormatXmlToCells(FlexCellGridXml);
               //设置报表参数数据
               SetReportParameters(parameters);
               List<DataItemEntity> items = GetAllDataItems(referenceDataTables, parameters["bbCode"]);


               foreach (int row in referenceDataTables.Keys)
               {
                   //获取索引的最大列
                   if(referenceDataTables[row].Count>maxColumns){
                       maxColumns=referenceDataTables[row].Count;
                   }
                   foreach (int col in referenceDataTables[row].Keys)
                   {
                       foreach (AuditExportImport.ExportExcel.Cell cell in flexCells)
                       {
                           if (Convert.ToInt32(cell.Row) == referenceDataTables[row][col].row && Convert.ToInt32(cell.Col) == referenceDataTables[row][col].col&& !IsOrNotDataItem(items, referenceDataTables[row][col]))
                           {
     
                               referenceDataTables[row][col].value = cell.text.ToString().Trim();
                               referenceDataTables[row][col].cellDataType = "01";
                               break;
                           }
                       }
                   }
               }
               
             

               //获取DataItems索引和DataItem的表格索引
               GetDataItems(referenceDataTables, itemIndexes, tableItems, parameters["bbCode"],referenceColIndex);
               //形成数据
               for (int i = 0; i < maxColumns; i++)
               {
                   DataColumn dc = new DataColumn();
                   dc.DataType = System.Type.GetType("System.Object"); 
                   dc.ColumnName = i.ToString();
                   dt.Columns.Add(dc);
               }
               //获取数据
               Dictionary<int, int> accumulation = new Dictionary<int, int>();
               string whereSql = " WHERE DATA_TASKID='" + parameters["task"] + "' AND DATA_MANUSCRIPT='" + parameters["paper"] + "' AND DATA_COMPANYID='" + parameters["company"] + "' AND DATA_REPORTID='" + parameters["bbCode"] + "' AND DATA_YEAR='" + parameters["nd"] + "' AND DATA_CYCLE='" + parameters["zq"] + "'";
              //构建原始的行列数据
               Dictionary<int, int> rowIndexMap = new Dictionary<int, int>();
               Dictionary<int,Dictionary<int,int>>colIndexMap=new Dictionary<int,Dictionary<int,int>>();
               string layout = parameters["layoutType"];
               int rowIndex = 0;
               foreach (int row in referenceDataTables.Keys)
               {
                   rowIndexMap.Add(row, rowIndex);            
                   DataRow rowData = dt.NewRow();             
                   int colIndex = 0;
                   colIndexMap[row] = new Dictionary<int, int>();
                   foreach (int col in referenceDataTables[row].Keys)
                   {
                       rowData[colIndex] = referenceDataTables[row][col].value;
                       colIndexMap[row][col] = colIndex;
                       colIndex++;
                   }
                   dt.Rows.Add(rowData);
                   rowIndex++;
               }
               //设置固定区数据
               foreach (string tableName in tableItems.Keys)
               {
                   sql.Length = 0;
                   if (tableItems[tableName].Count == 0) continue;
                   if (FormatTool.GetDataItemType(tableName) == "BD") continue;
                   //获取数据项数据
                   DataTable temp = GetListDataItemData(tableItems, tableName, whereSql);

                   if (temp != null && temp.Rows.Count > 0)
                   {  
                       foreach (DataRow row in temp.Rows)
                       {
                               foreach (DataColumn column in temp.Columns)
                               {
                                   string columnName = column.ColumnName;
                                   DataItemEntity item = itemIndexes[columnName];
                                   ItemDataValueStruct idvs = referenceColIndex[item.Row][item.Col];
                                   int mapRow = idvs.row;
                                   int mapCol = idvs.col;

                                   int rowI = rowIndexMap[mapRow];
                                   int colI = colIndexMap[mapRow][mapCol];
                                   dt.Rows[rowI][colI] = row[column.ColumnName].ToString().Trim();
                               }
                           }

                   }
               }
               //设置变动取数据
               int relativeOffset = 0;
               foreach (string tableName in tableItems.Keys)
               {
                   sql.Length = 0;
                   if (tableItems[tableName].Count == 0) continue;
                   if (FormatTool.GetDataItemType(tableName) == "GD") continue;
                   //获取数据项数据
                   DataTable temp = GetListDataItemData(tableItems, tableName, whereSql);
                  
                   if (temp != null && temp.Rows.Count > 0)
                   {
                       //插入变动行的行数                     
                       if (FormatTool.GetDataItemType(tableName) == "BD")
                       {
                           //目前仅处理变动行，对于变动列暂不处理
                           string columnCode = temp.Columns[0].ToString();
                           DataItemEntity item = itemIndexes[columnCode];
                           //获取当前变动行的初始偏倚量
                           int initialOffset = rowIndexMap[item.Row];
                           //获取相对便宜量                          
                           foreach (int row in accumulation.Keys)
                           {
                               if (row < item.Row)
                               {
                                   relativeOffset += accumulation[row];
                               }
                           }
                           //插入数据
                           int rowCount = temp.Rows.Count - 1;
                           accumulation[item.Row] = rowCount;
                           for (int i = 0; i < rowCount; i++)
                           {
                               DataRow row=dt.NewRow();
                               dt.Rows.InsertAt(row, initialOffset + relativeOffset + i);
                           }
                       }
                       int j = 0;
                       foreach (DataRow row in temp.Rows)
                       {
                               //变动行数据
                               foreach (DataColumn column in temp.Columns)
                               {
                                   string columnName = column.ColumnName;
                                   DataItemEntity item = itemIndexes[columnName];
                                   ItemDataValueStruct idvs = referenceColIndex[item.Row][item.Col];
                                   int mapRow = idvs.row;
                                   int mapCol = idvs.col;

                                   int rowI = rowIndexMap[mapRow]+relativeOffset+j;
                                   int colI = colIndexMap[mapRow][item.Col];
                                   dt.Rows[rowI][colI] = row[column.ColumnName].ToString().Trim();
                               }
                           j++;
                       }
                   }
               }
               return dt ;
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }
       private DataTable GetListDataItemData(Dictionary<string, List<DataItemEntity>> tableItems,string tableName,string whereSql)
       {
           try
           {
               StringBuilder sql = new StringBuilder();
               sql.Append("SELECT ");
               foreach (DataItemEntity item in tableItems[tableName])
               {
                   sql.Append("[");
                   sql.Append(item.Code);
                   sql.Append("]");
                   sql.Append(",");
               }
               sql.Length--;
               sql.Append(" FROM ");
               sql.Append(tableName);
               sql.Append(whereSql);

               DataTable temp = dbManager.ExecuteSqlReturnDataTable(sql.ToString());
               return temp;
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }
       /// <summary>
       /// 设置单元格的默认参数
       /// </summary>
       /// <param name="parameters"></param>
       private void SetDefaultParameters(Dictionary<string, string> parameters)
       {
           try
           {
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
               if (!StringUtil.IsNullOrEmpty(parameters["cells"]))
               {
                   parameters["cells"] = Base64.Decode64(parameters["cells"]);
               }
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }
       /// <summary>
       /// 设置报表参数
       /// </summary>
       /// <param name="parameters"></param>
       private void SetReportParameters(Dictionary<string, string> parameters)
       {
           try
           {
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

           }
           catch (Exception ex)
           {
               throw ex;
           }
       }


       private List<DataItemEntity> GetAllDataItems(Dictionary<int, Dictionary<int, ItemDataValueStruct>> referenceDataTables,string reportId)
       {
           try
           {
               StringBuilder sql = new StringBuilder();
               sql.Append("SELECT ");
               sql.Append(" DATAITEM_CODE,DATAITEM_TABLENAME,DATAITEM_ROW,DATAITEM_COL,DATAITEM_TABLENAME,DATAITEM_CELLDATATYPE");
               sql.Append(" FROM ");
               sql.Append(" CT_FORMAT_DATAITEM ");
               sql.Append(" WHERE ");
               sql.Append(" DATAITEM_REPORTID ='");
               sql.Append(reportId);
               sql.Append("' ");
               int index = 0;
               foreach (int row in referenceDataTables.Keys)
               {
                   foreach (int col in referenceDataTables[row].Keys)
                   {
                       if (referenceDataTables[row][col].cellDataType != "01")
                       {
                           if (index == 0) sql.Append(" AND (");
                           else sql.Append(" OR ");
                           sql.Append("(");
                           sql.Append("DATAITEM_ROW");
                           sql.Append("=");
                           sql.Append(referenceDataTables[row][col].row);
                           sql.Append(" AND ");
                           sql.Append("DATAITEM_COL");
                           sql.Append("=");
                           sql.Append(referenceDataTables[row][col].col);
                           sql.Append(")");
                           index++;



                       }
                   }
               }
               sql.Append(")");
               return dbManager.ExecuteSqlReturnTType<DataItemEntity>(sql.ToString());
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }
       private bool IsOrNotDataItem(List<DataItemEntity> items,ItemDataValueStruct item)
       {
           try
           {
               foreach (DataItemEntity i in items)
               {

                   if (i.Row == item.row && item.col == i.Col)
                   {
                       return true;
                   }
               }
               return false;
           }

           catch (Exception ex)
           {
               throw ex;
           }
       }
       /// <summary>
       /// 获取数据项的格式内容
       /// </summary>
       /// <param name="referenceDataTables"></param>
       /// <param name="itemIndexes"></param>
       /// <param name="tableItems"></param>
       private void GetDataItems(Dictionary<int, Dictionary<int, ItemDataValueStruct>> referenceDataTables, Dictionary<string, DataItemEntity> itemIndexes, Dictionary<string, List<DataItemEntity>> tableItems,string reportId,Dictionary<int,Dictionary<int,ItemDataValueStruct>>referenctCol)
       {
           try
           {
               StringBuilder sql = new StringBuilder();
               sql.Append("SELECT ");
               sql.Append(" DATAITEM_CODE,DATAITEM_TABLENAME,DATAITEM_ROW,DATAITEM_COL,DATAITEM_TABLENAME,DATAITEM_CELLDATATYPE");
               sql.Append(" FROM ");
               sql.Append(" CT_FORMAT_DATAITEM ");
               sql.Append(" WHERE ");
               sql.Append(" DATAITEM_REPORTID ='");
               sql.Append(reportId);
               sql.Append("' ");
               int index = 0;
               foreach (int row in referenceDataTables.Keys)
               {
                   foreach (int col in referenceDataTables[row].Keys)
                   {
                       if (referenceDataTables[row][col].cellDataType != "01")
                       {
                           if (index == 0) sql.Append(" AND (");
                           else sql.Append(" OR ");
                           sql.Append("(");
                           sql.Append("DATAITEM_ROW");
                           sql.Append("=");
                           sql.Append(referenceDataTables[row][col].row);
                           sql.Append(" AND ");
                           sql.Append("DATAITEM_COL");
                           sql.Append("=");
                           sql.Append(referenceDataTables[row][col].col);
                           sql.Append(")");
                           index++;

                           
                        
                       }
                   }
               }
               if (index > 0)
               {
                   sql.Append(")");
                   sql.Append(" ORDER BY DATAITEM_ROW,DATAITEM_COL");
                   List<DataItemEntity> itemSets = dbManager.ExecuteSqlReturnTType<DataItemEntity>(sql.ToString());
                   sql.Length = 0;
                   //生成数据项索引和数据表格数据项索引
                   foreach (DataItemEntity i in itemSets)
                   {
                       //增加数据项索引
                       itemIndexes[i.Code] = i;
                       if (!tableItems.ContainsKey(i.TableName))
                       {
                           tableItems[i.TableName] = new List<DataItemEntity>();
                       }
                       tableItems[i.TableName].Add(i);
                       ItemDataValueStruct idvs = referenctCol[i.Row][i.Col];
                       referenceDataTables[idvs.row][idvs.col].cellDataType = i.CellDataType;
                   }
               }
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }

       /// <summary>
       /// 创建表格索引
       /// </summary>
       /// <param name="referenceDataTables"></param>
       private void CreateTableIndexes(Dictionary<int, Dictionary<int, ItemDataValueStruct>> referenceDataTables, string cellStr, string layoutType,  Dictionary<int, Dictionary<int, ItemDataValueStruct>> referenceColIndex)
       {
           try
           {
               List<CellBlock> cellBlocks = new List<CellBlock>();
               string[] cellsRC = cellStr.Split(';');

               foreach (string cellRc in cellsRC)
               {
                   CellBlock cellBlock = new CellBlock();
                   if (cellRc.IndexOf(":") != -1)
                   {
                       //解析块对象
                       string temp = cellRc.Substring(1, cellRc.Length - 2);
                       string[] beforeAfter = temp.Split(':');
                       int[] beforeRowCol = DeserializeCellRowCol(beforeAfter[0], false);
                       int[] afterRowCol = DeserializeCellRowCol(beforeAfter[1], false);
                       for (int i = beforeRowCol[0]; i <= afterRowCol[0]; i++)
                       {
                           if (!cellBlock.cells.ContainsKey(i))
                           {
                               Dictionary<int, ItemDataValueStruct> rowMap = new Dictionary<int, ItemDataValueStruct>();
                               cellBlock.cells.Add(i, rowMap);
                           }

                           for (int j = beforeRowCol[1]; j <= afterRowCol[1]; j++)
                           {
                               ItemDataValueStruct cell = new ItemDataValueStruct();
                               cell.row = i;
                               cell.col = j;
                               cellBlock.cells[i].Add(j, cell);
                           }
                       }
                       cellBlock.FirstRow = beforeRowCol[0];
                       cellBlock.FirstCol = beforeRowCol[1];
                   }
                   else
                   {
                       //解析单个对象
                       int[] rowCol = DeserializeCellRowCol(cellRc, true);
                       ItemDataValueStruct cell = new ItemDataValueStruct();
                       cell.row = rowCol[0];
                       cell.col = rowCol[1];
                       if (!cellBlock.cells.ContainsKey(cell.row))
                       {
                           Dictionary<int, ItemDataValueStruct> rowMap = new Dictionary<int, ItemDataValueStruct>();
                           cellBlock.cells.Add(cell.row, rowMap);
                       }
                       cellBlock.cells[cell.row].Add(cell.col, cell);
                       cellBlock.FirstCol = cell.col;
                       cellBlock.FirstRow = cell.row;
                   }
                   cellBlocks.Add(cellBlock);
               }

               //对于区块进行排序,并生成表格索引
               SortByLayoutType(cellBlocks, layoutType,cellBlocks,referenceDataTables,referenceColIndex);
                             

           }
           catch (Exception ex)
           {
               throw ex;
           }
       }
       /// <summary>
       /// 根据排序方式对于区块进行排序
       /// </summary>
       /// <param name="blocks"></param>
       /// <param name="layoutType"></param>
       /// <returns></returns>
       private List<CellBlock> SortByLayoutType(List<CellBlock> blocks, string layoutType, List<CellBlock> cellBlocks, Dictionary<int, Dictionary<int, ItemDataValueStruct>> referenceDataTables,  Dictionary<int, Dictionary<int, ItemDataValueStruct>> referenceColIndex)
       {
           try
           {
               if (layoutType == "01")
               {
                   //表格布局
                   TableSort(blocks);
                   
                   foreach (CellBlock block in cellBlocks)
                   {
                      
                       foreach (int row in block.cells.Keys)
                       {
                           
                           if (!referenceDataTables.ContainsKey(row))
                           {
                               referenceDataTables.Add(row, new Dictionary<int, ItemDataValueStruct>());
                           }
                           if (!referenceColIndex.ContainsKey(row))
                           {

                               referenceColIndex.Add(row, new Dictionary<int,  ItemDataValueStruct>());
                           }
                           foreach (int col in block.cells[row].Keys)
                           {
                               //将行列对象写入目前已有的数据中
                               referenceDataTables[row][col] = block.cells[row][col];
                               ItemDataValueStruct ids = new ItemDataValueStruct();
                               ids.row = row;
                               ids.col = col;
                               referenceColIndex[row][col] = ids;
                           }
                       }
                   }
               }
               else if (layoutType == "02")
               {
                   //行布局
                   RowSort(blocks);
                   int colAccumulate = 0;
                   foreach (CellBlock block in cellBlocks)
                   {
                       int rowCount = 0;
                       int maxColCount =0;
                       foreach (int row in block.cells.Keys)
                       {

                           
                           if (!referenceDataTables.ContainsKey(rowCount))
                           {
                               referenceDataTables.Add(rowCount, new Dictionary<int, ItemDataValueStruct>());
                           }
                           if (!referenceColIndex.ContainsKey(row))
                           {
                               referenceColIndex.Add(row, new Dictionary<int, ItemDataValueStruct>());
                           }
                           int colCount = 0;
                           foreach (int col in block.cells[row].Keys)
                           {
                               //将行列对象写入目前已有的数据中
                               ItemDataValueStruct ids = new ItemDataValueStruct();
                               ids.row = rowCount;
                               ids.col= colCount + colAccumulate;
                               referenceColIndex[row][col] =ids;
                               referenceDataTables[ids.row][ids.col] = block.cells[row][col];
                             
                               colCount++;
                               if (maxColCount < block.cells[row].Count)
                               {
                                   maxColCount = block.cells[row].Count;
                               }
                           }
                           colAccumulate += maxColCount;
                           rowCount++;
                       }
                       rowCount++;
                   }
               }
               else if (layoutType == "03")
               {
                   ColSort(blocks);
                   int rowAccmu = 0;

                   foreach (CellBlock block in cellBlocks)
                   {
                       int rowCount = 0;
                       int maxRowCount = block.cells.Count;
                       foreach (int row in block.cells.Keys)
                       {
                       
                           if (!referenceDataTables.ContainsKey(rowCount + rowAccmu))
                           {
                               referenceDataTables.Add(rowCount + rowAccmu, new Dictionary<int, ItemDataValueStruct>());
                           }
                           if (!referenceColIndex.ContainsKey(row))
                           {
                               referenceColIndex.Add(row, new Dictionary<int, ItemDataValueStruct>());
                           }
                           int colCount = 0;
                           foreach (int col in block.cells[row].Keys)
                           {
                               //将行列对象写入目前已有的数据中       
                               ItemDataValueStruct idvs = new ItemDataValueStruct();
                               idvs.row = rowCount + rowAccmu;
                               idvs.col = colCount;                               
                               referenceDataTables[idvs.row][idvs.col] = block.cells[row][col];
                               referenceColIndex[row][col] = idvs;
                               colCount++;
                           }
                           rowCount++;
                       }
                       rowAccmu += maxRowCount;
                   }
                   
               }
               return blocks;
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }
       /// <summary>
       /// 行优先排序
       /// </summary>
       /// <param name="blocks"></param>
       /// <returns></returns>
       private void  RowSort(List<CellBlock> blocks)
       {
           try
           {
               
               for (int i = 0; i < blocks.Count; i++)
               {
                   for (int j = i + 1; j < blocks.Count; j++)
                   {
                       if (blocks[i].FirstRow > blocks[j].FirstRow)
                       {
                           CellBlock temp = blocks[i];
                           blocks[i] = blocks[j];
                           blocks[j] = temp;
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
       /// 列优先排序
       /// </summary>
       /// <param name="blocks"></param>
       /// <returns></returns>
       private void ColSort(List<CellBlock> blocks)
       {
           try
           {

               for (int i = 0; i < blocks.Count; i++)
               {
                   for (int j = i + 1; j < blocks.Count; j++)
                   {
                       if (blocks[i].FirstCol > blocks[j].FirstCol)
                       {
                           CellBlock temp = blocks[i];
                           blocks[i] = blocks[j];
                           blocks[j] = temp;
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
       /// 表格排序
       /// 先行后列
       /// </summary>
       /// <param name="blocks"></param>
       private void TableSort(List<CellBlock> blocks)
       {
           try
           {
               for (int i = 0; i < blocks.Count; i++)
               {
                   for (int j = i + 1; j < blocks.Count; j++)
                   {
                       if (blocks[i].FirstRow > blocks[j].FirstRow)
                       {
                           CellBlock temp = blocks[i];
                           blocks[i] = blocks[j];
                           blocks[j] = temp;
                       }
                       else if (blocks[i].FirstRow == blocks[j].FirstRow)
                       {
                           if (blocks[i].FirstCol > blocks[j].FirstCol)
                           {
                               CellBlock temp = blocks[i];
                               blocks[i] = blocks[j];
                               blocks[j] = temp;
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
       /// <summary>
       /// 解析行列数据
       /// </summary>
       /// <param name="cellRowCol"></param>
       /// <returns></returns>
       private int[] DeserializeCellRowCol(string cellRowCol, bool flag)
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
       /// 设置宏函数报表相关的解析参数
       /// </summary>
       /// <param name="rdps"></param>
       public void SetReportParameters(ReportDataParameterStruct rdps)
       {
           this.rdps = rdps;
           macroHelp.ReportParameter = rdps;
       }
    }
}
