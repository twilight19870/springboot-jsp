<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Date"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width" />
<script type="text/javascript" src="../js/selelogin.js?v=<%=new Date().getTime() %>"></script>
<script src="../layui/layui.js"></script>
<script src="../js/jquery-3.3.1.js"></script>
<script src="../js/jquerysession.js"></script>
<script type="text/javascript" src="../js/check.js?v=<%=new Date().getTime() %>" ></script>
<link rel="stylesheet" href="../layui/css/layui.css"
	media="all">
<link rel="stylesheet"
	href="../css/style.css?v=<%= new Date().getTime() %>" media="all">
<title>后台管理系统</title>
<script type="text/javascript">
$(function(){
	selelogin();
	$(".namecontent").html($.session.get("name"));
	
});
layui.use(['element', 'layer','form'],function(){
	var  flexible,
	b = $('body'),
	t = $('.layui-tab-title'),
	layout = $('.layui-layout'),
	session = window.sessionStorage,
	waitTime = 60,
	addTab = layui.addTab = function (e) {
        var id = e.attr('lay-href');
        if (t.find('li[lay-id="' + id + '"]').length === 0){
        	let text = e.find('cite').text();
        	/* if(id == 'machine.jsp'){
        		text = '门禁设备'
        	} */
        	layui.element.tabAdd('tabBody', {
                id: id,
                title: text,
                content: '<iframe src="' + id + '" frameborder="0" class="tabs-iframe"></iframe>'
            });
        }
        layui.element.tabChange('tabBody', id);
    },
    time = function(){
        if (waitTime == 0) {
            $("#codeBut").html("点击获取验证码");
            $("#codeBut").attr('disabled',false);
            $("#codeBut").attr('class',"layui-btn layui-btn-primary");
            waitTime = 60;// 恢复计时
            layui.form.render();
        } else {
        	$("#codeBut").html(waitTime + "秒后重新发送");
        	$("#codeBut").attr('disabled',true);
        	$("#codeBut").attr('class',"layui-btn layui-btn-disabled");
            waitTime--;
            setTimeout(function() {
            	layui.form.render();
                time()// 关键处-定时循环调用
            }, 1000)
        }
    },
	getMenuList = function(){
    	doAjax("post","../api/userManager/v1/selectUserMenuList",
    			{"userId":session.getItem("id"),"token":session.getItem("token")},function (data) {
    				if(data.code!==0 || !data.data || !data){
    		            window.top.location = "./login.jsp";
    				}
    				if(data.code==0){
    					var datalist = data.data;	
    					var menu = {};
    					for(i=0;i<datalist.length;i++){
    						menu[datalist[i]['menuId']] = datalist[i]['permissionId'];
    					} 
    					//menu["9"] = "2";
    					//console.log("menustr:"+JSON.stringify(menu));
    					session.setItem("menu",JSON.stringify(menu));
    					//window.sessionStorage.setItem("menu", JSON.stringify(datalist));
    					//console.log(JSON.stringify(menu));
    					//console.log(menu[3]);
    					var list = [];
    					var ulHtml = '';
    					
    					var select = [
    						 [3, 'agency.jsp', '代理商'],
    		                [1, 'user.jsp', '用户管理'],
    		                [7, 'machine.jsp', '设备管理'],
    		              	[9, 'intelligent.jsp', '智能设备'],
    		             	[48, 'allot.jsp', '分配设备'],
    		                [11, 'iccard.jsp', '门禁卡管理'],
    		                [2, 'community.jsp', '小区管理'],
    		                [8, 'admin.jsp', '管理员管理'],
    		                [42, 'role.jsp', '角色管理'],
    		                [4, 'identity.jsp', '身份证卡'],
    		                [43, 'dept.jsp', '部门管理'],
    		                [49, 'history.jsp', '操作记录']
    		                ];
    					let jk = 0;
    					//console.log(menu);
    		             for(i=0;i<select.length;i++){
    		            	 //console.log("menu[select[i][0]]:"+menu[select[i][0]]);
    		            	 
    		            	 let flag = menu[select[i][0]];
    		            	 
    		            	 if(flag && flag>0){
    		            		 list[jk] = {"id":select[i][0],"menuUrl":select[i][1],"name":select[i][2],"permission":menu[select[i][0]]};
    		            		 ulHtml += '<li class="layui-nav-item">';
    		                     ulHtml += '<a href="javascript:;" lay-href="' + select[i][1] +'">';
    		                     /* if(select[i][2] == '设备管理'){
    		                    	ulHtml += '<cite>' + select[i][2] + '</cite></a>';
    		                    	ulHtml += '<dl class="layui-nav-child">'+
    		                    	      '<dd><a lay-href="machine.jsp"><cite>门禁设备</cite></a></dd>'+
    		                    	      '<dd><a lay-href=""><cite>收件设备</cite></a></dd>'+
    		                    	      '<dd><a lay-href=""><cite>梯控设备</cite></a></dd>'+
    		                    	    '</dl>';
    		                        ulHtml += '</li>'; 
    		                     }else{ */
    		                    	ulHtml += '<cite>' + select[i][2] + '</cite></a>';
    		                        ulHtml += '</li>';  
    		                     //}
    		                     jk++;
    		            	 }
    		             }
    		             console.log(session.getItem("id"));
    		             window.localStorage.setItem("menus", JSON.stringify(list));
    		             $('.layui-nav-tree').html(ulHtml);
    		             layui.element.render('nav-tree'); 
    				}else{
    					layer.msg(data.msg);
    				}
        },function(err){
        	
        });
		/* $.post("../api/userManager/v1/selectUserMenuList",
				{"userId":session.getItem("id"),"token":session.getItem("token")},function(data){
			//checkLogin(data);
			checkForDataCode(data);
			if(data.code!==0 || !data.data || !data){
	            window.top.location = "./login.jsp";
			}
			if(data.code==0){
				var datalist = data.data;	
				var menu = {};
				for(i=0;i<datalist.length;i++){
					menu[datalist[i]['menuId']] = datalist[i]['permissionId'];
				} 
				//console.log("menustr:"+JSON.stringify(menu));
				session.setItem("menu",JSON.stringify(menu));
				//window.sessionStorage.setItem("menu", JSON.stringify(datalist));
				//console.log(JSON.stringify(menu));
				//console.log(menu[3]);
				var list = [];
				var ulHtml = '';
	            
				var select = [
					 [3, 'agency.jsp', '代理商'],
	                [1, 'user.jsp', '用户管理'],
	                [7, 'machine.jsp', '设备管理'],
	             	[48, 'allot.jsp', '分配设备'],
	                [11, 'iccard.jsp', '门禁卡管理'],
	                [2, 'community.jsp', '小区管理'],
	                [8, 'admin.jsp', '管理员管理'],
	                [42, 'role.jsp', '角色管理'],
	                [4, 'identity.jsp', '身份证卡'],
	                [43, 'dept.jsp', '部门管理'],
	                [49, 'history.jsp', '操作记录']
	                ];
				let jk = 0;
	             for(i=0;i<select.length;i++){
	            	 //console.log("menu[select[i][0]]:"+menu[select[i][0]]);
	            	 let flag = menu[select[i][0]];
	            	 if(flag && flag>0){
	            		 list[jk] = {"id":select[i][0],"menuUrl":select[i][1],"name":select[i][2],"permission":menu[select[i][0]]};
	            		 ulHtml += '<li class="layui-nav-item">';
	                     ulHtml += '<a href="javascript:;" lay-href="' + select[i][1] +'">';
	                     /* if(select[i][2] == '设备管理'){
	                    	ulHtml += '<cite>' + select[i][2] + '</cite></a>';
	                    	ulHtml += '<dl class="layui-nav-child">'+
	                    	      '<dd><a lay-href="machine.jsp"><cite>门禁设备</cite></a></dd>'+
	                    	      '<dd><a lay-href=""><cite>收件设备</cite></a></dd>'+
	                    	      '<dd><a lay-href=""><cite>梯控设备</cite></a></dd>'+
	                    	    '</dl>';
	                        ulHtml += '</li>'; 
	                     }else{ */
	                    	/* ulHtml += '<cite>' + select[i][2] + '</cite></a>';
	                        ulHtml += '</li>';  
	                     //}
	                     jk++;
	            	 }
	             }
	             window.localStorage.setItem("menus", JSON.stringify(list));
	             $('.layui-nav-tree').html(ulHtml);
	             layui.element.render('nav-tree'); 
			}else{
				layer.msg(data.msg);
			}
		});  */
	},
	events = {
            "flexible": function (d) {
                 layout.toggleClass("hideNav");
                 //console.log("layout:"+JSON.stringify(layout));
                 //console.log("d:"+JSON.stringify(d));
                if (!flexible)
                    flexible = d.find('i');
                //console.log("flexible:"+JSON.stringify(flexible));
                flexible.toggleClass("layui-icon-shrink-right");
                flexible.toggleClass("layui-icon-spread-left"); 
            }
            , 'refresh': function (d) {
                $('.layui-tab-item.layui-show').find('.tabs-iframe')[0].contentWindow.location.reload(true);
            }
            , 'editPassword':function(d){
            	layer.open({
                    type: 1
                    , maxmin: true
                    , title: '修改密码'
                    , content: $("#editPasswordD")
                    , area: ['700px', '600px']
                });
            }
            , 'getCode':function(){
            	var i = layer.load(2, {time: 5000});
            	let url = 'http://yfwl-test.idealhome666.com/yefiot-apps/api/sendExample/v1/sendRegisterSMSCodeForPc';
            	 let postData = {};
            	 postData.mobile = session.getItem("phone");
            	 console.log(postData);
            	 $.post(url, postData, function (data) {
                 	console.log(data);
                 	layer.close(i);
                     if (data) {
                         layer.msg("验证码发送成功,请注意查收!");
                     } else {
                         layer.msg(data.msg);
                     }
                 }, 'json');
            	time();
            }
        };
	 b.on('click', '[touch-event]', function () {
         events[$(this).attr('touch-event')]($(this));
     });
     b.on('click', '[lay-href]', function () {
         //console.log("你点击的是："+$(this).attr('lay-href'));
         addTab($(this))
     });
     layui.form.verify({
         passNum: function (value, item) {
        	 let checkPass = /^(?![0-9]+$)(?![a-zA-Z]+$)(?!([^(0-9a-zA-Z)]|[\\(\\)])+$)([^(0-9a-zA-Z)]|[\\(\\)]|[a-zA-Z]|[0-9]){6,12}$/;
        	 let passValue = $("#newPass").val();
        	 console.log(passValue);
        	 console.log(value);
             if (value != '') {
                 if (!checkPass.test(value)) {
                 	return '密码字符无效!';
                 }
                 if(passValue != value){
                	 return '两次输入的密码不一致!';
                 }
             }
         }
     }); 
     layui.form.on('submit(editPassSubmit)', function (data) {
    	 console.log(data);
    	 var i = layer.load(2, {time: 8000});
    	 let url = '../api/loginManager/v1/updateUserPassword';
    	 let postData = {};
    	 data = data.field;
    	 postData.password=data.newPass;
    	 postData.repassword=data.truePass;
    	 postData.identifyingCode=data.exampleCode;
    	 postData.accountsName=session.getItem("accountsName");
    	 console.log(postData);
    	 $.post(url, postData, function (data) {
         	console.log(data);
             layer.close(i);
             if (data.code == 0) {
             	layer.open({
           		 content: '修改成功,请重新登录!'
           		  ,btn: ['确定']
           		  ,closeBtn: 0
           		  ,yes: function(index, layero){
           			  outlogin();
           		  }
           		}); 
             } else {
                 layer.msg(data.msg);
             }
         }, 'json');
    	 return false;
     });
	getMenuList();
	
});
/* function getMenuList(){
	$.post("../api/userManager/v1/selectUserMenuList",{"userId":$.session.get("id"),"token":$.session.get("token")},function(data){
		//checkLogin(data);
		checkForDataCode(data);
		if(data.code!==0 || !data.data || !data){
            window.top.location = "./login.jsp";
		}
		if(data.code==0){
			var datalist = data.data;	
			var menu = {};
			for(i=0;i<datalist.length;i++){
				menu[datalist[i]['menuId']] = datalist[i]['permissionId'];
			} 
			//console.log("menustr:"+JSON.stringify(menu));
			$.session.set("menu",JSON.stringify(menu));
			//window.sessionStorage.setItem("menu", JSON.stringify(datalist));
			//console.log(JSON.stringify(menu));
			//console.log(menu[3]);
			var list = [];
			var ulHtml = '';
            
			var select = [
				 [3, 'agency.jsp', '代理商'],
                [1, 'user.jsp', '用户管理'],
                [7, 'machine.jsp', '设备管理'],
             	[48, 'allot.jsp', '分配设备'],
                [11, 'iccard.jsp', '门禁卡管理'],
                [2, 'community.jsp', '小区管理'],
                [8, 'admin.jsp', '管理员管理'],
                [42, 'role.jsp', '角色管理'],
                [4, 'identity.jsp', '身份证卡'],
                [43, 'dept.jsp', '部门管理'],
                [49, 'history.jsp', '操作记录']
                ];
			let jk = 0;
             for(i=0;i<select.length;i++){
            	 //console.log("menu[select[i][0]]:"+menu[select[i][0]]);
            	 let flag = menu[select[i][0]];
            	 if(flag && flag>0){
            		 list[jk] = {"id":select[i][0],"menuUrl":select[i][1],"name":select[i][2],"permission":menu[select[i][0]]};
            		 ulHtml += '<li class="layui-nav-item">';
                     ulHtml += '<a href="javascript:;" lay-href="' + select[i][1] +'">';
                     /* if(select[i][2] == '设备管理'){
                    	ulHtml += '<cite>' + select[i][2] + '</cite></a>';
                    	ulHtml += '<dl class="layui-nav-child">'+
                    	      '<dd><a lay-href="machine.jsp"><cite>门禁设备</cite></a></dd>'+
                    	      '<dd><a lay-href=""><cite>收件设备</cite></a></dd>'+
                    	      '<dd><a lay-href=""><cite>梯控设备</cite></a></dd>'+
                    	    '</dl>';
                        ulHtml += '</li>'; 
                     }else{ */
/*                     	ulHtml += '<cite>' + select[i][2] + '</cite></a>';
                        ulHtml += '</li>';  
                     //}
                     jk++;
            	 }
             }
             window.localStorage.setItem("menus", JSON.stringify(list));
             $('.layui-nav-tree').html(ulHtml);
             layui.element.render('nav-tree'); 
		}else{
			layer.msg(data.msg);
		}
	});
}  */

</script>
<style type="text/css">
#getCodeDiv{
	margin-left: 0px;
	width:100%;
	float: right;
}
#codeBut{
	width:100%;
	float: right;
}
</style>
</head>
<body class="layui-layout-body">
				<div id="editPasswordD" class="site-block" style="display: none">
			<form class="layui-form">
				 <input type="hidden" id="roomId" name="roomId">
				<!-- <div class="layui-form-item">
					<label class="layui-form-label">当前密码:</label>
					<div class="layui-input-block">
						<input type="password" id="olderPass" name="olderPass"
							lay-verify="required" placeholder="请输入当前密码" class="layui-input">
					</div>
				</div> -->
				<div class="layui-form-item">
					<label class="layui-form-label">新密码:</label>
					<div class="layui-input-block">
						<input type="password" id="newPass" name="newPass"
							lay-verify="required" placeholder="请输入新密码(6-12个字符,且必须要有数字和英文,符号中的任意两种。)" 
							class="layui-input">
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">确认新密码:</label>
					<div class="layui-input-block">
						<input type="password" id="truePass" name="truePass"
							lay-verify="required|passNum" placeholder="请确认新密码" class="layui-input">
					</div>
				</div>
				<div class="layui-form-item">
					<div class="layui-row">
						<div class="layui-col-xs9">
							<label class="layui-form-label">验证码:</label>
							<div class="layui-input-block">
								<input type="text" id="exampleCode"  name="exampleCode"
									lay-verify="required" placeholder="请输入手机验证码" class="layui-input">
							</div>
						</div>
						<div class="layui-col-xs3">
							<div class="layui-input-block" id="getCodeDiv">
								<button type="button"  id="codeBut" class="layui-btn layui-btn-primary" 
								 touch-event="getCode" >点击获取验证码</button>
		    				</div>
						</div>
					</div>
						
				</div>
				<div class="layui-input-block">
					<button type="button" class="layui-btn" lay-submit lay-filter="editPassSubmit">保存
					</button>
					<button type="button" data-type="cancel" class="layui-btn">取消</button>
				</div>
			</form>
		</div>
	<div class="layui-layout layui-layout-admin">
		<div class="layui-header ">
			<div class="layui-logo" lay-href="main.jsp" style="cursor: pointer">
				<span>后台管理系统</span>
			</div>
			<ul class="layui-nav layui-layout-left">
				<li class="layui-nav-item" lay-unselect><a href="javascript:"
					touch-event="flexible" title="侧边伸缩"> <i
						class="layui-icon layui-icon-shrink-right"></i>
				</a></li>
				<!--<li class="layui-nav-item layui-hide-xs" lay-unselect>-->
				<!--<a href="http://www.layui.com/admin/" target="_blank" title="前台">-->
				<!--<i class="layui-icon layui-icon-website"></i>-->
				<!--</a>-->
				<!--</li>-->
				<li class="layui-nav-item" lay-unselect><a href="javascript:"
					touch-event="refresh" title="刷新"> <i
						class="layui-icon layui-icon-refresh-3"></i>
				</a></li>
				<li class="layui-inline">
					<div id="tp-weather-widget"></div> <script>(function (T, h, i, n, k, P, a, g, e) {
                        g = function () {
                            P = h.createElement(i);
                            a = h.getElementsByTagName(i)[0];
                            P.src = k;
                            P.charset = "utf-8";
                            P.async = 1;
                            a.parentNode.insertBefore(P, a)
                        };
                        T["ThinkPageWeatherWidgetObject"] = n;
                        T[n] || (T[n] = function () {
                            (T[n].q = T[n].q || []).push(arguments)
                        });
                        T[n].l = +new Date();
                        if (T.attachEvent) {
                            T.attachEvent("onload", g)
                        } else {
                            T.addEventListener("load", g, false)
                        }
                    }(window, document, "script", "tpwidget", "//widget.seniverse.com/widget/chameleon.js"))</script>
					<script>
                    tpwidget("init", {
                        "flavor": "slim",
                        "location": "WX4FBXXFKE4F",
                        "geolocation": "enabled",
                        "language": "zh-chs",
                        "unit": "c",
                        "theme": "chameleon",
                        "container": "tp-weather-widget",
                        "bubble": "disabled",
                        "alarmType": "badge",
                        "color": "#FFFFFF",
                        "uid": "U9EC08A15F",
                        "hash": "039da28f5581f4bcb5c799fb4cdfb673"
                    });
                    tpwidget("show");</script>
				</li>
			</ul>
			<ul class="layui-nav layui-layout-right">
				<!--<li class="layui-nav-item" lay-unselect>-->
				<!--<a lay-href="app/message/index.html" layadmin-event="message" lay-text="消息中心">-->
				<!--<i class="layui-icon layui-icon-notice"></i>-->
				<!--&lt;!&ndash; 如果有新消息，则显示小圆点 &ndash;&gt;-->
				<!--<span class="layui-badge-dot"></span>-->
				<!--</a>-->
				<!--</li>-->
				<!--<li class="layui-nav-item layui-hide-xs" lay-unselect>-->
				<!--<a href="javascript:;" layadmin-event="theme">-->
				<!--<i class="layui-icon layui-icon-theme"></i>-->
				<!--</a>-->
				<!--</li>-->
				<!--<li class="layui-nav-item layui-hide-xs" lay-unselect>-->
				<!--<a href="javascript:;" layadmin-event="note">-->
				<!--<i class="layui-icon layui-icon-note"></i>-->
				<!--</a>-->
				<!--</li>-->
				<li class="layui-nav-item" lay-unselect><a href="javascript:"
					class="namecontent"> </a>
					<dl class="layui-nav-child" style="right: 0; left: auto;">
						<!--<dd><a lay-href="set/user/info.html">基本资料</a></dd>-->
						<dd><a href="javascript:"  touch-event="editPassword" >修改密码</a></dd>
						<dd style="text-align: center;">
							<a href="javascript:void(0)" onclick="checkOutLogin()">退出</a>
						</dd>
						
					</dl></li>

				<!--<li class="layui-nav-item" lay-unselect>-->
				<!--<a href="../login/logout">退出</a>-->
				<!--</li>-->
				<!--<li class="layui-nav-item layui-hide-xs" lay-unselect>-->
				<!--<a href="javascript:;" layadmin-event="about"><i-->
				<!--class="layui-icon layui-icon-more-vertical"></i></a>-->
				<!--</li>-->
				<!--<li class="layui-nav-item layui-show-xs-inline-block layui-hide-sm" lay-unselect>-->
				<!--<a href="javascript:;" layadmin-event="more"><i class="layui-icon layui-icon-more-vertical"></i></a>-->
				<!--</li>-->
			</ul>
		</div>

		<!-- 侧边菜单 -->
		<div class="layui-side layui-bg-black">
			<div class="layui-side-scroll">
				<ul class="layui-nav layui-nav-tree" lay-shrink="all">
					<!--<li data-name="home" class="layui-nav-item">-->
					<!--<a href="javascript:" lay-tips="主页" lay-direction="2">-->
					<!--<i class="layui-icon layui-icon-home"></i>-->
					<!--<cite>主页</cite>-->
					<!--</a>-->
					<!--<dl class="layui-nav-child">-->
					<!--<dd data-name="console" class="layui-this">-->
					<!--<a lay-href="home/console.html">控制台</a>-->
					<!--</dd>-->
					<!--</dl>-->
					<!--</li>-->
					<!--<li data-name="component" class="layui-nav-item">-->
					<!--<a href="javascript:" lay-tips="组件" lay-direction="2">-->
					<!--<i class="layui-icon layui-icon-component"></i>-->
					<!--<cite>组件</cite>-->
					<!--</a>-->
					<!--<dl class="layui-nav-child">-->
					<!--<dd data-name="grid">-->
					<!--<a href="javascript:">栅格</a>-->
					<!--<dl class="layui-nav-child">-->
					<!--<dd data-name="list"><a lay-href="component/grid/list.html">等比例列表排列</a></dd>-->
					<!--<dd data-name="mobile"><a lay-href="component/grid/mobile.html">按移动端排列</a></dd>-->
					<!--<dd data-name="mobile-pc"><a lay-href="component/grid/mobile-pc.html">移动桌面端组合</a>-->
					<!--</dd>-->
					<!--<dd data-name="all"><a lay-href="component/grid/all.html">全端复杂组合</a></dd>-->
					<!--<dd data-name="stack"><a lay-href="component/grid/stack.html">低于桌面堆叠排列</a></dd>-->
					<!--<dd data-name="speed-dial"><a lay-href="component/grid/speed-dial.html">九宫格</a></dd>-->
					<!--</dl>-->
					<!--</dd>-->
					<!--<dd data-name="button">-->
					<!--<a lay-href="component/button/index.html">按钮</a>-->
					<!--</dd>-->
					<!--</dl>-->
					<!--</li>-->
					<!--<li data-name="template" class="layui-nav-item">-->
					<!--<a href="javascript:" lay-tips="模板">-->
					<!--<i class="layui-icon layui-icon-template"></i>-->
					<!--<cite>模板</cite>-->
					<!--</a>-->
					<!--<dl class="layui-nav-child">-->
					<!--<dd><a href="user/reg.html" target="_blank">注册</a></dd>-->
					<!--<dd><a href="user/login.html" target="_blank">登入</a></dd>-->
					<!--<dd><a href="user/forget.html" target="_blank">忘记密码</a></dd>-->

					<!--<dd><a lay-href="template/tips/404.html">404页面不存在</a></dd>-->
					<!--<dd><a lay-href="template/tips/error.html">错误提示</a></dd>-->

					<!--<dd><a lay-href="http://www.baidu.com/">百度一下</a></dd>-->
					<!--<dd><a lay-href="http://www.layui.com/">layui官网</a></dd>-->
					<!--<dd><a lay-href="http://www.layui.com/admin/">layuiAdmin官网</a></dd>-->
					<!--</dl>-->
					<!--</li>-->
					<!--<li data-name="app" class="layui-nav-item">-->
					<!--<a href="javascript:;" lay-tips="应用" lay-direction="2">-->
					<!--<i class="layui-icon layui-icon-app"></i>-->
					<!--<cite>应用</cite>-->
					<!--</a>-->
					<!--<dl class="layui-nav-child">-->
					<!--<dd>-->
					<!--<a lay-href="app/message/index.html">消息中心</a>-->
					<!--</dd>-->
					<!--</dl>-->
					<!--</li>-->
					<!--<li data-name="senior" class="layui-nav-item">-->
					<!--<a href="javascript:;" lay-tips="高级" lay-direction="2">-->
					<!--<i class="layui-icon layui-icon-senior"></i>-->
					<!--<cite>高级</cite>-->
					<!--</a>-->
					<!--<dl class="layui-nav-child">-->
					<!--<dd>-->
					<!--<a layadmin-event="im">LayIM 通讯系统</a>-->
					<!--</dd>-->
					<!--</dl>-->
					<!--</li>-->
					<!--<li data-name="set" class="layui-nav-item">-->
					<!--<a href="javascript:;" lay-tips="设置" lay-direction="2">-->
					<!--<i class="layui-icon layui-icon-set"></i>-->
					<!--<cite>设置</cite>-->
					<!--</a>-->
					<!--<dl class="layui-nav-child">-->
					<!--<dd>-->
					<!--<a href="javascript:;">系统设置</a>-->
					<!--<dl class="layui-nav-child">-->
					<!--<dd><a lay-href="set/system/website.html">网站设置</a></dd>-->
					<!--<dd><a lay-href="set/system/email.html">邮件服务</a></dd>-->
					<!--</dl>-->
					<!--</dd>-->
					<!--<dd>-->
					<!--<a href="javascript:;">我的设置</a>-->
					<!--<dl class="layui-nav-child">-->
					<!--<dd><a lay-href="set/user/info.html">基本资料</a></dd>-->
					<!--<dd><a lay-href="set/user/password.html">修改密码</a></dd>-->
					<!--</dl>-->
					<!--</dd>-->
					<!--</dl>-->
					<!--</li>-->
					<!--<li data-name="get" class="layui-nav-item">-->
					<!--<a href="javascript:;" lay-href="system/get.html" lay-tips="授权" lay-direction="2">-->
					<!--<i class="layui-icon layui-icon-auz"></i>-->
					<!--<cite>授权</cite>-->
					<!--</a>-->
					<!--</li>-->
				</ul>
			</div>
		</div>

		<div class="layui-body">
			<div class="layui-tab" lay-filter="tabBody" lay-allowClose="true">
				<ul class="layui-tab-title">
					<li lay-id="main.jsp" class="layui-this"><i
						class="layui-icon layui-icon-home"></i></li>
				</ul>
				<div class="layui-tab-content">
					<div class="layui-tab-item layui-show">
						<iframe src="main.jsp" frameborder="0" class="tabs-iframe"></iframe>
					</div>
					
				</div>
			</div>
		</div>
		<!-- 页面标签 -->
		<!--<div class="pagetabs">-->
		<!--<div class="layui-icon tabs-control layui-icon-prev" layadmin-event="leftPage"></div>-->
		<!--<div class="layui-icon tabs-control layui-icon-next" layadmin-event="rightPage"></div>-->
		<!--<div class="layui-icon tabs-control layui-icon-down">-->
		<!--<ul class="layui-nav tabs-select">-->
		<!--<li class="layui-nav-item" lay-unselect>-->
		<!--<a href="javascript:"></a>-->
		<!--<dl class="layui-nav-child layui-anim-fadein">-->
		<!--<dd layadmin-event="closeThisTabs"><a href="javascript:">关闭当前标签页</a></dd>-->
		<!--<dd layadmin-event="closeOtherTabs"><a href="javascript:">关闭其它标签页</a></dd>-->
		<!--<dd layadmin-event="closeAllTabs"><a href="javascript:">关闭全部标签页</a></dd>-->
		<!--</dl>-->
		<!--</li>-->
		<!--</ul>-->
		<!--</div>-->
		<!--</div>-->

		<!--<div class="layui-footer">-->
		<!--&lt;!&ndash; 底部固定区域 &ndash;&gt;-->
		<!--© layui.com - 底部固定区域-->
		<!--</div>-->
	</div>
</body>
</html>