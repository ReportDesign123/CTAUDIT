using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditSPI.Analysis;
using MultiParse;
using MultiParse.Default;
using AuditEntity;
using System.Data;
using CtTool;
using AuditSPI.ReportData;


namespace AuditService.Analysis.Formular
{
    public  class FormularAnalysisFactory:IFormularDeserialize,IFormularExpressDeserialize
    {
        IFormularDeserialize deserializer;
        IFormularExpressDeserialize expressDeserializer;
        string formularType;
        string formularContent;
        ReportDataParameterStruct rdps;


        public FormularAnalysisFactory()
        {
        }




        public DataTable DeserializeToSql(FormularEntity fe)
        {
            try
            {
                string formular = fe.content;
                int startIndex = formular.IndexOf("(");
                int endIndex = formular.LastIndexOf(")");
                formularType = formular.Substring(0, startIndex);
                formularContent = formular.Substring(startIndex+1, endIndex - startIndex - 1);
                switch (formularType.ToUpper())
                {
                    case "SQL":
                        deserializer = new SqlFormularAnalysis();
                        break;
                    case "SIMA":
                        deserializer = new SimaFormularAnalysis();
                        break;
                    case "BBQS":
                        deserializer = new ReportFormularAnalysis();
                        break;
                    case "CCGC":
                        deserializer = new ProcedureFormularAnalysis();
                        break;
                    case  "KMYE":
                        deserializer = new KmyeFormularAnalysis();
                        break;
                    case "BBHLQS":
                        deserializer = new ReportRowColFormularAnalysis();
                        break;
                    case "BBQKQS":
                        deserializer = new FormularBlockAnalysis();
                        break;


                }
                if (rdps != null)
                {
                    deserializer.SetReportParameters(rdps);
                }               
                fe.content = formularContent;
               return deserializer.DeserializeToSql(fe);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }




        public object ExpressParse(string formular)
        {
            try
            {
                if (expressDeserializer == null)
                {
                    expressDeserializer = new FormularExpressParser();
                }
                formular = formular.Trim();
                formular = formular.Replace(" ", "");
                formular = formular.Replace(" ", "");
                formular = formular.Replace("\r","");
                formular=formular.Replace("\"","");
                formular = formular.Replace("'","");
                object result= expressDeserializer.ExpressParse(formular);
                result= ExpressEqual(result.ToString());
                result = ExpressNotEqual(result.ToString());
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public void SetReportParameters(AuditSPI.ReportData.ReportDataParameterStruct rdps)
        {
            this.rdps = rdps;
        }
        /// <summary>
        /// 计算等于公式
        /// </summary>
        /// <param name="formular"></param>
        public object ExpressEqual(string formular)
        {
            try
            {
                if (formular.IndexOf("==") != -1)
                {
                    string[] formulars = formular.Split(new string[] { "==" }, StringSplitOptions.RemoveEmptyEntries);
                    return formulars[0] == formulars[1];

                }
                return formular;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 计算不等于公式
        /// </summary>
        /// <param name="formular"></param>
        public object ExpressNotEqual(string formular)
        {
            try
            {
                if (formular.IndexOf("!=") != -1)
                {
                    string[] formulars = formular.Split(new string[] { "!=" }, StringSplitOptions.RemoveEmptyEntries);
                    return formulars[0] != formulars[1];

                }
                return formular;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
