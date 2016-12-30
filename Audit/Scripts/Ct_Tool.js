var Ct_Tool = {
    GetCurrentDate: function () {
        var date = new Date();
        var year = date.getFullYear();
        var month = date.getMonth() + 1;
        var day = date.getDate();
        var monthstr = month < 10 ? ("0" + month) : month.toString();
        var dateStr = date < 10 ? ("0" + day) : day.toString();
        return year + "-" + monthstr + "_" + dateStr;
    },
    AddDecimalPoint: function (num) {
        var temp = num.toString();
        if (isNaN(temp)) return num;
        var index = temp.indexOf(".");
        if (index == -1) {
            var regex = /(-?\d+)(\d{3})/;
            while (regex.test(temp)) {
                temp = temp.replace(regex, "$1,$2");
            }
        } else {
            var intPart = temp.substring(0, index);
            var pointPart = temp.substring(index + 1, temp.length);
            var reg = /(-?\d+)(\d{3})/;
            while (reg.test(intPart)) {
                intPart = intPart.replace(reg, "$1,$2");
            }
            temp = intPart + "." + pointPart;
        }
        return temp;
    },
    RemoveDecimalPoint: function (num) {
        num = num.replace(/[ ]/g, "");
        num = num.replace(/,/gi, '');
        return num;
    },
    KeyPress: function (id, pressFunc) {
        $("#" + id).keypress(function (e) {
            var curKey = e.which;
            if (curKey == 13) {
                pressFunc();
            }
        });
    },
    FixNumber: function (value, num) {
        try {
           return Number(value).toFixed(num);
        } catch (err) {
            alert(err.Message);
        }
    }

};