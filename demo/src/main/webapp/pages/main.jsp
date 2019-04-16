<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width" />
 <script type="text/javascript" src="../js/selelogin.js"></script> 
<script src="../layui/layui.js"></script>
<script src="../js/jquery-3.3.1.js"></script>
<script src="../js/jquerysession.js"></script>
<link rel="stylesheet" href="../layui/css/layui.css" media="all">
<link rel="stylesheet" href="../css/style.css?v=<%= new Date().getTime() %>" media="all">
<title>首页</title>
<script>
$(function(){
	selelogin();
	//var menu = window.sessionStorage.getItem("menu");
	//var menusession = $.session.get("menu");
	//console.log("menu:"+menu);
	//console.log("menusession"+menusession);
	setTimeout("selectForMenu()","500");
	
});
function selectForMenu(){
	let menusession = $.session.get("menu");
	//console.log("menu:"+menusession);
	let menujson = JSON.parse(menusession);
	//console.log(menujson);
	//console.log("menujson[3]:"+menujson["3"]);	
	if(menujson["1"] && menujson["1"] > 0 ){
		$("#userpage").show();
	}
	if(menujson["11"] && menujson["11"] > 0 ){
		$("#identitypage").show();
	}
	if(menujson["3"] && menujson["3"] > 0 ){
		$("#adprogrampage").show();
	}
	if(menujson["49"] && menujson["49"] > 0 ){
		$("#historypage").show();
	}
}
layui.use(['element', 'layer'], function () {
    var $ = layui.jquery
        , b = $('body');
    b.on('click', '[lay-href]', function () {
        var li = $(this);
        top.layui.addTab(li);
    });
});
</script>
<style>
.icon {
	padding: 10px 0;
}

.icon i {
	display: block;
	font-size: 3em;
	color: white;
	transition: .4s;
}

a[lay-href] {
	display: block;
	border-radius: 5px;
	overflow: hidden;
	background-color: #f2f2f2;
}

a[lay-href]:hover {
	box-shadow: 0 2px 7px 0 #0C0C0C;
}

a[lay-href]:hover .icon i {
	transform: rotate(360deg);
}

.text {
	padding: 5px 0;
}
#userpage{
	display:none
}
#identitypage{
	display:none
}
#adprogrampage{
	display:none
}
#historypage{
	display:none
}
</style>
</head>
<body>
	<div class="child-body">
		<div class="layui-row layui-col-space30" style="text-align: center;">
			<div class="layui-col-lg2 layui-col-md2 layui-col-sm4 layui-col-xs6" id="userpage">
				<a href="javascript:" lay-href="user.jsp">
					<div class="icon" style="background-color: #FF5722;">
						<i class="layui-icon layui-icon-user"></i>
					</div>
					<div class="text">
						<cite>用户</cite>
					</div>
				</a>
			</div>
			<div class="layui-col-lg2 layui-col-md2 layui-col-sm4 layui-col-xs6" id="identitypage">
				<a href="javascript:" lay-href="iccard.jsp">
					<div class="icon" style="background-color: #5FB878;">
						<i class="layui-icon layui-icon-vercode"></i>
					</div>
					<div class="text">
						<cite>门禁卡</cite>
					</div>
				</a>
			</div>
			<div class=" layui-col-lg2 layui-col-md2 layui-col-sm4 layui-col-xs6" id="adprogrampage">
				<a href="javascript:" lay-href="adprogram.jsp">
					<div class="icon" style="background-color: #F7B824;">
						<i class="layui-icon" data-icon="&#xe64a;">&#xe64a;</i>
					</div>
					<div class="text">
						<cite>广告单</cite>
					</div>
				</a>
			</div>
			
			<div class=" layui-col-lg2 layui-col-md2 layui-col-sm4 layui-col-xs6"
				id="historypage">
				<a href="javascript:" lay-href="history.jsp">
					<div class="icon" style="background-color: #54ade8;">
						<i class="layui-icon layui-icon-log"></i>
					</div>
					<div class="text">
						 <cite>操作记录</cite> 
					</div>
				</a>
			</div>
			
		</div>
	</div>
</body>
</html>