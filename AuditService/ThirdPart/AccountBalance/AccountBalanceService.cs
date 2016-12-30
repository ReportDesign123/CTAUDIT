using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditSPI.ThirdPart.AccountBalance;
using GlobalConst;
using AuditEntity;
using DbManager;
using AuditSPI;


namespace AuditService.ThirdPart.AccountBalance
{
   public   class AccountBalanceService:IAccountBalance
    {
       IAccountBalance accountBalanceService;
       public AccountBalanceService()
       {
 
       }
       /// <summary>
       /// 获取会计科目列表
       /// </summary>
       /// <param name="dataGrid"></param>
       /// <param name="ass"></param>
       /// <returns></returns>
        public AuditSPI.DataGrid<AccountSubjectStruct> AccountSubjectsDataGrid(AuditSPI.DataGrid<AccountSubjectStruct> dataGrid, AccountSubjectStruct ass)
        {
            try
            {
                switch (ThirdPartConst.AccountType)
                {
                    case "Inspur":
                        accountBalanceService = new InspurAccountBalanceService();
                        break;
                }
                return accountBalanceService.AccountSubjectsDataGrid(dataGrid, ass);
               
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

       
    }
}
