<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Audit.Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>框架界面</title>

    <script src="lib/xhEditor/jquery/jquery-1.4.4.min.js" type="text/javascript"></script>
    <script src="Scripts/ct/pub/PubHelp.js" type="text/javascript"></script>
<%--    <script src="lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>--%>
<%--    <script src="lib/Editor/kindeditor-min.js" type="text/javascript"></script>
    <script src="lib/Editor/lang/zh_CN.js" type="text/javascript"></script>
    <link href="lib/Editor/themes/default/default.css" rel="stylesheet" type="text/css" />
    <link href="lib/Editor/themes/qq/qq.css" rel="stylesheet" type="text/css" />--%>

    <script src="lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <link href="lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <link href="lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <script src="lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>

<%--
    <link href="lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
    <script src="lib/jquery/jquery-1.5.2.min.js" type="text/javascript"></script>
    <script src="lib/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="lib/ligerUI/js/ligerui.min.js" type="text/javascript"></script>
    <script src="lib/Cookie/jquery.cookie.js" type="text/javascript"></script>--%>
 <%--   <link href="Styles/Ct_TextInput.css" rel="stylesheet" type="text/css" />
    <script src="Scripts/Ct_TextInput.js" type="text/javascript"></script>--%>

<%--    <script src="lib/Editor/ckEditor/ckeditor.js" type="text/javascript"></script>
    <script src="lib/Editor/ckEditor/styles.js" type="text/javascript"></script>
    <script src="lib/Editor/ckEditor/adapters/jquery.js" type="text/javascript"></script>--%>

    <script src="lib/highCharts403/highcharts.js" type="text/javascript"></script>
    <script src="Scripts/Login.js" type="text/javascript"></script>
    <script src="lib/xhEditor/xheditor-1.2.1.min.js" type="text/javascript"></script>
    <script src="lib/xhEditor/xheditor_lang/zh-cn.js" type="text/javascript"></script>

    <script type="text/javascript">
        //        $(
        //        function () {
        //            var width = document.body.clientWidth;            
        //            $("#layout").ligerLayout({ width: '100%', height: '100%',leftWidth:190,rightWidth:width-210, allowRightCollapse: false });
        //        }
        //        );
        //        var para = { name: "gg" };
        //        $.cookie.row = true;
        //        $.cookie("ss", para);
        //        para = $.cookie("ss");
        //        alert(para.name);

        //        $(
        //        function () {
        //            $("#input").focus(function () {
        //                $("#span").addClass("textbox-focused");
        //            });
        //            $("#input").blur(function () {
        //                $("#span").removeClass("textbox-focused");
        //            });

        //            $("#ti").CTTextBox({ innerText: "code" });
        //   
        //       
        //        }
        //        );



        //        $(function () {
        //            $('#container').highcharts({
        //                title: {
        //                    text: '历史趋势',
        //                    x: -20 //center
        //                },
        //                subtitle: {
        //                    text: '资产负债表',
        //                    x: -20
        //                },
        //                xAxis: {
        //                    categories: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月']
        //                },
        //                yAxis: {
        //                    title: {
        //                        text: '金额 (元)'
        //                    },
        //                    plotLines: [{
        //                        value: 0,
        //                        width: 1,
        //                        color: '#808080'
        //                    }]
        //                },
        //                tooltip: {
        //                    valueSuffix: '元'
        //                },
        //                series: [{
        //                    name: '流动资产',
        //                    data: [7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6]
        //                }]
        //            });
        //        });
    </script>
    <style type="text/css">
        body{ padding:5px; margin:0; padding-bottom:15px;overflow:hidden;}
        .code
        {
            background-color:Green;
            width:30px;
            height:20px;        
            text-align:center;   
            padding:2px; 
        }
    </style>
</head>
<body>
   
  <%--  <form id="form1" runat="server">--%>
   
<%--    <div id="layout" >
     <div id="northDiv" position="top"></div>
    <div id="westDiv" position="left"></div>
    <div id="eastDiv" position="right"></div>
    <div id="southDiv" position="bottom"></div>
    </div>--%>

<%--    <asp:Button ID="Button1" runat="server" onclick="Button1_Click" Text="Button" />--%>
<%--<div>Company:</div>
            <input class="easyui-textbox" style="width:100%;height:32px">
    </form>--%>
 <%--   <span id="span" class="ct-textBox" style=" width:276px; height:30px;">
    <input type="text" id="input" class=" ct-textbox-prompt ct-textBox-text" autocomplete="off" placeholder="Enter a email address..." style="margin-left: 0px; margin-right: 0px; padding-top: 7px; padding-bottom: 7px; width: 268px;"/>    
    </span>--%>
<%--
    <input id="ti" type="text"  value="ss"/>
    <button id="text" value="ss"></button>
        <div id="Dialog">
     <textarea id="content" name="content" style="WIDTH: 600px; HEIGHT: 300px"></textarea>
    </div>--%>
   <div id="container" style=" width:600px; height:400px;"></div>
    <script>
        //        CKEDITOR.replace('content', { uiColor: '#14B8C4' });
        //        $("#text").bind("click", function () {
        //            alert( editor.html());
        //        }
        //                        );
        //        var editor;
        //        KindEditor.ready(function (K) {
        //            K.each({
        //                'plug-align': {
        //                    name: '对齐方式',
        //                    method: {
        //                        'justifyleft': '左对齐',
        //                        'justifycenter': '居中对齐',
        //                        'justifyright': '右对齐'
        //                    }
        //                },
        //                'plug-order': {
        //                    name: '编号',
        //                    method: {
        //                        'insertorderedlist': '数字编号',
        //                        'insertunorderedlist': '项目编号'
        //                    }
        //                },
        //                'plug-indent': {
        //                    name: '缩进',
        //                    method: {
        //                        'indent': '向右缩进',
        //                        'outdent': '向左缩进'
        //                    }
        //                }
        //            }, function (pluginName, pluginData) {
        //                var lang = {};
        //                lang[pluginName] = pluginData.name;
        //                KindEditor.lang(lang);
        //                KindEditor.plugin(pluginName, function (K) {
        //                    var self = this;
        //                    self.clickToolbar(pluginName, function () {
        //                        var menu = self.createMenu({
        //                            name: pluginName,
        //                            width: pluginData.width || 100
        //                        });
        //                        K.each(pluginData.method, function (i, v) {
        //                            menu.addItem({
        //                                title: v,
        //                                checked: false,
        //                                iconClass: pluginName + '-' + i,
        //                                click: function () {
        //                                    self.exec(i).hideMenu();
        //                                }
        //                            });
        //                        })
        //                    });
        //                });
        //            });
        //            editor = K.create('#content', {
        //                themeType: 'qq',
        //                items: [
        //						'bold', 'italic', 'underline', 'fontname', 'fontsize', 'forecolor', 'hilitecolor', 'plug-align', 'plug-order', 'plug-indent'
        //					],
        //                width:'400px',
        //                minWidth: "100px"
        //            });
        //        });

        //        KindEditor.each({
        //            'plug-align': {
        //                name: '对齐方式',
        //                method: {
        //                    'justifyleft': '左对齐',
        //                    'justifycenter': '居中对齐',
        //                    'justifyright': '右对齐'
        //                }
        //            },
        //            'plug-order': {
        //                name: '编号',
        //                method: {
        //                    'insertorderedlist': '数字编号',
        //                    'insertunorderedlist': '项目编号'
        //                }
        //            },
        //            'plug-indent': {
        //                name: '缩进',
        //                method: {
        //                    'indent': '向右缩进',
        //                    'outdent': '向左缩进'<input id="Button1" type="button" value="button" />
        //                }
        //            }
        //        });
        //            var editor = KindEditor.create('#content', {
        //                themeType: 'qq',
        //                items: [
        //						'bold', 'italic', 'underline', 'fontname', 'fontsize', 'forecolor', 'hilitecolor', 'plug-align', 'plug-order', 'plug-indent'
        //					],
        //                width: '400px',
        //                minWidth: "100px"
        //            });

        function ClickBtn() {
            var code = PasswordManager.CreateValidateCode();
            $("span").text(code);
            var str = PasswordManager.PasswordStrengthValidate(code);
            alert(str);
        }

        function ClickJump() {
            //            var HeigthIframe = window.frames["HeigthIframe"];
            //            var mulu = HeigthIframe.document.getElementById("mulu");
            //            //mulu.href = "#test";
            //            HeigthIframe.document.frames.window.location.hash = "#test";
            //            var result = window.showModelessDialog("Default2.aspx?a=ss", "ss", "DialogHeight:120px;DialogWidth:450px;help:no;status:no;");
            pubHelp.parameters.name = "sss";
            pubHelp.OpenDialogWithHref("dialog", "测试", "ct/pub/HelpDialogEasyUi.htm", null, 400, 300, true);

        }

    </script>
<input id="Button1" type="button" value="button" onclick="ClickBtn()" />

<span id="span" class="code" ></span>
<%--<textarea name="content" class="xheditor" style=" width:800px; height:600px;">test</textarea>--%>
<iframe height="300px" width="400px" src="Default2.aspx"   id="HeigthIframe"></iframe>
<a href="#"  onclick="ClickJump()">目录一</a>
<div id="dialog"></div>
  
</body>
</html>