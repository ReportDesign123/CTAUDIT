using System;
using System.Collections.Generic;
using System.Collections;
using System.Collections.Specialized;
using System.Linq;
using System.Text;
using System.Reflection;
using System.Web;
using GlobalConst;
using System.IO;
using AuditSPI;

namespace CtTool
{
    public  class ActionTool
    {
        /// <summary>
        /// 调用特定类型的方法
        /// 如果有返回类型，则直接返回
        /// 反之，范围类型为空
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="obj"></param>
        /// <param name="methodName"></param>
        /// <param name="parameters"></param>
        public static object InvokeObjMethod<T>(T obj, string methodName,Object[] parameters)
        {
            try
            {
                Type t = typeof(T);
                MethodInfo mi = t.GetMethod(methodName);
                if (parameters == null)
                {
                    return mi.Invoke(obj, null);
                }
                else
                {
                    return mi.Invoke(obj, parameters);
                }
               
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 调用特定类型的方法
        /// 如果有返回类型，则直接返回
        /// 反之，范围类型为空
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="obj"></param>
        /// <param name="methodName"></param>
        /// <param name="parameters"></param>
        public static object InvokeObjMethod<T>(T obj, string methodName, Object parameter)
        {
            try
            {
                object[] objs = new object[1];
                objs[0] = parameter;
                return  InvokeObjMethod<T>(obj, methodName, objs);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 解析特定参数的变量
        /// </summary>
        /// <returns></returns>
        public static object[] DeserializeParameters(List<string> paraNames,HttpContext context,string postType)
        {
            try
            {


                object[] paras = new object[paraNames.Count];
                for (int i = 0; i < paraNames.Count; i++)
                {
                    if (postType == BasicGlobalConst.POSTTYPE_GET)
                    {
                        paras[i] = context.Request.QueryString[paraNames[i]];
                    }
                    else if(postType==BasicGlobalConst.POSTTYPE_POST)
                    {
                        paras[i] = context.Request.Form[paraNames[i]];
                    }else{
                        paras[i] = context.Request.QueryString[paraNames[i]];
                        if (paras[i] == null)
                        {
                            paras[i] = context.Request.Form[paraNames[i]];
                        }
                    }
                }
                return paras;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static object DeserializeParameter(string paraName, HttpContext context)
        {
            try
            {
                object paraValue = new object();
                paraValue = context.Request.QueryString[paraName];
                if (paraValue == null)
                {
                    paraValue = context.Request.Form[paraName];
                }
                return paraValue;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public static List<T> DeserializeListParameter<T>(HttpContext context,string postType,string paraName){
            try
            {
                List<T> lists = new List<T>();
                Dictionary<string, int> maps = new Dictionary<string, int>();
                NameValueCollection nameValues = context.Request.Form;
                Type t = typeof(T);
                PropertyInfo[] pis = t.GetProperties();
                int i=0;
                foreach (string key in nameValues.Keys)
                {
                    string subStr = key.Substring(0, paraName.Length+1);
                    var right=key.IndexOf("]", paraName.Length);

                    if (subStr == paraName + "[" && right!=-1)
                    {
                        string indentity = key.Substring(0, right + 1);
                        T temp ;
                        if (!maps.ContainsKey(indentity))
                        {
                            temp = Activator.CreateInstance<T>();
                            lists.Add(temp);
                            maps.Add(indentity, i);
                            i++;
                        }
                        else
                        {
                            temp = lists[maps[indentity]];
                        }
                        int end = key.LastIndexOf("[");
                        string name = key.Substring(end + 1,key.Length-end-2);
                        foreach (PropertyInfo pi in pis)
                        {
                            if (pi.Name == name)
                            {
                             
                                SetPropertyValue(pi, temp, nameValues[key]);
                        
                            }
                        }

                    }
                }
                return lists;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 解析特定类型的变量
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="context"></param>
        /// <param name="postType"></param>
        /// <returns></returns>
        public static T DeserializeParameters<T>(HttpContext context, string postType)
        {
            try
            {
                Type type = typeof(T);
                T obj=Activator.CreateInstance<T>();

                PropertyInfo[] pis = type.GetProperties();
                foreach (PropertyInfo pi in pis)
                {
                    string pn = pi.Name;
                    object pobj=null;
                    if (postType == BasicGlobalConst.POSTTYPE_GET)
                    {
                        pobj = context.Request.QueryString[pn];
                    }
                    else if (postType == BasicGlobalConst.POSTTYPE_POST)
                    {
                        pobj = context.Request.Form[pn];
                    }
                    else
                    {
                        pobj = context.Request.QueryString[pn];
                        if (pobj == null)
                        {
                            pobj = context.Request.Form[pn];
                        }
                    }
                    if (pobj != null)
                    {
                        SetPropertyValue(pi, obj, pobj);
                        
                    }
                }
                return obj;
            }
            catch (Exception ex)
            {
                throw ex;
            }
          
        }

        /// <summary>
        /// 解析特定类型的变量
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="context"></param>
        /// <param name="postType"></param>
        /// <returns></returns>
        public static T DeserializeParametersByFields<T>(HttpContext context, string postType)
        {
            try
            {
                Type type = typeof(T);
                T obj = Activator.CreateInstance<T>();

                FieldInfo[] pis = type.GetFields();
                foreach (FieldInfo pi in pis)
                {
                    string pn = pi.Name;
                    object pobj = null;
                    if (postType == BasicGlobalConst.POSTTYPE_GET)
                    {
                        pobj = context.Request.QueryString[pn];
                    }
                    else if (postType == BasicGlobalConst.POSTTYPE_POST)
                    {
                        pobj = context.Request.Form[pn];
                    }
                    else
                    {
                        pobj = context.Request.QueryString[pn];
                        if (pobj == null)
                        {
                            pobj = context.Request.Form[pn];
                        }
                    }
                    if (pobj != null)
                    {
                        SetFieldValue(pi, obj, pobj);

                    }
                }
                return obj;
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        

        private static void SetPropertyValue(PropertyInfo pi, object obj, object pobj)
        {
            try
            {
                if (pobj != null)
                {
                    string valueType = pi.PropertyType.FullName;
                    if (valueType == "System.String")
                    {
                        pi.SetValue(obj, pobj, null);
                    }
                    else if (valueType == "System.Decimal")
                    {
                        pi.SetValue(obj, Convert.ToDecimal(pobj), null);
                    }
                    else if (valueType == "System.Int32")
                    {
                        pi.SetValue(obj, Convert.ToInt32(pobj), null);
                    }
                    else if (valueType == "System.Int64")
                    {
                        pi.SetValue(obj, Convert.ToInt64(pobj), null);
                    }
                    else if (valueType == "System.DateTime")
                    {
                        pi.SetValue(obj, Convert.ToDateTime(pobj), null);
                    }

                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private static void SetFieldValue(FieldInfo fi, object obj,object value)
        {
            try
            {
                if (obj != null)
                {
                    string valueType = fi.FieldType.FullName;
                    if (valueType == "System.String")
                    {
                        fi.SetValue(obj, value);
                    }
                    else if (valueType == "System.Decimal")
                    {
                        fi.SetValue(obj, Convert.ToDecimal(value));
                    }
                    else if (valueType == "System.Int32")
                    {
                        fi.SetValue(obj, Convert.ToInt32(value));
                    }
                    else if (valueType == "System.Int64")
                    {
                        fi.SetValue(obj, Convert.ToInt64(value));
                    }
                    else if (valueType == "System.DateTime")
                    {
                        fi.SetValue(obj, Convert.ToDateTime(value));
                    }

                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 下载文档
        /// </summary>
        /// <param name="context"></param>
        /// <param name="fileFullName"></param>
        /// <param name="fileName"></param>
        public static void DownloadFile(HttpContext context, string fileFullName, string fileName)
        {
            try
            {
                FileInfo fi = new FileInfo(fileFullName);
                context.Response.ClearContent();
                context.Response.ClearHeaders();
                context.Response.ContentType = "application/octet-stream";
                context.Response.AddHeader("Content-Disposition", "attachment;filename=" + context.Server.UrlPathEncode(fileName));
                context.Response.AddHeader("Content-Length", fi.Length.ToString());
                context.Response.AddHeader("Content-Transfer-Encoding", "binary");
                context.Response.ContentEncoding = System.Text.Encoding.GetEncoding("gb2312");
                context.Response.WriteFile(fi.FullName);
                context.Response.Flush();
                //context.Response.End();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public static List<FileStruct> UploadFile(HttpContext context, string filePath)
        {
            try
            {
                List<FileStruct> fss = new List<FileStruct>();
                if (!File.Exists(filePath))
                {
                    Directory.CreateDirectory(filePath);
                }
                //上传文件
                HttpFileCollection hfc = context.Request.Files;
                for (int i = 0; i < hfc.Count; i++)
                {
                    HttpPostedFile hpf = hfc[i];                  
                    FileStruct fs = new FileStruct();
                    if (hpf.ContentLength > 0)
                    {

                        int index = hpf.FileName.LastIndexOf("\\");
                        fs.FileName = hpf.FileName.Substring(index + 1);
                        int point = fs.FileName.LastIndexOf(".");

                        fs.FileExtend = fs.FileName.Substring(point);
                        fs.FileId = Guid.NewGuid().ToString();
                        fs.FileFullName = filePath + @"\" + fs.FileId + fs.FileExtend;
    
                        hpf.SaveAs(fs.FileFullName);                   

                    }
                    fss.Add(fs);
                }
                return fss;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public static string GetReportTemplatePath(HttpContext context)
        {
            try
            {
                return context.Server.MapPath("~/ct/attatchs/ExportReportAttatch/Template/");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       /// <summary>
       /// 设置导出Excel的基本信息
       /// </summary>
       /// <param name="context"></param>
       /// <param name="filePath"></param>
        public static void SetExportExcelInfo(HttpContext context, string filePath,string fileName)
        {
            try
            {
                FileInfo fi = new FileInfo(filePath);
                context.Response.ClearContent();
                context.Response.ClearHeaders();
                context.Response.ContentType = "application/octet-stream";
                context.Response.AddHeader("Content-Disposition", "attachment;filename="+context.Server.UrlEncode(fileName)+".xls");
                context.Response.AddHeader("Content-Length", fi.Length.ToString());
                context.Response.AddHeader("Content-Transfer-Encoding", "binary");
                context.Response.WriteFile(fi.FullName);
                context.Response.Flush();
                File.Delete(filePath);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

    }
}
