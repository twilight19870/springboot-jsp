<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<html>
<head>
<meta name="viewport" content="width=device-width" />
<link rel="stylesheet" href="css/mui.css" media="all">
<link rel="stylesheet" type="text/css" href="fonts/font.css">
<script src="js/mui.js"></script>
<script src="js/md5.js"></script>
<script src="js/jquery-3.3.1.js"></script>
<title>登录页面</title>
<script type="text/javascript">
function login(){
	let username = $("input[name='username']").val();
	//console.log("username:"+username);
	let password = $("input[name='password']").val();
	let client_id = $("input[name='client_id']").val();
	let redirect_uri = $("input[name='redirect_uri']").val();
	let response_type = $("input[name='response_type']").val();
	let state = $("input[name='state']").val();
	/* console.log("password:"+password);
	console.log("client_id:"+client_id);
	console.log("redirect_uri:"+redirect_uri);
	console.log("response_type:"+response_type);
	console.log("state:"+state); */
	//console.log(hex_md5(password+username));
	$.post("https://yfwl-test1.idealhome666.com/yefiot-manager/alexaLogin",{
		username:username,
		password:hex_md5(password+username),
		client_id:client_id,
		redirect_uri:redirect_uri,
		response_type:response_type,
		state:state
		},function(data){
			
			//console.log("data:"+data.data);
			if(data.data == "5001" || data.data == "5002"){
				$("p").show();
			}
			else{
				//console.log(11111111111);
				window.location.href=data.data;
			}
	},"json"); 
	
}

</script>
<style type="text/css">
html, body {
	width: auto;
	height: auto
}

body {
	background: url(img/2.jpg);
	background-repeat: no-repeat;
	background-size: cover;
}

#form1 {
	background: rgba(0, 0, 0, 0.4);
	color: #C0C0C0;
	border-left: 1px solid #C0C0C0;
	border-right: 1px solid #C0C0C0;
}

h2 {
	color: #F5F5F5;
	margin-top: 10%;
	text-align: center;
	text-shadow: 4px 4px 4px #696969;
}

#title {
	width: 100%;
}

#content {
	margin-top: 70%;
	width: 86%;
	margin-left: 7%;
}

input::-webkit-input-placeholder {
	color: #808080;
}
p{
	color: 	#DC143C;
	display:none;
}
</style>
</head>
<body>
	<div id="title">
		<h2>斯玛特物联</h2>
	</div>

	<div id="content">
		<h6>请使用理想社区APP账号登录</h6>
		<form id="form1" class="mui-input-group" method="post"
			autocomplete="off"
			action="https://yfwl-test1.idealhome666.com/yefiot-manager/userlogin">
			<div class="mui-input-row">
				<label>账号</label> <input type="text" name="username"
					class="mui-input-clear" placeholder="请输入用户名">
			</div>
			<div class="mui-input-row">
				<label>密码</label> <input type="password" name="password"
					class="mui-input-password" placeholder="请输入密码">
			</div>

			<input type="hidden" name="client_id"
				value="<%=request.getParameter("client_id") %>" /> <input
				type="hidden" name="redirect_uri"
				value="<%=request.getParameter("redirect_uri") %>" /> <input
				type="hidden" name="response_type"
				value="<%=request.getParameter("response_type") %>" /> <input
				type="hidden" name="state"
				value="<%=request.getParameter("state") %>" />
				<div class="mui-button-row">
				<p>账号或者密码错误！</p>
				</div>
			
			<div class="mui-button-row">
				<button type="button" class="mui-btn mui-btn-primary" onclick="login()">登录</button>

			<!-- 	<button type="button" class="mui-btn mui-btn-danger">退出</button> -->
			</div>

		</form>
		
	</div>
</body>
</html>
