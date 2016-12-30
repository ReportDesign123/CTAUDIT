<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProblemReturnDetail.aspx.cs" Inherits="Audit.ct.ProblemTrace.ProblemReturnDetail" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
     <title>问题反馈</title>
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
     <script src="../../Scripts/Ct_Controls.js" type="text/javascript"></script>
    <link href="../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/Ct_Tool.js" type="text/javascript"></script>

     <script src="../../lib/Editor/kindeditor-min.js" type="text/javascript"></script>
    <script src="../../lib/Editor/lang/zh_CN.js" type="text/javascript"></script>
    <link href="../../lib/Editor/themes/default/default.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/Editor/themes/qq/qq.css" rel="stylesheet" type="text/css" />

<style type="text/css">
    .title{background-color: #66cccc;}
    .title_center
    {    
        display:inline-block;
        padding:10px;
        font-size:20px;
        color:#007979;
        font-weight:600;
    }
    .return
    {
        width:100%;
        overflow:auto;
        margin:0px 0px 5px 0px;
        margin-bottom:15px;
        }
    .title_2
    {
        padding:5px;
        font-size:13px;
        background-color:#ebebe4;
    }
    .return_Content
    {
        width:100%;
        font-size:13px;
        padding:5px 5px;
        }
    .MyBtn
    {
        border-radius:2px;
        padding:8px 25px 8px 25px;
        font-size:12px;
        display:inline-block;
   		color:#FFFFFF;
   		text-align:center;
   		text-decoration:none;
  		background: linear-gradient(to bottom, #4d90fe 0,#3078eb 50% ,#4d90fe 100%); 
   }
   .MyBtn:hover 
   {
        border-radius:2px;
        text-decoration:none;
   		background: linear-gradient(to bottom,#2894FF 0%, #4d90fe 50%, #2894FF  100%);
   	}
   	
   	p{margin: 5px;}
    .Remark
    {
        font-size:12px;
        color:#3C3C3C;
        font-weight:500;
        display:inline-block;
        margin:5px;
        }
    .delBtn
    {
        margin-left:10px;
        color:#479ac7;
        font-size:12px;
   		text-decoration:none;
    }
</style>
<script type="text/javascript">
    var urls = {
            functionsUrl: "../../handler/ProblemTraceHandler.ashx"
    };
    var editor;
    var paraControl = { dHtm: "" };
    $(function () {
        LayoutManager.fitHeight();
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
        editor = K.create('#textEdit', {
            themeType: 'qq',
            items: [
						'bold', 'italic', 'underline', 'fontname', 'fontsize', 'forecolor', 'hilitecolor', 'plug-align', 'plug-order', 'plug-indent'
					],
            width: '99.8%',
            height: '200px',
            minWidth: "100px"
        });
    });

    var LayoutManager = {
        fitHeight: function () {
            var height = $(window).height();
//            $("#returnBody").css("height", height - 380);
        }
    };

    var MethodsManager = {
        setHtml: function (text) {
            editor.html(text);
        },
        getHtml: function () {
            var parm = editor.html();
            return parm;
        },
        Replay: function (all) {
            var date = MethodsManager.getDate();
            var replay = MethodsManager.getHtml();
            if (!replay) { return; }
            var user = $("#User").val();
            var htm = document.getElementById("replayContent").innerHTML;
            htm = htm + '<tr onmouseover = "MethodsManager.OverReplay(this)"><td><div class="return_Content">' + replay + '</div><div style="border-top:1px dotted #ADADAD;text-align:right;">'
                + '<div class="Remark">' + user + '&nbsp;&nbsp;' + date
                + '<a class="delBtn" href="javascript:void(0);" onclick = "MethodsManager.delReplay()">删除</a>'
                + '</div></div></td></tr>';
            var param = { Replay: htm, Id: "" };
            param.Id = $("#Id").val();
            param = CreateParameter(ProblemTraceAction.ActionType.Post, ProblemTraceAction.Functions.ProblemTraceAction, ProblemTraceAction.Methods.ProblemManagerMethods.AddReportProblemReturn, param);
            DataManager.sendData(urls.functionsUrl, param, resultManager.success, resultManager.fail, false);
        },
        delReplay: function () {
            if (!paraControl.dHtm) return;
            var htm = document.getElementById("replayContent").innerHTML;
            htm = htm.toString();
            htm = htm.replace(paraControl.dHtm, "");
            var param = { Replay: htm, Id: "" };
            param.Id = $("#Id").val();
            param = CreateParameter(ProblemTraceAction.ActionType.Post, ProblemTraceAction.Functions.ProblemTraceAction, ProblemTraceAction.Methods.ProblemManagerMethods.AddReportProblemReturn, param);
            DataManager.sendData(urls.functionsUrl, param, resultManager.successDel, resultManager.fail, false);
        },
        delReplayAll: function () {
            $.messager.confirm('系统提示', '确定要清空该问题下所有反馈记录?', function (r) {
                if (r) {
                    var param = { Replay: "", Id: "" };
                    param.Id = $("#Id").val();
                    param = CreateParameter(ProblemTraceAction.ActionType.Post, ProblemTraceAction.Functions.ProblemTraceAction, ProblemTraceAction.Methods.ProblemManagerMethods.AddReportProblemReturn, param);
                    DataManager.sendData(urls.functionsUrl, param, resultManager.successDel, resultManager.fail, false);
                }
            });
        },
        OverReplay: function (Remark) {
            paraControl.dHtm = Remark.innerHTML;
        },
        getDate: function () {
            var date = new Date();
            var o = {
                "Y": date.getFullYear(),
                "M": date.getMonth() + 1, //月份 
                "d": date.getDate(), //日 
                "h": date.getHours(), //小时 
                "m": date.getMinutes(), //分 
                "s": date.getSeconds() //秒 
            };
            return o.Y + '-' + o.M + '-' + o.d + ' ' + o.h + ':' + o.m + ':' + o.s;
        }
    };
    var resultManager = {
        success: function (data) {
            if (data.success) {
//                MessageManager.InfoMessage(data.sMeg);
                MethodsManager.setHtml("")
                $("#replayContent").empty();
                $("#replayContent").append(data.obj);
            } else {
                MessageManager.ErrorMessage(data.sMeg);
            }
        },
        successDel: function (data) {
            if (data.success) {
//                MessageManager.InfoMessage("删除成功");
                MethodsManager.setHtml("")
                $("#replayContent").empty();
                $("#replayContent").append(data.obj);
                paraControl.dHtm = "";
            } else {
                MessageManager.ErrorMessage(data.sMeg);
            }
        },
        fail: function (data) {
            MessageManager.ErrorMessage(data.toString);
        }
    }
    
    
</script>
</head>
<body style="background-color:#FCFCFC;">
    <input id="User" value="<%=user.Name%>"  type="hidden"/>
    <input id="Id" value="<%=rpe.Id%>"  type="hidden"/>
    <table style="width:100%;height:100%;" cellspacing="10px" cellpadding="0px">
        <tr>
            <td style="width:10px"></td>
            <td class="title">
                <div id="title" class="title_center" ><%=rpe.Title%></div>
            </td>
            <td style="width:10px"></td>
        </tr>
        <tr>
            <td></td>
            <td style="border:0px solid #F0F0F0">
                <div class="title_2">问题内容</div>
                <div class="return_Content">
                    <div style="padding-right:5px">
                    <%=rpe.Content%></div>
                </div>
                <div style="border-top:1px dotted #ADADAD;text-align:right;">
                    <div class="Remark" style="padding-right:10px"><span><%=rpe.UserName%></span>&nbsp;&nbsp <span><%=rpe.CreateTime%></span></div>
                </div>
            </td>
            <td></td>
        </tr>
        <tr>
            <td></td>
            <td>
                <div class="title_2">反馈内容</div>
                    <table id="replayContent"  class="return" cellpadding="5px" cellspacing="0px"><%=rpe.Replay %></table>
            </td>
            <td></td>
        </tr>
        <tr>
            <td></td>
            <td style="padding-bottom:20px">
                <div style="width:100%">
                    <div style="width:100%">
                        <div style="padding:0px 15px 5px;text-align:right">
                            <a class="delBtn" href="javascript:void(0);" onclick = "MethodsManager.delReplayAll()" >清空反馈记录</a>
                        </div>
                        <textarea id="textEdit" name="textEdit" cols="" rows="" ></textarea>
                    </div>
                    <div style="padding-top:10px;text-align:right">
                        <a href="javascript:void(0);" class="MyBtn" onclick="MethodsManager.Replay()">提交反馈</a>
                    </div>
                </div>
            </td>
            <td></td>
        </tr>
    </table>
    <div>
        
    </div>
</body>
</html>
