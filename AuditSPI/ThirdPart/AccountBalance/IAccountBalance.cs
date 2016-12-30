using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AuditSPI.ThirdPart.AccountBalance
{
   public interface IAccountBalance
    {
       DataGrid<AccountSubjectStruct> AccountSubjectsDataGrid(DataGrid<AccountSubjectStruct> dataGrid, AccountSubjectStruct ass);

    }
}
