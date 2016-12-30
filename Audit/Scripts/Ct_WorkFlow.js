/// <reference path="../lib/jquery/jquery-1.11.1.min.js" />

var NodeManager = {
    CreateTaskNode: function (value, cur) {
        if (value == undefined) return "";
        var nodes = value.split(",");
        var result = "";
        $.each(nodes, function (index, item) {
            if (item == cur) {
                result += "<span style='color:#ff0000;'>" + item + "</span>" + "→";
            } else {
                result += "<span>" + item + "</span>" + "→";
            }

        });
        result = result.substr(0, result.length - 1);
        return result;
    },
    GetLines: function (lines) {
        var allLines = new Array;
        $.each(lines, function (index, line) {
            allLines.push(line);
        });
        return allLines;
    },
    GetNodeByType: function (type, nodes) {
        var allNodes = new Array;
        $.each(nodes, function (index, node) {
            if (node.type == type) {
                ///张双义
                ///暂时将id = index
                node.id = index;
                allNodes.push(node);
            }
        });
        return allNodes;
    },
    GetNodeById: function (id, nodes) {
        var backNode;
        $.each(nodes, function (index, node) {
            if (node.id == id) {
                backNode = node;
                return;
            }
        });
        return backNode;
    },
    GetLineByNodeId: function (nodeId, lines) {
        var backLine;
        $.each(lines, function (index, line) {
            if (line.from == nodeId) {
                backLine = line;
            }
        });
        return backLine;
    }
};