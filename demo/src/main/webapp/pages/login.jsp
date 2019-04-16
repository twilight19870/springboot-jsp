<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width" />
<script src="../layui/layui.js"></script>
<script src="../js/jquery-3.3.1.js"></script>
<script src="../js/jquerysession.js"></script>
<script src="../layui/layui.js"></script>
<link rel="stylesheet" href="../layui/css/layui.css">
<link rel="stylesheet" href="../layui/css/layui.css">
<title>后台管理系统</title>
<script type="text/javascript">
$(function(){
	
});
layui.use(['jquery','layer','form'],function(){
	var $ = layui.jquery;
	 layui.form.on('submit(formSubmit)',function(data){
		/* $.ajaxSettings.async = false;
		 $.post("../api/loginManager/v1/login.do",data.field,function(userlist){
			if(userlist){
				switch (data.code) {
                case 0:
                    console.log(data.data);
                    
                    return;
                default:
                    layer.msg(data.msg);
                    return;
            }
			}else
            	layer.msg("登录出错！请稍候重试。");
			
		},"json").error(function(){
			layer.msg("登录出错！请稍候重试。");
		});
		 $.ajaxSettings.async = true; */
		  $.ajax({
            async: false,
            type: "post",
            data: data.field,
            url: "../api/loginManager/v1/login",
            dataType: "json",
            success: function (datalist) {
            	console.log(datalist.data);
                if (datalist) {
                	if(datalist.code==0){
                		//console.log(JSON.stringify(datalist.data));
                		//console.log("code==0");
                		//console.log(datalist);
                		binding(datalist);
               			             
                	}else{
                		layer.msg(datalist.msg);
                	} 
                    /* switch (datalist.code) {
                        case 0:
                            console.log(JSON.stringify(datalist.data));
                            binding(datalist);
                            forindex();
                            return;
                        
                        default:
                            layer.msg(datalist.msg);
                            return;
                    } */
                 }else
                	layer.msg("登录出错！请稍候重试。");
            },
            error: function () {
                layer.msg("登录出错！请稍候重试。");
            }
        });   
		 //window.location.href="index.jsp";
		 return false;
	}); 
});
function binding(data){
//	 $user = $ret['data'][0];
	 var user = data.data[0];
	 //console.log(user.userName);
	 if(user){
		 //console.log(user);
		 var username = $("#form-username").val();
		 var password = $("#form-password").val();
		 $.session.set("menuList",user.menuList);
		 //console.log(user.menuList);
		 $.session.set("time",new Date().toLocaleTimeString());
		 $.session.set("token",data.token);
		 window.sessionStorage.setItem("accountsName",user.accountsName);
		 window.sessionStorage.setItem("token",data.token);
		 window.sessionStorage.setItem("userId",user.id);
		 $.session.set("user",[username,password]);
		 $.session.set("name",user.userName);
		 window.sessionStorage.setItem("name",user.userName);
		 $.session.set("id",user.id);
		 $.session.set("phone",user.phoneNo);
		 window.sessionStorage.setItem("phone",user.phoneNo);
		 $.session.set("idCard",user.idCard);
		 $.session.set("sex",user.userSex);
		 $.session.set("agencyId",user.ageId);
		 window.sessionStorage.setItem("agencyId",user.ageId);
		 if(user.agencyName == '斯玛特'){
			 $.session.set("agencyName","本代理商");
			 window.sessionStorage.setItem("agencyName","本代理商");
		 }else{
			 $.session.set("agencyName",user.agencyName);
			 window.sessionStorage.setItem("agencyName",user.agencyName);
		 }
		 $.session.set("creatorId",user.procreatorId);
		 $.session.set("deptId",user.deptId);
		 $.session.set("roleId",user.roleId); 
		 //console.log("session里面是："+JSON.stringify($.session));
		 window.location = "index.jsp";  
	 }else{
		 layer.msg("登录出错！请稍候重试。");
	 }

	
}
function forindex(){
	window.location.href="index.jsp";
}
</script>
<style>
body {
	background: url(../img/login_bg.jpg) no-repeat fixed;
	background-size: cover;
	width:100%;
	height:100%
}
</style>
</head>
<body>
<div class="layui-container">
    <h1 style="text-align: center;color: white;font-size: 5em;margin-top: 8%;margin-bottom: 3%">后台管理系统</h1>
    <div style="background-color: rgba(6,6,6,0.33);padding: 6% 3%; border-radius: 8px;max-width: 350px;margin: auto;">
        <form class="layui-form">
            <div class="layui-form-item ">
                <input type="text" name="accountsName" placeholder="账号" required lay-verify="required"
                       class="layui-input" id="form-username">
            </div>
            <div class="layui-form-item">
                <input type="password" name="password" placeholder="密码" required lay-verify="required"
                       class="layui-input" id="form-password">
            </div>
            <button lay-submit lay-filter="formSubmit" class="layui-btn layui-btn-fluid">登录</button>
        </form>
    </div>
    <div style="display: none">
        Copyright © 2017-2018 <strong><a href="//www.yefiot.com/" target="_blank">斯玛特</a></strong>&nbsp;
        <strong><a href="//www.yefiot.com/" target="_blank">yefiot.com</a></strong>
    </div>
</div>
</body>
</html>