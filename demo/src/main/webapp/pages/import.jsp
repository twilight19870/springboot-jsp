<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Date"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width" />
<script type="text/javascript" src="../js/selelogin.js"></script>
<script src="../layui/layui.js"></script>
<script src="../js/jquery-3.3.1.js"></script>
<script src="../js/jquerysession.js"></script>
<script type="text/javascript" src="../js/check.js?v=<%=new Date().getTime() %>" ></script>
<link rel="stylesheet" href="../layui/css/layui.css"
	media="all">
<link rel="stylesheet"
	href="../css/style.css?v=<%= new Date().getTime() %>" media="all">
<title>斯玛特物联</title>
<script>
$(function(){
	selelogin();
	$(".namecontent").html($.session.get("name"));
	
});
layui.config({
    base: "../js/"
}).use(['element', 'layer','upload','table','form'],function(){
	var $ = layui.jquery
	,session = window.sessionStorage
	,table = layui.table
	,form = layui.form
	,upload = layui.upload
	, buttons = {
            add: function () {
                typeForm = 0;
                dialogIndex = layer.open({
                    type: 1
                    , maxmin: true
                    , title: '添加设备'
                    , content: $("#macDialog")
                    , area: ['700px', '600px']
                });
            }};
	upload.render({
	    elem: '#test3'
	    ,url: '../api/doorManager/v1/batchImportDevice'
	    ,accept: 'file' //普通文件
	    ,exts: 'xlsx|xls' //excel文件
	   	, before: function (obj) { 
	   		this.data={token:session.getItem("token")};
	   	}
	    ,done: function(res){
	      console.log(res);
	      let data = res.data;
	      /* for(let i=0;i<data.length;i++){
	    	  $("#tbody1").append('<tr><td>'+data[i].doorPhoneName+'</td><td>'+data[i].errorMessage+'</td></tr>'); 
	      } */
	      if(data.length>0){
	    	  layer.open({
		            type: 1,
		            content: $("#table1-div"), 
		            title : '导入失败的数据',
		            area: ['800px', '620px'],
		      		success: function(layero, index){
		      			table.render({
		      	    	  elem: '#table1'
		      	    	  ,cols: [[
		      	              {field: 'doorPhoneName',width:100, title: '设备名称',align: 'center'}
		      	            ,{field: 'doorPhoneSerialId',width:200, title: '设备序号',align: 'center'}
		      	          ,{field: 'doorPhoneMac',width:200, title: '设备MAC地址',align: 'center'}
		      	              ,{field: 'errorMessage', title: '失败信息',align: 'center'}
		      	            ]]
		      				,page:true
		      				,limit:10
		      	      	   ,data:data
		      	      });
		      		
		        }
		    });
	      }else{
	    	  layer.open({
	    		  content:"设备导入成功",
	    		  title : '导入设备信息'
	    	  });
	      }
	      
	     
	    }
	  });
	form.on('submit(formSubmit)', function (data) {
        // if (!typeForm && data.field.communityId.length < 1 && data.field.buildingId.length < 1 && data.field.unitId.length < 1) {
        //     buttons['choose']();
        //     return false;
        // }
        var i = layer.load(2, {time: 5000});
        console.log(data);
        //var i = layer.load(2, {time: 10000});
        //console.log(data.field);
        var url ="../api/doorManager/v1/singleImportDevice";
        data.field.token = session.getItem("token");
        $.post(url, data.field, function (data) {
            layer.close(i);
            if (!data || checkLogin(data)) return null;
            if (data.code == 0) {
                layer.msg("保存成功");
            } else {
                layer.msg(data.msg);
            }
        }, 'json');
      return false;
    });
	$('.layui-btn[data-type]').on('click', function () {
        var type = $(this).data('type');
        buttons[type] ? buttons[type].call(this) : '';
    });

});
function outlogin(){
	$.session.remove("token");
	window.location.href="login.jsp";
}
function downloadExcel(){
	console.log();
	var form = $("<form>");
	form.attr("style","display:none");
	form.attr("target","");
	form.attr("method","post");
	form.attr("action","../api/doorManager/v1/download");
	var input1 = $("<input>");
	input1.attr("type","hidden");
	input1.attr("name","token");
	input1.attr("value",$.session.get("token"));
	$("body").append(form);
	form.append(input1);
	form.submit();
	form.remove();
}
</script>
<style>
body{
	width:100%;
	height:100%;
}
.layui-layout-body{
	width:100%;
	height:100%;
}
.layui-body{
	background-color: #FFFFF0;
	width:100%;
	height:100%;
	text-align: center;
	margin-left: -200px;
}

.layui-layout-admin{
	width:100%;
	height:100%;
}
.layui-add1{
	margin-top: 19%;
	margin-bottom: 10px;
}
.layui-add2{
	width: 164px;
	margin: 0 auto;
}
.layui-add3{
	float: right;
}
</style>
</head>

<body class="layui-layout-body">
<div id="table1-div" style="display: none">
<table class="layui-hide" id="table1" lay-filter="table1Filter"></table>
</div>
	<div id="macDialog" class="site-block" style="display: none">
		<form class="layui-form">
			<div class="layui-form-item">
					<label class="layui-form-label">设备类型:</label>
					<div class="layui-input-block">
						<input type="radio" id="jin" name="doorPhoneType" value="0"
							title="门禁机" checked> <input type="radio" id="wu"
							name="doorPhoneType" value="1" title="物业机">
						<input type="radio" id="shou"
							name="doorPhoneType" value="2" title="收件箱">
					</div>
			</div>
			<div class="layui-form-item">
					<label class="layui-form-label">是否触摸屏:</label>
					<div class="layui-input-block">
						<input type="radio"  name="touchScreen" value="0"
							title="是" checked>
						 <input type="radio" 
							name="touchScreen" value="1" title="否">
					</div>
			</div>
			<div class="layui-form-item">
					<label class="layui-form-label">屏幕方向:</label>
					<div class="layui-input-block">
						<input type="radio"  name="screenType" value="0"
							title="横屏" checked>
						 <input type="radio" 
							name="screenType" value="1" title="竖屏">
					</div>
			</div>
			<div class="layui-form-item">
					<label class="layui-form-label">屏幕尺寸:</label>
					<div class="layui-input-block">
						<input type="text" id="screenSize" name="screenSize"
							placeholder="请输入屏幕尺寸" lay-verify="required"  class="layui-input">
					</div>
			</div>
			<div class="layui-form-item">
					<label class="layui-form-label">设备名称:</label>
					<div class="layui-input-block">
						<input type="text" id="doorPhoneName" name="doorPhoneName"
							lay-verify="required" placeholder="请输入设备名称" class="layui-input">
					</div>
			</div>
			<div class="layui-form-item">
					<label class="layui-form-label">设备序号:</label>
					<div class="layui-input-block">
						<input type="text" id="doorPhoneSerialId" name="doorPhoneSerialId"
							lay-verify="required" placeholder="请输入设备序号" class="layui-input">
					</div>
			</div>
			<div class="layui-form-item">
					<label class="layui-form-label">MAC地址:</label>
					<div class="layui-input-block">
						<input type="text" id="doorPhoneMac" name="doorPhoneMac"
							placeholder="请输入设备MAC地址" class="layui-input">
					</div>
			</div>
			<div class="layui-form-item">
					<label class="layui-form-label">设备密码:</label>
					<div class="layui-input-block">
						<input type="text" id="password" name="password"
							placeholder="请输入设备密码" class="layui-input">
					</div>
			</div>
			<div class="layui-input-block">
					<button type="button"  class="layui-btn" lay-submit lay-filter="formSubmit">保存
					</button>
					<button type="button" data-type="cancel" class="layui-btn">取消</button>
			</div>
		</form>
	</div>
	<div class="layui-layout layui-layout-admin">
		<div class="layui-header ">
			<div class="layui-logo" style="cursor: pointer">
				<span>后台管理系统</span>
			</div>
			<ul class="layui-nav layui-layout-right">

				<li class="layui-nav-item" lay-unselect><a href="javascript:"
					class="namecontent"> </a>
					<dl class="layui-nav-child" style="right: 0; left: auto;">
						<!--<dd><a lay-href="set/user/info.html">基本资料</a></dd>-->
						<!--<dd><a lay-href="set/user/password.html">修改密码</a></dd>-->
						
						<dd style="text-align: center;">
							<a href="javascript:void(0)" onclick="outlogin()">退出</a>
						</dd>
					</dl></li>

			</ul>
		</div>
		<div class="layui-body">
			
			<div class="layui-add3">
		    	<button class="layui-btn layui-btn-primary" onclick="downloadExcel()"><i class="layui-icon">&#xe601;</i>下载Excel模板</button>
		    </div>
			<div class="layui-add1">
				<button data-type="add" class="layui-btn">添加设备</button>
			</div>
			
			<div class="layui-add2">
		      <button type="button"  class="layui-btn" id="test3"><i class="layui-icon"></i>批量导入设备</button>
		    </div>

		    
		</div>
	</div>
</body>
</html>