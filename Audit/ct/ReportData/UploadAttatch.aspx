<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UploadAttatch.aspx.cs" Inherits="Audit.ct.ReportData.UploadAttatch" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="../../Scripts/Ct_Upload.js" type="text/javascript"></script>
    <title>附件上传</title>
    <style type="text/css">
    #fileGrid td
    {
        border-bottom:1px solid #95B8E7;
        line-height:25px;
        
    }
    #realTitle td
    {
        border-bottom:1px solid #95B8E7;
        padding-bottom:5px;
    }
    #hideTitle td
    {
        border:0px;
        height:1px;
        padding:0px
    }
    body
    {
        font-size:14px;      
    }
    </style>

    <script type="text/javascript">
        var bbPara;
        $(function () {
          
        });
        function Download(obj) {
            var objid = $(obj).attr("objid");
            window.location.href = "../../handler/AttatchHandler.ashx?method=download&Id=" + objid + "&TaskId=" 
            + $("input[name='TaskId']").val() + "&PaperId=" + $("input[name='PaperId']").val()
            + "&ReportId=" + $("input[name='ReportId']").val() + "&CompanyId=" + $("input[name='CompanyId']").val()
            + "&Nd=" + $("input[name='Nd']").val() + "&Zq=" + $("input[name='Zq']").val() + "&DataItem=" + $("input[name='DataItem']").val();
           
        }
        function Delete(obj) {
            var objid = $(obj).attr("objid");
            var para = { method: "delete", Id: objid, TaskId: "", PaperId: "", ReportId: "", CompanyId: "", Nd: "", Zq: "",DataItem:"" };

            para.TaskId = $("input[name='TaskId']").val();
            para.PaperId = $("input[name='PaperId']").val();
            para.ReportId = $("input[name='ReportId']").val();
            para.CompanyId = $("input[name='CompanyId']").val();
            para.Nd = $("input[name='Nd']").val();
            para.Zq = $("input[name='Zq']").val();
            para.DataItem = $("input[name='DataItem']").val();
            $.post("../../handler/AttatchHandler.ashx", para, function (data) {
                data = $.parseJSON(data);
                $("#tbody").empty();
                $.each(data, function (index, item) {
                    var htmlstr = "";
                    htmlstr += "<tr>";
                    htmlstr += "   <td>   <input type='checkbox' objid='" + item.Id + "' id='check" + index + "' name='check' /></td>"
                    htmlstr += "   <td>" + item.Name + "</td>";
                    htmlstr += "<td><input id='Dow" + index + "' objid='" + item.Id + "' type='button' value='下载' onclick='Download(this)'/>";
                    htmlstr += "   <input id='Del" + index + "' objid='" + item.Id + "' type='button' value='删除' onclick='Delete(this)'/></td>";
                    htmlstr += "   </tr>";
                    $("#tbody").append(htmlstr);
                });
            });
        }

        function Change(obj) {
            var flag = obj.checked;
            $.each($("input[name='check']"), function (index, item) {
                if (flag) {
                    item.checked = "checked";
                } else {
                    item.checked = "";
                }

            });
        }

        function DownLoadAll() {
            var ids = GetIds();
            if (ids != "") {
                window.location.href = "../../handler/AttatchHandler.ashx?method=downAll&ids=" + ids + "&TaskId="
            + $("input[name='TaskId']").val() + "&PaperId=" + $("input[name='PaperId']").val()
            + "&ReportId=" + $("input[name='ReportId']").val() + "&CompanyId=" + $("input[name='CompanyId']").val()
            + "&Nd=" + $("input[name='Nd']").val() + "&Zq=" + $("input[name='Zq']").val() + "&DataItem=" + $("input[name='DataItem']").val();
            } else {
            alert("请选择下载项！");
            }
         
        }
        function DeleteAll() {
            var ids = GetIds();
            var para = { method: "deleteAll", ids: ids, TaskId: "", PaperId: "", ReportId: "", CompanyId: "", Nd: "", Zq: "" };

            para.TaskId = $("input[name='TaskId']").val();
            para.PaperId = $("input[name='PaperId']").val();
            para.ReportId = $("input[name='ReportId']").val();
            para.CompanyId = $("input[name='CompanyId']").val();
            para.Nd = $("input[name='Nd']").val();
            para.Zq = $("input[name='Zq']").val();
            if (ids != "") {
                $.post("../../handler/AttatchHandler.ashx", para, function (data) {
                    data = $.parseJSON(data);
                    $("#tbody").empty();
                    $.each(data, function (index, item) {
                        var htmlstr = "";
                        htmlstr += "<tr>";
                        htmlstr += "   <td>   <input type='checkbox' objid='" + item.Id + "' id='check" + index + "' name='check' /></td>"
                        htmlstr += "   <td>" + item.Name + "</td>";
                        htmlstr += "<td><input id='Dow" + index + "' objid='" + item.Id + "' type='button' value='下载' onclick='Download(this)'/>";
                        htmlstr += "   <input id='Del" + index + "' objid='" + item.Id + "' type='button' value='删除' onclick='Delete(this)'/></td>";
                        htmlstr += "   </tr>";
                        $("#tbody").append(htmlstr);
                    });
                });
            } else {
                alert("请选择删除项！");
            }
        }

        function GetIds() {
            var ids = "";
            $.each($("input[name='check']"), function (index, item) {
                if (item.checked) {
                    ids += $(item).attr("objid") + ",";
                }

            });
            if (ids.length > 0) {
                ids = ids.substr(0, ids.length - 1);                
            }
            return ids;
        }

        function SetPara(para) {
            bbPara = para;
            if (bbPara) {
                $("input[name='TaskId']").val(bbPara.TaskId);
                $("input[name='PaperId']").val(bbPara.PaperId);
                $("input[name='ReportId']").val(bbPara.ReportId);
                $("input[name='CompanyId']").val(bbPara.CompanyId);
                $("input[name='Nd']").val(bbPara.Year);
                $("input[name='Zq']").val(bbPara.Cycle);

            }
        }
    </script>
</head>
<body  style=" padding-left:20px; padding-top:10px;margin:0px">
  <form runat="server">
  <input name="TaskId" type="hidden" value="<%=para.TaskId%>" />
      <input name="PaperId" type="hidden" value="<%=para.PaperId %>" />
      <input name="ReportId" type="hidden" value="<%=para.ReportId %>" />
      <input name="CompanyId" type="hidden" value="<%=para.CompanyId %>" />
      <input name="Nd" type="hidden" value="<%=para.Nd %>" />
      <input name="Zq" type="hidden" value="<%=para.Zq %>" />
      <input name="DataItem" type="hidden" value="<%=para.DataItem %>" />
      <table >
          <tr><td>  <asp:FileUpload ID="FileUpload1" runat="server" /></td><td>
          <asp:Button ID="upLoadBtn" runat="server" Text="上传" onclick="upLoadBtn_Click" /></td></tr>
      </table>
      <table style="border-bottom:1px solid #95B8E7;" cellpadding="0" cellspacing="0">
          <tr id="realTitle" ><td style=" width:120px;">选择</td><td style=" width:300px;">描述</td><td style=" width:120px; " colspan="2">操作</td></tr>
      </table>
      <div style="min-height:50px;max-height:400px;overflow:auto">
          <table id="fileGrid" style=""  cellpadding="4px" cellspacing="0">
          <thead>
          <tr style=""  id="hideTitle"><td style=" width:100px;"></td><td style=" width:300px;"></td><td style=" width:140px; " colspan="2"></td><td></td></tr>
          </thead>
              <tbody id="tbody">

              <%
                  for (int i = 0; i < attatches.Count; i++)
                  {
                      AuditEntity.ReportAttatch.ReportAttatchEntity rae = attatches[i];
          

             Response.Write(" <tr>");
             Response.Write("   <td>   <input type='checkbox' objid='" + rae.Id + "' id='check" + i.ToString() + "' name='check' /></td>");
             Response.Write("   <td>"+rae.Name+"</td>");
             Response.Write("<td><input id='Dow" + i.ToString() + "' objid='"+rae.Id+"' type='button' value='下载' onclick='Download(this)'/>");
             Response.Write("   <input id='Del" + i.ToString() + "' objid='" + rae.Id + "' type='button' value='删除' onclick='Delete(this)'/></td>");
             Response.Write("   </tr>");     
                  }%> 
              </tbody>
          </table>
      </div>
          <table style="border-top:1px solid #95B8E7;width:540px" cellpadding="4px" cellspacing="0">
            <tr style=" height:40px">
            <td  style="width:25px"><input type='checkbox' onclick="Change(this)"/></td><td style="width:30px">全选</td><td><input id="downAll" type="button" style=" margin-left:20px" value="下载"  onclick="DownLoadAll()"/> <input id="DelAll" type="button" value="删除" onclick="DeleteAll()"/>
            </td><td></td><td></td></tr>
          </table>

  </form>

    </body>
</html>
