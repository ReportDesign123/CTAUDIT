using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Linq.Expressions;
using System.Data.Common;


using AuditSPI;
using DbManager;
using AuditEntity;
using CtTool;
using GlobalConst;

namespace AuditService
{
    /// <summary>
    /// 菜单服务类
    /// </summary>
   public   class FunctionService:IFunctionService
    {
        private ILinqDataManager linqDataManager;
        private IDbManager dbManager;

        public FunctionService()
        {
            linqDataManager = new LinqDataManager();
            dbManager = new CTDbManager();
        }
        /// <summary>
        /// 获取一级菜单
        /// </summary>
        /// <returns></returns>
        public List<FunctionStruct> getFirstFunctions()
        {
            try
            {
                UserEntity ue = SessoinUtil.GetCurrentUser();
                List<FunctionStruct> functionStructs = new List<FunctionStruct>();
                //List<FunctionEntity> functionEntities = linqDataManager.getList<FunctionEntity>(f => f.Parent == null);

                string sql ="";
                if (ue.Code == BasicGlobalConst.CT_ADMIN)
                {
                    sql = "SELECT F.* FROM CT_BASIC_FUNCTIONS F ORDER BY F.FUNCTIONS_SEQUENCE";
                }
                else
                {
                    if (ue.Rols==null||ue.Rols.Count==0)
                    {
                        ue.Rols = new List<RoleEntity>();
                        RoleEntity re = new RoleEntity();
                        re.Id = ue.RoleId;
                        ue.Rols.Add(re);
                    }
                    sql = "SELECT DISTINCT F.* FROM CT_BASIC_FUNCTIONS F " +
                   " INNER JOIN CT_BASIC_ROLEANDFUNCTIONS R ON " +
                   " (F.FUNCTIONS_ID = R.ROLEANDFUNCTIONS_FUNCTIOINID AND  " + BeanUtil.ConvertListObjectsToInSql<RoleEntity>(ue.Rols, "ROLEANDFUNCTIONS_ROLEID") + ")" +
                   " ORDER BY F.FUNCTIONS_SEQUENCE";
                }
                   
                List<FunctionEntity> functionEntities = dbManager.ExecuteSqlReturnTType<FunctionEntity>(sql);
                foreach(FunctionEntity entity in functionEntities ){
                    if (StringUtil.IsNullOrEmpty(entity.Parent))
                    {
                        FunctionStruct fs = ConvertFunctionEntityToFunctionStruct(entity);
                        functionStructs.Add(fs);
                        entity.isOrNOtUsed = true;
                        FindChildren(functionEntities, fs);
                        fs.childrenJson =JsonTool.WriteJsonStr<List<FunctionStruct>>(fs.children);
                    }                   
                }
                return functionStructs;

            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
       /// <summary>
       /// 获取功能菜单
       /// </summary>
       /// <param name="fs"></param>
       /// <returns></returns>
        public List<FunctionEntity> getFunctions(FunctionEntity fs)
        {
            try
            {

                List<FunctionEntity> functionEntities;
                if (fs != null && fs.Id != null)
                {
                    functionEntities = linqDataManager.getList<FunctionEntity,decimal>(f => f.Parent == fs.Id,or=>or.Sequence);
                }
                else
                {
                    functionEntities = linqDataManager.getList<FunctionEntity,decimal>(f => f.Parent == null|| f.Parent=="",or=>or.Sequence);
                }

                string sql = "SELECT * FROM CT_BASIC_FUNCTIONS  ORDER BY FUNCTIONS_SEQUENCE";
                List<FunctionEntity> allEntities = dbManager.ExecuteSqlReturnTType<FunctionEntity>(sql);
                foreach (FunctionEntity fe in functionEntities)
                {
                    foreach(FunctionEntity f  in allEntities){
                        if (fe.Id == f.Parent)
                        {
                            fe.state = "closed";
                            break;
                        }
                    }
                }

                return functionEntities;
            }
            catch (NullReferenceException ex)
            {
                throw ex;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

       /// <summary>
       /// 获取上级目录
       /// </summary>
       /// <returns></returns>
        public List<TreeNode> ParentCombo()
        {
            try
            {

                List<FunctionEntity> functionEntities = GetAllFunctions();
                List<TreeNode> nodes=new List<TreeNode>();
                BeanUtil.ConvertTTypeToTreeNode<FunctionEntity>(functionEntities, nodes, "Id", "Name", "Parent");
                return nodes;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 权限功能的配置
       /// </summary>
       /// <returns></returns>
        public List<TreeNode> AuthorityParentCombo(string RoleId)
        {
            try
            {
                List<FunctionEntity> allFunctions = GetAllFunctions();
                List<RoleAndFunctionsEntity> roleAllFunctions = GetAllAuthrotyFunctions(RoleId);
                
                    foreach (RoleAndFunctionsEntity rafe in roleAllFunctions)
                    {
                        foreach (FunctionEntity fe in allFunctions)
                        {
                            if (fe.Id == rafe.FunctionId)
                            {
                                fe.isOrNotChecked = true;
                                break;

                            }
                    }
                }
                List<TreeNode> nodes = new List<TreeNode>();
                BeanUtil.ConvertTTypeToTreeNode<FunctionEntity>(allFunctions, nodes, "Id", "Name", "Parent");
                return nodes;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 获取不带层级的功能菜单；
       /// </summary>
       /// <returns></returns>
        private List<FunctionEntity> GetAllFunctions()
        {
            try
            {
                string sql = "SELECT FUNCTIONS_ID,FUNCTIONS_NAME,FUNCTIONS_PARENT FROM CT_BASIC_FUNCTIONS  ORDER BY FUNCTIONS_SEQUENCE";
                List<FunctionEntity> functionEntities = dbManager.ExecuteSqlReturnTType<FunctionEntity>(sql);
                return functionEntities;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 获取不带级次的所有所有权限菜单
       /// </summary>
       /// <returns></returns>
        private List<RoleAndFunctionsEntity> GetAllAuthrotyFunctions(string RoleId)
        {
            try
            {
                string sql = "SELECT * FROM CT_BASIC_ROLEANDFUNCTIONS WHERE ROLEANDFUNCTIONS_ROLEID='" + RoleId + "' AND ROLEANDFUNCTIONS_STATE='" + BasicGlobalConst.RoleFunctionState_Selected + "'";
                List<RoleAndFunctionsEntity> roleAndFs = dbManager.ExecuteSqlReturnTType<RoleAndFunctionsEntity>(sql);
                return roleAndFs;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 保存功能菜单
       /// </summary>
       /// <param name="?"></param>
       public void Save(FunctionEntity entity){
           try
           {
               if (entity.Id == null || entity.Id == "")
               {
                   entity.Id = Guid.NewGuid().ToString();
               }
               linqDataManager.InsertEntity<FunctionEntity>(entity);
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }
       /// <summary>
       /// 更新功能菜单
       /// </summary>
       /// <param name="entity"></param>
       public void Update(FunctionEntity entity)
       {
           try
           {
               FunctionEntity fe = linqDataManager.GetEntity<FunctionEntity>(r => r.Id == entity.Id);
               BeanUtil.CopyBeanToBean(entity, fe);
               linqDataManager.UpdateEntity<FunctionEntity>(entity);
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }
       public FunctionEntity Get(string id)
       {
           try
           {
              FunctionEntity fe= linqDataManager.GetEntity<FunctionEntity>(r => r.Id == id);
              return fe;
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }

       public void Delete(string Id)
       {
           try
           {
               string sql = "Delete FROM CT_BASIC_FUNCTIONS WHERE FUNCTIONS_ID={0} OR FUNCTIONS_PARENT={0}";
               List<DbParameter> ps=new List<DbParameter>();
               DbParameter dp=dbManager.GetDbParameter();
               dp.Value=Id;
               dp.ParameterName="id";
               ps.Add(dp);
               dbManager.ExecuteSql(sql, ps);
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }
        #region   工具方法
        /// <summary>
        /// 将FunctionEntity转换为FunctionStruct
        /// </summary>
        /// <param name="functionEntity"></param>
        /// <returns></returns>
        private FunctionStruct ConvertFunctionEntityToFunctionStruct( FunctionEntity functionEntity)
        {
            FunctionStruct fs = new FunctionStruct();
            fs.id = functionEntity.Id;
            fs.text = functionEntity.Name;
            fs.iconCls = functionEntity.Icon;
            fs.attributes.Add("url", functionEntity.Url);
            fs.parent = functionEntity.Parent;
            return fs;
        }
       /// <summary>
       /// 查找子集列表
       /// </summary>
       /// <param name="lists"></param>
       /// <param name="parent"></param>
       /// <returns></returns>
        private void FindChildren(List<FunctionEntity> lists, FunctionStruct parent)
        {
            foreach (FunctionEntity entity in lists)
            {
                if (entity.Parent==parent.id&&!entity.isOrNOtUsed)
                {
                    FunctionStruct fs=ConvertFunctionEntityToFunctionStruct(entity);
                    parent.children.Add(fs);
                    entity.isOrNOtUsed = true;
                    FindChildren(lists, fs);
                }
            }
        }
        #endregion



    }
}
