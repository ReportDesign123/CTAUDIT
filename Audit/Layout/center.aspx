<%--<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="center.aspx.cs" Inherits="Audit.Layout.center1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>--%>
    <script type="text/javascript">
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

            var heightMax = document.documentElement.clientHeight;
            var widthMax = document.body.clientWidth;
            var niframe = document.getElementById("Notice");
            niframe.height = heightMax;
            niframe.width = widthMax;

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
    
</script>
<%--</head>
<body>--%>
   <div id="centerTabs">
	<div title="公告版" border="false" style="overflow: hidden;" >
    <iframe id="Notice"src="Layout/News.aspx" border="0" frameborder="no"></iframe>
    </div>
</div>
<div id="tabsMenu" style="width: 120px;display:none;">
	<div type="refresh">刷新</div>
	<div class="menu-sep"></div>
	<div type="close">关闭</div>
	<div type="closeOther">关闭其他</div>
	<div type="closeAll">关闭所有</div>
</div>
<%--</body>
</html>--%>
