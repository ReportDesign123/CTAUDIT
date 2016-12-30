using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity;
using AuditSPI.ReportData;
using System.Data;

namespace AuditSPI.Format
{
    public  interface IFormular
    {
        void SaveFormulars(List<FormularEntity> formulars, string formularStr, string reportId);
        List<DataSourceEntity> GetDataSourceList();
        void DeserializeFatchFormular(ReportDataStruct rds );
        void DeserializeCaculateFormular(ReportDataStruct rds);
        string DeserializeVarifyFormular(ReportDataStruct rds);
        string BatchDeserializeFatchFormular(ReportDataParameterStruct rdps);
        string BatchDeserializeCaculateFormular(ReportDataParameterStruct rdps);
        string BatchDeserializeVerifyFormular(ReportDataParameterStruct rdps);
        /// <summary>
        /// 获取单个公式的公式内容
        /// </summary>
        /// <param name="rdps"></param>
        /// <returns></returns>
        DataTable GetSingleFatchFormularData(ReportDataParameterStruct rdps, FormularEntity fe);
    }
}
