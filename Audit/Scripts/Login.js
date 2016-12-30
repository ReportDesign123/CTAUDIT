var PasswordManager = {
    CreateValidateCode: function () {
        code = "";
        var codeLength = 6; //验证码的长度  
        var selectChar = new Array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'); //所有候选组成验证码的字符，当然也可以用中文的  
        for (var i = 0; i < codeLength; i++) {
            var charIndex = Math.floor(Math.random() * 36);
            code += selectChar[charIndex];
        }
        return code;
    },
    PasswordStrengthValidate: function (string) {
        if (string.length >= 6) {
            if (/[a-zA-Z]+/.test(string) && /[0-9]+/.test(string) && /\W+\D+/.test(string)) {
                return "强";
            } else if (/[a-zA-Z]+/.test(string) || /[0-9]+/.test(string) || /\W+\D+/.test(string)) {
                if (/[a-zA-Z]+/.test(string) && /[0-9]+/.test(string)) {
                    return "中";
                } else if (/\[a-zA-Z]+/.test(string) && /\W+\D+/.test(string)) {
                    return "较弱";
                } else if (/[0-9]+/.test(string) && /\W+\D+/.test(string)) {
                    return "较弱";
                } else {
                    return "弱";
                }
            }
        } else {
            return -1;
        }
    }
};