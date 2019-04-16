function checkLogin(data) {
    switch (data.code) {
        case 1004:
        case 1003:
        case 1002:
        	alert("登录信息已超时！");
            window.top.location = "./login.jsp";
            return true;
    }
}