/// <reference path="../../lib/jquery/jquery-1.3.2.min.js" />
/// <reference path="FormularGuid.js" />

var BalanceManager = {
    AddBalanceManager: function (id, formularContent, methodType, errorInfo) {
        //创建平衡公式，对于混合平衡公式的行列，其开始行、开始列、结束行、结束列都要采用*
        var formular;
        if (methodType == "add") {
            formular = toolManager.Formular.CreateFormularObj();
            formular.firstCol = "-1";
            formular.firstRow = "-1";
            formular.lastRow = "-1";
            formular.lastCol = "-1";
            formular.Id = id;
            formular.content = formularContent;
            formular.isOrNotBatch = "1";
            formular.isOrNotCaculate = "0";
            formular.isOrNotTake = "0";
            formular.sequence = 0;
            FormularData.formularMaps[id] = [];
            FormularData.formularMaps[id].push(formular);

        } else if (methodType == "edit") {
            formular = FormularData.formularMaps[id][0];
            formular.content = formularContent;
        }
        formular.ErrorInfo = errorInfo;
    },
    DeleteBalanceManager: function (id) {
        delete FormularData.formularMaps[id];
    },
    CreateBalanceData: function () {
        var data = { Rows: [] };
        $.each(FormularData.formularMaps, function (id, formulars) {
            if (formulars[0].firstCol == "-1" && formulars[0].firstRow == "-1") {
                data.Rows.push(formulars[0]);
            }
        });
        return data;
    }
};
