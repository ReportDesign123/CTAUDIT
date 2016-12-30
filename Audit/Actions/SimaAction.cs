using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using AuditSPI;
using AuditEntity;
using AuditService;
using CtTool;

namespace Audit.Actions
{
    public class SimaAction:BaseAction
    {
        ISima simaService;
        public SimaAction()
        {
            simaService = new SimaService();
        }
        public override void GoToMethod(string methodName)
        {
            switch (methodName)
            {

                case "GetDataGrid":
                    DataGrid<SimaEntity> dg = new DataGrid<SimaEntity>();
                    dg = ActionTool.DeserializeParametersByFields<DataGrid<SimaEntity>>(context, actionType);
                    SimaEntity se = ActionTool.DeserializeParameters<SimaEntity>(context, actionType);
                    GetDataGrid(dg, se);
                    break;
              


            }
        }

        public void GetDataGrid(DataGrid<SimaEntity> dataGrid,SimaEntity se)
        {
            try
            {
                DataGrid<SimaEntity> dg = simaService.GetSimaList(dataGrid,se);
                JsonTool.WriteJson<DataGrid<SimaEntity>>(dg, context);  
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
    }
}