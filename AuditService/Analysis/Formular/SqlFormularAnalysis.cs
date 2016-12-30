using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditSPI.Analysis;
using AuditEntity;
using System.Data;
using DbManager;
using AuditSPI;
using AuditSPI.ReportData;

namespace AuditService.Analysis.Formular
{
    public  class SqlFormularAnalysis:IFormularDeserialize
    {
        MacroHelp mh;
        CTDbManager dbManager;
        ReportDataParameterStruct rdps = new ReportDataParameterStruct();
        public SqlFormularAnalysis()
        {
            if (mh == null)
            {
                mh = new MacroHelp();
            }
            if(dbManager==null){
                dbManager = new CTDbManager();
            }
        }

        public DataTable DeserializeToSql(FormularEntity fe)
        {
            try
            {
                string formular = fe.content;
                string sql=mh.ReplaceMacroVariable(formular);
                sql = mh.ReplaceYYYYMM(sql);
                DataTable dt = new DataTable();
                DbDataSourceInstance ddsi = DBTool.GetDataSource(fe.FormularDb, dbManager);
                dt = ddsi.ExecuteSqlReturnDataTable(sql);
                return dt;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public void SetReportParameters(ReportDataParameterStruct rdps)
        {
            this.rdps = rdps;
            mh.ReportParameter = rdps;
        }
    }
}
