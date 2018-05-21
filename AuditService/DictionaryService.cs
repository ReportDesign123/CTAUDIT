using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using AuditSPI;
using DbManager;
using CtTool;
using AuditEntity;
using AuditSPI.ReportData;
using System.Text.RegularExpressions;
using AuditService.Analysis.Formular;
namespace AuditService
{
   public   class DictionaryService:IDictionaryService
    {
       private ILinqDataManager ldManager;
       private IDbManager dbManager;
       public DictionaryService()
       {
           ldManager = new LinqDataManager();
           dbManager = new CTDbManager();
       }

      

        public void SaveDictionaryClassify(AuditEntity.DictionaryClassificationEntity dce)
        {
            try
            {
                ldManager.InsertEntity<DictionaryClassificationEntity>(dce);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void SaveDictionary(AuditEntity.DictionaryEntity de)
        {
            try
            {
                ldManager.InsertEntity<DictionaryEntity>(de);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void UpdateDictionaryClassify(AuditEntity.DictionaryClassificationEntity dce)
        {
            try
            {
                DictionaryClassificationEntity temp = GetDictionaryClassify(dce);
                BeanUtil.CopyBeanToBean(dce, temp);
                ldManager.UpdateEntity<DictionaryClassificationEntity>(temp);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void UpdateDictionary(AuditEntity.DictionaryEntity de)
        {
            try
            {
                DictionaryEntity temp = GetDictionary(de);
                BeanUtil.CopyBeanToBean(de, temp);
                ldManager.UpdateEntity<DictionaryEntity>(temp);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<DictionaryEntity> GetList()
        {
            try
            {
                string sql = "SELECT * FROM CT_BASIC_DICTIONARY  WHERE DICTIONARY_CLASSID='b9b5eeef-c5ff-43fe-a1af-0e3339a96144'";
                List<DictionaryEntity> lists = dbManager.ExecuteSqlReturnTType<DictionaryEntity>(sql);
                return lists;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public DataGrid<DictionaryEntity> GetParasList(DataGrid<DictionaryEntity> dataGrid, DictionaryEntity de)
        {
            try
            {
                DataGrid<DictionaryEntity> dg = new DataGrid<DictionaryEntity>();

                string csql = "SELECT * FROM CT_BASIC_DICTIONARY  WHERE DICTIONARY_CLASSID='b9b5eeef-c5ff-43fe-a1af-0e3339a96144' ";

                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<DictionaryEntity>();
                maps["CName"] = "DICTIONARYCLASSIFICATION_NAME";
                string countSql = "SELECT COUNT(*) FROM CT_BASIC_DICTIONARY WHERE DICTIONARY_CLASSID='b9b5eeef-c5ff-43fe-a1af-0e3339a96144'";

                string sortName = maps[dataGrid.sort];
                dg.rows = dbManager.ExecuteSqlReturnTType<DictionaryEntity>(csql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order + ",DICTIONARY_CODE ASC", maps);
                dg.total = dbManager.Count(countSql);
                return dg;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public void DeleteDictionaryClassify(AuditEntity.DictionaryClassificationEntity dce)
        {
            try
            {
                DictionaryClassificationEntity temp = GetDictionaryClassify(dce);
                ldManager.Delete<DictionaryClassificationEntity>(temp);
                string sql = "DELETE FROM CT_BASIC_DICTIONARY WHERE DICTIONARY_CLASSID='"+dce.Id+"'";
                dbManager.ExecuteSql(sql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void DeleteDictionary(AuditEntity.DictionaryEntity de)
        {
            try
            {
                DictionaryEntity temp = GetDictionary(de);
                ldManager.Delete<DictionaryEntity>(temp);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }



        public DictionaryClassificationEntity GetDictionaryClassify(DictionaryClassificationEntity dce)
        {
            try
            {
                DictionaryClassificationEntity temp = ldManager.GetEntity<DictionaryClassificationEntity>(r => r.Id == dce.Id);
                return temp;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DictionaryEntity GetDictionary(DictionaryEntity de)
        {
            try
            {
                DictionaryEntity temp = ldManager.GetEntity<DictionaryEntity>(r => r.Id == de.Id);
                return temp;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataGrid<DictionaryClassificationEntity> GetDicClassifyList(DataGrid<DictionaryClassificationEntity> dataGrid)
        {
            try
            {
                DataGrid<DictionaryClassificationEntity> dg = new DataGrid<DictionaryClassificationEntity>();
                string csql = "SELECT * FROM CT_BASIC_DICTIONARYCLASSIFICATION";
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<DictionaryClassificationEntity>();
                string countSql = "SELECT COUNT(*) FROM CT_BASIC_DICTIONARYCLASSIFICATION"; 
                string sortName = maps[dataGrid.sort];
                dg.rows = dbManager.ExecuteSqlReturnTType<DictionaryClassificationEntity>(csql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
                dg.total = dbManager.Count(countSql);
                return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        //新增 预制LSHELP
        DataGrid<LSHELPDIC> IDictionaryService.GetDicLshelpList(DataGrid<LSHELPDIC> dataGrid, LSHELPDIC dce)
        {
            try
            {
                DataGrid<LSHELPDIC> dg = new DataGrid<LSHELPDIC>();
                string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<LSHELPDIC>(dce);
                string s = "";
                if (whereSql.Length > 0)
                {
                    s = " WHERE " + whereSql;
                }
                string csql = "SELECT * FROM LSHELP" + s;

                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<LSHELPDIC>();
                string countSql = "SELECT COUNT(*) FROM LSHELP" + s;
                string sortName = maps[dataGrid.sort];
                dg.rows = dbManager.ExecuteSqlReturnTType<LSHELPDIC>(csql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
                dg.total = dbManager.Count(countSql);
                return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataGrid<DictionaryEntity> GetDictionaryList(DataGrid<DictionaryEntity> dataGrid,DictionaryEntity de)
        {
            try
            {
                DataGrid<DictionaryEntity> dg = new DataGrid<DictionaryEntity>();
                List<string> names = new List<string>();
                names.Add("Code");
                names.Add("Name");
                string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<DictionaryEntity>(de,names);
                string csql = "SELECT * FROM CT_BASIC_DICTIONARY D INNER JOIN CT_BASIC_DICTIONARYCLASSIFICATION C ON D.DICTIONARY_CLASSID=C.DICTIONARYCLASSIFICATION_ID WHERE 1=1 ";
                if(!StringUtil.IsNullOrEmpty(whereSql))
                csql +="AND "+ whereSql;
                if (!StringUtil.IsNullOrEmpty(de.CName))
                {
                    csql += " AND " + "DICTIONARYCLASSIFICATION_NAME like '%"+de.CName+"%'";
                }
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<DictionaryEntity>();
                maps["CName"] = "DICTIONARYCLASSIFICATION_NAME";
                string countSql = "SELECT COUNT(*) FROM CT_BASIC_DICTIONARY D INNER JOIN CT_BASIC_DICTIONARYCLASSIFICATION C ON D.DICTIONARY_CLASSID=C.DICTIONARYCLASSIFICATION_ID WHERE 1=1 ";
                if (!StringUtil.IsNullOrEmpty(whereSql))
                    countSql += "AND " + whereSql;

                if (!StringUtil.IsNullOrEmpty(de.CName))
                {
                    countSql += " AND " + "DICTIONARYCLASSIFICATION_NAME like '%" + de.CName + "%'";
                }
                string sortName = maps[dataGrid.sort] ;
                dg.rows = dbManager.ExecuteSqlReturnTType<DictionaryEntity>(csql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order + ",DICTIONARY_CODE ASC", maps);
                dg.total = dbManager.Count(countSql);
                return dg;
                
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<DictionaryClassificationEntity> GetDicClassifyCombo()
        {
            try
            {
                List<DictionaryClassificationEntity> lists = ldManager.getList<DictionaryClassificationEntity>();
                return lists;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public DataGrid<DictionaryEntity> GetDictionaryListByClass(DataGrid<DictionaryEntity> dataGrid, string classid, DictionaryClassificationEntity dce)
        {
            try
            {
                string wheresql = " WHERE 1=1 ";
                if (!StringUtil.IsNullOrEmpty(dce.Name))
                {
                    wheresql += " AND DICTIONARY_NAME LIKE '%" + dce.Name + "%'";
                }
                if (!StringUtil.IsNullOrEmpty(dce.Code))
                {
                    wheresql += " AND DICTIONARY_CODE LIKE '%" + dce.Code + "%'";
                }
                DataGrid<DictionaryEntity> dg = new DataGrid<DictionaryEntity>();
                string csql = "SELECT * FROM CT_BASIC_DICTIONARY D INNER JOIN CT_BASIC_DICTIONARYCLASSIFICATION C ON D.DICTIONARY_CLASSID=C.DICTIONARYCLASSIFICATION_ID  AND C.DICTIONARYCLASSIFICATION_CODE='" + classid + "' " + wheresql;
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<DictionaryEntity>();
                maps["CName"] = "DICTIONARYCLASSIFICATION_NAME";
                string countSql = "SELECT COUNT(*) FROM  CT_BASIC_DICTIONARY D INNER JOIN CT_BASIC_DICTIONARYCLASSIFICATION C ON D.DICTIONARY_CLASSID=C.DICTIONARYCLASSIFICATION_ID  AND C.DICTIONARYCLASSIFICATION_CODE='" + classid + "' "+wheresql;
                string sortName = maps[dataGrid.sort];
                dg.rows = dbManager.ExecuteSqlReturnTType<DictionaryEntity>(csql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order + ",DICTIONARY_CODE ASC", maps);
                dg.total = dbManager.Count(countSql);

                return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public List<DictionaryEntity> GetDictionaryListByClassType(string classType)
        {
            try
            {
                string sql = "SELECT D.* FROM CT_BASIC_DICTIONARY D INNER JOIN CT_BASIC_DICTIONARYCLASSIFICATION C ON D.DICTIONARY_CLASSID=C.DICTIONARYCLASSIFICATION_ID AND DICTIONARYCLASSIFICATION_CODE='"+classType+"'";
                List<DictionaryEntity> dlists=dbManager.ExecuteSqlReturnTType<DictionaryEntity>(sql);
                return dlists;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public string GetMarcoName(ReportDataParameterStruct rdps, string strMacro)
        {
            string MarcoName = string.Empty;
            ReportDataStruct rds = new ReportDataStruct();
            rds.rdps = rdps;
            MacroHelp mh = new MacroHelp();

            try
            {
                if (strMacro.Contains("@"))
                {
                    for(int i=1;i< strMacro.Split('@').Length;i++)
                    {
                        mh.ReportParameter = rdps;
                        string strOld = strMacro.Split('@')[i];
                        MarcoName = mh.ReplaceMacroVariable(mh.ReplaceMacroVariable(strOld));
                        if (string.IsNullOrEmpty(MarcoName))
                            continue;
                        strMacro = strMacro.Replace("@"+strOld+"@", "'"+MarcoName+"'");
                    }
                }

              
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return strMacro;
        }
        private void ReplaceMarchPara(string strWhere, MacroHelp mh)
        {
           
            string ps = strWhere;
            Regex re = new Regex(@"(^|&)?(\w+)=([^&]+)(&|$)?", RegexOptions.Compiled);

            MatchCollection mc = re.Matches(ps);
            Dictionary<string, string> DParas = new Dictionary<string, string>();
            foreach (Match m in mc)
            {
                string strValue = m.Result("$3");
                if (strValue.Contains("@"))
                {
                    string strMarcro = mh.ReplaceMacroVariable(mh.ReplaceMacroVariable(strValue.Split('@')[1]));
                    ps =ps.Replace(strValue, strMarcro);
                }
            }
        }
        DataGrid<DictionaryEntity> IDictionaryService.GetDictionaryDataGridByLsHelp(string classType, DataGrid<DictionaryEntity> dataGrid, DictionaryEntity de, ReportDataParameterStruct rdps)
        {
            try
            {
                DataGrid<DictionaryEntity> dg = new DataGrid<DictionaryEntity>();
                
                MacroHelp mh = new MacroHelp();
                string sql = string.Empty;
                sql = "select  LSHELP_TABLE,LSHELP_TABLECODE,LSHELP_TABLENAME,LSHELP_TABLEWHERE,LSHELP_NAME from lshelp where LSHELP_CODE='" + classType+"'";
                DataTable table = dbManager.ExecuteSqlReturnDataTable(sql);
                if (table == null || table.Rows.Count == 0)
                    return null;
                
                string tableName = table.Rows[0][0].ToString();
                string tableFCode= table.Rows[0][1].ToString();
                string tableFName= table.Rows[0][2].ToString();
                string tableWhere= table.Rows[0][3].ToString();
                if (string.IsNullOrEmpty(tableWhere))
                    tableWhere = "1=1";
                tableWhere= GetMarcoName(rdps,tableWhere);
                ReplaceMarchPara(tableWhere, mh);
                string tableHelp = table.Rows[0][4].ToString();
                sql = "select "+ tableFCode + " AS DICTIONARY_CODE ,"+ tableFName+ " AS DICTIONARY_NAME from "+ tableName+ "  CT_BASIC_DICTIONARY where "+ tableWhere;

                string csql = "SELECT * FROM CT_BASIC_DICTIONARY D INNER JOIN CT_BASIC_DICTIONARYCLASSIFICATION C ON D.DICTIONARY_CLASSID=C.DICTIONARYCLASSIFICATION_ID  AND C.DICTIONARYCLASSIFICATION_CODE='" + classType + "' ";
                string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<DictionaryEntity>(de);
              
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<DictionaryEntity>();
                maps["CName"] = "'"+ tableHelp+"' CName";
                string countSql = "SELECT COUNT(*) FROM  "+ tableName + "  CT_BASIC_DICTIONARY where " + tableWhere; // CT_BASIC_DICTIONARY D INNER JOIN CT_BASIC_DICTIONARYCLASSIFICATION C ON D.DICTIONARY_CLASSID=C.DICTIONARYCLASSIFICATION_ID  AND C.DICTIONARYCLASSIFICATION_CODE='" + classType + "' ";
                if (whereSql.Length > 0)
                {
                    whereSql = whereSql.Replace("DICTIONARY_CODE", "lsbzdw_dwbh");
                    whereSql = whereSql.Replace("DICTIONARY_NAME", "lsbzdw_dwmc");
                    sql = sql + " and " + whereSql;
                    countSql= countSql+ " and " + whereSql;
                }
                string sortName = maps[dataGrid.sort];
                dg.rows = dbManager.ExecuteSqlReturnTType<DictionaryEntity>(sql, dataGrid.page, dataGrid.pageNumber,  tableFCode+" ASC", maps);
                dg.total = dbManager.Count(countSql);

                return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        DataGrid<DictionaryEntity> IDictionaryService.GetDictionaryDataGridByClassType(string classType, DataGrid<DictionaryEntity> dataGrid,DictionaryEntity de)
        {
            try
            {
                DataGrid<DictionaryEntity> dg = new DataGrid<DictionaryEntity>();
                string csql = "SELECT * FROM CT_BASIC_DICTIONARY D INNER JOIN CT_BASIC_DICTIONARYCLASSIFICATION C ON D.DICTIONARY_CLASSID=C.DICTIONARYCLASSIFICATION_ID  AND C.DICTIONARYCLASSIFICATION_CODE='" + classType + "' ";
                string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<DictionaryEntity>(de);
               
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<DictionaryEntity>();
                maps["CName"] = "DICTIONARYCLASSIFICATION_NAME";
                string countSql = "SELECT COUNT(*) FROM  CT_BASIC_DICTIONARY D INNER JOIN CT_BASIC_DICTIONARYCLASSIFICATION C ON D.DICTIONARY_CLASSID=C.DICTIONARYCLASSIFICATION_ID  AND C.DICTIONARYCLASSIFICATION_CODE='" + classType + "' ";
                if (whereSql.Length > 0)
                {
                    csql += " WHERE " + whereSql;
                    countSql += " WHERE " + whereSql;

                }
                string sortName = maps[dataGrid.sort];
                dg.rows = dbManager.ExecuteSqlReturnTType<DictionaryEntity>(csql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order + ",DICTIONARY_CODE ASC", maps);
                dg.total = dbManager.Count(countSql);

                return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }





        DataGrid<DictionaryClassificationEntity> IDictionaryService.GetDicClasifyList(DataGrid<DictionaryClassificationEntity> dataGrid, DictionaryClassificationEntity dce)
        {
            try
            {
                DataGrid<DictionaryClassificationEntity> dg = new DataGrid<DictionaryClassificationEntity>();
                string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<DictionaryClassificationEntity>(dce);
                string s = "";
                if (whereSql.Length > 0)
                {
                    s = " WHERE " + whereSql;
                }
                string csql = "SELECT * FROM CT_BASIC_DICTIONARYCLASSIFICATION" + s;

                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<DictionaryClassificationEntity>();
                string countSql = "SELECT COUNT(*) FROM CT_BASIC_DICTIONARYCLASSIFICATION" + s;
                string sortName = maps[dataGrid.sort];
                dg.rows = dbManager.ExecuteSqlReturnTType<DictionaryClassificationEntity>(csql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
                dg.total = dbManager.Count(countSql);
                return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
