<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UploadMiddle.aspx.cs" Inherits="Audit.ct.ReportData.UploadMiddle" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>报表下载管理</title>
      <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
        <script src="../../Scripts/ct_dialog.js" type="text/javascript"></script>
    <script type="text/javascript">
        window.onload = function () {
            var bbPara = dialog.para();// window.dialogArguments;
            var iframe = window.frames["upFrame"];           
            iframe.SetPara(bbPara);
        }
    </script>
</head>
<body>
    <iframe id="upFrame" src="UploadAttatch.aspx?TaskId=<%=rae.TaskId%>&PaperId=<%=rae.PaperId %>&ReportId=<%=rae.ReportId %>&CompanyId=<%=rae.CompanyId %> &Nd=<%=rae.Nd %>&Zq=<%=rae.Zq %>&DataItem=<%=rae.DataItem %>" frameborder="0" width="100%" height="540px" ></iframe>
</body>
</html>
