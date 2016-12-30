<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Editor.aspx.cs" Inherits="Audit.ct.ReportAudit.Editor" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>框架界面</title>

    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="../../lib/Editor/kindeditor-min.js" type="text/javascript"></script>
    <script src="../../lib/Editor/lang/zh_CN.js" type="text/javascript"></script>
    <link href="../../lib/Editor/themes/default/default.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/Editor/themes/qq/qq.css" rel="stylesheet" type="text/css" />

    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    
</head>
<body style=" padding:0px; overflow:hidden">
     <textarea id="content" name="content" ></textarea>
    <script type="text/javascript">
        var editor;
        function getHtml() {
            var parm = editor.html();
            return parm;
        }
        function setHtml(text) {
            editor.html(text);
        }
        var tWidth = "370px";
        var tHeight = "180px";
        $(function () {
            if (parent.setTareaParam) {
                var param = parent.setTareaParam();
                tWidth = param.width;
                tHeight = param.height;
            }
        });
        KindEditor.ready(function (K) {
            K.each({
                'plug-align': {
                    name: '对齐方式',
                    method: {
                        'justifyleft': '左对齐',
                        'justifycenter': '居中对齐',
                        'justifyright': '右对齐'
                    }
                },
                'plug-order': {
                    name: '编号',
                    method: {
                        'insertorderedlist': '数字编号',
                        'insertunorderedlist': '项目编号'
                    }
                },
                'plug-indent': {
                    name: '缩进',
                    method: {
                        'indent': '向右缩进',
                        'outdent': '向左缩进'
                    }
                }
            }, function (pluginName, pluginData) {
                var lang = {};
                lang[pluginName] = pluginData.name;
                KindEditor.lang(lang);
                KindEditor.plugin(pluginName, function (K) {
                    var self = this;
                    self.clickToolbar(pluginName, function () {
                        var menu = self.createMenu({
                            name: pluginName,
                            width: pluginData.width || 100
                        });
                        K.each(pluginData.method, function (i, v) {
                            menu.addItem({
                                title: v,
                                checked: false,
                                iconClass: pluginName + '-' + i,
                                click: function () {
                                    self.exec(i).hideMenu();
                                }
                            });
                        })
                    });
                });
            });
            editor = K.create('#content', {
                themeType: 'qq',
                items: [
						'bold', 'italic', 'underline', 'fontname', 'fontsize', 'forecolor', 'hilitecolor', 'plug-align', 'plug-order', 'plug-indent'
					],
                width: tWidth,
                height:tHeight,
                minWidth: "100px"
            });
        });
       
    </script>
</body>
</html>

