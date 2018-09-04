using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity;

using AuditSPI.ReportData;
namespace AuditSPI
{
    public  interface IDictionaryService
    {

        DataGrid<DictionaryClassificationEntity>  GetDicClassifyList(DataGrid<DictionaryClassificationEntity> dataGrid);
        DataGrid<DictionaryClassificationEntity> GetDicClasifyList(DataGrid<DictionaryClassificationEntity> dataGrid, DictionaryClassificationEntity dce);
        DataGrid<LSHELPDIC> GetDicLshelpList(DataGrid<LSHELPDIC> dataGrid, LSHELPDIC dce);
        DataGrid<DictionaryEntity> GetDictionaryList(DataGrid<DictionaryEntity> dataGrid,DictionaryEntity de);
        DataGrid<DictionaryEntity> GetParasList(DataGrid<DictionaryEntity> dataGrid, DictionaryEntity de);
        List<DictionaryEntity> GetList();
        DataGrid<DictionaryEntity> GetDictionaryListByClass(DataGrid<DictionaryEntity> dataGrid, string classid, DictionaryClassificationEntity dce);
        void SaveDictionaryClassify(DictionaryClassificationEntity dce);
        void SaveDictionary(DictionaryEntity de);

        void UpdateDictionaryClassify(DictionaryClassificationEntity dce);
        void UpdateDictionary(DictionaryEntity de);
        void DeleteDictionaryClassify(DictionaryClassificationEntity dce); 
        void DeleteDictionary(DictionaryEntity de);
        DictionaryClassificationEntity GetDictionaryClassify(DictionaryClassificationEntity dce);
        DictionaryEntity GetDictionary(DictionaryEntity de);
        List<DictionaryClassificationEntity> GetDicClassifyCombo();
        List<DictionaryEntity> GetDictionaryListByClassType(string classType);
        DataGrid<DictionaryEntity> GetDictionaryDataGridByClassType(string classType, DataGrid<DictionaryEntity> dataGrid,DictionaryEntity de);
        DataGrid<DictionaryEntity> GetDictionaryDataGridByLsHelp(string classType, DataGrid<DictionaryEntity> dataGrid, DictionaryEntity de, ReportDataParameterStruct rdps);
        string GetValue(string sql);
    }
}
