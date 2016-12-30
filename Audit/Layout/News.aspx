<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="News.aspx.cs" Inherits="Audit.Layout.News" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <link href="../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <link href="../lib/easyUI/themes/color.css" rel="stylesheet" type="text/css" />
    <link href="../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <script src="../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <style type="text/css">
    .panelHeaderM{
     height:14px;
     vertical-align:middle;
    }
    
     
    a:link {color: #000066; text-decoration:none;} 
    a:active:{color: red; }
    a:visited {color:purple;text-decoration:none;} 
    a:hover {color: #FF6633; text-decoration:underline;} 

    </style>
     


</head>
<body style="margin:10px;">
     <table id= "table1"  style=" width:83%; margin-left:0.5%;margin-top:1.2%">
     <tr>
        <td>
            <table ><tr><td>
            <div id="p1" class="easyui-panel" >
                <p style="font-size:14px">&nbsp&nbsp&nbsp&nbsp</p>
                <ul class="artul">
                   </ul>
            </div>
            </td></tr></table>
        </td>
        <td >
            <table ><tr><td>
            <div id="p2" class="easyui-panel" >
            <p style="font-size:10px">&nbsp&nbsp </p>
                <ul class="artul">
                   </ul>
            </div>
            </td></tr></table>
        </td>
     </tr>
    
        <tr >
        <td >
            <table style="margin-top:1%"><tr><td>
            <div id="p3" class="easyui-panel" >
            <p style="font-size:10px">&nbsp&nbsp </p>
                <ul class="artul">
                    </ul>
            </div>
            </td></tr></table>
        </td>
        <td>
          <table style="margin-top:1%"><tr><td>
            <div id="p4" class="easyui-panel" >
            <p style="font-size:10px">&nbsp&nbsp </p>
                <ul class="artul">
                   
                </ul>
            </div>
          </td></tr></table>
        </td>
    </tr>
    </table>

    <script type="text/javascript">
        //document.documentElement.clientHeight ==> 可见区域高度
        var widthMax;
        var heightMax;
        $(
        function setPanel(Pwidth,Pheight){
            heightMax = document.documentElement.clientHeight;
            widthMax = document.body.clientWidth;
            var width1 = widthMax *0.41-20;
            var height1 = heightMax*0.41;
            //alert(heightMax + "**" + widthMax);
            if (width1 > 50 && height1 > 50) {
                $('#p1').panel({
                    width: width1,
                    height: height1,
                    headerCls: 'panelHeaderM',
                    title: '最新公告 <a href="#" style="font-size:12px;float:right;text-decoration:none;color: #333333;"onclick="ToMore(1)"> 更多...</a>'

                });
                //alert(heightMax / 2 - 40);

                $('#p2').panel({
                    width: width1,
                    height: height1,
                    headerCls: 'panelHeaderM',
                    title: '业务消息 <a href="#" style="font-size:12px;float:right;text-decoration:none;color: #333333;"onclick="ToMore(2)"> 更多...</a>'
                });
                $('#p3').panel({
                    width: width1,
                    height: height1,
                    headerCls: 'panelHeaderM',
                    title: '集团要闻 <a href="#" style="font-size:12px;float:right;text-decoration:none;color: #333333;"onclick="ToMore(3)"> 更多...</a>'
                });
                $('#p4').panel({
                    width: width1,
                    height: height1,
                    headerCls: 'panelHeaderM',
                    title: '浩电集团内部链接 <a href="http://www.haowujidian.com/culture/news/News.aspx?ArticleId=400&CategoryId=1" style="font-size:12px;float:right;text-decoration:none;color: #333333;"onclick="ToMore(4)"> GO...</a>'
                });
            }
        });
        function ToMore(node) {
            alert(node);
//            var nodeurl = node.attributes['url'].replace(' ', '');
//            if (nodeurl != '' && nodeurl != '#')
//                addTab(node);
        }
</script>
</body>
</html>
