<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="Audit.Index" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <title>浩物机电审计系统</title>

    <meta http-equiv="X-UA-Compatible" content="IE=10" />
    <meta http-equiv="X-UA-Compatible" content="IE=9" />
    <meta http-equiv="X-UA-Compatible" content="IE=8" />
    <meta http-equiv="X-UA-Compatible" content="IE=7" />
    <script src="lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />

    <script src="lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="Scripts/FunctionMethodManager.js" type="text/javascript"></script>

    <script src="Scripts/layer/layer.js"></script>
    <style type="text/css">
        table {
    display: table;
    border-collapse: separate;
    border-spacing: 2px;
    border-color: grey;
    border-width:5px;
    border-style:solid;
}
        .loading {
    font-family: Arial, sans-serif;
    color: #4f4f4f;
    background: #ffffff;
    font-size: 20px;
    padding: 0.4em;
}
        .ui_dialog {
    background: #FFF;
}
        .layui-layer-hui {
            background:none;
        }
    </style>
    
    <script type="text/javascript">
        loader = {
            open: function (  ) {
                if (layer) {
                     
                    layer.msg('<table class="ui_dialog"><tbody><tr><td colspan="2"><div class="ui_title_bar"><div class="ui_title" unselectable="on" style="cursor: move; display: none;"></div><div class="ui_title_buttons"><a class="ui_min" href="javascript:void(0);" title="最小化" style="display: none;"><b class="ui_min_b"></b></a><a class="ui_max" href="javascript:void(0);" title="最大化" style="display: none;"><b class="ui_max_b"></b></a><a class="ui_res" href="javascript:void(0);" title="还原"><b class="ui_res_b"></b><b class="ui_res_t"></b></a><a class="ui_close" href="javascript:void(0);" title="关闭(esc键)" style="display: none;">×</a></div></div></td></tr><tr><td class="ui_icon"><img src="Scripts/layer/skin/default/loading-2.gif" class="ui_icon_bg"></td><td class="ui_main" style="width: auto; height: auto;"><div class="ui_content" style="padding: 10px;"><span class="loading">报表正在计算数据，请稍后</span></div></td></tr><tr><td colspan="2"><div class="ui_buttons" style="display: none;"></div></td></tr></tbody></table>', {
                        icon:  -1,
                        time: 0,
                        shade: 0.1,
                        area: ['390px', '80px'],

                    } );
                    
                }
               
            },
            close: function () {
                if (layer) {
                    layer.close(layer.index);
                }
            }
        };
    </script>
    <style type="text/css">
        .easyui-tree li {
            margin-top: 6px;
        }

        .headerCss {
            padding-left: 10px;
        }

        body {
            font-family: helvetica, tahoma, verdana, sans-serif;
            padding: 10px;
            font-size: 13px;
            margin: 0;
        }

        .easyui-tree {
            list-style-type: none;
            margin: 0px;
            padding: 0px;
        }
    </style>
    <script type="text/javascript">
        //导航函数
        function NavigatorNode(node) {
            addTab(node);
        }

        var centerTabs;
        var tabsMenu;
        $(function () {
            tabsMenu = $('#tabsMenu').menu({
                onClick: function (item) {
                    var curTabTitle = $(this).data('tabTitle');
                    var type = $(item.target).attr('type');

                    if (type === 'refresh') {
                        refreshTab(curTabTitle);
                        return;
                    }

                    if (type === 'close') {
                        var t = centerTabs.tabs('getTab', curTabTitle);
                        if (t.panel('options').closable) {
                            centerTabs.tabs('close', curTabTitle);
                        }
                        return;
                    }

                    var allTabs = centerTabs.tabs('tabs');
                    var closeTabsTitle = [];

                    $.each(allTabs, function () {
                        var opt = $(this).panel('options');
                        if (opt.closable && opt.title != curTabTitle && type === 'closeOther') {
                            closeTabsTitle.push(opt.title);
                        } else if (opt.closable && type === 'closeAll') {
                            closeTabsTitle.push(opt.title);
                        }
                    });

                    for (var i = 0; i < closeTabsTitle.length; i++) {
                        centerTabs.tabs('close', closeTabsTitle[i]);
                    }
                }
            });

            centerTabs = $('#centerTabs').tabs({
                fit: true,
                border: false,
                onContextMenu: function (e, title) {
                    e.preventDefault();
                    tabsMenu.menu('show', {
                        left: e.pageX,
                        top: e.pageY
                    }).data('tabTitle', title);
                }
            });

            //            var heightMax = document.documentElement.clientHeight;
            //            var widthMax = document.body.clientWidth;
            //            var niframe = document.getElementById("Notice");
            //            niframe.height = heightMax;
            //            niframe.width = widthMax;

        });
        function refreshTab(title) {
            var tab = centerTabs.tabs('getTab', title);

            centerTabs.tabs('update', {
                tab: tab,
                options: tab.panel('options')
            });
        }
        function refreshTabURL(title, content) {
            var tab = centerTabs.tabs('getTab', title);
            tab.panel('options').content = content;
            centerTabs.tabs('update', {
                tab: tab,
                options: tab.panel('options')
            });
        }

        function addTab(node) {
            if (centerTabs.tabs('exists', node.text)) {
                refreshTab(node.text); //增加左侧菜单点击刷新功能 libc 2012-9-24  
                centerTabs.tabs('select', node.text);
                //                	var content='<iframe src="' + node.attributes.url + '" frameborder="0" style="border:0;width:100%;height:99.4%;"></iframe>';
                //                	refreshTabURL(node.text,content);


            } else {
                if (node.attributes.url && node.attributes.url.length > 0) {
                    //if (node.attributes.url.indexOf('!druid.action') == -1) {/*数据源监控页面不需要开启等待提示*/
                    $.messager.progress({
                        text: '正在加载...',
                        interval: 100
                    });
                    window.setTimeout(function () {
                        try {
                            $.messager.progress('close');
                        } catch (e) {
                        }
                    }, 0);
                    //	}
                    centerTabs.tabs('add', {
                        title: node.text,
                        closable: true,
                        iconCls: node.iconCls,
                        content: '<iframe src="' + node.attributes.url + '" frameborder="0" style="border:0;width:100%;height:99.4%;"></iframe>',
                        tools: [{
                            iconCls: 'icon-mini-refresh',
                            handler: function () {
                                refreshTab(node.text);
                            }
                        }]
                    });
                } else {
                    centerTabs.tabs('add', {
                        title: node.text,
                        closable: true,
                        iconCls: node.iconCls,
                        content: '<iframe src="" frameborder="0" style="border:0;width:100%;height:99.4%;"></iframe>',
                        tools: [{
                            iconCls: 'icon-mini-refresh',
                            handler: function () {
                                refreshTab(node.text);
                            }
                        }]
                    });
                }
            }
        }
        ///调用参数：<iframe id="Frame"...></iframe>
        ///用途：获取Frame对象
        ///张双义
        function getGridIframe() {
            gridFrame = window.frames["Notice"];
            return gridFrame;
        }



        function clickHandler(node) {
            var nodeurl = node.attributes['url'].replace(' ', '');
            if (nodeurl != '' && nodeurl != '#')
                addTab(node);
        }
        function LoginOut() {
            var para = {};
            para = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.UserManager, BasicAction.Methods.UserManagerMethods.LoginOut, para);
            DataManager.sendData("handler/BasicHandler.ashx", para, resultManagers.success, resultManagers.fail, false);
            return false;
        }

        var resultManagers = {

            success: function (data) {
                if (data.success) {
                    window.location.href = "Login.aspx";
                } else {
                    MessageManager.InfoMessage(data.sMeg);
                }
            },
            fail: function (data) {
                if (data) {
                    MessageManager.InfoMessage(data.sMeg);
                }
            }
        };
        function ss() {
            alert(1);
        }
    </script>
</head>
<body id="indexLayout" class="easyui-layout">
    <%-- <div region="north" class="logo" style="height: 85px; padding: 1px; overflow: hidden;"  href="Layout/north.aspx"></div>--%>
    <div region="center" style="overflow: hidden;">
        <div id="centerTabs">
            <div title="公告版" border="false" style="overflow: hidden;">
                <%--<iframe id="Notice"src="Layout/News.aspx" border="0" frameborder="no"></iframe>--%>
            </div>
        </div>
        <div id="tabsMenu" style="width: 120px; display: none;">
            <div type="refresh">刷新</div>
            <div class="menu-sep"></div>
            <div type="close">关闭</div>
            <div type="closeOther">关闭其他</div>
            <div type="closeAll">关闭所有</div>
        </div>
    </div>
    <div region="west" title="功能导航" split="false" style="width: 190px; overflow: hidden;">
        <div class="easyui-layout" data-options="fit:true" style="border: 0px">
            <div region="center" style="border: 0px">
                <div class="easyui-accordion" style="border: left" data-options="fit:true,border:false,animate:true">
                    <%
                        int i = 0;
                        foreach (AuditSPI.FunctionStruct fs in functions)
                        {
                            string temp = i.ToString();
                            Response.Write("<script type='text/javascript'>var mdata" + i.ToString() + "=" + fs.childrenJson + "</script>");
                    %>
                    <div title="<%=fs.text %>" data-options="iconCls:'<%=fs.iconCls %>'">
                        <ul class="easyui-tree tree" data-options="data:mdata<%=temp%>,onClick : clickHandler"></ul>
                    </div>

                    <%
                            i++;
                        }
                    %>
                </div>
            </div>
            <div region="south" style="height: 30px; overflow: hidden; border: 0px" data-options="collapsible:false">
                <div class="panel-header" style="width: 190px; cursor: pointer" onclick="LoginOut()">
                    <img src="lib/easyUI/themes/icons/closs16.png" style="left: 3px; width: 16px; position: relative;" /><span class="panel-title" style="left: 9px; top: -3px; position: relative;">退出系统</span></div>
            </div>
        </div>
    </div>
    <%--   <div region="south" style="height:20px;overflow: hidden;"  href="Layout/south.aspx"></div>--%>
</body>
</html>
