<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="IndexConclusion.aspx.cs" Inherits="Audit.ct.ReportAudit.IndexConclusion" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>审计结论</title>
    <meta http-equiv="X-UA-Compatible" content="IE=9" />
     <meta http-equiv="X-UA-Compatible" content="IE=8" />
     <meta http-equiv="X-UA-Compatible" content="IE=7" />
    <script src="../../lib/jquery/jquery-1.3.2.min.js" type="text/javascript"></script>
       <script src="../../Scripts/Ct_TextInput.js" type="text/javascript"></script>
    <link href="../../Styles/Ct_TextInput.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/Editor/kindeditor-min.js" type="text/javascript"></script>
    <link href="../../lib/Editor/themes/default/default.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/Editor/lang/zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
</head>
<body style=" text-align:center;padding:15px; overflow-y:auto;overflow-x:hidden">
    <script type="text/javascript">
        var widthTemp;
        var contentTemp = "";
        var controls = {};
        $(function () {
            //var widthTemp = document.body.clientWidth;
            $('#editBox').css({
                width: 380,
                height: 300
            });
            KindEditor.ready(function (K) {
                EditorK = K;
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
                controls.problemContent = K.create('#editBox', {
                    themeType: 'qq',
                    items: [
                			'bold', 'italic', 'underline', 'fontname', 'fontsize', 'forecolor', 'hilitecolor', 'plug-align', 'plug-order', 'plug-indent'
                		],
                    width: '340px',
                    minWidth: '100px'
                });
                controls.problemContent.html(contentTemp);
            });
            //parent.CommunicationManager.Right_Control.setFrameData("IndexConclusion");
        });
        function loadData(data) {
            $('#editBox').css({
                width: widthTemp - 40,
                height: data.height - 320
            });
        }
        function LoadConclusion(content) {
            if (controls.problemContent) {
                if (!content) content = "";
                controls.problemContent.html(content);
            } else {
                contentTemp = content;
            }
        }
        function saveConclusion() {
            var param = { key: "Conclusion", data: "" }
            param.data= controls.problemContent.html();
            parent.CommunicationManager.Right_Control.SaveConclusionAndDiscription(param);
        }
         
    </script>
    <div style=" width:auto; height:100%">
    <textarea  id="editBox"></textarea>
    <a  href="#" class="easyui-linkbutton"  style="float:right; outline:none;width:70px; margin-top:10px" iconcls="icon-save"  onclick="saveConclusion()">保存</a>
    </div>
</body>
</html>
