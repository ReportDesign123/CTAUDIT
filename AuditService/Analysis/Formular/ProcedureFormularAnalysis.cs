using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditSPI.Analysis;
using DbManager;
using CtTool;
using AuditSPI.Procedure;
using AuditEntity;
using System.Data;
using System.Data.Common;
using AuditEntity.Procedure;
using AuditSPI;
using AuditSPI.ReportData;



namespace AuditService.Analysis.Formular
{
    class ProcedureFormularAnalysis:IFormularDeserialize
    {
        CTDbManager dbManager;
        MacroHelp mh;
        ReportDataParameterStruct rdps = new ReportDataParameterStruct();
        public ProcedureFormularAnalysis()
        {
            if (dbManager == null)
            {
                dbManager = new CTDbManager();
            }
            if (mh == null)
            {
                mh = new MacroHelp();
            }
        }
        public DataTable DeserializeToSql(FormularEntity fe)
        {
            try
            {
                ProcedureParametersStruct pps = JsonTool.DeserializeObject<ProcedureParametersStruct>(fe.content);
                DataTable dt = new DataTable();
                List<DbParameter> parameters = new List<DbParameter>();
                foreach (ProcedureParameterEntity ppe in pps.parameters)
                {
                    DbParameter p = dbManager.GetDbParameter();
                    switch (ppe.Type)
                    {
                        case "varchar":
                            p.DbType = DbType.String;
                            break;
                    }
                    p.ParameterName = ppe.Name;
                    p.Value = mh.ReplaceMacroVariable(ppe.Value);
                    parameters.Add(p);
                }

                DbDataSourceInstance ddsi = DBTool.GetDataSource(fe.FormularDb, dbManager);
                dt = ddsi.ExecuteProcedureDataTable(pps.name, parameters);
               
                return dt;

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
