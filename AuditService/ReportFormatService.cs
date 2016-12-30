using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Common;
using System.Data;
using System.IO;

using AuditEntity;
using AuditSPI.Format;
using DbManager;
using GlobalConst;
using CtTool;
using AuditSPI;
using CtTool.BB;
using AuditEntity.ReportAttatch;

namespace AuditService
{
    public  class ReportFormatService:IReportFormat
    {
        CTDbManager dbManager;
        ReportClassifyService classifyService;
        public ReportFormatService()
        {
            if (dbManager == null)
            {
                dbManager = new CTDbManager();
            }
            if (classifyService == null)
            {
                classifyService = new ReportClassifyService();
            }
        }

#region 报表格式保存
        /// <summary>
        /// 保存报表格式信息
        /// </summary>
        /// <param name="report"></param>
        public void SaveBBFormat(BBData bbData)
        {
            DbConnection connection = dbManager.GetDbConnection();
            DbCommand command = dbManager.getDbCommand();
            dbManager.Open();
            DbTransaction transactoin = connection.BeginTransaction();
            try
            {
                

                command.Transaction = transactoin;
                if (StringUtil.IsNullOrEmpty(bbData.Id))
                {
                    bbData.Id = Guid.NewGuid().ToString();
                    bbData.BBState = "1";
                }
                else
                {
                    bbData.BBState = "2";
                }
              
                //保存数据项信息
                SaveDataItems(bbData, command);

                if (bbData.BBState == "1")
                {
                    //创建固定区报表的数据
                    SaveFixReportRegion(bbData, command);
                    //保存变动区数据和创建变动区数据结构
                    SaveChangeReportRegion(bbData, command);

                    //保存报表格式数据
                    CreateReportDictionary(bbData, command);
                    //保存报表类别
                    CreateReportClassify(bbData, command);
                }
                else
                {
                    UpdateChangeReportDic(bbData, command);
                    UpdateFixAndChangeRegionDatas(bbData, command);
                    UpdateReportDictionary(bbData, command);
                }
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
        private void UpdateReportDictionary(BBData bbData, DbCommand command)
        {
            try
            {
                List<string> names = new List<string>();
                names.Add("formularStr");
                names.Add("Id");
                string whereSql = " WHERE REPORTDICTIONARY_ID='"+bbData.Id+"'";
                List<DbParameter> parameters = new List<DbParameter>();
                 ReportFormatDicEntity reportDic = CreateReportFormatDicEntity(bbData, command);
                 string upsql = dbManager.ConvertBeanToUpdateSql<ReportFormatDicEntity>(reportDic, whereSql, parameters, names);
                 command.CommandText =upsql;
                 foreach (DbParameter p in parameters)
                 {
                     command.Parameters.Add(p);
                 }
                 command.ExecuteNonQuery();
                 command.Parameters.Clear();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 创建报表字典
        /// </summary>
        /// <param name="bbData"></param>
        /// <param name="command"></param>
        private void CreateReportDictionary(BBData bbData, DbCommand command)
        {
            try
            {
                ReportFormatDicEntity reportDic = CreateReportFormatDicEntity(bbData, command);
                DbParameter parameter = dbManager.GetDbParameter();
                string sql = dbManager.ConvertBeanToDeleteCommandSql<ReportFormatDicEntity>(reportDic, "bbCode", parameter);
                command.CommandText = sql;
                if (parameter.Value != null)
                {
                    command.Parameters.Add(parameter);
                }

                command.ExecuteNonQuery();
                command.Parameters.Clear();



                List<DbParameter> parameters = new List<DbParameter>();
                sql = dbManager.ConvertBeanToInsertCommandSql<ReportFormatDicEntity>(reportDic, parameters);

                command.CommandText = sql;
                foreach (DbParameter p in parameters)
                {
                    command.Parameters.Add(p);
                }
                command.ExecuteNonQuery();
                command.Parameters.Clear();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 保存报表分类
        /// </summary>
        /// <param name="bbData"></param>
        /// <param name="command"></param>
        private void CreateReportClassify(BBData bbData, DbCommand command)
        {
            try
            {
                ReportRelationEntity rel=new ReportRelationEntity();
                if (StringUtil.IsNullOrEmpty(rel.Id))
                {
                    rel.Id = Guid.NewGuid().ToString();
                }
                rel.ReportId=bbData.Id;
                rel.ClassifyId=bbData.bbClassifyId;

                List<DbParameter> parameters = new List<DbParameter>();
                string sql = dbManager.ConvertBeanToInsertCommandSql<ReportRelationEntity>(rel, parameters);
                command.CommandText = sql;
                foreach (DbParameter p in parameters)
                {
                    command.Parameters.Add(p);
                }
                command.ExecuteNonQuery();
                command.Parameters.Clear();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 更新固定区和变动区数据
        /// </summary>
        /// <param name="bbData"></param>
        /// <param name="command"></param>
        private void UpdateFixAndChangeRegionDatas(BBData bbData, DbCommand command)
        {
            try
            {
                foreach (string tableName in bbData.UpdateTablesAndDatas.Keys)
                {
                    foreach (DataItemEntity item in bbData.UpdateTablesAndDatas[tableName])
                    {
                        StringBuilder updateSql = new StringBuilder();
                        StringBuilder deleteSql = new StringBuilder();

                       

                        updateSql.Append("ALTER ");
                        updateSql.Append(" TABLE ");
                        updateSql.Append(tableName);
                        if (item.UpdateState == "2")
                        {                           
                            updateSql.Append(" ADD ");
                            deleteSql.Append("if exists(select * from syscolumns where id=object_id('"+tableName+"') and name='"+item.Code+"') ");
                            deleteSql.Append(" ALTER ");
                            deleteSql.Append("TABLE ");
                            deleteSql.Append(tableName);
                            deleteSql.Append(" DROP ");
                            deleteSql.Append(" COLUMN ");
                            deleteSql.Append("[");
                            deleteSql.Append(item.Code);
                            deleteSql.Append("]");
                        }
                        else if (item.UpdateState == "1")
                        {
                            updateSql.Append(" ALTER COLUMN ");
                        }

                        if (item.CellDataType == ReportGlobalConst.DATATYPE_TEXT)
                        {
                            updateSql.Append("[");
                            updateSql.Append(item.Code);
                            updateSql.Append("]");
                                                

                            updateSql.Append(" varchar(");
                            updateSql.Append(item.Length);
                            updateSql.Append(") ");
                            updateSql.Append("NULL");
                        }
                        else if (item.CellDataType == ReportGlobalConst.DATATYPE_NUMBER)
                        {
                            updateSql.Append("[");
                            updateSql.Append(item.Code);
                            updateSql.Append("]");
                            updateSql.Append(" decimal(16,2)");
                            updateSql.Append("");
                        }
                        if (deleteSql.Length > 0)
                        {
                            command.CommandText = deleteSql.ToString();
                            command.ExecuteNonQuery();
                        }
                        command.CommandText = updateSql.ToString();
                        command.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private ReportFormatDicEntity CreateReportFormatDicEntity(BBData bbData,DbCommand command)
        {
            try
            {           
                
                ReportFormatDicEntity report = new ReportFormatDicEntity();
                report.Id =bbData.Id;
                report.createTime = SessoinUtil.GetCurrentDateTime();
                report.creater = SessoinUtil.GetCurrentUser().Id;
                report.bbCode = bbData.bbCode;
                report.bbName = bbData.bbName;
                report.formatStr = bbData.formatStr;
                report.itemStr = bbData.dataStr;
                report.bbRows = bbData.bbRows;
                report.bbCols = bbData.bbCols;
                report.bbCycle = bbData.zq.Split(':')[0];
                report.creater = SessoinUtil.GetCurrentUser().Id;
                report.fixTableName = bbData.fixTableName;
                return report;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 更新数据项算法：
        /// 1、如果是新增则，直接采用先删后增的办法进行保存；
        /// 2、如果是更新，则需要查找每个数据项所采用的办法；
        ///   如果单元格进行更新，则进行更新操作；
        ///   如果单元格删除，则进行删除操作；
        /// </summary>
        /// <param name="bbData"></param>
        /// <param name="command"></param>
        private void SaveDataItems(BBData bbData, DbCommand command)
        {
            try
            {
                if (bbData.BBState == "1")
                {
                    //首先删除报表编号相同的数据项信息
                    string sql = "DELETE FROM CT_FORMAT_DATAITEM WHERE DATAITEM_REPORTID IN (SELECT REPORTDICTIONARY_ID FROM CT_FORMAT_REPORTDICTIONARY WHERE REPORTDICTIONARY_CODE='" + bbData.bbCode + "' )";
                    command.CommandText = sql;
                    command.ExecuteNonQuery();
                    //保存数据项信息
                    foreach (int row in bbData.bbData.Keys)
                    {

                        foreach (int col in bbData.bbData[row].Keys)
                        {

                            BdJudge bdJudge = JudgeCellGdOrBd(bbData, row, col);

                            DataItemEntity die = ConvertCellToDataItem(bbData.bbData[row][col], bbData, bdJudge);
                            if (die.Row == -1 || die.Col == -1||StringUtil.IsNullOrEmpty(die.CellDataType)) continue;
                            //保存每个单元格信息
                            List<DbParameter> parameters = new List<DbParameter>();
                            sql = dbManager.ConvertBeanToInsertCommandSql<DataItemEntity>(die, parameters);
                            foreach (DbParameter p in parameters)
                            {
                                command.Parameters.Add(p);
                            }
                            command.CommandText = sql;
                            command.ExecuteNonQuery();
                            command.Parameters.Clear();
                        }
                    }
                }
                else 
                {
                    string upSql="SELECT * FROM CT_FORMAT_DATAITEM WHERE DATAITEM_REPORTID IN (SELECT REPORTDICTIONARY_ID FROM CT_FORMAT_REPORTDICTIONARY WHERE REPORTDICTIONARY_CODE='" + bbData.bbCode + "' )";
                    command.CommandText = upSql;
                    DbDataReader dr = command.ExecuteReader();
                    //获取已有的数据项列表
                    List<DataItemEntity> items = new List<DataItemEntity>();
                    try
                    {
                       
                           items = dbManager.ConvertDataReaderToType<DataItemEntity>(dr);
                           dr.Close();
                    }
                    catch (Exception ex)
                    {
                        dr.Close();
                        throw ex;
                    }
                    //数据项字典
                    Dictionary<string, DataItemEntity> mapItems = new Dictionary<string, DataItemEntity>();
                    foreach (DataItemEntity item in items)
                    {
                        if (StringUtil.IsNullOrEmpty(item.Code))
                        {
                            string sql = "DELETE FROM CT_FORMAT_DATAITEM WHERE DATAITEM_ID='" + item.Id + "'";
                            command.CommandText = sql;
                            command.ExecuteNonQuery();
                        }
                        else
                        {
                            mapItems[item.Code]= item;
                        }
                       
                    }
                    Dictionary<string, Cell> newMapItems = new Dictionary<string, Cell>();
                    StringBuilder deleteItems = new StringBuilder();
                    //更新数据
                    foreach (int row in bbData.bbData.Keys)
                    {
                        foreach (int col in bbData.bbData[row].Keys)
                        {
                            if (StringUtil.IsNullOrEmpty(bbData.bbData[row][col].CellCode)) continue;
                            if (!newMapItems.ContainsKey(bbData.bbData[row][col].CellCode))
                            {
                                newMapItems.Add(bbData.bbData[row][col].CellCode, bbData.bbData[row][col]);
                            }
                           
                            //if (bbData.bbData[row][col].isOrUpdate == "1")
                            //{                               
                                BdJudge bdJudge = JudgeCellGdOrBd(bbData, row, col);
                                DataItemEntity die = ConvertCellToDataItem(bbData.bbData[row][col], bbData, bdJudge);                                
                                if (die.Row == 0 || die.Col == 0) continue;

                                //查找已有的数据项
                                DataItemEntity old = null;
                                List<DbParameter> parameters = new List<DbParameter>();
                                string sql = "";
                                if (mapItems.ContainsKey(die.Code)) { old = mapItems[die.Code]; }
                                
                                if (old != null)
                                {
                                    //如果存在，则进行差异化更新
                                    die.Id = old.Id;
                                    sql = dbManager.ConvertBeanByOldBeanToUpdateSql<DataItemEntity>(die, old, " WHERE DATAITEM_ID='" + die.Id + "'", parameters);
                                    command.CommandText = sql; 
                                    die.UpdateState="1";
                                }
                                else
                                {
                                    //如果不存在，则进行插入
                                    sql = dbManager.ConvertBeanToInsertCommandSql<DataItemEntity>(die, parameters);
                                    die.UpdateState = "2";
                                    command.CommandText = sql;
                                }
                                foreach (DbParameter p in parameters)
                                {
                                    command.Parameters.Add(p);
                                }
                                command.ExecuteNonQuery();
                                command.Parameters.Clear();


                                //预装更新字典；
                                if (bbData.UpdateTablesAndDatas.Keys.Contains(die.TableName))
                                {
                                    bbData.UpdateTablesAndDatas[die.TableName].Add(die);
                                }
                                else
                                {
                                    List<DataItemEntity> lists = new List<DataItemEntity>();
                                    lists.Add(die);
                                    bbData.UpdateTablesAndDatas.Add(die.TableName, lists);
                                }
                            //}
                           

                        }
                    }

                    //删除多余的Items
                    foreach (string code in mapItems.Keys)
                    {
                        if (!newMapItems.ContainsKey(code))
                        {
                            deleteItems.Append("'");
                            deleteItems.Append(mapItems[code].Id);
                            deleteItems.Append("'");
                            deleteItems.Append(",");
                        }
                    }
                    if (deleteItems.Length > 0)
                    {
                        deleteItems.Length--;
                        string deleteSql = "DELETE FROM CT_FORMAT_DATAITEM WHERE DATAITEM_ID IN (" + deleteItems.ToString() + ")";
                        command.CommandText=deleteSql;
                        command.ExecuteNonQuery();
                    }
                  
                }
                
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 将单元格转换为数据项对象
       /// </summary>
       /// <param name="cell"></param>
       /// <param name="bbData"></param>
       /// <param name="bdJudge"></param>
       /// <returns></returns>
        private DataItemEntity ConvertCellToDataItem(Cell cell,BBData bbData,BdJudge bdJudge)
        {
            try
            {
                DataItemEntity die = new DataItemEntity();
                die.Id = Guid.NewGuid().ToString();
                die.Help = cell.CellHelp;
                die.CellDataType = cell.CellDataType;
                die.CellType = cell.CellType;
                die.Code = cell.CellCode;
                die.Col = cell.CellCol;
                die.Currency = cell.CellCurrence;
                die.Length = cell.CellLength;
                die.Lock = cell.CellLock;
                die.Macro = cell.CellMacro;
                die.Name = cell.CellName;
                die.ReportId = bbData.Id;
                die.Row = cell.CellRow;
                die.Smbol = cell.CellSmbol;
                die.TableName = FormatTool.CreateBBTableName(bbData.bbCode, bdJudge.isFixOrChagne, bdJudge.index,bdJudge.BdCode);
                die.Thousand = cell.CellThousand;
                die.Zero = cell.CellZero;
                die.CellAggregation = cell.CellAggregation;
                die.CellAggregationType = cell.CellAggregationType;
                die.CellPrimary = cell.CellPrimary;
                die.DigitNumber = cell.DigitNumber;
                die.ParaValue = cell.CellValue;
                return die;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 判断当前单元格是否为变动单元格
        /// </summary>
        /// <param name="bbData"></param>
        /// <param name="row"></param>
        /// <param name="col"></param>
        /// <returns></returns>
        private BdJudge JudgeCellGdOrBd(BBData bbData, int row, int col)
        {
            BdJudge bdJudge = new BdJudge();
            bdJudge.index = 1;
            bdJudge.isFixOrChagne = true;
            for (int i = 0; i < bbData.bdq.Bdqs.Count; i++)
            {
                Bdq bdq = bbData.bdq.Bdqs[i];
                if (bdq == null) continue;
                if (bdq.BdType == ReportGlobalConst.Report_ChangeRow&& row==bdq.Offset)
                {
                    bdJudge.isFixOrChagne = false;
                    bdJudge.index = i+1;
                    bdJudge.BdCode = bdq.Code;
                    break;
                }
                else if (bdq.BdType == ReportGlobalConst.Report_ChangeCol&&col==bdq.Offset)
                {
                    bdJudge.isFixOrChagne = false;
                    bdJudge.index = i+1;
                    bdJudge.BdCode = bdq.Code;
                    break;
                }
              
            }
            
            return bdJudge;
        }
        /// <summary>
        /// 保存固定区数据
        /// </summary>
        /// <param name="bbdata"></param>
        /// <param name="command"></param>
        private void SaveFixReportRegion(BBData bbdata,DbCommand command)
        {
            try{
            string tableName = FormatTool.CreateBBTableName(bbdata.bbCode, true, 1,null);
            bbdata.fixTableName = tableName;
            String dropSql = "IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'" + tableName + "') AND type in (N'U')) "
                + " DROP TABLE " + tableName;
            command.CommandText = dropSql;
            command.ExecuteNonQuery();

            StringBuilder createSql = new StringBuilder();
            createSql.Append("CREATE TABLE " + tableName + "(");
            createSql.Append("DATA_ID varchar(36) NOT NULL,");
            createSql.Append("DATA_TASKID varchar(36) NULL,");
            createSql.Append("DATA_MANUSCRIPT varchar(36) NULL,");
            createSql.Append("DATA_COMPANYID varchar(36) NULL,");
            createSql.Append("DATA_REPORTID varchar(36) NULL,");

            createSql.Append("DATA_YEAR varchar(4) NULL,");
            createSql.Append("DATA_CYCLE varchar(36) NULL,");
            createSql.Append("DATA_TIME varchar(20) NULL,");
            createSql.Append("DATA_CREATER varchar(36) NULL,");
            foreach (int row in bbdata.bbData.Keys)
            {
                foreach (int col in bbdata.bbData[row].Keys)
                {
                    BdJudge bdJudge = JudgeCellGdOrBd(bbdata, row, col);
                    if (bdJudge.isFixOrChagne)
                    {
                        Cell cell = bbdata.bbData[row][col];
                        if (cell.CellDataType == ReportGlobalConst.DATATYPE_TEXT)
                        {
                            createSql.Append("[");
                            createSql.Append(cell.CellCode);
                            createSql.Append("]");
                            createSql.Append(" varchar(");
                            createSql.Append(cell.CellLength.ToString());
                            createSql.Append(") ");
                            createSql.Append("NULL,");
                        }
                        else if (cell.CellDataType == ReportGlobalConst.DATATYPE_NUMBER)
                        {
                            createSql.Append("[");
                            createSql.Append(cell.CellCode);
                            createSql.Append("]");
                            createSql.Append(CreateCellDigitsNumber(cell));
                            createSql.Append(",");
                        }
                    }
                }
            }
            createSql.Length--;
            createSql.Append(")");
            command.CommandText = createSql.ToString();
            command.ExecuteNonQuery();
            }catch(Exception ex){
            throw ex;
            }
        }
        /// <summary>
        /// 保存变动区数据
        /// 1、删除与报表相关的变动区；
        /// 2、创建变动区数据；
        /// 3、创建变动区字典；
        /// 4、创建变动区和报表关系；
        /// </summary>
        public void SaveChangeReportRegion(BBData bbData,DbCommand command)
        {
            try
            {
                //删除报表相关的变动区；
                StringBuilder sb = new StringBuilder();

                //删除变动行字典
                sb.Append("DELETE FROM CT_FORMAT_ROWCHANGEDICTIONARY WHERE ROWCHANGEDICTIONARY_ID IN ");
                sb.Append(" (SELECT REPORTANDCHANGEREGIONAL_CHANGEREGIONID FROM CT_FORMAT_REPORTANDCHANGEREGIONAL WHERE REPORTANDCHANGEREGIONAL_REPORTID");
                sb.Append(" IN (SELECT REPORTDICTIONARY_ID FROM CT_FORMAT_REPORTDICTIONARY WHERE REPORTDICTIONARY_CODE='" + bbData.bbCode + "') )");
                command.CommandText = sb.ToString();
                command.ExecuteNonQuery();
                //删除变动列字典
                sb.Length = 0;
                sb.Append("DELETE FROM CT_FORMAT_COLUMNCHANGEDICTIONARY WHERE COLUMNCHANGEDICTIONARY_ID IN ");
                sb.Append(" (SELECT REPORTANDCHANGEREGIONAL_CHANGEREGIONID FROM CT_FORMAT_REPORTANDCHANGEREGIONAL WHERE REPORTANDCHANGEREGIONAL_REPORTID");
                sb.Append(" IN (SELECT REPORTDICTIONARY_ID FROM CT_FORMAT_REPORTDICTIONARY WHERE REPORTDICTIONARY_CODE='" + bbData.bbCode + "') )");
                command.CommandText = sb.ToString();
                command.ExecuteNonQuery();

                //删除变动区关系表
                sb.Length = 0;
                sb.Append("DELETE FROM CT_FORMAT_REPORTANDCHANGEREGIONAL WHERE REPORTANDCHANGEREGIONAL_REPORTID IN ");
                sb.Append("(SELECT REPORTDICTIONARY_ID FROM CT_FORMAT_REPORTDICTIONARY WHERE REPORTDICTIONARY_CODE='" + bbData.bbCode + "') ");
                command.CommandText = sb.ToString();
                command.ExecuteNonQuery();

           

               sb.Length = 0;
               sb.Append("SELECT [NAME] FROM sys.objects where name like 'CT_BD_"+bbData.bbCode+"%'");
               command.CommandText = sb.ToString();
               DbDataReader dr= command.ExecuteReader();
               List<string> sqls = new List<string>();
               try
               {
                   while (dr.Read())
                   {
                       sb.Length = 0;
                       sb.Append(" DROP TABLE ");
                       sb.Append(dr["NAME"]);
                       sqls.Add(sb.ToString());
                   }
                   dr.Close();
               }
               catch (Exception ex)
               {
                   dr.Close();
                   throw ex;
               }
               foreach (string s in sqls)
               {
                   command.CommandText = s;
                   command.ExecuteNonQuery();
               }
            

                for (int i = 0; i < bbData.bdq.bdNum; i++)
                {
                    Bdq bdq = bbData.bdq.Bdqs[i];
                    if (bdq == null) continue;
                    bdq.Id = Guid.NewGuid().ToString();
                    if (bdq.BdType == ReportGlobalConst.Report_ChangeRow)
                    {
                        SaveRowChangeReportDic(bdq, command, bbData, i+1);
                    }
                    else if (bdq.BdType == ReportGlobalConst.Report_ChangeCol)
                    {
                        SaveColChangeReportDic(bdq, command, bbData, i + 1);
                    }
                    //保存变动区关系
                    SaveChangeRelation(bbData.Id, bdq.Id, bdq.BdType, command);
                    //创建变动区数据表
                    CreateChangeDataTable(bbData, bdq, i + 1, command);
                }
               
            }
               
            catch (Exception ex)
            {
                
                throw ex;
            }
        }

        
        private void UpdateChangeReportDic(BBData bbData, DbCommand command)
        {
            try
            {
                StringBuilder sb = new StringBuilder();
                

                sb.Length = 0;
                sb.Append("SELECT [NAME] FROM sys.objects where name like 'CT_BD_" + bbData.bbCode + "%'");
                command.CommandText = sb.ToString();
                DbDataReader dr = command.ExecuteReader();
                List<string> sqls = new List<string>();
                try
                {
                    while (dr.Read())
                    {
                        sqls.Add(dr["NAME"].ToString());
                    }
                    dr.Close();
                }
                catch (Exception ex)
                {
                    dr.Close();
                    throw ex;
                }
                for (int i = 0; i < bbData.bdq.bdNum; i++)
                {
                    Bdq bdq = bbData.bdq.Bdqs[i];
                    if (bdq == null) continue;
                    string tempTable = FormatTool.CreateBBTableName(bbData.bbCode, false, i+1, bdq.Code); 
                    if (bdq == null) continue;
                    bool isOrNotNew = true;
                    //判断是否存在变动区
                    foreach(string table in sqls){
                        if (tempTable == table) { isOrNotNew = false; break; }
                    }
                    if (!isOrNotNew)
                    {
                        //如果存在，则需要改变已有的单元格数据
                        if (bdq.BdType == ReportGlobalConst.Report_ChangeRow)
                        {
                            //变动行
                            ReportRowChangeEntity rrce=CreateReportRowChangeEntity(bdq,bbData);
                            List<string> rowExcludes=new List<string>();
                            rowExcludes.Add("Id");
                            rowExcludes.Add("RegionTable");
                            List<DbParameter> parameters = new List<DbParameter>();
                            string whereSql = " WHERE ROWCHANGEDICTIONARY_REGIONTABLE='"+tempTable+"'";
                           string sql = dbManager.ConvertBeanToUpdateSql<ReportRowChangeEntity>(rrce,whereSql,parameters, rowExcludes);
                           ExecuteSql(command, sql, parameters);
                            
                        }
                        else if (bdq.BdType == ReportGlobalConst.Report_ChangeCol)
                        {
                            //变动列
                            ReportColChangeEntity rcce = CreateReportColChangeEntity(bdq, bbData);
                            List<string> colExcludes = new List<string>();
                            colExcludes.Add("Id");
                            colExcludes.Add("RegionTable");
                            List<DbParameter> parameters = new List<DbParameter>();
                            string whereSql = " WHERE COLUMNCHANGEDICTIONARY_REGIONTABLE='" + tempTable + "'";
                            string sql = dbManager.ConvertBeanToUpdateSql<ReportColChangeEntity>(rcce, whereSql, parameters, colExcludes);
                            ExecuteSql(command, sql, parameters);
                        }
                    }
                    else
                    {
                        //如果不存在，则需要重新创建
                        bbData.UpdateTablesAndDatas.Remove(tempTable);
                        bdq.Id = Guid.NewGuid().ToString();
                        if (bdq.BdType == ReportGlobalConst.Report_ChangeRow)
                        {
                            SaveRowChangeReportDic(bdq, command, bbData, i + 1);
                        }
                        else if (bdq.BdType == ReportGlobalConst.Report_ChangeCol)
                        {
                            SaveColChangeReportDic(bdq, command, bbData, i + 1);
                        }
                        //保存变动区关系
                        SaveChangeRelation(bbData.Id, bdq.Id, bdq.BdType, command);
                        //创建变动区数据表
                        CreateChangeDataTable(bbData, bdq, i + 1, command);
                    }
                   
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 执行SQL
        /// </summary>
        /// <param name="command"></param>
        /// <param name="parameters"></param>
        private void ExecuteSql(DbCommand command,string sql, List<DbParameter> parameters)
        {
            try
            {
                foreach (DbParameter parameter in parameters)
                {
                    command.Parameters.Add(parameter);
                }
                command.CommandText = sql;
                command.ExecuteNonQuery();
                command.Parameters.Clear();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 保存变动列字典
        /// </summary>
        /// <param name="bdq"></param>
        /// <param name="command"></param>
        /// <param name="bbData"></param>
        /// <param name="index"></param>
        private void SaveColChangeReportDic(Bdq bdq,DbCommand command,BBData bbData,int index){
        
          try
            {
                ReportColChangeEntity rrce = CreateReportColChangeEntity(bdq, bbData);
                List<DbParameter> lists=new List<DbParameter>();
                string sql = dbManager.ConvertBeanToInsertCommandSql<ReportColChangeEntity>(rrce,lists);
                foreach (DbParameter parameter in lists)
                {
                    command.Parameters.Add(parameter);
                }
                command.CommandText = sql;
                command.ExecuteNonQuery();
                command.Parameters.Clear();
               
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 根据变动区信息创建列变动区信息
        /// </summary>
        /// <param name="bdq"></param>
        /// <param name="bbData"></param>
        /// <returns></returns>
        private ReportColChangeEntity CreateReportColChangeEntity(Bdq bdq, BBData bbData)
        {
            try
            {
                ReportColChangeEntity rrce = new ReportColChangeEntity();
                rrce.Id = bdq.Id;
                rrce.Code = bdq.Code;
                if (bdq.DataCode != 0)
                {
                    rrce.DataCode = bbData.bbData[bdq.DataCode][bdq.Offset].CellCode;
                }
                if (bdq.DataName != 0)
                {
                    rrce.DataName = bbData.bbData[bdq.DataName][bdq.Offset].CellCode;
                }
                if (bdq.SortRow != 0)
                {
                    rrce.ColSort = bbData.bbData[bdq.SortRow][bdq.Offset].CellCode;
                }
                if (bdq.isOrNotMerge)
                {
                    rrce.IsOrNotMerge = "1";
                }
                else
                {
                    rrce.IsOrNotMerge = "0";
                }

                rrce.Offset = bdq.Offset;
                rrce.ColNumber = 1;
                rrce.RegionTable = FormatTool.CreateBBTableName(bbData.bbCode, false, -1, bdq.Code);
                return rrce;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 保存变动行字典
        /// </summary>
        /// <param name="bdq"></param>
        /// <param name="command"></param>
        /// <param name="bbData"></param>
        /// <param name="index"></param>
        private void SaveRowChangeReportDic(Bdq bdq, DbCommand command,BBData bbData,int index)
        {
            try
            {
                ReportRowChangeEntity rrce = CreateReportRowChangeEntity(bdq, bbData);
                List<DbParameter> lists=new List<DbParameter>();
                string sql = dbManager.ConvertBeanToInsertCommandSql<ReportRowChangeEntity>(rrce,lists);
                foreach (DbParameter parameter in lists)
                {
                    command.Parameters.Add(parameter);
                }
                command.CommandText = sql;
                command.ExecuteNonQuery();
                command.Parameters.Clear();
               
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 创建报表变动行数据信息
        /// </summary>
        /// <param name="bdq"></param>
        /// <param name="bbData"></param>
        /// <returns></returns>
        private ReportRowChangeEntity CreateReportRowChangeEntity(Bdq bdq, BBData bbData)
        {
            try
            {
                ReportRowChangeEntity rrce = new ReportRowChangeEntity();
                rrce.Id = bdq.Id;
                rrce.Code = bdq.Code;
                if (bdq.DataCode != 0)
                {
                    rrce.DataCode = bbData.bbData[bdq.Offset][bdq.DataCode].CellCode;
                }
                else
                {
                    rrce.DataCode = "";
                }
                if (bdq.DataName != 0)
                {
                    rrce.DataName = bbData.bbData[bdq.Offset][bdq.DataName].CellCode;
                }
                else
                {
                    rrce.DataCode = "";
                }
                if (bdq.SortRow != 0)
                {
                    rrce.RowSort = bbData.bbData[bdq.Offset][bdq.SortRow].CellCode;
                }
                else
                {
                    rrce.RowSort = "";
                }
                if (bdq.isOrNotMerge)
                {
                    rrce.IsOrNotMerge = "1";
                }
                else
                {
                    rrce.IsOrNotMerge = "0";
                }

                rrce.RowNumber = 1;
                rrce.RegionTable = FormatTool.CreateBBTableName(bbData.bbCode, false, -1, bdq.Code);
                return rrce;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 保存变动区域报表关系字典
        /// </summary>
        /// <param name="reportId"></param>
        /// <param name="bdqId"></param>
        /// <param name="type"></param>
        /// <param name="command"></param>
        private void SaveChangeRelation(string reportId,string bdqId,string type,DbCommand command)
        {
            try
            {
                ReportChangeRelationEntity rcre = new ReportChangeRelationEntity();
                rcre.Id = Guid.NewGuid().ToString();
                rcre.ReportId = reportId;
                rcre.ChangeId = bdqId;
                rcre.ChangeType = type;
                List<DbParameter> lists = new List<DbParameter>();
                string sql = dbManager.ConvertBeanToInsertCommandSql<ReportChangeRelationEntity>(rcre, lists);
                foreach (DbParameter parameter in lists)
                {
                    command.Parameters.Add(parameter);
                }
                command.CommandText = sql;
                command.ExecuteNonQuery();
                command.Parameters.Clear();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        private void CreateChangeDataTable(BBData bbData, Bdq bdq, int index,DbCommand command)
        {
            //删除变动区数据表
            string tableName = FormatTool.CreateBBTableName(bbData.bbCode, false, index,bdq.Code);
            String dropSql = "IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'" + tableName + "') AND type in (N'U')) "
                + " DROP TABLE " + tableName;
            command.CommandText = dropSql;
            command.ExecuteNonQuery();


            //创建变动区表格
            StringBuilder createSql = new StringBuilder();
            createSql.Append("CREATE TABLE " + tableName + "(");
            createSql.Append("DATA_ID varchar(36) Primary Key,");
            createSql.Append("DATA_TASKID varchar(36) NULL,");
            createSql.Append("DATA_MANUSCRIPT varchar(36) NULL,");
            createSql.Append("DATA_COMPANYID varchar(36) NULL,");
            createSql.Append("DATA_REPORTID varchar(36) NULL,");

            createSql.Append("DATA_YEAR varchar(4) NULL,");
            createSql.Append("DATA_CYCLE varchar(36) NULL,");
            createSql.Append("DATA_TIME varchar(20) NULL,");
            createSql.Append("DATA_CREATER varchar(36) NULL,");
            if (bdq.BdType == ReportGlobalConst.Report_ChangeRow && bbData.bbData.ContainsKey(bdq.Offset))
            {
                
                foreach (Cell cell in bbData.bbData[bdq.Offset].Values)
                {
                    if (cell.CellDataType == ReportGlobalConst.DATATYPE_TEXT)
                    {
                        createSql.Append("[");
                        createSql.Append(cell.CellCode);
                        createSql.Append("]");
                        createSql.Append(" varchar(");
                        createSql.Append(cell.CellLength.ToString());
                        createSql.Append(") ");
                        createSql.Append("NULL,");
                    }
                    else if (cell.CellDataType == ReportGlobalConst.DATATYPE_NUMBER)
                    {
                        createSql.Append("[");
                        createSql.Append(cell.CellCode);
                        createSql.Append("]");
                        createSql.Append(CreateCellDigitsNumber(cell));
                        createSql.Append(",");
                    }
                }
            }
            else if (bdq.BdType == ReportGlobalConst.Report_ChangeCol)
            {
                foreach (int row in bbData.bbData.Keys)
                {
                    if (!bbData.bbData[row].ContainsKey(bdq.Offset))
                    {
                        break;
                    }
                    Cell cell = bbData.bbData[row][bdq.Offset];
                    if (cell.CellDataType == ReportGlobalConst.DATATYPE_TEXT)
                    {
                        createSql.Append("[");
                        createSql.Append(cell.CellCode);
                        createSql.Append("]");
                        createSql.Append(" varchar(");
                        createSql.Append(cell.CellLength.ToString());
                        createSql.Append(") ");
                        createSql.Append("NULL,");
                    }
                    else if (cell.CellDataType == ReportGlobalConst.DATATYPE_NUMBER)
                    {
                        createSql.Append("[");
                        createSql.Append(cell.CellCode);
                        createSql.Append("]");
                        createSql.Append(CreateCellDigitsNumber(cell));
                        createSql.Append(",");
                    }
                }
            }

            createSql.Length--;
          

            createSql.Append(")");
            command.CommandText = createSql.ToString();
            command.ExecuteNonQuery();
        }
       /// <summary>
       /// 根据小数位数生成数据库小数位数
       /// </summary>
       /// <param name="cell"></param>
       /// <returns></returns>
        private string CreateCellDigitsNumber(Cell cell)
        {
            try
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" ");
                sb.Append("decimal(16,");
                sb.Append(cell.DigitNumber);
                sb.Append(")");
                return sb.ToString();
               
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

#endregion


        #region 获取报表字典列表
        /// <summary>
        /// 获取报表字典列表；
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <returns></returns>
        public DataGrid<AuditEntity.ReportFormatDicEntity> getDataGrid(DataGrid<AuditEntity.ReportFormatDicEntity> dataGrid, ReportFormatDicEntity rfde)
        {
            try
            {
                DataGrid<ReportFormatDicEntity> dg = new DataGrid<ReportFormatDicEntity>();
                string whereSql = "";
                if (!StringUtil.IsNullOrEmpty(rfde.bbName))
                {
                    whereSql = " WHERE REPORTDICTIONARY_NAME LIKE '%"+rfde.bbName+"%'";
                    if (!StringUtil.IsNullOrEmpty(rfde.bbCode)){
                        whereSql += " AND REPORTDICTIONARY_CODE  LIKE '%" + rfde.bbCode + "%'";
                    }
                }else{
                    if (!StringUtil.IsNullOrEmpty(rfde.bbCode))
                    {
                        whereSql = " WHERE REPORTDICTIONARY_CODE LIKE '%"+rfde.bbCode+"%'";
                    }
                }
                string sql = "SELECT REPORTDICTIONARY_ID,REPORTDICTIONARY_CODE,REPORTDICTIONARY_NAME,REPORTDICTIONARY_CREATETIME FROM CT_FORMAT_REPORTDICTIONARY"+whereSql;
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<ReportFormatDicEntity>();

                string sortName=maps[dataGrid.sort];
                List<ReportFormatDicEntity> lists = dbManager.ExecuteSqlReturnTType<ReportFormatDicEntity>(sql ,dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
                sql = "SELECT COUNT(*) FROM CT_FORMAT_REPORTDICTIONARY"+whereSql;
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
        /// <summary>
        /// 锁定
        /// </summary>
        /// <param name="ComPID"></param>
        /// <param name="TableName"></param>
        /// <returns></returns>
        public List<ReportCompFormatDicEntity> LoadCompReportFormat(string ComPID, string TableName)
        {
            try
            {
                DataGrid<ReportCompFormatDicEntity> dg = new DataGrid<ReportCompFormatDicEntity>();
                string sql = string.Format("SELECT LOCKITEM_ROW,LOCKITEM_COL FROM CT_FORMAT_LOCKITEM ", ComPID, TableName);//where LOCKITEM_CompID='{0}' and LOCKITEM_TABLENAME='{1}'
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<ReportCompFormatDicEntity>();
                List<ReportCompFormatDicEntity> lists = dbManager.ExecuteSqlReturnTType<ReportCompFormatDicEntity>(sql);
                return lists;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

       
        /// <summary>
        /// 获取报表编号、名称、分类和创建时间
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="rfde"></param>
        /// <returns></returns>
        public  DataGrid<ReportFormatDicEntity> ReportDataGrid(DataGrid<ReportFormatDicEntity> dataGrid, ReportFormatDicEntity rfde)
        {

            try
            {
                DataGrid<ReportFormatDicEntity> dg = new DataGrid<ReportFormatDicEntity>();
                string whereSql = " WHERE 1=1 ";
                if (!StringUtil.IsNullOrEmpty(rfde.bbName))
                {
                    whereSql += " AND REPORTDICTIONARY_NAME LIKE '%"+rfde.bbName+"%'";
                }

                if (!StringUtil.IsNullOrEmpty(rfde.bbCode))
                {
                    whereSql += " AND REPORTDICTIONARY_CODE LIKE '%" + rfde.bbCode + "%'";
                }
                if (!StringUtil.IsNullOrEmpty(rfde.ReportClassifyName))
                {
                    whereSql += " AND CLASSIFY_NAME LIKE '%" + rfde.ReportClassifyName + "%'";
                }
                if (!StringUtil.IsNullOrEmpty(rfde.ReportClassifyId))
                {
                    whereSql += " AND CLASSIFY_ID = '" + rfde.bbName + "'";
                }
                string sql = "SELECT REPORTDICTIONARY_ID,REPORTDICTIONARY_CODE,REPORTDICTIONARY_NAME,"+
" REPORTDICTIONARY_CREATETIME,CLASSIFY_NAME,CLASSIFY_ID FROM CT_FORMAT_REPORTDICTIONARY LEFT JOIN "+
" CT_FORMAT_RELATION ON REPORTDICTIONARY_ID=RELATION_REPORTID LEFT JOIN "+
" CT_FORMAT_CLASSIFY ON RELATION_CLASSIFYID=CLASSIFY_ID" + whereSql;
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<ReportFormatDicEntity>();
                maps.Add("ReportClassifyId", "CLASSIFY_ID");
                maps.Add("ReportClassifyName", "CLASSIFY_NAME");

                string sortName = maps[dataGrid.sort];
                List<ReportFormatDicEntity> lists = dbManager.ExecuteSqlReturnTType<ReportFormatDicEntity>(sql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
                sql = "SELECT COUNT(*)" +
" FROM CT_FORMAT_REPORTDICTIONARY LEFT JOIN " +
" CT_FORMAT_RELATION ON REPORTDICTIONARY_ID=RELATION_REPORTID LEFT JOIN " +
" CT_FORMAT_CLASSIFY ON RELATION_CLASSIFYID=CLASSIFY_ID" + whereSql; ;
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
        /// <summary>
        /// 获取报表单元格的格式数据
        /// </summary>
        /// <param name="reportCode"></param>
        /// <returns></returns>
        public ReportFormatDicEntity LoadReportCellFormat(string reportCode)
        {
            try
            {
                string sql = "SELECT REPORTDICTIONARY_CODE,REPORTDICTIONARY_NAME,REPORTDICTIONARY_FORMATINFO FROM CT_FORMAT_REPORTDICTIONARY WHERE REPORTDICTIONARY_CODE='"+reportCode+"'";
                List<ReportFormatDicEntity> rfde = dbManager.ExecuteSqlReturnTType<ReportFormatDicEntity>(sql);
                if (rfde != null && rfde.Count > 0)
                {
                    return rfde[0];
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
        /// 根据报表ID或者报表编号返回报表格式信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ReportFormatDicEntity LoadReportFormat(string idOrCode)
        {
            try
            {
                string sql = "SELECT * FROM CT_FORMAT_REPORTDICTIONARY WHERE REPORTDICTIONARY_ID='" + idOrCode + "'  OR REPORTDICTIONARY_CODE='"+idOrCode+"'";
               List< ReportFormatDicEntity> rfde = dbManager.ExecuteSqlReturnTType<ReportFormatDicEntity>(sql);
               if (rfde != null && rfde.Count > 0)
               {
                   return rfde[0];
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

       

        public List<ReportFormatDicEntity> getAllReport()
        {
            try
            {
                DataGrid<ReportFormatDicEntity> dg = new DataGrid<ReportFormatDicEntity>();
                string sql = "SELECT REPORTDICTIONARY_ID,REPORTDICTIONARY_CODE,REPORTDICTIONARY_NAME,REPORTDICTIONARY_CREATETIME FROM CT_FORMAT_REPORTDICTIONARY";
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<ReportFormatDicEntity>();
                List<ReportFormatDicEntity> lists = dbManager.ExecuteSqlReturnTType<ReportFormatDicEntity>(sql);
                return lists;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 加载报表格式不包括报表公式信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ReportFormatDicEntity LoadReportFormatNotInclueFormular(string id)
        {
            try
            {
                string sql = "SELECT REPORTDICTIONARY_FORMATINFO,REPORTDICTIONARY_DATAINFO FROM CT_FORMAT_REPORTDICTIONARY WHERE REPORTDICTIONARY_ID='"+id+"'";
                List<ReportFormatDicEntity>lists= dbManager.ExecuteSqlReturnTType<ReportFormatDicEntity>(sql);
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
        /// 获取当前报表相关的表名称列表
        /// 1、获取固定表名称；
        /// 2、获取变动表名称
        /// </summary>
        /// <param name="reportId">报表ID</param>
        /// <returns>表名列表</returns>
        public List<string> GetReportTables(string reportId)
        {
            try
            {
                List<string> tables = new List<string>();
                StringBuilder sql=new StringBuilder();
                sql.Append("SELECT REPORTDICTIONARY_FIXTABLENAME FROM CT_FORMAT_REPORTDICTIONARY");
                sql.Append(" WHERE REPORTDICTIONARY_ID='"+reportId+"'");
                List<ReportFormatDicEntity> reportFormats = dbManager.ExecuteSqlReturnTType<ReportFormatDicEntity>(sql.ToString());
                if (reportFormats.Count > 0)
                {
                    if (!StringUtil.IsNullOrEmpty(reportFormats[0].fixTableName))
                    {
                        tables.Add(reportFormats[0].fixTableName);
                    }                   
                }
                sql.Length = 0;
                //获取变动行数据表
                sql.Append("SELECT ROWCHANGEDICTIONARY_REGIONTABLE FROM CT_FORMAT_ROWCHANGEDICTIONARY H INNER JOIN CT_FORMAT_REPORTANDCHANGEREGIONAL R ON H.ROWCHANGEDICTIONARY_ID=R.REPORTANDCHANGEREGIONAL_CHANGEREGIONID AND ");
                sql.Append("REPORTANDCHANGEREGIONAL_REPORTID='"+reportId+"'");
                List<ReportRowChangeEntity> RowRegions = dbManager.ExecuteSqlReturnTType<ReportRowChangeEntity>(sql.ToString());
                if (RowRegions.Count > 0)
                {
                    foreach (ReportRowChangeEntity row in RowRegions)
                    {
                        if (!StringUtil.IsNullOrEmpty(row.RegionTable))
                        {
                            tables.Add(row.RegionTable);
                        }
                    }
                }
                //获取变动列数据表
                sql.Length = 0;
                sql.Append("SELECT COLUMNCHANGEDICTIONARY_REGIONTABLE FROM CT_FORMAT_COLUMNCHANGEDICTIONARY C INNER JOIN CT_FORMAT_REPORTANDCHANGEREGIONAL R ON C.COLUMNCHANGEDICTIONARY_ID=R.REPORTANDCHANGEREGIONAL_CHANGEREGIONID AND ");
                sql.Append("REPORTANDCHANGEREGIONAL_REPORTID='"+reportId+"'");
                List<ReportColChangeEntity> ColRegions = dbManager.ExecuteSqlReturnTType<ReportColChangeEntity>(sql.ToString());
                if (ColRegions.Count > 0)
                {
                    foreach (ReportColChangeEntity col in ColRegions)
                    {
                        if (!StringUtil.IsNullOrEmpty(col.RegionTable))
                        {
                            tables.Add(col.RegionTable);
                        }
                    }
                }
                return tables;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #region 删除报表后台结构信息
        /// <summary>
        /// 1、删除报表数据项信息 
        /// 2、删除报表公式信息
        /// 3、删除报表状态信息
        /// 4、删除报表公式信息；
        /// 5、删除报表附件信息；
        /// 6、删除报表固定区、变动区信息
        /// 7、删除报表与报表分类关系信息；
        /// 8、删除审计底稿和报表关系信息
        /// 9、删除报表字典信息
        /// </summary>
        /// <param name="ids"></param>
        public void DeleteReports(string ids)
        {
            try
            {
                string[] idsArr = ids.Split(',');
                foreach (string reportId in idsArr)
                {
                    if (dbManager.GetDbType() == CTDbType.SQLSERVER)
                    {
                       
                        StringBuilder sql = new StringBuilder();
                        sql.Length = 0;
                        sql.Append("SELECT REPORTDICTIONARY_ID,REPORTDICTIONARY_CODE,REPORTDICTIONARY_FIXTABLENAME FROM CT_FORMAT_REPORTDICTIONARY WHERE REPORTDICTIONARY_ID='"+reportId+"'");
                        List<ReportFormatDicEntity> reports = dbManager.ExecuteSqlReturnTType<ReportFormatDicEntity>(sql.ToString());
                        if (reports.Count > 0)
                        {
                            if (StringUtil.IsNullOrEmpty(reports[0].fixTableName))
                            {
                                reports[0].fixTableName = FormatTool.CreateBBTableName(reports[0].bbCode, true, 1, "");
                            }
                            //删除固定表
                            sql.Length = 0;
                            sql.Append("if exists(select * from sysobjects where id=object_id('" + reports[0].fixTableName + "')) DROP TABLE [" + reports[0].fixTableName + "]");
                            dbManager.ExecuteSql(sql.ToString());
                            //删除变动表
                            sql.Length = 0;
                            sql.Append("SELECT * FROM CT_FORMAT_ROWCHANGEDICTIONARY WHERE ROWCHANGEDICTIONARY_ID IN ( SELECT REPORTANDCHANGEREGIONAL_CHANGEREGIONID FROM CT_FORMAT_REPORTANDCHANGEREGIONAL WHERE REPORTANDCHANGEREGIONAL_REPORTID='"+reportId+"')");
                            List<ReportRowChangeEntity> rowChanges = dbManager.ExecuteSqlReturnTType<ReportRowChangeEntity>(sql.ToString());
                            foreach (ReportRowChangeEntity rrce in rowChanges)
                            {
                                sql.Length = 0;
                                sql.Append("if exists(select * from sysobjects where id=object_id('" +rrce.RegionTable + "')) DROP TABLE [" + rrce.RegionTable + "]");
                                dbManager.ExecuteSql(sql.ToString());
                            }
                            sql.Length = 0;
                            sql.Append("SELECT * FROM CT_FORMAT_COLUMNCHANGEDICTIONARY WHERE COLUMNCHANGEDICTIONARY_ID IN ( SELECT REPORTANDCHANGEREGIONAL_CHANGEREGIONID FROM CT_FORMAT_REPORTANDCHANGEREGIONAL WHERE REPORTANDCHANGEREGIONAL_REPORTID='" + reportId + "')");
                            List<ReportColChangeEntity> colChanges = dbManager.ExecuteSqlReturnTType<ReportColChangeEntity>(sql.ToString());
                            foreach (ReportColChangeEntity rcce in colChanges)
                            {
                                sql.Length = 0;
                                sql.Append("if exists(select * from sysobjects where id=object_id('" +rcce.RegionTable + "')) DROP TABLE [" + rcce.RegionTable + "]");
                                dbManager.ExecuteSql(sql.ToString());
                            }

                            //删除数据项
                            sql.Length = 0;
                            sql.Append("DELETE FROM CT_FORMAT_DATAITEM  WHERE DATAITEM_REPORTID='"+reportId+"'");
                            dbManager.ExecuteSql(sql.ToString());

                            //删除公式信息
                            sql.Length = 0;
                            sql.Append("DELETE FROM CT_FORMULAR WHERE FORMULAR_REPORTCODE='"+reports[0].bbCode+"'");
                            dbManager.ExecuteSql(sql.ToString());

                            //删除报表状态信息
                            sql.Length = 0;
                            sql.Append("DELETE FROM CT_STATE_REPORTSTATE WHERE REPORTSTATE_REPORTID='"+reportId+"'");
                            dbManager.ExecuteSql(sql.ToString());

                            sql.Length = 0;
                            sql.Append("DELETE FROM CT_STATE_REPORTSTATEDETAIL WHERE REPORTSTATEDETAIL_REPORTID='"+reportId+"'");
                            dbManager.ExecuteSql(sql.ToString());
                            //删除报表分类中报表信息
                            sql.Length = 0;
                            sql.Append("DELETE FROM CT_FORMAT_RELATION  WHERE RELATION_REPORTID='"+reportId+"'");
                            dbManager.ExecuteSql(sql.ToString());
                            //删除审计底稿中的报表
                            sql.Length = 0;
                            sql.Append("DELETE FROM CT_PAPER_AUDITPAPERANDREPORT WHERE AUDITPAPERANDREPORT_REPORTID='"+reportId+"'");
                            dbManager.ExecuteSql(sql.ToString());

                            //删除报表字典
                            sql.Length = 0;
                            sql.Append("DELETE FROM CT_FORMAT_REPORTDICTIONARY WHERE REPORTDICTIONARY_ID='"+reportId+"'");
                            dbManager.ExecuteSql(sql.ToString());
                            //删除报表附件

                            sql.Length = 0;
                            sql.Append("SELECT * FROM CT_DATA_ATTACHMENT WHERE ATTACHMENT_REPORTID='" + reportId + "'");
                            List<ReportAttatchEntity> attatches = dbManager.ExecuteSqlReturnTType<ReportAttatchEntity>(sql.ToString());
                            foreach (ReportAttatchEntity rae in attatches)
                            {
                                if (File.Exists(rae.Route))
                                {
                                    File.Delete(rae.Route);
                                }
                            }
                            sql.Length = 0;
                            sql.Append("DELETE FROM CT_DATA_ATTACHMENT WHERE ATTACHMENT_REPORTID='"+reportId+"'");
                            dbManager.ExecuteSql(sql.ToString());
                        }
                    }                   
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion


        # region 变动区相关 
        /// <summary>
        /// 获取变动区排序字段
        /// </summary>
        /// <param name="tableName"></param>
        /// <returns></returns>
        public string GetBdqSortCode(string tableName)
        {
            try
            {
                List<ReportRowChangeEntity> rows = new List<ReportRowChangeEntity>();
                string sql = " SELECT * FROM CT_FORMAT_ROWCHANGEDICTIONARY WHERE ROWCHANGEDICTIONARY_REGIONTABLE='"+tableName+"'";
                rows=dbManager.ExecuteSqlReturnTType<ReportRowChangeEntity>(sql);
                if (rows.Count > 0)
                {
                    return rows[0].RowSort;
                }
                else
                {
                    sql = "SELECT * FROM CT_FORMAT_COLUMNCHANGEDICTIONARY WHERE COLUMNCHANGEDICTIONARY_REGIONTABLE='" + tableName + "'";
                    List<ReportColChangeEntity> cols = dbManager.ExecuteSqlReturnTType<ReportColChangeEntity>(sql);
                    if (cols.Count > 0)
                    {
                        return cols[0].ColSort;
                    }
                }
                return "";
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion


        public ReportFormatDicEntity GetReportFormatById(string id)
        {
            try
            {
                string sql = "SELECT REPORTDICTIONARY_CODE,REPORTDICTIONARY_NAME FROM CT_FORMAT_REPORTDICTIONARY WHERE REPORTDICTIONARY_ID='"+id+"'";
                List<ReportFormatDicEntity> reports = dbManager.ExecuteSqlReturnTType<ReportFormatDicEntity>(sql);
                if (reports != null && reports.Count > 0)
                {
                    return reports[0];
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
    }

    class BdJudge{
    public bool isFixOrChagne;
        public int index;
        public string BdCode = "";
    }
}
