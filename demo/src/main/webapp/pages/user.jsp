<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Date"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width" />
<script type="text/javascript" src="../js/selelogin.js?v=<%=new Date().getTime() %>"></script>
<script type="text/javascript" src="../js/check.js?v=<%=new Date().getTime() %>" ></script>
<script src="../layui/layui.js"></script>
<script src="../js/jquery-3.3.1.js"></script>
<script src="../js/jquerysession.js"></script>
<link rel="stylesheet" href="../layui/css/layui.css"
	media="all">
<link rel="stylesheet"
	href="../css/style.css?v=<%= new Date().getTime() %>" media="all">
<title>用户</title>
<script>
$(function(){
	//selelogin();
	let menu = $.session.get('menu');
	let menujson = JSON.parse(menu);
	if(menujson["3"] != 2){
		$("#treeAgent").hide();
	}
});
layui.config({
    base: "../js/"
}).use(['form', 'table', 'laydate', 'ztree','upload'], function () {
	
	var session = window.sessionStorage ,
			table = layui.table,
			courierUploadUrl,
    		date = new Date(),$ = layui.$,
    		selectType=$("#selectType"),
    		frontindex=0,
    		backindex=0;
    
    layui.laydate.render({
        elem: '#validDate'
        , type: 'date'
        , value: date
        , isInitValue: true
    });
    layui.laydate.render({
        elem: '#courierExpireDate'
        , type: 'date'
        , value: date
        , isInitValue: true
    });
    layui.laydate.render({
        elem: '#courierValidDate'
        , type: 'date'
        , value: date
        , isInitValue: true
    });
    
    layui.laydate.render({
        elem: '#faceValidDate'
        , type: 'date'
        , value: date
        , isInitValue: true
    });
    date.setFullYear(date.getFullYear() + 1);
    layui.laydate.render({
        elem: '#expireDate'
        , type: 'date'
        , value: date
        , isInitValue: true
    });
    layui.laydate.render({
        elem: '#faceExpireDate'
        , type: 'date'
        , value: date
        , isInitValue: true
    });
    //方法级渲染
    var appUserCols =[[
        {
            title: '编号', type: 'numbers'
        }
        , {title: '姓名', field: 'userName', width: 100, sort: true, style: "text-align:center"}

        , {title: '手机号码', field: 'phoneNo', width: 220, sort: true, style: "text-align:center"}
        , {title: '身份证号码', field: 'idCard', sort: true, style: "text-align:center", width: 180}
        , {
            title: '性别', field: 'userSex', width: 99, sort: true, style: "text-align:center",
            templet: function (d) {
                return d.userSex == '0' ? '男' : '女';
            }
        }
        , {
            title: '状态', field: 'status', width: 90, sort: true, style: "text-align:center"
            , templet: function (d) {
                if (d.status == '0') {
                    return "已激活"
                } else if (d.status == '3') {
                    return "已删除"
                }
            }
        }
        , {
            title: '身份', field: 'userType', sort: true, width: 80,
            templet: function (d) {
                if (d.userType == '0') {
                    return "业主"
                } else if (d.userType == '1') {
                    return "家属"
                } else if (d.userType == '2') {
                    return "租客"
                } else if (d.userType == '3') {
                    return "物业"
                }
            }
        }
        , {
            title: '是否开启人脸', field: 'faceId', sort: true, width: 130, style: "text-align:center",
            templet: function (d) {
                if (d.faceId) {
                    return "已开启"
                } else {
                    return "未开启"
                }
            }
        }

        //, {title: '心跳时间', field: 'appLastHeartbeat', sort: true, style: "text-align:center", width: 200}
        , {title: '生效时间', field: 'validDate', sort: true, style: "text-align:center", width: 200}
        , {title: '管理', align: 'center', toolbar: '#barUser', fixed: 'right', width: 244}
    	]];
    //方法级渲染
    var courierCols =[[
        {
            title: '编号', type: 'numbers'
        }
        , {title: '姓名', field: 'courierUserName', width: 100, sort: true, style: "text-align:center"}
        , {title: '联系电话', field: 'courierPhoneNo', sort: true, style: "text-align:center", width: 200}
        , {
            title: '性别', field: 'courierSex', width: 99, sort: true, style: "text-align:center",
            templet: function (d) {
                return d.courierSex == '0' ? '男' : '女';
            }
        }
        , {
            title: '公司名称', field: 'companyName',  width: 200,sort: true,style: "text-align:center"
        }
        , {
            title: '公司联系电话', field: 'companyPhoneNo', width: 200,sort: true,style: "text-align:center"
        }
        //, {title: '心跳时间', field: 'appLastHeartbeat', sort: true, style: "text-align:center", width: 200}
        , {title: '生效时间', field: 'validDate', sort: true, style: "text-align:center", width: 200}
        , {title: '结束时间', field: 'expireDate', sort: true, style: "text-align:center", width: 200}
        , {title: '管理', align: 'center', toolbar: '#barUser', fixed: 'right', width: 244}
    	]];
        var userTable1= table.render({
            elem: '#LAY_table_user'
            , url: '../api/userManager/v1/selectAppUserList'
            ,  cols:  appUserCols
            , id: 'userTable'
            , page: true
            , height: 'full-120'
            , method: "post"
    		,contentType:'application/x-www-form-urlencoded'
            , where: {
                token : function(){
                	return session.getItem("token");
                }
       			,ageId : session.getItem("agencyId")
       			,userName : function(){
       				//console.log($('#queryType').val());
       				if($('#queryType').val() == "userName"){
       					return $('#queryKey').val();
       				}else{
       					return "";
       				}
       			},phoneNo : function(){
       				if($('#queryType').val() == "phoneNo"){
       					return $('#queryKey').val();
       				}else{
       					return "";
       				}
       			}
            }
            , request: {
                pageName: 'pageNum'
                , limitName: 'pageSize'
            }
            , parseData: function(res){
            	if(res.code ==1005){
            		let checkCode = checkToken(res);
            		if(checkCode == "200"){
            			return {
                    		"code":res.code,
                    		"msg":res.msg,
                    		"count":res.data.total,
                    		"data":res.data.appUserList
                    	}
            		}else if(checkCode == "1005"){
            			table.reload('userTable', {
                            page: {
                                curr: 1 //重新从第 1 页开始
                            }
                        });
	   	        	 }
            	}else if(res.code ==1004 ||res.code ==1003||res.code ==1002){
            		relogin(res);
            	}else{
                	return {
                		"code":res.code,
                		"msg":res.msg,
                		"count":res.data.total,
                		"data":res.data.appUserList
                	}
            	}
            }
            , done: function (res, curr, count) {
            	checkForDataCode(res);
            } 
        });
        var courierTable1= table.render({
            elem: '#LAY_table_courier'
            , url: '../api/userManager/v1/selectCourierList'
            ,  cols:  courierCols
            , id: 'courierTable'
            , page: true
            , height: 'full-120'
            , method: "post"
    		,contentType:'application/x-www-form-urlencoded'
            , where: {
                token : function(){
                	return session.getItem("token");
                }
       			,ageId : session.getItem("agencyId")
       			,userName : function(){
       				//console.log($('#queryType').val());
       				if($('#queryType').val() == "userName"){
       					return $('#queryKey').val();
       				}else{
       					return "";
       				}
       			},phoneNo : function(){
       				if($('#queryType').val() == "phoneNo"){
       					return $('#queryKey').val();
       				}else{
       					return "";
       				}
       			}
            }
            , request: {
                pageName: 'pageNum'
                , limitName: 'pageSize'
            }
            , parseData: function(res){
            	if(res.code ==1005){
	           		let checkCode = checkToken(res);
	           		//console.log(checkCode);
	           		if(checkCode == "200"){
	           			return {
	                   		"code":res.code,
	                   		"msg":res.msg,
	                   		"count":res.data.total,
	                   		"data":res.data.courierList
	                    	}
	            		}else if(checkCode == "1005"){
	            			table.reload('courierTable', {
	                            page: {
	                                curr: 1 //重新从第 1 页开始
	                            }
	                        });
		   	        	 }
	            	}else if(res.code ==1004 ||res.code ==1003||res.code ==1002){
                		relogin(res);
                	}else{
	                	return {
	                		"code":res.code,
	                		"msg":res.msg,
	                		"count":res.data.total,
	                		"data":res.data.courierList
	                	}
            	}
            }
            , done: function (res, curr, count) {
            	checkForDataCode(res);
            } 
        }); 

    table.on('tool(userTable)', function (obj) {
        if (buttons[obj.event]) buttons[obj.event](obj);
    });
    table.on('tool(courierTable)', function (obj) {
        if (buttons[obj.event]) buttons[obj.event](obj);
    });
    var  time
        , treeCommunityDialog = $('#treeCommunityDialog')
        , treeMachineDialog = $('#treeMachineDialog')
        , bindRoomDialog = $('#bindRoomDialog')
        , bindCourierDialog = $('#bindCourierDialog')
        , courierDialog = $('#courierDialog')
        , userDialog = $('#userDialog')
        , roomDialog = $('#roomDialog')
        , place = $('#place')
        , doorAccess = $('#doorAccess')
        , zhu = $('#zhu')
        , jia = $('#jia')
        , ke = $('#ke')
        , wu = $('#wu')
        , userName = $('#userName')
        , male = $('#male')
        , female = $('#female')
        , phoneNo = $('#phoneNo')
        , idCard = $('#idCard')
        , validDate = $('#validDate')
        , expireDate = $('#expireDate')
        , setFace = $('#setFace')
        , setFaceP = $('#setFaceP')
        , userId = $('#userId')
        , queryType = $('#queryType')
        , queryKey = $('#queryKey')
        , commName = $('#commName')
        , bldName = $('#bldName')
        , unitName = $('#unitName')
        , roomName = $('#roomName')
        , roomId = $('#roomId')
        , proprietName = $('#proprietName')
        , proprietId = $('#proprietId')
        , machine = $('#machine')
        , faceDiv = $('#faceDiv')
        , facePic = $('#facePic')
        , faceValidDate = $('#faceValidDate')
        , faceExpireDate = $('#faceExpireDate')
        , typeForm = 0
        , filereindex = true
        , dialogIndex
        , timeout
        , queryLoop = function () {
            // clearTimeout(timeout);
            if (time < 0) {
                setFace.attr('disabled', false);
                setFaceP.text("录入失败！请重试").css('color', '#CF301A');
            } else {
                timeout = setTimeout(function () {
                    time--;
                    if (time % 5 === 0) {
                    	//console.log("faceId:"+userId.val());
                    	
                    	//console.log("token:"+session.getItem("token"));
                    	doAjax("post","../api/userManager/v1/seleteFaceRecognitionOrder",
                    			{faceId: userId.val(),token:session.getItem("token")},function (data) {
                                if (data && data.code == 0) {
                                    var face = data.data.face;
                                    if (!face || !face.pictureUrl) {
                                        setFaceP.text("录入失败！正在重试").css('color', '#fec006');
                                        // setFaceP.text("录入失败！请重试").css('color', '#CF301A');
                                        return;
                                    }
                                    setFace.attr('disabled', false);
                                    setFaceP.text("录入成功").css('color', '#00f000');
                                    clearTimeout(timeout);
                                    faceDiv.show('normal');
                                    if (face.pictureUrl){
                                    	facePic.attr('src', face.pictureUrl);
                                    	facePic.show();
                                    }              
                                } else {
                                    setFaceP.text("录入失败！正在重试").css('color', '#fec006');
                                }
				        },function(err){
				        	
				        });
/*                         $.post("../api/userManager/v1/seleteFaceRecognitionOrder", {faceId: userId.val(),
                        	token:session.getItem("token")}, function (data) {
                        	
                            if (data && data.code == 0) {
                                var face = data.data.face;
                                if (!face || !face.pictureUrl) {
                                    setFaceP.text("录入失败！正在重试").css('color', '#fec006');
                                    // setFaceP.text("录入失败！请重试").css('color', '#CF301A');
                                    return;
                                }
                                setFace.attr('disabled', false);
                                setFaceP.text("录入成功").css('color', '#00f000');
                                clearTimeout(timeout);
                                faceDiv.show('normal');
                                if (face.pictureUrl){
                                	facePic.attr('src', face.pictureUrl);
                                	facePic.show();
                                }              
                            } else {
                                setFaceP.text("录入失败！正在重试").css('color', '#fec006');
                            }
                        }); */
                    }
                    queryLoop();
                }, 1000);
                setFaceP.text("正在录入..." + time + "秒").css('color', '#fec006');
            }
        }
        , curUser, userType = 0
        , buttons = {
            add: function () {
                typeForm = 0;
                dialogIndex = layer.open({
                    type: 1
                    , maxmin: true
                    , title: '添加用户'
                    , content: userDialog
                    , area: ['800px', '800px']
                });
                layer.full(dialogIndex);
                place.show();
                doorAccess.hide();
            },
            addCourier:function(){
            	filereindex = true;
            	$("#inboxAuth").prop('checked', true);
            	$("#reqType").prop('value', 'add');
            	$("#courierId").prop('value', '');
            	$("#userIdForCourier").prop('value', '');
            	$("#frontImgUrl").prop('value', '');
            	$("#backImgUrl").prop('value', '');
            	$('#demo2').empty();
            	//$("#place1").show();
            	$("#courierId").prop('value', '');
            	$("#courierUserName").prop('value', '');
            	$("#courierCard").prop('value','');
            	//$("#courierName").prop('value', '');
               	$("#manCourier").click();
                $("#courierPhoneNo").prop('value', '');
                $("#companyPhoneNo").prop('value', '');
                $("#companyName").prop('value', '');
                $("#companyContacts").prop('value','');
                $("#exigenceContactPhoneNo").prop('value', '');
                $("#exigenceContactName").prop('value', '');
                $("#courierValidDate").prop('value','');
                $("#courierExpireDate").prop('value', '');
                layui.form.render('radio');
                layui.form.render('checkbox');
            	layer.open({
                    type: 1
                    , maxmin: true
                    , title: '添加快递员'
                    , content: $("#courierDialog")
                    , area: ['800px', '800px']
                });
            }
            , edit: function (tobj) {
            	filereindex = true;
            	$("#place1").hide();
            	//console.log(tobj.data);
                typeForm = 1;
                dialogIndex = layer.open({
                    type: 1
                    , maxmin: true
                    , title: '修改用户信息'
                    , content: tobj.data.courierPhoneNo?courierDialog:userDialog
                    , area: ['800px', '800px']
                    , end: function () {
                        clearTimeout(timeout);
                    }
                });
                layer.full(dialogIndex);
                if(!tobj.data.courierCard){
                	//console.log("用户");
                	$("#inboxAuthDiv").hide();
                    switch (tobj.data.userType) {
                    case '0':
                        zhu.click();
                        break;
                    case '1':
                        jia.click();
                        break;
                    case '2':
                        ke.click();
                        break;
                    case '3':
                        wu.click();
                        $("#inboxAuthDiv").show();
                        break;
	                }
	                //console.log(tobj.data.inboxAuth);
	                if(tobj.data.inboxAuth!='0'){
	                	//console.log("否");
	                	$("#inboxAuth").prop('checked', false);
	                }
	                userId.prop('value', tobj.data.userId);
	                userName.prop('value', tobj.data.userName);
	                switch (tobj.data.userSex) {
	                    case '0':
	                        male.click();
	                        break;
	                    case '1':
	                        female.click();
	                        break;
	                }
	                switch (tobj.data.constructors) {
                    case '0':
                        $("#nonConstructors").click();
                        break;
                    case '1':
                    	$("#yesConstructors").click();
                        break;
                	}
	                layui.form.render('radio');
	                layui.form.render('checkbox');
	                phoneNo.prop('value', tobj.data.phoneNo);
	                idCard.prop('value', tobj.data.idCard);
	
	                if (tobj.data.validDate)
	                //validDate.prop('value', tobj.data.validDate.substring(0, 10));
	                    if (tobj.data.expireDate)
	                        expireDate.prop('value', tobj.data.expireDate.substring(0, 10));
	                if (tobj.data.facePictureUrl) {
	                    faceDiv.show('normal');
	                    facePic.attr('src', tobj.data.facePictureUrl);
	                    faceValidDate.val(tobj.data.faceValidDate);
	                    faceExpireDate.val(tobj.data.faceExpireDate);
	                    facePic.show();
	                }else{
	                	facePic.hide();
	                }
	                setFace.attr('disabled', false);
	                setFaceP.text("");
	                place.hide();
	                doorAccess.show();
                }else{
                	//console.log("快递员");
                	$("#reqType").prop('value', 'update');
                	$("#userIdForCourier").prop('value', tobj.data.userId);
                	$("#courierCard").prop('value', tobj.data.courierCard);
                	$("#courierId").prop('value', tobj.data.id);
                	$("#frontImgUrl").prop('value', tobj.data.frontImgUrl);
                	$("#backImgUrl").prop('value', tobj.data.backImgUrl);
                	$("#courierUserName").prop('value', tobj.data.courierUserName);
                	$("#courierCard").prop('value',tobj.data.courierCard);
                	$("#courierName").prop('value', tobj.data.courierName);
                    switch (tobj.data.courierSex) {
                    case '0':
                        $("#manCourier").click();
                        break;
                    case '1':
                    	$("#womanCourier").click();
                        break;
                	}
                    $("#courierPhoneNo").prop('value', tobj.data.courierPhoneNo);
                    $("#companyPhoneNo").prop('value', tobj.data.companyPhoneNo);
                    $("#companyName").prop('value', tobj.data.companyName);
                    $("#companyContacts").prop('value', tobj.data.companyContacts);
                    $("#exigenceContactPhoneNo").prop('value', tobj.data.exigenceContactPhoneNo);
                    $("#exigenceContactName").prop('value', tobj.data.exigenceContactName);
                    $("#courierValidDate").prop('value', tobj.data.validDate.substring(0, 10));
                    $("#courierExpireDate").prop('value', tobj.data.expireDate.substring(0, 10));
                    $('#demo2').empty();
                    let tr1;
                    let tr2;
                    if(tobj.data.frontImgUrl!=null && tobj.data.frontImgUrl!=""){
                    	tr1 = $(['<div  style="position:relative;width:110px;display:inline-block">'+
                            '<img  style="margin-right: 14px" width="100px" height="80px" src="'+
                            tobj.data.frontImgUrl +'"  class="layui-upload-img"></div>'].join(''));
                    	$('#demo2').append(tr1);
                    }
                    if(tobj.data.backImgUrl!=null && tobj.data.backImgUrl!=""){
                        tr2 = $(['<div  style="position:relative;width:110px;display:inline-block">'+
                            '<img  style="margin-right: 14px" width="100px" height="80px" src="'+
                            tobj.data.backImgUrl +'"  class="layui-upload-img"></div>'].join(''));
                        $('#demo2').append(tr2);
                    }
                    layui.form.render('radio');
                    layui.form.render('checkbox');
                }

            },
            upload0:function(tobj){
            	//console.log("正面");
            	imgType = "0";
            	frontindex = 1;
            },
            upload1:function(tobj){
            	//console.log("反面");
            	imgType = "1";
            	backindex=1;
            }
            , del: function (tobj) {
            	//console.log(tobj.data);
            	let contentText;
            	let url;
                let userId;
            	if(tobj.data.userId){
            		contentText = "确定删除用户：" + tobj.data.userName + "?";
            		url = '../api/userManager/v1/deleteAppUserById';
            		userId = tobj.data.userId;
            	}else{
            		contentText = "确定删除用户：" + tobj.data.courierUserName + "?";
            		url = '../api/userManager/v1/deleteCourierById';
            		userId = tobj.data.id;
            	}
                layer.open({
                    type: 0
                    , content: contentText
                    , shadeClose: true
                    , yes: function (index, layero) {
                        var i = layer.load(2, {time: 5000});
                        doAjax("post",url,{"userId": userId,"token":session.getItem("token")},function (data) {
                        	layer.close(i);
                            if (!data || checkLogin(data)) return null;
                            if (data.code == 0) {
                                layer.msg("删除成功");
                                // table.reload('userTable');
                                tobj.del();
                            } else {
                                layer.msg(data.msg);
                            }
				        },function(err){
				        	
				        });
                        
/*                         $.post(url, {"userId": userId,
                        	"token":session.getItem("token")}, function (data) {
                            layer.close(i);
                            if (!data || checkLogin(data)) return null;
                            if (data.code == 0) {
                                layer.msg("删除成功");
                                // table.reload('userTable');
                                tobj.del();
                            } else {
                                layer.msg(data.msg);
                            }
                        }, 'json'); */
                    }
                });
            }
            , rooms: function (tobj) {
                curUser = tobj.data;
                //console.log(curUser);
                let url;
                let cols;
                if(selectType.val() == "user"){
                	url = '../api/userManager/v1/selectAppUserRoomBindingList';
                	cols = [[
                        {
                            title: '序号', type: 'numbers'
                        }
                        , {
                            title: '类型', field: 'userType', width: 60, templet: function (d) {
                                var type = "未知";
                                switch (d.userType) {
                                    case '0':
                                        type = '业主';
                                        break;
                                    case '1':
                                        type = '家属';
                                        break;
                                    case '2':
                                        type = '租客';
                                        break;
                                }
                                return type;
                            }
                        }
                        , {title: '小区', field: 'commName', width: 120}
                        , {title: '楼栋', field: 'bldName', width: 120}
                        , {title: '单元', field: 'unitName', width: 120}
                        , {title: '房间', field: 'roomName', width: 120}
                        , {title: '', align: 'center', toolbar: '#barRoom', fixed: 'right', width: 102}
                    ]];
                }else{
                	url = '../api/userManager/v1/selectCourierRoomBindingList';
                	cols = [[
                        {
                            title: '序号', type: 'numbers'
                        }
                        , {title: '小区', field: 'commName', width: 120}
                        , {title: '楼栋', field: 'bldName', width: 120}
                        , {title: '单元', field: 'unitName', width: 120}
                        , {title: '房间', field: 'roomName', width: 120}
                        , {title: '', align: 'center', toolbar: '#barRoom', fixed: 'right'}
                    ]];
                }
                table.render({
                    elem: '#table_room'
                    , url: url
               		, method: "post"
               		,contentType:'application/x-www-form-urlencoded'
                    , cols: cols
                    , id: 'roomTable'
                    // , page: true
                    // , height: 'full-120'
                    , where: {
                        userId: selectType.val() == "user"?curUser.userId:curUser.id,
                        token : session.getItem("token")
                    }
                    // , request: {
                    //     pageName: 'pageNum'
                    //     , limitName: 'pageSize'
                    // }
                    , done: function (res, curr, count) {
                        checkLogin(res);
                    }
                });
                table.on('tool(roomTable)', function (obj) {
                    if (buttons[obj.event]) buttons[obj.event](obj);
                });
                let username = curUser.userName?curUser.userName:curUser.courierUserName;
                layer.open({
                    type: 1
                    , content: roomDialog
                    , title: '用户:' + username
                    , area: ['700px', '500px']
                    , shadeClose: true
                    , btn: ['添加房间']
                    , yes: function (index, layero) {
                        layer.open({
                            type: 1
                            , shadeClose: true
                            , title: '绑定房间（用户:' + username + '）'
                            , content: selectType.val() == "user"?bindRoomDialog:bindCourierDialog
                            , area: ['700px', '500px']
                            , btn: ['确定']
                            , yes: function (index, layero) {
                            	var nodes;
                            	let url;
                            	let data;
                            	if(selectType.val() == "user"){
                            		nodes = treeRoom.getSelectedNodes();
                                    if (!nodes.length || nodes[0].level != 4) {
                                        layer.msg('请选中房间');
                                        return;
                                    }
                            		
                            		url = '../api/userManager/v1/appUserRoomBinding';
                            		data = {
                                            userType: userType,
                                            userId: curUser.userId,
                                            roomId: nodes[0].id,
                                            token:session.getItem("token")
                                        };
                            	}else{
                            		nodes = bindCourierTree.getSelectedNodes();
                            		//console.log(nodes[0]);
                            		url = '../api/userManager/v1/courierRoomBinding';
                            		data = {
                                            userId: curUser.id,
                                            token:session.getItem("token")
                                        };
                                    if (!nodes.length || nodes[0].level < 1) {
                                        layer.msg('请选择绑定位置');
                                        return;
                                    }
                                    switch(nodes[0].level){
                                    case 1:
                                    	data.commId = nodes[0].id;
                                    	break;
                                    case 2:
                                    	data.bldId = nodes[0].id;
                                    	break;
                                    case 3:
                                    	data.unitId = nodes[0].id;
                                    	break;
                                    case 4:
                                    	data.roomId = nodes[0].id;
                                    	break;
                                    }
                            	}
                            	//console.log(data);

                                var i = layer.load(2, {time: 5000});
                                doAjax("post",url,data,function (data) {
                                	layer.close(i);
                                    if (!data) return null;
                                    if (data.code == 0) {
                                        layer.msg("保存成功");
                                        table.reload('roomTable');
                                        layer.close(index);
                                    } else {
                                        layer.msg(data.msg);
                                    }
        				        },function(err){
        				        	
        				        });
                                
/*                                  $.post(url,data, function (data) {
                                    layer.close(i);
                                    if (!data || checkLogin(data)) return null;
                                    if (data.code == 0) {
                                        layer.msg("保存成功");
                                        table.reload('roomTable');
                                        layer.close(index);
                                    } else {
                                        layer.msg(data.msg);
                                    }
                                }, 'json');  */
                            }
                        });
                    }
                });
            }
            , unbindRoom: function (tobj) {
            	//console.log(tobj.data);
            	let contenttext;
            	if(tobj.data.roomId){
            		contenttext = "确定解绑房间：" + tobj.data.roomName + "?";
            	}else if(tobj.data.unitId){
            		contenttext = "确定解绑单元：" + tobj.data.unitName + "?";
            	}else if(tobj.data.bldId){
            		contenttext = "确定解绑楼栋：" + tobj.data.bldName + "?";
            	}else if(tobj.data.commId){
            		contenttext = "确定解绑小区：" + tobj.data.commName + "?";
            	}
                layer.open({
                    type: 0
                    , content: contenttext
                    , shadeClose: true
                    , yes: function (index, layero) {
                        var i = layer.load(2, {time: 5000});
                        let userid;
                        let url;
                        if(tobj.data.userId){
                        	url='../api/userManager/v1/deleteAppUserRoomBindingById';
                        	userid = tobj.data.userId;
                        }else{
                        	url='../api/userManager/v1/deleteCourierBindingById';
                        	userid = tobj.data.courierId;
                        }
                        doAjax("post",url,{
                            userId: userid,
                            roomId: tobj.data.roomId,
                            commId : tobj.data.commId,
                            bldId : tobj.data.bldId,
                            unitId : tobj.data.unitId,
                            token:session.getItem("token")
                        },function (data) {
                        	 layer.close(i);
                             if (data.code == 0) {
                                 layer.msg("解绑成功");
                                 // table.reload('roomTable');
                                 tobj.del();
                             } else {
                                 layer.msg(data.msg);
                             } 
				        },function(err){
				        	
				        });
/*                          $.post(url, {
                            userId: userid,
                            roomId: tobj.data.roomId,
                            commId : tobj.data.commId,
                            bldId : tobj.data.bldId,
                            unitId : tobj.data.unitId,
                            token:session.getItem("token")
                        }, function (data) {
                        	//console.log("解绑的Data:"+JSON.stringify(data));
                             layer.close(i);
                            if (data.code == 0) {
                                layer.msg("解绑成功");
                                // table.reload('roomTable');
                                tobj.del();
                            } else {
                                layer.msg(data.msg);
                            } 
                        }, 'json');  */
                    }
                });
            }
            , query: function () {
            	if(selectType.val() == "user"){
            		$("#tablecontenid").show();
            		$("#courierTableConten").hide();
                    var where = {userName: '', phoneNo: '', idCard: ''};
                    where[queryType.val()] = queryKey.val();
                    table.reload('userTable', {
                        page: {
                            curr: 1 //重新从第 1 页开始
                        }
                        , where: where
                    });
            	}else{
            		$("#tablecontenid").hide();
            		$("#courierTableConten").show();
                    var where = {userName: '', phoneNo: ''};
                    where[queryType.val()] = queryKey.val();
                    table.reload('courierTable', {
                        page: {
                            curr: 1 //重新从第 1 页开始
                        }
                        , where: where
                    });
            	}

            }
            , cancel: function () {
                layer.close(dialogIndex);
            }
            , choose: function () {
                treeIndex = layer.open({
                    type: 1
                    , shadeClose: true
                    , title: '请选择房间（业主可不选）'
                    , content: treeCommunityDialog
                    , area: ['700px', '500px']
                });
            }
            ,chooseCourier: function(){
            	treeCourier = layer.open({
                     type: 1
                     , shadeClose: true
                     , title: '请选择位置'
                     , content: treeCommunityDialog
                     , area: ['700px', '500px']
                 });
            }
            , machine: function () {
                machineIndex = layer.open({
                    type: 1
                    , shadeClose: true
                    , maxmin: true
                    , title: '请选择人脸录入设备'
                    , content: treeMachineDialog
                    , area: ['700px', '500px']
                });
            }
            , setFace: function () {
                if (!curMac || curMac.id.length <= 0) {
                    buttons['machine']();
                    return;
                }
                setFace.attr('disabled', true);
                time = 40;
                doAjax("post","../api/userManager/v1/sendFaceRecognitionOrder", {
                    faceId: userId.val(),
                    doorPhoneId: curMac.id,
                    token:session.getItem("token")
                },function (data) {
                	if (!data || data.code !== 0) {
                        time = 0;
                    }
		        },function(err){
		        	
		        });
                
/*                 $.post("../api/userManager/v1/sendFaceRecognitionOrder", {
                    faceId: userId.val(),
                    doorPhoneId: curMac.id,
                    token:session.getItem("token")
                }, function (data) {
                    if (!data || data.code !== 0) {
                        time = 0;
                    }
                }); */
                queryLoop();
            }
        }
        , treeIndex, curNode,treeCourier
        , treeCommunity = $.fn.zTree.init($("#treeCommunity"), {
            view: {
                addHoverDom: function (treeId, treeNode) {
                    var sObj = $("#" + treeNode.tId + "_span");
                    if (!treeNode.isParent || treeNode.editNameFlag || $("#refreshBtn_" + treeNode.tId).length > 0) return;
                    var addStr = "<span  id='refreshBtn_" + treeNode.tId
                        + "' title='刷新' onfocus='this.blur();' class='layui-icon'>&#xe9aa;</span>";
                    sObj.after(addStr);
                    var btn = $("#refreshBtn_" + treeNode.tId);
                    if (btn) btn.bind("click", function () {
                        treeCommunity.reAsyncChildNodes(treeNode, 'refresh');
                        return false;
                    });
                }
                , removeHoverDom: function (treeId, treeNode) {
                    $("#refreshBtn_" + treeNode.tId).unbind().remove();
                }
                , selectedMulti: false
            }
            , async: {
                enable: true,
                url: getPlace,
                otherParam:  {"token":function(){return session.getItem("token")}}, 
                dataFilter: function (treeId, parentNode, data) {
                	//console.log("dataFilter:"+JSON.stringify(data));
                	let checkCode = checkToken(data);
                    if(checkCode == "1005"){
                    	treeCommunity.expandAll(false);
                    	treeCommunity.refresh();
                    }else if(checkCode == "1004"){
                    	relogin(checkCode);
                    }
                	var childNodes;
                    if(data.code == 0 && parentNode.level == 0 ){
                 	   childNodes = forTreeAgentCommunityParentData(data.data);
                    }else if(data.code == 0 && parentNode.level == 1){
                 	   childNodes = forTreeAgentCommunityLevelOneData(data.data);
                    }else if(data.code == 0 && parentNode.level == 2){
                 	   childNodes = forTreeAgentCommunityLevelTwoData(data.data);
                    }else if(data.code == 0 && parentNode.level == 3){
                 	   childNodes = forTreeAgentCommunityLevelThreeData(data.data);
                    }else if(data.code == 0 && parentNode.level == 4){
                 	   childNodes = forTreeAgentCommunityLevelFourData(data.data);
                    }else if(data.code!=0){
                    	return null;
                    }
                    for (var i = 0, l = childNodes.length; i < l; i++) {
                        childNodes[i].isParent = childNodes[i].level < 5;
                    }
                    return childNodes; 
                }
            }
            , callback: {
                onClick: function (event, treeId, treeNode) {
                    if (treeNode.level < 4) return;
                    layer.close(treeIndex);
                    layer.close(treeCourier);
                    if (curNode === treeNode) return;
                    curNode = treeNode;
                    if (treeNode.level == 5) {
                        proprietId.prop('value', treeNode.id);
                        proprietName.text(treeNode.name);
                        treeNode = treeNode.getParentNode();
                    } else {
                        proprietId.prop('value', '');
                        proprietName.text('请选择业主（可选）');
                    }
                    roomId.prop('value', treeNode.id);
                    $("#courierRoomId").prop('value', treeNode.id);
                    roomName.text(treeNode.name);
                    $("#courierRoomName").text(treeNode.name);
                    treeNode = treeNode.getParentNode();
                    unitName.text(treeNode.name);
                    $("#courierUnitName").text(treeNode.name);
                    treeNode = treeNode.getParentNode();
                    bldName.text(treeNode.name);
                    $("#courierBldName").text(treeNode.name);
                    treeNode = treeNode.getParentNode();
                    commName.text(treeNode.name);
                    $("#courierCommName").text(treeNode.name);
                }
            }
        }, {
            name: "小区列表"
            , id: session.getItem("agencyId")
            , isParent: true
        }),
        indexlist =  new Array(),
        imgType,
        uploadQ,
        uploadbool = true,
        uploadInst = layui.upload.render({
            elem: '.uploadImg' //绑定元素
                ,url: "../api/userManager/v1/addCourierInfoFile" //上传接口
                ,auto:false
                , multiple: true
                ,acceptMime: 'image/*'
                ,number:'2'
                ,bindAction:"#formSubmitForCourier"
                ,choose:function(obj){
                	if(filereindex){
                		$('#demo2').empty();
                	}
                	files = this.files = obj.pushFile();
                    obj.preview(function(index, file, result){
                    	if(imgType == "0"){
                    		frontindex = 1;
                    	}else if(imgType == "1"){
                    		backindex=1;
                    	}
                    	indexlist.push({name:file.name,imgType : imgType});
                        var tr = $(['<div  style="position:relative;width:110px;display:inline-block">'+
                            '<img class= "demo-delete" style="position:absolute;left:84px;top:0;" width="16px" height="16px" '+
                            'src="../img/del.png" onclick=""><img  style="margin-right: 14px" width="100px" height="80px" src="'+
                            result +'" alt="'+ file.name +
                           		 '" class="layui-upload-img"></div>'].join(''));
                        tr.find('.demo-delete').on('click', function () {
                    	//console.log("对应的文件："+files[index].name);
                    	
                    	//console.log(files[index]);
                    	for(i=0;i<indexlist.length;i++){
                    		if(indexlist[i].name == files[index].name){
                    			//console.log(indexlist[i]);
                    			if(indexlist[i].imgType == "0"){
                    				frontindex = 0;
                    			}else if(indexlist[i].imgType == "1"){
                    				backindex = 0;
                    			}
                    			indexlist.splice( i, 1 );
                    		}
                    	}
                    	delete files[index]; //删除对应的文件
                    	tr.remove();
                    	uploadInst.config.elem.next()[0].value = ''; //清空 input file 值，以免删除后出现同名文件不可选
                    });
                       $('#demo2').append(tr);
                       filereindex = false;
                })
                }
                ,before: function(obj){
                	//console.log(files);
                    //预读本地文件示例，不支持ie8
                    if(frontindex==0 && backindex==0){
                    	return ;
                    }
                    if(frontindex!=1 || backindex!=1){
                    	return layer.msg('请使用按钮选择图片正反面！');
                    }
                    let courierUserName = $("#courierUserName").val();
                    if(!courierUserName){
                    	return layer.msg('姓名不能为空！');
                    }
                    let courierCard = $("#courierCard").val();
                    if(!courierCard){
                    	return layer.msg('身份证号不能为空！');
                    }
/*                let courierPassword = $("#courierPassword").val();
                    if(!courierPassword){
                    	return false;
                    } */
                    let courierPhoneNo = $("#courierPhoneNo").val();
                    if(!(/^1[3456789]\d{9}$/.test(courierPhoneNo))){
                    	return layer.msg('手机号码格式不正确');
                    }
                    let companyName = $("#companyName").val();
                    let companyContacts = $("#companyContacts").val();
                    let companyPhoneNo = $("#companyPhoneNo").val();
                    let exigenceContactName = $("#exigenceContactName").val();
                    let exigenceContactPhoneNo = $("#exigenceContactPhoneNo").val();
                    let courierValidDate = $("#courierValidDate").val();
                    let userIdForCourier = $("#userIdForCourier").val();
                    let courierExpireDate = $("#courierExpireDate").val();
                   /*  let courierRoomId = $("#courierRoomId").val();
                    if($('#courierId').val()==null || $('#courierId').val()==""){
                        if(courierRoomId.length<1){
                        	buttons['chooseCourier']();
                            return layer.msg('请选择绑定位置');
                        }
                    } */
                    //console.log("token:"+session.getItem("token"));
                    let courierSex = $("input[name='courierSex']:checked").val();
                    this.data={
                    		token:session.getItem("token"),
							typeList:JSON.stringify(indexlist),
							courierCard:courierCard,
                    		ageId : session.getItem("agencyId"),
                    		procreatorId : session.getItem("userId"),
                    		courierId:$('#courierId').val(),
                    		frontImgUrl:$('#frontImgUrl').val(),
                    		backImgUrl:$('#backImgUrl').val(),
                    		courierUserName:courierUserName,
                    		userIdForCourier:userIdForCourier,
                    		filekey:"yes",
                    		reqType:$('#reqType').val(),
                    		courierPhoneNo:courierPhoneNo,
                    		companyContacts : companyContacts,
                    		companyPhoneNo : companyPhoneNo,
                    		exigenceContactName : exigenceContactName,
                    		exigenceContactPhoneNo : exigenceContactPhoneNo,
                    		courierValidDate : courierValidDate,
                    		courierExpireDate : courierExpireDate,
                    		courierSex : courierSex,
                    		companyName:companyName
                    };
                    uploadQ = layer.load(2, {time: 5000});
                }
                ,done: function(res, index, upload){
                	let checkCode = checkToken(res);
                	if(checkCode == "1005"){
                		uploadListIns.upload(); 
                	}else if(checkCode == "1004" || checkCode == "1003" || checkCode == "1002"){
                		relogin(checkCode);
                	}else{
                		layer.close(uploadQ);
                    	//console.log(res.data);
                        //如果上传失败
                        if(res.code == 0){
                        	delete this.files[index];
                			frontindex = 0;
                			backindex = 0;
                        	layer.closeAll('page');
                        	//layer.msg('添加成功');
                            table.reload('courierTable', {
                                page: {
                                    curr: 1 //重新从第 1 页开始
                                }
                                , where: {userName: '', phoneNo: ''}
                            });
                        }else if(res.code == 4003){
                        	return layer.msg(res.msg);
                        }    
                	}
                }
                ,error: function(){
                    //演示失败状态，并实现重传

                }
            })
        , machineIndex, curMac
        , treeMac = $.fn.zTree.init($("#treeMachine"), {
            view: {
                addHoverDom: function (treeId, treeNode) {
                    var sObj = $("#" + treeNode.tId + "_span");
                    if (!treeNode.isParent || treeNode.editNameFlag || $("#refreshBtn_" + treeNode.tId).length > 0) return;
                    var addStr = "<span  id='refreshBtn_" + treeNode.tId
                        + "' title='刷新' onfocus='this.blur();' class='layui-icon'>&#xe9aa;</span>";
                    sObj.after(addStr);
                    var btn = $("#refreshBtn_" + treeNode.tId);
                    if (btn) btn.bind("click", function () {
                        treeMac.reAsyncChildNodes(treeNode, 'refresh');
                        return false;
                    });
                }
                , removeHoverDom: function (treeId, treeNode) {
                    $("#refreshBtn_" + treeNode.tId).unbind().remove();
                }
                , selectedMulti: false
            }
            , async: {
                enable: true,
                url: getMacMain,
                otherParam:  {"token":function(){return session.getItem("token")},"ageId":session.getItem("agencyId")},
                dataFilter: function (treeId, parentNode, data) {
                	let checkCode = checkToken(data);
                    if(checkCode == "1005"){
                    	treeMac.expandAll(false);
                    	treeMac.refresh();
                    }else if(checkCode == "1004"){
                    	relogin(checkCode);
                    }
                	var childNodes;
                	//console.log(JSON.stringify(parentNode));
                    if(data.code == 0 && parentNode.level == 0 ){
                 	   childNodes = fortreeMacParentData(data.data);
                    }else if(data.code == 0 && parentNode.level == 1 ){
                    	childNodes = fortreeMacLevelOneData(data.data);
                    }
                    //console.log(JSON.stringify(childNodes));
                    if(!childNodes) return null;
                    for (var i = 0, l = childNodes.length; i < l; i++) {
                        childNodes[i].isParent = childNodes[i].level < 1;
                    }
                    return childNodes;
                }
            }
            , callback: {
                onClick: function (event, treeId, treeNode) {
                    if (treeNode.isParent) return;
                    layer.close(machineIndex);
                    if (curMac === treeNode) return;
                    curMac = treeNode;
                    machine.text(treeNode.name);
                }
            }
        }, {
            name: session.getItem("agencyName")
            , isParent: true
        })
        ,
        treeAgent = $.fn.zTree.init($("#treeAgent"), {
                async: {
                    enable: true,
                    url: "../api/agencyManager/v1/selectSystemAgencyList",
                    autoParam: ["ageId=parentAgeId"],
                    otherParam:{"token":function(){return session.getItem("token")}},
                    dataFilter: function (treeId, parentNode, data) {
                        //console.log(treeId);
                        //console.log(data.data);
                    	let checkCode = checkToken(data);
                        if(checkCode == "1005"){
                        	treeAgent.expandAll(false);
                        	treeAgent.refresh();
                        }else if(checkCode == "1004"){
                        	relogin(checkCode);
                        }
                        if (!data || !data.data) return null;
                        var childNodes = data.data;
                        for (var i = 0, l = childNodes.length; i < l; i++) {
                            childNodes[i].isParent = true;
                        }
                        return childNodes;
                    }
                },
                data: {
                    key: {
                        name: "ageName"
                    }
                    , simpleData: {
                        enable: true
                        , idKey: "ageId"
                        , pidKey: "parentAgeId"
                    }
                }
                , callback: {
                    onClick: function (event, treeId, treeNode) {
/*                     	console.log(selectType.val());
                        console.log(treeId);
                        console.log(event);
                        console.log(treeNode.ageId);
                        console.log(treeNode.ageName);
                        console.log("treeNode:"+treeNode.parentAgeId); */
                        var where = {ageId: treeNode.ageId,commId:null,bldId:null,unitId:null,roomId:null,userName:function(){
                        	if($("#queryType").val() == "userName"){
                        		return $("#queryKey").val();
                        	}else{
                        		return "";
                        	}
                        },phoneNo :function(){
                        	if($("#queryType").val() == "phoneNo"){
                        		return $("#queryKey").val();
                        	}else{
                        		return "";
                        	}
                        }};
                        treeAgentCommunity.reload({id: treeNode.ageId, name: treeNode.ageName, isParent: true});
                        if(selectType.val() == "user"){
                            table.reload('userTable',{
                                    url:'../api/userManager/v1/selectAppUserList',
                                    page: {
                                        curr: 1 //重新从第 1 页开始
                                    }
                                    , where: where
                                }
                            )
                        }else{
                        	table.reload('courierTable',{
                                url:'../api/userManager/v1/selectCourierList',
                                page: {
                                    curr: 1 //重新从第 1 页开始
                                }
                                , where: where
                            })
                        }
                    }
                }
            },
            {
                ageName: session.getItem("agencyName")
                , ageId: session.getItem("agencyId")
                , isParent: true
            }),
            treeAgentCommunity = function () {
                var zTreeObj
                	, newCommId
                	, newAgeId
                	, newBldId
                	, newUnitId
                	, newRoomId
                    , setting = {
                     async: {
                        enable: true,
                        url:getPlace,
                        otherParam: {"token":function(){return session.getItem("token")}}, 
                        dataFilter: function (treeId, parentNode, data) {
                        	//console.log("treeId:"+treeId);
                        	//console.log("parentNode:"+JSON.stringify(parentNode));
                          // console.log("data:"+JSON.stringify(data));
                        	let checkCode = checkToken(data);
                            if(checkCode == "1005"){
                            	treeAgentCommunity.expandAll(false);
                            	treeAgentCommunity.refresh();
                            }else if(checkCode == "1004"){
                            	relogin(checkCode);
                            }
                          if (!data ||  !data.data) return null;
                           var childNodes;
                           if(data.code == 0 && parentNode.level == 0 ){
                        	   childNodes = forTreeAgentCommunityParentData(data.data);
                           }else if(data.code == 0 && parentNode.level == 1){
                        	   childNodes = forTreeAgentCommunityLevelOneData(data.data);
                           }else if(data.code == 0 && parentNode.level == 2){
                        	   childNodes = forTreeAgentCommunityLevelTwoData(data.data);
                           }else if(data.code == 0 && parentNode.level == 3){
                        	   childNodes = forTreeAgentCommunityLevelThreeData(data.data);
                           }else if(data.code == 0 && parentNode.level == 4){
                        	   childNodes = forTreeAgentCommunityLevelFourData(data.data);
                           }
                           for (var i = 0, l = childNodes.length; i < l; i++) {
                               childNodes[i].isParent = childNodes[i].level < 4;
                           }
                    	   //console.log("childNodes:"+childNodes);
                           return childNodes;
                        }
                    }
                    , callback: {
                        onClick: function (event, treeId, treeNode) {
                            //console.log(treeId);
                            //console.log(event);
                            //console.log(treeNode);
                            //console.log(treeNode.level);
                            //console.log("treeNode:"+treeNode.parentAgeId);
                            let where;
                            switch (treeNode.level){
                                case 0:
                                   where = {ageId: treeNode.id,commId: null,bldId: null,unitId: null,roomId: null,userName:function(){
                                   	if($("#queryType").val() == "userName"){
                                		return $("#queryKey").val();
                                	}else{
                                		return "";
                                	}
                                },phoneNo :function(){
                                	if($("#queryType").val() == "phoneNo"){
                                		return $("#queryKey").val();
                                	}else{
                                		return "";
                                	}
                                }};
                                    break;
                                case 1:
                                    where = {commId:treeNode.id,bldId:null,unitId:null,roomId:null,userName:function(){
                                       	if($("#queryType").val() == "userName"){
                                    		return $("#queryKey").val();
                                    	}else{
                                    		return "";
                                    	}
                                    },phoneNo :function(){
                                    	if($("#queryType").val() == "phoneNo"){
                                    		return $("#queryKey").val();
                                    	}else{
                                    		return "";
                                    	}
                                    }};
                                    break;
                                case 2:
                                   where = {commId:null,bldId:treeNode.id,unitId:null,roomId:null,userName:function(){
                                      	if($("#queryType").val() == "userName"){
                                    		return $("#queryKey").val();
                                    	}else{
                                    		return "";
                                    	}
                                    },phoneNo :function(){
                                    	if($("#queryType").val() == "phoneNo"){
                                    		return $("#queryKey").val();
                                    	}else{
                                    		return "";
                                    	}
                                    }};
                                    break;
                                case 3:
                                    where = {commId:null,bldId:null,unitId:treeNode.id,roomId:null,userName:function(){
                                       	if($("#queryType").val() == "userName"){
                                    		return $("#queryKey").val();
                                    	}else{
                                    		return "";
                                    	}
                                    },phoneNo :function(){
                                    	if($("#queryType").val() == "phoneNo"){
                                    		return $("#queryKey").val();
                                    	}else{
                                    		return "";
                                    	}
                                    }};
                                    break;
                                case 4:
                                    where = {commId:null,bldId:null,unitId:null,roomId:treeNode.id,userName:function(){
                                       	if($("#queryType").val() == "userName"){
                                    		return $("#queryKey").val();
                                    	}else{
                                    		return "";
                                    	}
                                    },phoneNo :function(){
                                    	if($("#queryType").val() == "phoneNo"){
                                    		return $("#queryKey").val();
                                    	}else{
                                    		return "";
                                    	}
                                    }};
                                    break;
                            }
                            if(selectType.val() == "user"){
                                table.reload('userTable',{
                                        url:'../api/userManager/v1/selectAppUserList',
                                        page: {
                                            curr: 1 //重新从第 1 页开始
                                        }
                                        , where: where
                                    }
                                )
                            }else{
                            	table.reload('courierTable',{
                                    url:'../api/userManager/v1/selectCourierList',
                                    page: {
                                        curr: 1 //重新从第 1 页开始
                                    }
                                    , where: where
                                })
                            }

                        },
                        beforeExpand:function(treeId,treeNode){
                            var cLevel = treeNode.level;
                            //console.log("打开级别："+cLevel);
                            //这里假设id是唯一的
                            var cId = treeNode.id;
                            //console.log("ID:"+cId);
                            //此对象可以保存起来，没有必要每次查找
                            var treeObj =  zTreeObj;
                           // console.log("treeObj:"+treeObj);
                            var expandedNodes = treeObj.getNodesByParam("open", true, treeNode.getParentNode());
                            //console.log(expandedNodes);
                            for(var i = expandedNodes.length - 1; i >= 0; i--){
                                var node = expandedNodes[i];
                                var level = node.level;
                                var id = node.id;
                                if (cId != id && level == cLevel) {
                                    treeObj.expandNode(node, false);
                                }
                            }
                            return true;
                        }
                    }
                };

                zTreeObj = $.fn.zTree.init($("#treeAgentCommunity"), setting, {
                	 name: "小区列表"
                     , id: session.getItem("agencyId")
                    , isParent: true
                });
                return {
                    reload: function (node) {
                        zTreeObj = $.fn.zTree.init($("#treeAgentCommunity"), setting, node);
                    }
                }
            }(),
        treeRoom = $.fn.zTree.init($("#treeRoom"), {
            view: {
                addHoverDom: function (treeId, treeNode) {
                    var sObj = $("#" + treeNode.tId + "_span");
                    if (!treeNode.isParent || treeNode.editNameFlag || $("#refreshBtn_" + treeNode.tId).length > 0) return;
                    var addStr = "<span  id='refreshBtn_" + treeNode.tId
                        + "' title='刷新' onfocus='this.blur();' class='layui-icon'>&#xe9aa;</span>";
                    sObj.after(addStr);
                    var btn = $("#refreshBtn_" + treeNode.tId);
                    if (btn) btn.bind("click", function () {
                        treeRoom.reAsyncChildNodes(treeNode, 'refresh');
                        return false;
                    });
                }
                , removeHoverDom: function (treeId, treeNode) {
                    $("#refreshBtn_" + treeNode.tId).unbind().remove();
                }
                , selectedMulti: false
            }
            , async: {
                enable: true,
                url: getPlace,
                otherParam:{"token":function(){return session.getItem("token")}},
                dataFilter: function (treeId, parentNode, data) {
                	let checkCode = checkToken(data);
                    if(checkCode == "1005"){
                    	treeRoom.expandAll(false);
                    	treeRoom.refresh();
                    }else if(checkCode == "1004"){
                    	relogin(checkCode);
                    }
                	if (!data ) return null;
                	var childNodes;
                    if(data.code == 0 && parentNode.level == 0 ){
                 	   childNodes = forTreeAgentCommunityParentData(data.data);
                    }else if(data.code == 0 && parentNode.level == 1){
                 	   childNodes = forTreeAgentCommunityLevelOneData(data.data);
                    }else if(data.code == 0 && parentNode.level == 2){
                 	   childNodes = forTreeAgentCommunityLevelTwoData(data.data);
                    }else if(data.code == 0 && parentNode.level == 3){
                 	   childNodes = forTreeAgentCommunityLevelThreeData(data.data);
                    }else if(data.code == 0 && parentNode.level == 4){
                 	   childNodes = forTreeAgentCommunityLevelFourData(data.data);
                    }else if(data.code!=0){
                    	return null;
                    }
                    for (var i = 0, l = childNodes.length; i < l; i++) {
                        childNodes[i].isParent = childNodes[i].level < 4;
                    }
                    return childNodes; 
                }
            }
        }, {
            name: session.getItem("agencyName")
            , id: session.getItem("agencyId")
            , isParent: true
        }),
        bindCourierTree = $.fn.zTree.init($("#bindCourierTree"), {
            view: {
                addHoverDom: function (treeId, treeNode) {
                    var sObj = $("#" + treeNode.tId + "_span");
                    if (!treeNode.isParent || treeNode.editNameFlag || $("#refreshBtn_" + treeNode.tId).length > 0) return;
                    var addStr = "<span  id='refreshBtn_" + treeNode.tId
                        + "' title='刷新' onfocus='this.blur();' class='layui-icon'>&#xe9aa;</span>";
                    sObj.after(addStr);
                    var btn = $("#refreshBtn_" + treeNode.tId);
                    if (btn) btn.bind("click", function () {
                        treeRoom.reAsyncChildNodes(treeNode, 'refresh');
                        return false;
                    });
                }
                , removeHoverDom: function (treeId, treeNode) {
                    $("#refreshBtn_" + treeNode.tId).unbind().remove();
                }
                , selectedMulti: false
            }
            , async: {
                enable: true,
                url: getPlace,
                otherParam:{"token":function(){return session.getItem("token")}},
                dataFilter: function (treeId, parentNode, data) {
                	let checkCode = checkToken(data);
                    if(checkCode == "1005"){
                    	bindCourierTree.expandAll(false);
                    	bindCourierTree.refresh();
                    }else if(checkCode == "1004"){
                    	relogin(checkCode);
                    }
                	if (!data ) return null;
                	var childNodes;
                    if(data.code == 0 && parentNode.level == 0 ){
                 	   childNodes = forTreeAgentCommunityParentData(data.data);
                    }else if(data.code == 0 && parentNode.level == 1){
                 	   childNodes = forTreeAgentCommunityLevelOneData(data.data);
                    }else if(data.code == 0 && parentNode.level == 2){
                 	   childNodes = forTreeAgentCommunityLevelTwoData(data.data);
                    }else if(data.code == 0 && parentNode.level == 3){
                 	   childNodes = forTreeAgentCommunityLevelThreeData(data.data);
                    }else if(data.code == 0 && parentNode.level == 4){
                 	   childNodes = forTreeAgentCommunityLevelFourData(data.data);
                    }else if(data.code!=0){
                    	return null;
                    }
                    for (var i = 0, l = childNodes.length; i < l; i++) {
                        childNodes[i].isParent = childNodes[i].level < 4;
                    }
                    return childNodes; 
                }
            }
        }, {
            name: session.getItem("agencyName")
            , id: session.getItem("agencyId")
            , isParent: true
        });
    layui.form.on('submit(formSubmit)', function (data) {
       /*  if (!typeForm && data.field.roomId.length < 1) {
            buttons['choose']();
            return false;
        } */
        //console.log(data);
        let inboxAuth =null;
        if(data.field.userType=="3"){
        	inboxAuth = data.field.inboxAuth=="on"?"0":"1";
        }
        //console.log(inboxAuth);
        console.log(data.field.constructor);
        var url, postData = {
            userName: data.field.userName
            , userSex: data.field.userSex
            , constructors : data.field.constructors
            , phoneNo: data.field.phoneNo
            , idCard: data.field.idCard
            , inboxAuth:inboxAuth
            , validDate: data.field.validDate
            , expireDate: data.field.expireDate
            ,token:session.getItem("token")
        };
        console.log(postData);
        if (typeForm) {
            url = '../api/userManager/v1/updateAppUserInfo';
            postData.userId = data.field.userId;
            postData.faceValidDate = data.field.faceValidDate;
            postData.faceExpireDate = data.field.faceExpireDate;
        } else {
            url = '../api/userManager/v1/addAppUserInfo';
            postData.proprietId = data.field.proprietId;
            postData.userType = data.field.userType;
            postData.roomId = data.field.roomId;
            postData.ageId = session.getItem("agencyId");
        }
        var i = layer.load(2, {time: 5000});
        doAjax("post",url, postData,function (data) {
            layer.close(i);
            if (!data) return null;
            if (data.code == 0) {
                layer.msg("保存成功");
                if (typeForm)
                    table.reload('userTable');
                else
                    table.reload('userTable', {
                        page: {
                            curr: 1 //重新从第 1 页开始
                        }
                        , where: {userName: '', phoneNo: '', idCard: ''}
                    });
                layer.close(dialogIndex);
                userId.prop('value', '');
                userName.prop('value', '');
                phoneNo.prop('value', '');
                idCard.prop('value', '');
                validDate.prop('value', '');
                expireDate.prop('value', '');
                roomId.prop('value', '');
                roomName.text('请选择住所');
                unitName.text('请选择住所');
                bldName.text('请选择住所');
                commName.text('请选择住所');
                proprietName.text('请选择业主（可选）');
                faceDiv.hide('normal');
            } else {
                layer.msg(data.msg);
            }
        },function(err){
        	
        });
        
/*         $.post(url, postData, function (data) {
            layer.close(i);
            if (!data || checkLogin(data)) return null;
            if (data.code == 0) {
                layer.msg("保存成功");
                if (typeForm)
                    table.reload('userTable');
                else
                    table.reload('userTable', {
                        page: {
                            curr: 1 //重新从第 1 页开始
                        }
                        , where: {userName: '', phoneNo: '', idCard: ''}
                    });
                layer.close(dialogIndex);
                userId.prop('value', '');
                userName.prop('value', '');
                phoneNo.prop('value', '');
                idCard.prop('value', '');
                validDate.prop('value', '');
                expireDate.prop('value', '');
                roomId.prop('value', '');
                roomName.text('请选择住所');
                unitName.text('请选择住所');
                bldName.text('请选择住所');
                commName.text('请选择住所');
                proprietName.text('请选择业主（可选）');
                faceDiv.hide('normal');
            } else {
                layer.msg(data.msg);
            }
        }, 'json'); */
        return false;
    });
    
   layui.form.on('submit(formSubmitForCourier)', function (data) {
	  //console.log($('#courierId').val());
	   //console.log(backindex);
       let courierUserName = $("#courierUserName").val();
       let courierCard = $("#courierCard").val();
       let courierName = $("#courierName").val();
       let userIdForCourier = $("#userIdForCourier").val();
       let courierPhoneNo = $("#courierPhoneNo").val();
       let companyName = $("#companyName").val();
       let companyContacts = $("#companyContacts").val();
       let companyPhoneNo = $("#companyPhoneNo").val();
       let exigenceContactName = $("#exigenceContactName").val();
       let exigenceContactPhoneNo = $("#exigenceContactPhoneNo").val();
       let courierValidDate = $("#courierValidDate").val();
       let courierExpireDate = $("#courierExpireDate").val();
/*        let courierRoomId = $("#courierRoomId").val();
       if($('#courierId').val()==null || $('#courierId').val()==""){
           if(courierRoomId.length<1){
           	buttons['chooseCourier']();
               return layer.msg('请选择绑定位置！');
           }
       } */
       let courierSex = $("input[name='courierSex']:checked").val();
	   let adata = {token:session.getItem("token"),
				typeList:JSON.stringify(indexlist),
        		ageId : session.getItem("agencyId"),
        		procreatorId : session.getItem("userId"),
        		courierId:$('#courierId').val(),
        		frontImgUrl:$('#frontImgUrl').val(),
        		backImgUrl:$('#backImgUrl').val(),
        		courierUserName:courierUserName,
        		courierCard :courierCard,
        		userIdForCourier: userIdForCourier,
        		filekey:"no",
        		reqType:$('#reqType').val(),
        		courierPhoneNo:courierPhoneNo,
        		companyContacts : companyContacts,
        		companyPhoneNo : companyPhoneNo,
        		exigenceContactName : exigenceContactName,
        		exigenceContactPhoneNo : exigenceContactPhoneNo,
        		courierValidDate : courierValidDate,
        		courierExpireDate : courierExpireDate,
        		courierSex : courierSex,
        		companyName:companyName
        };
	   if(frontindex+backindex<1){
	        doAjax("post","../api/userManager/v1/addCourierInfoFile", adata,function (data) {
	        	if (!data) return null;
	            if (data.code == 0) {
	            	layer.closeAll('page');
                	layer.msg('保存成功');
                    table.reload('courierTable', {
                        page: {
                            curr: 1 //重新从第 1 页开始
                        }
                        , where: {userName: '', phoneNo: ''}
                    });
	            } else {
	                layer.msg(data.msg);
	            }
	        },function(err){
	        	
	        });
		   
/* 	        $.post("../api/userManager/v1/addCourierInfoFile", adata, function (data) {
	            //layer.close(i);
	            if (!data || checkLogin(data)) return null;
	            if (data.code == 0) {
	            	layer.closeAll('page');
                	layer.msg('保存成功');
                    table.reload('courierTable', {
                        page: {
                            curr: 1 //重新从第 1 页开始
                        }
                        , where: {userName: '', phoneNo: ''}
                    });
	            } else {
	                layer.msg(data.msg);
	            }
	        }, 'json'); */
	   }
      return false;
    }); 
    layui.form.on('radio(userType)', function (data) {
        userType = data.value;
    });
    $('.layui-btn[data-type]').on('click', function () {
        var type = $(this).data('type');
        buttons[type] ? buttons[type].call(this) : '';
    });
    layui.form.verify({
    	  username: function(value, item){ //value：表单的值、item：表单的DOM对象
    	  	    if(!new RegExp("^[a-zA-Z0-9_\u4e00-\u9fa5\\s·]+$").test(value)){
    	  	      return '用户名不能有特殊字符';
    	  	    }
    	  	    if(/(^\_)|(\__)|(\_+$)/.test(value)){
    	  	      return '用户名首尾不能出现下划线\'_\'';
    	  	    }
    	  	    if(/^\d+\d+\d$/.test(value)){
    	  	      return '用户名不能全为数字';
    	  	    }
    	  	    if(!/^[0-9a-zA-Z]+$/.test(value)){
    	  	      return '用户名只能是字母或者数字';
    	  	    }
    	  	    if(!/^.{6,20}$/.test(value)){
    	  	      return '用户名长度必须为6位及以上，20位以下';
    	  	    }
    	  	  },
    	phoneNoNew :function(value, item){
    		if(!/^1(3|4|5|6|7|8|9)\d{9}$/.test(value)){
  	  	      return '输入的手机号码格式不正确！';
  	  	    }
    	}
    	  	  
    });
    $("#courierPhoneNo").blur(function(){
    	let phone = $("#courierPhoneNo").val();
    	if(phone && /^1[34578]\d{9}$/.test(phone)){
    		let adata={};
    		adata.token = $.session.get("token");
    		adata.ageId = $.session.get("agencyId");
    		adata.phoneNo = phone;
	        doAjax("post","../api/userManager/v1/selectAppUserList", adata,function (data) {
    	        let userData = data.data[0];
    	        if(userData){
    	            //console.log(userData.userSex);
    	            $("#userIdForCourier").prop('value', userData.userId);
    	            $("#courierUserName").prop('value', userData.userName);
    	            $("#courierCard").prop('value', userData.idCard);
    	            switch (userData.userSex) {
    	            case '0':
    	            	//console.log(1534);
    	            	$("#manCourier").prop('checked',true);
    	                //$("#manCourier").click();
    	                break;
    	            case '1':
    	            	//console.log(1535);
    	            	$("#womanCourier").prop('checked',true);
    	            	//$("#womanCourier").click();
    	                break;
    	        	}
    	            //console.log(1536);
    	        }
	        },function(err){
	        	
	        });
/*     		$.post("../api/userManager/v1/selectAppUserList", adata, function (data) {
    	        //layer.close(i);
    	        console.log(data);
    	        let userData = data.data[0];
    	        if(userData){
    	            console.log(userData.userSex);
    	            $("#userIdForCourier").prop('value', userData.userId);
    	            $("#courierUserName").prop('value', userData.userName);
    	            $("#courierCard").prop('value', userData.idCard);
    	            switch (userData.userSex) {
    	            case '0':
    	            	console.log(1534);
    	            	$("#manCourier").prop('checked',true);
    	                //$("#manCourier").click();
    	                break;
    	            case '1':
    	            	console.log(1535);
    	            	$("#womanCourier").prop('checked',true);
    	            	//$("#womanCourier").click();
    	                break;
    	        	}
    	            console.log(1536);
    	        }
    	    }, 'json'); */
    	}else{
            $("#courierUserName").prop('value', '');
            $("#courierCard").prop('value', '');
            $("#manCourier").prop('checked',true);
    	}
    	layui.form.render('radio');
    });
/*     window.getAppUserForOnBlur =function (){
    	let phone = $("#courierPhoneNo").val();
    	if(phone && /^1[34578]\d{9}$/.test(phone)){
    		let adata={};
    		adata.token = $.session.get("token");
    		adata.ageId = $.session.get("agencyId");
    		adata.phoneNo = phone;
    		$.post("../api/userManager/v1/selectAppUserList", adata, function (data) {
    	        //layer.close(i);
    	        console.log(data);
    	        let userData = data.data[0];
    	        if(userData){
    	            console.log(userData.userSex);
    	            $("#courierUserName").prop('value', userData.userName);
    	            $("#courierCard").prop('value', userData.idCard);
    	            switch (userData.userSex) {
    	            case '0':
    	            	console.log(1534);
    	                $("#manCourier").click();
    	                break;
    	            case '1':
    	            	console.log(1535);
    	            	$("#womanCourier").click();
    	                break;
    	        	}
    	            layui.form.render('checkbox');
    	            console.log(1536);
    	        }
    	    }, 'json');
    	}else{
            $("#courierUserName").prop('value', '');
            $("#courierCard").prop('value', '');
             $("#manCourier").click();
    	}

    } */
});

</script>
<script type="text/html" id="barUser">
    <a class="layui-btn layui-btn-xs" lay-event="rooms">查看房间</a>
    <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
    <!--<a class="layui-btn layui-btn-xs" lay-event="check">审核</a>-->
</script>
<script type="text/html" id="barRoom">
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="unbindRoom">解绑</a>
</script>
<style>
#selectZtreeid {
	width: 25%;
	float: left;
	height: 100%;
}

#treeAgent {
	width: 50%
}

#treeAgentCommunity {
	width: 50%
}

#showtableid {
	width: 73%;
	float: right;
}

.layui-table-cell>span {
	text-align: center;
	display: block;
	
}
</style>
</head>
<body>
	<div id="treeCommunityDialog" class="site-block" style="display: none">
		<ul id="treeCommunity" class="ztree"></ul>
	</div>
	<div id="treeMachineDialog" class="site-block" style="display: none">
		<ul id="treeMachine" class="ztree"></ul>
	</div>
	<div class="child-body">
		<div id="selectZtreeid">
			<ul id="treeAgent" class="ztree layui-col-xs2"></ul>
			<ul id="treeAgentCommunity" class="ztree layui-col-xs2"></ul>
		</div>
		<div id="bindRoomDialog" class="site-block" style="display: none">
			<div class="layui-form">
				<div class="layui-form-item">
					<label class="layui-form-label">住户类型</label>
					<div class="layui-input-block">
						<input type="radio" name="userType" lay-filter="userType"
							value="0" title="业主" checked> <input type="radio"
							name="userType" lay-filter="userType" value="1" title="家属">
						<input type="radio" name="userType" lay-filter="userType"
							value="2" title="租客"> <input type="radio" name="userType"
							lay-filter="userType" value="3" title="物业">
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">指定房间</label>
					<div class="layui-input-block">
						<ul id="treeRoom" class="ztree"></ul>
					</div>
				</div>
			</div>
		</div>
		<div id="bindCourierDialog" class="site-block" style="display: none">
			<div class="layui-form">
				<div class="layui-form-item">
					<label class="layui-form-label">绑定位置</label>
					<div class="layui-input-block">
						<ul id="bindCourierTree" class="ztree"></ul>
					</div>
				</div>
			</div>
		</div>
		<div id="userDialog" class="site-block" style="display: none">
			<form class="layui-form">
				<input type="hidden" id="userId" name="userId"> <input
					type="hidden" id="roomId" name="roomId"> <input
					type="hidden" id="proprietId" name="proprietId">
				<!-- 指定房间业主 -->
				<div class="layui-form-item">
					<label class="layui-form-label">姓名</label>
					<div class="layui-input-block">
						<input type="text" id="userName" name="userName"
							lay-verify="required" placeholder="请输入名称" class="layui-input">
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">性别</label>
					<div class="layui-input-block">
						<input type="radio" id="male" name="userSex" value="0" title="男"
							checked> <input type="radio" id="female" name="userSex"
							value="1" title="女">
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">施工人员</label>
					<div class="layui-input-block">
						<input type="radio" id="nonConstructors" name="constructors" value="0" title="否"
							checked> <input type="radio" id="yesConstructors" name="constructors"
							value="1" title="是">
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">手机号码</label>
					<div class="layui-input-block">
						<input type="text" id="phoneNo" name="phoneNo"
							lay-verify="required|phoneNoNew" placeholder="请输入号码"
							class="layui-input">
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">身份证号</label>
					<div class="layui-input-block">
						<input type="text" id="idCard" name="idCard"
							lay-verify="required|identity" placeholder="请输入身份证号"
							class="layui-input">
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label" for="validDate">生效时间</label>
					<div class="layui-input-inline">
						<input type="text" class="layui-input" id="validDate"
							name="validDate">
					</div>
					<label class="layui-form-label" for="expireDate">结束时间</label>
					<div class="layui-input-inline">
						<input type="text" class="layui-input" id="expireDate"
							name="expireDate">
					</div>
				</div>
				<div id="place">
					<div class="layui-form-item">
						<label class="layui-form-label">住户类型</label>
						<div class="layui-input-block">
							<input type="radio" id="zhu" name="userType" value="0" title="业主"
								checked> <input type="radio" id="jia" name="userType"
								value="1" title="家属"> <input type="radio" id="ke"
								name="userType" value="2" title="租客"> <input
								type="radio" id="wu" name="userType" value="3" title="物业">
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">住所</label>
						<div class="layui-input-block">
							<button type="button" data-type="choose"
								class="layui-btn layui-btn-normal">选择住所/业主</button>
						</div>
						<div class="layui-input-block">
							<table class="layui-table" lay-size="sm">
								<colgroup>
									<col width="150">
									<col width="150">
									<col width="150">
									<col width="150">
									<col width="150">
								</colgroup>
								<thead>
									<tr>
										<th>小区</th>
										<th>楼栋</th>
										<th>单元</th>
										<th>房间</th>
										<th>业主（可选）</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td id="commName">请选择住所</td>
										<td id="bldName">请选择住所</td>
										<td id="unitName">请选择住所</td>
										<td id="roomName">请选择住所</td>
										<td id="proprietName">请选择业主（可选）</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
				<div id="inboxAuthDiv" class="layui-form-item" style="display: none;">
				    <label class="layui-form-label">收件箱权限</label>
				    <div class="layui-input-block">
				      <input type="checkbox"  id="inboxAuth" name="inboxAuth" lay-skin="switch" lay-text="开|关" >
				    </div>
				</div>
				<div id="doorAccess" class="layui-form-item" style="display: none;">
					<label class="layui-form-label">门禁支持</label>
					<div class="layui-input-block">
						<div style="border: 1px solid #eee; padding: 20px;">
							<div class="layui-form-item">
								<label class="layui-form-label">人脸识别</label>
								<div class=" layui-btn-container">
									<button type="button" data-type="machine" id="machine"
										class="layui-btn layui-btn-primary">选择人脸设备</button>
									<button type="button" data-type="setFace" id="setFace"
										class="layui-btn layui-btn-normal">录入人脸</button>
								</div>
								<div class="layui-input-block">
									<span id="setFaceP"></span>
								</div>
								<div id="faceDiv" style="display: none;">
									<div class="layui-input-block">
										<img id="facePic"
											style="width: 80px; height: 80px; margin: 5px">
									</div>
									<div class="layui-form-item">
										<label class="layui-form-label" for="faceValidDate">生效时间</label>
										<div class="layui-input-inline">
											<input type="text" class="layui-input" id="faceValidDate"
												name="faceValidDate">
										</div>
										<label class="layui-form-label" for="faceExpireDate">结束时间</label>
										<div class="layui-input-inline">
											<input type="text" class="layui-input" id="faceExpireDate"
												name="faceExpireDate">
										</div>
									</div>
								</div>
							</div>
							<!--<hr>-->
							<!--<div class="layui-form-item">-->
							<!--<label class="layui-form-label">刷身份证</label>-->
							<!--<div class="layui-input-block">-->
							<!--<input type="text" id="a"-->
							<!--placeholder="请刷身份证输入"-->
							<!--class="layui-input">-->
							<!--</div>-->
							<!--</div>-->
						</div>
					</div>
				</div>
				<div class="layui-input-block">
					<button id="formSubmit" class="layui-btn" lay-submit
						lay-filter="formSubmit">保存</button>
					<button type="button" data-type="cancel" id="formCancel"
						class="layui-btn">取消</button>
				</div>
			</form>
		</div>
		
		<div id="courierDialog" class="site-block" style="display: none">
			 <form class="layui-form"   id="CourierForm">
				<input type="hidden" id="courierId" name="courierId">
				<input type="hidden" id="userIdForCourier" name="userIdForCourier">
				<input type="hidden" id="reqType" name="reqType">
				<input type="hidden" id="frontImgUrl" name="frontImgUrl">
				<input type="hidden" id="backImgUrl" name="backImgUrl">
				 <input type="hidden" id="courierRoomId" name="courierRoomId">
				<!-- 指定房间业主 -->
				<div class="layui-form-item">
					<label class="layui-form-label">姓名</label>
					<div class="layui-input-block">
						<input type="text" id="courierUserName" name="courierUserName"
							placeholder="请输入用户名" class="layui-input">
					</div>
				</div>
<!-- 				<div class="layui-form-item">
					<label class="layui-form-label">姓名</label>
					<div class="layui-input-block">
						<input type="text" id="courierName" name="courierName"
							class="layui-input">
					</div>
				</div> -->
				<div class="layui-form-item">
					<label class="layui-form-label">性别</label>
					<div class="layui-input-block">
						<input type="radio" id="manCourier" name="courierSex" value="0" title="男"
							checked> <input type="radio" id="womanCourier" name="courierSex"
							value="1" title="女">
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">手机号码</label>
					<div class="layui-input-block">
						<input type="text" id="courierPhoneNo" name="courierPhoneNo"
							 placeholder="请输入号码"
							class="layui-input" >
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">身份证号</label>
					<div class="layui-input-block">
						<input type="text" id="courierCard" name="courierCard"
							lay-verify="required|identity" placeholder="请输入身份证号"
							class="layui-input">
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">公司名称</label>
					<div class="layui-input-block">
						<input type="text" id="companyName" name="companyName"

							class="layui-input">
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">公司联系人</label>
					<div class="layui-input-block">
						<input type="text" id="companyContacts" name="companyContacts"

							class="layui-input">
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">公司联系电话</label>
					<div class="layui-input-block">
						<input type="text" id="companyPhoneNo" name="companyPhoneNo"

							class="layui-input">
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">紧急联系人名称</label>
					<div class="layui-input-block">
						<input type="text" id="exigenceContactName" name="exigenceContactName"

							class="layui-input">
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">紧急联系人电话</label>
					<div class="layui-input-block">
						<input type="text" id="exigenceContactPhoneNo" name="exigenceContactPhoneNo"

							class="layui-input">
					</div>
				</div>
				<div class="layui-form-item">
				<label class="layui-form-label">身份证/工作证照片(正反面)</label>
		        <div class="layui-input-block">
		            <button type="button" class="layui-btn uploadImg"  data-type="upload0">选择图片正面</button>
		            <button type="button" class="layui-btn uploadImg"  data-type="upload1">选择图片反面</button>
		            <input type="hidden" id="backImgUrl" name="backImgUrl" value=""/>
		            <input type="hidden" id="frontImgUrl" name="frontImgUrl" value=""/>
		              <blockquote class="layui-elem-quote layui-quote-nm" style="margin-top: 10px;">
					    <div class="layui-upload-list" id="demo2"></div>
					 </blockquote>
		        </div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label" for="courierValidDate">生效时间</label>
					<div class="layui-input-inline">
						<input type="text" class="layui-input"  id="courierValidDate"
							name="courierValidDate">
					</div>
					<label class="layui-form-label" for="courierExpireDate">结束时间</label>
					<div class="layui-input-inline">
						<input type="text" class="layui-input"  id="courierExpireDate"
							name="courierExpireDate">
					</div>
				</div>
<!--  				<div id="place1">
					<div class="layui-form-item">
						<label class="layui-form-label">住所</label>
						<div class="layui-input-block">
							<button type="button" data-type="chooseCourier"
								class="layui-btn layui-btn-normal">选择住所/业主</button>
						</div>
						<div class="layui-input-block">
							<table class="layui-table" lay-size="sm">
								<colgroup>
									<col width="150">
									<col width="150">
									<col width="150">
									<col width="150">
								</colgroup>
								<thead>
									<tr>
										<th>小区</th>
										<th>楼栋</th>
										<th>单元</th>
										<th>房间</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td id="courierCommName">请选择小区</td>
										<td id="courierBldName">请选择楼栋</td>
										<td id="courierUnitName">请选择单元</td>
										<td id="courierRoomName">请选择房间号</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div> -->
				<div class="layui-input-block">
					<button id="formSubmitForCourier" class="layui-btn"  lay-submit
						lay-filter="formSubmitForCourier" ">保存</button>
					<button type="button" data-type="cancel" id="formCancel"
						class="layui-btn">取消</button>
				</div>
			 </form> 
		</div>
		
		<div id="roomDialog" style="display: none; padding: 5px">
			<table id="table_room" lay-filter="roomTable"></table>
		</div>
		<div id="showtableid">
			<div class="layui-form">
				<div class="layui-form-item">
					<div class="layui-inline">
						<select id="selectType">
							<option value="user">显示用户信息</option>
							<option value="courier">显示快递员数据</option>
						</select>
					</div>
					<div class="layui-inline">
						<select id="queryType">
							<option value="userName">根据用户名搜索</option>
							<option value="phoneNo">根据手机号搜索</option>
							<!--<option value="idCard">根据身份证搜索</option>-->
						</select>
					</div>
					<div class="layui-inline">
						<input class="layui-input" id="queryKey" placeholder="请输入关键字">
					</div>
					<button class="layui-btn" data-type="query">搜索</button>
					<button data-type="add" class="layui-btn layui-btn-normal">
						<i class="layui-icon">&#xe608;</i>添加新用户
					</button>
					<button data-type="addCourier" class="layui-btn layui-btn-primary">
						<i class="layui-icon">&#xe608;</i>添加快递员
					</button>
				</div>
			</div>
			<div id="tablecontenid">
				<table id="LAY_table_user" lay-filter="userTable"></table>
			</div>
			<div id="courierTableConten" style="display: none">
				<table id="LAY_table_courier" lay-filter="courierTable" ></table>
			</div>
			
		</div>
	</div>
</body>
</html>