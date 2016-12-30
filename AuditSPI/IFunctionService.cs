using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using AuditEntity;

namespace AuditSPI
{
   public   interface IFunctionService
    {
       /// <summary>
       /// 获取一级菜单
       /// </summary>
       /// <returns></returns>
       List<FunctionStruct> getFirstFunctions();
       /// <summary>
       /// 获取功能菜单；
       /// </summary>
       /// <param name="fs"></param>
       /// <returns></returns>
       List<FunctionEntity> getFunctions(FunctionEntity fs);

       /// <summary>
       /// 获取父节点
       /// </summary>
       /// <returns></returns>
       List<TreeNode> ParentCombo();
       /// <summary>
       /// 获取带权限的功能菜单；
       /// 目的用于权限功能的配置；
       /// </summary>
       /// <returns></returns>
       List<TreeNode> AuthorityParentCombo(string RoleId);
       /// <summary>
       /// 保存功能菜单
       /// </summary>
       /// <param name="entity"></param>
       void Save(FunctionEntity entity);
       /// <summary>
       /// 更新功能菜单属性
       /// </summary>
       /// <param name="entity"></param>
       void Update(FunctionEntity entity);
       /// <summary>
       /// 查找对象实例
       /// </summary>
       /// <param name="id"></param>
       /// <returns></returns>
       FunctionEntity Get(string id);
       /// <summary>
       /// 删除对象实例
       /// </summary>
       /// <param name="Id"></param>
       void Delete(string Id);
    }
}
