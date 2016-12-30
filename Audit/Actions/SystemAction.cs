using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using AuditEntity;
using AuditService;
using AuditSPI;
using CtTool;
using AuthorityBinPeng.Service;


namespace Audit.Actions
{
    public class SystemAction : BaseAction
    {
        SystemService systemService;
        AuthorityService authorityService;
        public SystemAction()
        {
            if (systemService == null)
            {
                systemService = new SystemService();
            }
            if (authorityService == null)
            {
                authorityService = new AuthorityService();
            }
        }
        public override void GoToMethod(string methodName)
        {

            switch (methodName)
            {
                case "Edit":
                    ConfigEntity ce = ActionTool.DeserializeParameters<ConfigEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<SystemAction>(this, methodName, ce);
                    break;
                case "DataGrid":
                    ce = ActionTool.DeserializeParameters<ConfigEntity>(context, actionType);
                    DataGrid<ConfigEntity> dg = ActionTool.DeserializeParametersByFields<DataGrid<ConfigEntity>>(context, actionType);
                    DataGrid(dg, ce);
                    break;
                case "GetWorkFlows":
                case "DownLoadPlug":
                    ActionTool.InvokeObjMethod<SystemAction>(this, methodName, null);
                    break;
                case "LogDataGrid":
                    LogEntity le = ActionTool.DeserializeParameters<LogEntity>(context, actionType);
                    DataGrid<LogEntity> ldg = ActionTool.DeserializeParametersByFields<DataGrid<LogEntity>>(context, actionType);
                    LogDataGrid(le, ldg);
                    break;
                case "GetSequenceNumber":
                    ActionTool.InvokeObjMethod<SystemAction>(this, methodName, null);
                    break;
                case "Register":
                    ce = ActionTool.DeserializeParameters<ConfigEntity>(context, actionType);
                    ActionTool.InvokeObjMethod<SystemAction>(this, methodName, ce);
                    break;

            }

        }

        public void Edit(ConfigEntity config)
        {
            JsonStruct js = new JsonStruct();
            try
            {
                systemService.Edit(config);
                js.success = true;
                js.sMeg = "编辑成功";
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }

        public void DataGrid(DataGrid<ConfigEntity> dataGrid, ConfigEntity config)
        {
            try
            {
                DataGrid<ConfigEntity> dg = systemService.DataGrid(config, dataGrid);
                JsonTool.WriteJson<DataGrid<ConfigEntity>>(dg, context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
        public void GetWorkFlows()
        {
            JsonStruct js = new JsonStruct();
            try
            {
                List<ConfigEntity> lists = systemService.GetWorkFlows();
                js.success = true;
                js.obj = lists;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        public void DownLoadPlug()
        {
            try
            {
                string dress = context.Server.MapPath("~/ct/attatchs/ocx/BinCell_Web.exe");
                ActionTool.DownloadFile(context, dress, "宾朋科技表格插件.exe");
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }

        }
        public void LogDataGrid(LogEntity le, DataGrid<LogEntity> dataGrid)
        {
            try
            {
                DataGrid<LogEntity> dg = systemService.LogDataGrid(le, dataGrid);
                JsonTool.WriteJson<DataGrid<LogEntity>>(dg, context);
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
            }
        }
        #region 用户注册
        /// <summary>
        /// 获取序列号
        /// </summary>
        public void GetSequenceNumber()
        {
            JsonStruct js = new JsonStruct();
            try
            {
                js.obj = authorityService.getLocalSequenceNumber();
                js.success = true;               
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }

        public void Register(ConfigEntity  config)
        {
            JsonStruct js = new JsonStruct();
            try
            {               
                authorityService.GrantAuthority(config);
                js.obj = "注册成功";
                js.success = true;
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(ex.StackTrace);
                js.sMeg = ex.Message;
            }
            JsonTool.WriteJson<JsonStruct>(js, context);
        }
        #endregion
    }
}