using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Text;
using CtTool;
using CtTool.BB;
using System.Data;
using AuditSPI.Format;
namespace AuditService.Analysis.Formular
{
    /// <summary>
    /// 块公式解析，支持SUM、AVG、
    /// </summary>
   public  class CaculateBlockFormularDeserialize
    {
       public CaculateBlockFormularDeserialize()
       {
           FormularDeserialzie = new FormularDeserializeStruct();
       }
       public FormularAnalysisFactory FormularAnalysis
       {
           get;
           set;
       }
       public FormularDeserializeStruct FormularDeserialzie
       {
           get;
           set;
       }

       public FormularDeserializeStruct DeserializeCacularFormular(string formularContent,DataTable data,BBData bbData)
       {
           try
           {              
               List<string> formularNames = new List<string>();
               formularNames.Add("SUM(");
               formularNames.Add("AVG(");
               formularNames.Add("SUMIF(");
               formularNames.Add("COUNTIF(");
               formularNames.Add("ABS(");
               formularNames.Add("COUNT(");
               formularContent = formularContent.ToUpper();

               StringBuilder formular = new StringBuilder();
               
               foreach (string formularName in formularNames)
               {
                  // if (!formularContent.Contains(formularName)) continue;
                   int start = formularContent.IndexOf("(");
                   string name = formularContent.Substring(0, start + 1);
                   if (formularName != name) continue;
                  formularContent=  DeserializeRecursiveFormular(formularContent, data, formularName,bbData,formularNames);
               }
               FormularDeserialzie.FormularCondent = formularContent;
               return FormularDeserialzie ;        
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }

       private string DeserializeRecursiveFormular(string formularContent, DataTable data,string formularName,BBData bbData,List<string> formularNames)
       {
           try
           {
                int start = formularContent.IndexOf(formularName);
                int end = formularContent.LastIndexOf(")");
                string nextFormular=formularContent.Substring(start + formularName.Length, end - start-formularName.Length);
               bool flag=false;
               string nextName = "";
               foreach(string fn in formularNames){
                    int s = nextFormular.IndexOf("(");
                    nextName = nextFormular.Substring(0, s + 1);
                    if (fn != nextName) {continue;}else{
                    flag=true;
                    break;
                   }
               }
               if (!flag)
               {
                   return ChangeFunction(formularContent, data, formularName,bbData);
               }
               else
               {
                   string realFormular = "";
                   realFormular += formularName;
                   realFormular += DeserializeRecursiveFormular(formularContent.Substring(start + formularName.Length, end - start - formularName.Length), data, nextName, bbData, formularNames);
                   realFormular += formularContent.Substring(end );
                  realFormular= ChangeFunction(realFormular, data, formularName, bbData);
                   return realFormular;
               }
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }

       private string ChangeFunction(string formularContent,DataTable data, string formularName,BBData bbData)
       {
           try
           {
               switch (formularName)
               {
                   case "SUM(":
                       return DeserializeSumFormular(formularContent, data,bbData);
                   case "AVG(":
                       return DeserializeAvgFormular(formularContent, data,bbData);  
                   case "SUMIF(":
                       return DeserializeSumIfFormular(formularContent,data,bbData);
                   case "COUNTIF(":
                       return DeserializeCountIfFormular(formularContent, data, bbData);
                   case "ABS(":
                       return DeserializeABSFormular(formularContent, data, bbData);
                   case "COUNT(":
                       return DeserializeCountFormular(formularContent, data, bbData);
                      
                      
               }
               return formularContent;
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }

       /// <summary>
       /// 
       /// </summary>
       /// <param name="sumformularContent"></param>
       /// <returns></returns>
       private string DeserializeSumFormular(string sumformularContent,DataTable dt,BBData bbData)
       {
           try
           {              
               StringBuilder formular = new StringBuilder();   
               List<string> columns = new List<string>();
               CreateBlockColumnsAndFormular(sumformularContent, columns, formular,bbData);
               string dformular = SubstitudeFormularDatas(formular.ToString(), dt, columns);
               return dformular;
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }

       /// <summary>
       /// 解析块公式原型
       /// </summary>
       /// <param name="formularContent"></param>
       /// <param name="columns"></param>
       /// <param name="formular"></param>
       private void CreateBlockColumnsAndFormular(string formularContent,List<string>columns,StringBuilder formular,BBData bbData)
       {
           try
           {
               int startIndex, lastIndex;
               startIndex = 0;
               lastIndex = 0;
               startIndex = formularContent.IndexOf("[");
               if (startIndex == -1) return;
               lastIndex = formularContent.IndexOf("]", startIndex);
               string formularCell = formularContent.Substring(startIndex + 1, lastIndex - startIndex - 1);

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
                       formular.Append("[");
                       string code = i.ToString() + "," + j.ToString();
                       formular.Append(code);
                       formular.Append("]");
                       formular.Append("+");
                       columns.Add(bbData.bbData[i][j].CellCode);
                   }
               }

               if (formular.Length > 0)
               {
                   formular.Length--;

               }
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }
       /// <summary>
       /// 创建数据列的块公式解析
       /// </summary>
       /// <param name="formularContent"></param>
       /// <param name="columns"></param>
       /// <param name="bbData"></param>
       private void CreateBlockColumns(string formularContent, List<string> columns, BBData bbData)
       {
           try
           {
               try
               {
                   int startIndex, lastIndex;
                   startIndex = 0;
                   lastIndex = 0;
                   startIndex = formularContent.IndexOf("[");
                   if (startIndex == -1) return;
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
                               columns.Add(bbData.bbData[i][j].CellCode);
                               string code = "[" + i.ToString() + "," + j.ToString() + "]";
                              // formularColumns.Add(code);
                           }
                       }
                   }
                   else
                   {
                       string[] rowCol = formularCell.Split(',');
                       int row=Convert.ToInt32(rowCol[0]);
                       int col=Convert.ToInt32(rowCol[1]);
                       columns.Add(bbData.bbData[row][col].CellCode);

                       string code = "[" +row.ToString() + "," + col.ToString() + "]";
                      // formularColumns.Add(code);
                   }
                   
                 
               }
               catch (Exception ex)
               {
                   throw ex;
               }
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }

       /// <summary>
       /// 创建数据列的块公式解析,并且包含原数据单元列；
       /// </summary>
       /// <param name="formularContent"></param>
       /// <param name="columns"></param>
       /// <param name="bbData"></param>
       private void CreateBlockColumns(string formularContent, List<string> columns,List<string>formularColumns, BBData bbData)
       {
           try
           {
               try
               {
                   int startIndex, lastIndex;
                   startIndex = 0;
                   lastIndex = 0;
                   startIndex = formularContent.IndexOf("[");
                   if (startIndex == -1) return;
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
                               columns.Add(bbData.bbData[i][j].CellCode);
                               string code = "[" + i.ToString() + "," + j.ToString() + "]";
                               formularColumns.Add(code);
                           }
                       }
                   }
                   else
                   {
                       string[] rowCol = formularCell.Split(',');
                       int row = Convert.ToInt32(rowCol[0]);
                       int col = Convert.ToInt32(rowCol[1]);
                       columns.Add(bbData.bbData[row][col].CellCode);

                       string code = "[" + row.ToString() + "," + col.ToString() + "]";
                       formularColumns.Add(code);
                   }


               }
               catch (Exception ex)
               {
                   throw ex;
               }
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }
       /// <summary>
       /// 解析求平均公式
       /// </summary>
       /// <param name="avgformularContent"></param>
       /// <param name="dt"></param>
       /// <returns></returns>
       private string DeserializeAvgFormular(string avgformularContent, DataTable dt,BBData bbData)
       {
           try
           {             
               StringBuilder formular = new StringBuilder();
               List<string> columns = new List<string>();
               CreateBlockColumnsAndFormular(avgformularContent, columns, formular,bbData);
               string f = formular.ToString();
               if (columns.Count > 0)
               {
                   f = "(" + f + ")" + "/" + columns.Count;
               }
               string dformular = SubstitudeFormularDatas(f, dt, columns);
               
               return dformular;
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }

       private string DeserializeCountIfFormular(string countIfContent, DataTable dt, BBData bbData)
       {
           try
           {
               int start = countIfContent.IndexOf("(");
               int end = countIfContent.LastIndexOf(")");
               string nextFormular = countIfContent.Substring(start + 1, end - start - 1);
               countIfContent = nextFormular;
               string[] formularArr = countIfContent.Split(';');
               StringBuilder formular = new StringBuilder();
               List<string> dataColumns = new List<string>();  //数据列
               List<string> dataFormularColumns = new List<string>();
               List<string> conditionColumns = new List<string>();//条件列
               List<string> conditionFormularColumns = new List<string>();//条件公式列
               //解析数据区域
               CreateBlockColumns(formularArr[0], dataColumns, dataFormularColumns, bbData);
               //解析条件公式列
               CreateBlockColumns(formularArr[1], conditionColumns, conditionFormularColumns, bbData);

               //解析条件列
               string confitionFormular = SubstitudeFormularDatas(formularArr[1], dt, conditionColumns, conditionFormularColumns);
               FormularDeserialzie.FormularCondition = confitionFormular;
               FormularDeserialzie.BdHzType = " COUNT";
               //生成条件公式
               formular.Length = 0;
               for (int i = 0; i < dataColumns.Count; i++)
               {
                   //解析条件公式，目前为缺失状态；
                   if (dt != null && dt.Columns.Contains(dataColumns[i]))
                   {
                       string condition="";
                       if(dt.Rows[0][dataColumns[i]].ToString()==""){
                           condition = "0" + FormularDeserialzie.FormularCondition;
                       }else{
                           condition = dt.Rows[0][dataColumns[i]].ToString() + FormularDeserialzie.FormularCondition;
                       }
                      

                       if (Convert.ToBoolean(FormularAnalysis.ExpressParse(condition)))
                       {
                           formular.Append("1");
                           formular.Append("+");
                       }

                   }
                   else
                   {
                       formular.Append(dataFormularColumns[i]);
                       formular.Append("+");
                   }


               }
               if (formular.Length > 0) formular.Length--;

               return formular.ToString();
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }
       /// <summary>
       /// 条件SUM公式的解析
       /// </summary>
       /// <param name="sumIfContent"></param>
       /// <param name="dt"></param>
       /// <param name="bbData"></param>
       /// <returns></returns>
       private string DeserializeSumIfFormular(string sumIfContent, DataTable dt, BBData bbData)
       {
           try
           {

               int start = sumIfContent.IndexOf("(");
               int end = sumIfContent.LastIndexOf(")");
               string nextFormular = sumIfContent.Substring(start + 1, end - start - 1);
                sumIfContent = nextFormular;
               string[] formularArr = sumIfContent.Split(';');
               StringBuilder formular = new StringBuilder();
               List<string> dataColumns = new List<string>();  //数据列
               List<string>dataFormularColumns=new List<string>();
               List<string> conditionColumns = new List<string>();//条件列
               List<string> conditionFormularColumns = new List<string>();//条件公式列
               //解析数据区域
               CreateBlockColumns(formularArr[0], dataColumns,dataFormularColumns, bbData);
               //解析条件公式列
               CreateBlockColumns(formularArr[1], conditionColumns, conditionFormularColumns,bbData);

               //解析条件列
               string confitionFormular = SubstitudeFormularDatas(formularArr[1], dt, conditionColumns, conditionFormularColumns);
               FormularDeserialzie.FormularCondition = confitionFormular;
               //生成条件公式
               formular.Length = 0;
               for (int i = 0; i < dataColumns.Count; i++)
               {
                   //解析条件公式，目前为缺失状态；
                   if(dt!=null&&dt.Columns.Contains(dataColumns[i])){
                       string condition = dt.Rows[0][dataColumns[i]].ToString()+FormularDeserialzie.FormularCondition;

                       if (Convert.ToBoolean(FormularAnalysis.ExpressParse(condition)))
                       {
                           formular.Append(dataFormularColumns[i]);
                           formular.Append("+");
                       }

                   }else{
                       formular.Append(dataFormularColumns[i]);
                       formular.Append("+");
                   }
                 
                 
               }
               if (formular.Length > 0) formular.Length--;

               return formular.ToString();
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }
       private string DeserializeABSFormular(string absFormular, DataTable dt, BBData bbData)
       {
           try
           {
               int start = absFormular.IndexOf("(");
               int end = absFormular.LastIndexOf(")");
               string nextFormular = absFormular.Substring(start+1, end - start -1);
               absFormular = "-1*(" + nextFormular + ")";
               return absFormular;
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }
       private string DeserializeCountFormular(string countFormular, DataTable dt, BBData bbData)
       {
           try
           {
               StringBuilder formular = new StringBuilder();
               int start = countFormular.IndexOf("(");
               int end = countFormular.LastIndexOf(")");
               string nextFormular = countFormular.Substring(start + 1, end - start - 1);

               //获取数据字段列
               FormularDeserialzie.BdHzType = " COUNT";
               List<string> dataColumns = new List<string>();
               List<string> dataFormularColumns = new List<string>();
               CreateBlockColumns(nextFormular, dataColumns, dataFormularColumns, bbData);
               for (int i = 0; i < dataColumns.Count; i++)
               {
                   //解析条件公式，目前为缺失状态；
                   if (dt != null && dt.Columns.Contains(dataColumns[i]))
                   {
                       if (dt.Rows[0][dataColumns[i]].ToString() != "")
                       {
                           formular.Append("1");
                           formular.Append("+");
                       }
                       else
                       {
                           formular.Append("0");
                           formular.Append("+");
                       }

                   }
                   else
                   {
                       formular.Append(dataFormularColumns[i]);
                       formular.Append("+");
                   }

               }
               if (formular.Length > 0) formular.Length--;
               return formular.ToString();

           }
           catch (Exception ex)
           {
               throw ex;
           }
       }

       /// <summary>
       /// 替换公式
       /// </summary>
       /// <param name="formular"></param>
       /// <param name="data"></param>
       /// <param name="columns"></param>
       /// <returns></returns>
       public string SubstitudeFormularDatas(string formular, DataTable data,List<string> columns)
       {
           try
           {
               string dformular = formular;
               if (formular.Length > 0)
               {  
                
                   foreach (string column in columns)
                   {
                       if (data!=null&&data.Columns.Contains(column))
                       {
                           if (data.Rows.Count > 0 && Convert.ToString(data.Rows[0][column]) != "")
                           {
                               dformular = dformular.Replace(column, Convert.ToString(data.Rows[0][column]));
                           }
                           else
                           {
                               dformular = dformular.Replace(column, "0");
                           }
                       }
                      
                   }
               }
               else
               {
                   dformular = "0";
               }
               return dformular;
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }
       /// <summary>
       /// 替换公式列
       /// </summary>
       /// <param name="formular"></param>
       /// <param name="data"></param>
       /// <param name="columns"></param>
       /// <param name="formularColumns"></param>
       /// <returns></returns>
       public string SubstitudeFormularDatas(string formular, DataTable data, List<string> columns,List<string>formularColumns)
       {
           try
           {
               string dformular = formular;
               if (formular.Length > 0)
               {
                   int i = 0;
                   foreach (string column in columns)
                   {
                       if (data != null && data.Columns.Contains(column))
                       {
                           if (data.Rows.Count > 0 && Convert.ToString(data.Rows[0][column]) != "")
                           {
                               dformular = dformular.Replace(formularColumns[i], Convert.ToString(data.Rows[0][column]));
                           }
                           else
                           {
                               dformular = dformular.Replace(formularColumns[i], "0");
                           }
                       }
                       i++;

                   }
               }
               else
               {
                   dformular = "0";
               }
               return dformular;
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }
    }
}
