using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using AuditEntity;
using CtTool;
using AuditSPI;
using AuditService;

namespace Audit.Actions
{
    public class CompanyAction:BaseAction
    {
        ICompanyService companyService;

        public CompanyAction(){
             companyService=new CompanyService();
        }
        public override void GoToMethod(string methodName)
        {
            switch (methodName)
            {
                case "GetCompanyList":
                case "Save":
                case "Edit":
                case "Delete":
                case "GetCompanisAuthority":
                     CompanyEntity ce = ActionTool.DeserializeParameters<CompanyEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<CompanyAction>(this, methodName, ce);
                    break;
                case  "ParentCombo":
                    ActionTool.InvokeObjMethod<CompanyAction>(this, methodName, null);
                    break;
                case "CompanyDataGrid":
                    ce = ActionTool.DeserializeParameters<CompanyEntity>(context, actionType);
                    DataGrid<CompanyEntity> dataGrid = ActionTool.DeserializeParametersByFields<DataGrid<CompanyEntity>>(context, actionType);
                    CompanyDataGrid(dataGrid, ce);
                    break;
             

            }
        }

        public void GetCompanyList(CompanyEntity company)
        {
          
            try
            {
                JsonTool.WriteJson<List<CompanyEntity>>( companyService.GetCompanyList(company),context);              
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                
            }
          
        }

        public void Save(CompanyEntity company)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                companyService.Save(company);
                js.success = true;
                js.sMeg = "保存成功";                
                js.obj = company.Path+"|"+company.Id;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }

        public void Edit(CompanyEntity company)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                companyService.Edit(company);
                js.success = true;               
                js.sMeg = "编辑成功";
                js.obj = company.Path + "|" + company.Id;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }

        public void Delete(CompanyEntity company)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                companyService.Delete(company);
                js.success = true;
                js.sMeg = "删除成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }

        public void ParentCombo()
        {
            try
            {
                JsonTool.WriteJson<List<TreeNode>>(companyService.ParentCombo(),context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
        public void CompanyDataGrid(DataGrid<CompanyEntity> dataGrid, CompanyEntity ce)
        {
            try
            {
                DataGrid<CompanyEntity> dg = companyService.CompanyDataGrid(dataGrid, ce);
                JsonTool.WriteJson<DataGrid<CompanyEntity>>(dg, context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }

        public void  GetCompanisAuthority(CompanyEntity company)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                js.obj = companyService.GetCompanysByAuthority(company);
                js.success = true;
             
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
       
    }
}