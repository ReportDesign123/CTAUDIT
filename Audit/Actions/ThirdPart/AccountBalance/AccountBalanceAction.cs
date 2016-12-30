using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using AuditService.ThirdPart.AccountBalance;
using AuditSPI.ThirdPart.AccountBalance;
using AuditSPI;
using CtTool;

namespace Audit.Actions.ThirdPart.AccountBalance
{
    public class AccountBalanceAction :BaseAction
    {
        IAccountBalance accountBalanceService;

        public AccountBalanceAction()
        {
                if (accountBalanceService == null)
            {
                accountBalanceService = new AccountBalanceService();
            }
        }
        public override void GoToMethod(string methodName)
        {
            switch (methodName)
            {
                case "AccountSubjectsDataGrid":
                    AccountSubjectStruct ass = ActionTool.DeserializeParameters<AccountSubjectStruct>(context, actionType);
                    DataGrid<AccountSubjectStruct> dg = ActionTool.DeserializeParametersByFields<DataGrid<AccountSubjectStruct>>(context, actionType);
                    AccountSubjectsDataGrid(dg, ass);
                    break;
            }
        }
        /// <summary>
        /// 获取会计科目列表
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="ass"></param>
        public void AccountSubjectsDataGrid(AuditSPI.DataGrid<AccountSubjectStruct> dataGrid, AccountSubjectStruct ass)
        {
            try
            {
                DataGrid<AccountSubjectStruct> dgs = accountBalanceService.AccountSubjectsDataGrid(dataGrid, ass);
                JsonTool.WriteJson<DataGrid<AccountSubjectStruct>>(dgs, context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.Message);
            }
        }
    }
}