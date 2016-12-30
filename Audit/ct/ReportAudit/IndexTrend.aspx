<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="IndexTrend.aspx.cs" Inherits="Audit.ct.ReportAudit.IndexTrend" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>指标趋势</title>
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="../../lib/highCharts403/highcharts.js" type="text/javascript"></script>
    <script type="text/javascript">
        var categories = {
            figure: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'],
            empty: ['0', '0', '0', '0', '0', '0', '0', '0', '0', '0']

        }
        var colors = ["#FF6699", "#CC33CC", "#FF6600", "#009900", "#00CC99"]; 
        var shape=["circle", "triangle", "diamond", "square","triangle-down"];
        var type = "";
        var control = { IndexTrend: {}, chart: {} };
        function loadData(param) {
            var data = param.series;
            if (!data.XSeries[0]) { data.XSeries = categories.figure; }
            if (!data.series[0]) {
                data.series[0] = {};
                data.series[0].seriesData = categories.empty; 
             }
            if (!data.series[0].seriesData[0] && data.series[0].seriesData[0]!=0) { data.series[0].seriesData = categories.empty; }
            if (!control.IndexTrendchart) {
                control.IndexTrendchart = $('#IndexTrend').highcharts({
                    chart: {
                        height: 250,
                        type: 'line'
                    },
                    title: {
                        text: null
                    },
                    subtitle: {
                        text: null,
                        x: -20
                    },
                    xAxis: {
                        categories: data.XSeries
                    },
                    yAxis: {
                        title: {
                            text: null
                        },
                        labels: {
                            format: '{value}'
                        },
                        plotLines: [{
                            value: 0,
                            width: 1
                        }]
                    },
                    tooltip: {
                        formatter: function () {
                            return '<b>' + this.series.name + '</b><br/>' +
                    this.x + ': ' + this.y;
                        },
                        crosshairs: [{//控制十字线  
                            width: 1,
                            color: "#FFD700",
                            dashStyle: "longdash"
                        }, {//控制十字线  
                            width: 1,
                            color: "#FFD700",
                            dashStyle: "longdash"
                        }
                        ]
                    },
                    series: [{
                        color: colors[0],
                        name: param.Name + "(" + param.Code + ")",
                        data: data.series[0].seriesData
                    }]
                });
                control.chart = control.IndexTrendchart.highcharts();
            } else {
                var sNum = control.chart.series.length;
                for (var i = 1; i < sNum; i++) {
                    control.chart.series[(control.chart.series.length - 1)].remove();
                }
                if (control.chart.series[0]) {
                    control.chart.series[0].update({
                        name: param.Name + "(" + param.Code + ")",
                        data: data.series[0].seriesData
                    });
                }
                control.chart.xAxis[0].update({
                    categories: data.XSeries 
                });
            }
        }
        function addSeries(Series) {
            var sNum = control.chart.series.length;
            for (var i = 1; i < sNum; i++) {
                control.chart.series[(control.chart.series.length-1)].remove();
            }
            $.each(Series.series, function (index, series) {
                if (!control.IndexTrendchart) {
                    loadData(Series);
                } else {
                    if (control.chart.series[index]) {
                        control.chart.series[index].update({
                            color: colors[index],
                            marker: {
                                symbol: shape[index]//点形状
                            },
                            name: series.Name + "(" + series.Code + ")",
                            data: series.seriesData
                        });
                    } else {
                        control.chart.addSeries({
                            color: colors[index],
                            marker: {
                                symbol: shape[index]//点形状
                            },
                            name: series.Name + "(" + series.Code + ")",
                            data: series.seriesData
                        });
                    }
                }
            });
            control.chart.xAxis[0].update({
                categories: Series.XSeries
            });
        }
    </script>
    <style type="text/css">
        body{margin:0;overflow:hidden;}
    </style>
</head>
<body>
   <div id="IndexTrend" style=" width:100%;"></div>
</body>
</html>
