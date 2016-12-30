using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity;
using AuditSPI.Format;
using AuditSPI.ReportData;


namespace AuditService.Analysis.Formular
{
    /// <summary>
    /// Formular Cascade Handler
    /// </summary>
   public   class CaculateFormularCascadeManager
    {
       public delegate void ProcessCaculeteFormular(FormularEntity fe,BBData bbData,ReportDataStruct rds);
       private BBData bbData;
       private ReportDataStruct rds;


       public CaculateFormularCascadeManager(BBData bbData, ReportDataStruct rds)
       {
           this.bbData = bbData;
           this.rds = rds;
       }
       /// <summary>
       /// Find Cascade Formular Children
       /// </summary>
       /// <param name="formular">Current Formular</param>
       /// <param name="formulars">Formular List</param>
       public void FormularCascadeHandler(FormularEntity formular, List<FormularEntity> formulars,ProcessCaculeteFormular pcf)
       {
           try
           {
               FindFormularChildren(formular, formulars);
               //处理Formular对象
               HandlerFormular(formular, pcf);
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }
       /// <summary>
       /// 获取公式的孩子节点
       /// </summary>
       /// <param name="fe"></param>
       /// <param name="formulars"></param>
       /// <returns></returns>
       private FormularEntity FindFormularChildren(FormularEntity fe, List<FormularEntity> formulars)
       {
           try
           {
               foreach (FormularEntity f in formulars)
               {
                   if(getFormularLeft(fe)==getFormularLeft(f))continue;
                   if (JudgeFormularIsOrNotChild(fe, f))
                   {
                       //获取当前节点的子级节点
                       FindFormularChildren(f, formulars);
                       fe.Children.Add(f);
                   }
                   else
                   {
                       continue;
                   }
               }
               return fe;
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }

       /// <summary>
       /// 处理计算公式
       /// </summary>
       /// <param name="fe"></param>
       /// <param name="pcf"></param>
       private void  HandlerFormular(FormularEntity fe, ProcessCaculeteFormular pcf)
       {
           try
           {
               if (fe.Children.Count == 0&&!fe.Caculated) { pcf(fe, bbData, rds); fe.Caculated=true;}
               foreach (FormularEntity f in fe.Children)
               {
                   HandlerFormular(f, pcf);
               }
               if (!fe.Caculated)
               {
                   pcf(fe, bbData, rds);
                   fe.Caculated = true;
               }
              
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }
       /// <summary>
       /// 获取公式的有半部分
       /// </summary>
       /// <param name="formular"></param>
       /// <returns></returns>
       private string[] getFormularRight(FormularEntity formular)
       {
           try
           {
               return formular.DeserializeContent.Split(';');
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }
       /// <summary>
       /// 获取公式的左边部分
       /// </summary>
       /// <param name="formular"></param>
       /// <returns></returns>
       private string getFormularLeft(FormularEntity formular)
       {
           try
           {
               return formular.firstRow.ToString() + "," + formular.firstCol;
           }
           catch (Exception ex)
           {
               throw ex;
           }

       }
       /// <summary>
       /// 判断当前公式是否是父级节点的子级节点；
       /// </summary>
       /// <param name="parent"></param>
       /// <param name="currentFormular"></param>
       /// <returns></returns>
       private bool JudgeFormularIsOrNotChild(FormularEntity parent, FormularEntity currentFormular)
       {
           try
           {
               string[] pRight = getFormularRight(parent);
               string cLeft = getFormularLeft(currentFormular);
               foreach (string cell in pRight)
               {
                   if (cell == cLeft)
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

    }
}
