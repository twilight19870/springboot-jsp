<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Date"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width" />
<script type="text/javascript" src="../js/selelogin.js"></script>
<script type="text/javascript"
	src="../js/check.js?v=<%= new Date().getTime() %>"></script>
<script src="../layui/layui.js"></script>
<script src="../js/jquery-3.3.1.js"></script>
<script src="../js/jquerysession.js"></script>
<link rel="stylesheet" href="../layui/css/layui.css" media="all">
<link rel="stylesheet"
	href="../css/style.css?v=<%= new Date().getTime() %>" media="all">
<title>管理员</title>
<script>
$(function(){
	selelogin();
	let menu = $.session.get('menu');
	let menujson = JSON.parse(menu);
	if(menujson["3"] != 2){
		$("#treeAgency").hide();
		$("#divfirst").addClass("layui-col-xs12");
	}else{
		$("#divfirst").addClass("layui-col-xs10");
	}
});
layui.config({
    base: "../js/"
}).use(['form', 'table', 'ztree'], function () {
    var $ = layui.$, time
        , treeMenuDialog = $('#treeMenuDialog')
        , treeMenu = $("#treeMenu")
        , treeMachineDialog = $('#treeMachineDialog')
        , userDialog = $('#userDialog')
        , table = layui.table
        , deptDialog = $('#deptDialog')
        , roleDialog = $('#roleDialog')
        , accountsName = $('#accountsName')
        , userName = $('#userName')
        , male = $('#male')
        ,session = window.sessionStorage
        , female = $('#female')
        , phoneNo = $('#phoneNo')
        , adminA = $('#adminA')
        , adminB = $('#adminB')
        , idCard = $('#idCard')
        , agency = $('#agency')
        , queryType = $('#queryType')
        , queryKey = $('#queryKey')
        , roleId = $('#roleId')
        , deptId = $('#deptId')
        , role = $('#role'), roleInit = true
        , dept = $('#dept'), deptInit = true
        , typeForm = 0
        , dialogIndex
        , roleIndex
        , deptIndex
        , timeout
        , curUser
        , buttons = {
            add: function () {
                typeForm = 0;
                agency.prop('value', curAgency.ageName);
                $("#accountsName").removeAttr("readonly");
                dialogIndex = layer.open({
                    type: 1
                    , maxmin: true
                    , title: '添加管理员'
                    , content: userDialog
                    , area: ['700px', '620px']
                });
                // layer.full(dialogIndex);
            }
            , edit: function (tobj) {
                typeForm = 1;
                curUser = tobj.data;
                $("#accountsName").attr("readonly", "readonly");
                dialogIndex = layer.open({
                    type: 1
                    , maxmin: true
                    , title: '修改管理员信息'
                    , content: userDialog
                    , area: ['700px', '620px']
                    , end: function () {
                        clearTimeout(timeout);
                    }
                });
                // layer.full(dialogIndex);
                agency.prop('value', tobj.data.ageName);
                deptId.prop('value', tobj.data.deptId);
                roleId.prop('value', tobj.data.roleId);
                dept.text(tobj.data.deptName ? tobj.data.deptName : '选择部门');
                role.text(tobj.data.roleName ? tobj.data.roleName : '选择角色');
                accountsName.prop('value', tobj.data.accountsName);
                userName.prop('value', tobj.data.userName);
                switch (tobj.data.userSex) {
                    case '0':
                        male.click();
                        break;
                    case '1':
                        female.click();
                        break;
                }
                switch (tobj.data.userType) {
                    case '0':
                        adminA.click();
                        break;
                    case '1':
                        adminB.click();
                        break;
                }
                layui.form.render('radio');
                phoneNo.prop('value', tobj.data.phoneNo);
                idCard.prop('value', tobj.data.idCard);
            }
            , del: function (tobj) {
                layer.open({
                    type: 0
                    , content: "确定删除管理员：" + tobj.data.userName + '(' + tobj.data.accountsName + ')' + "?"
                    , shadeClose: true
                    , yes: function (index, layero) {
                        var i = layer.load(2, {time: 5000});
                        doAjax("post",'../api/userManager/v1/deleteUserById',
                        		{userId: tobj.data.id,token:session.getItem("token")},function (data) {
                       			 layer.close(i);
                                 if (data.code == 0) {
                                     layer.msg("删除成功");
                                     tobj.del();
                                 } else {
                                     layer.msg(data.msg);
                                 }
                        },function(err){
                        	
                        });
                        
/*                         $.post('../api/userManager/v1/deleteUserById', {userId: tobj.data.id,token:session.getItem("token")}, function (data) {
                            layer.close(i);
                            checkForDataCode(data);
                            if (!data /* || checkLogin(data) *//* ) return null;
                            if (data.code == 0) {
                                layer.msg("删除成功");
                                tobj.del();
                            } else {
                                layer.msg(data.msg);
                            }
                        }, 'json');  */
                    }
                });
            }
            , authority: function (tobj) {
                curUser = tobj.data;
                var i = layer.load(2, {time: 5000});
                //console.log("curUser:"+JSON.stringify(curUser));
                //console.log("userId:"+curUser.id);
                doAjax("post",'../api/userManager/v1/selectUserMenuList',
                		{"userId":curUser.id,"token":session.getItem("token")},function (data) {
                            layer.close(i);
                            if (!data /* || checkLogin(data) */) return null;
                            if (data.data) {
                                var menus = JSON.parse(window.localStorage.getItem('menus')), temp;
                                //console.log("menus:"+JSON.stringify(menus));
                                //console.log("data.data:"+JSON.stringify(data.data));
                                for (var j = 0; j < menus.length; j++) {
                                	//console.log(menus[j].id);
                                	//console.log(menus[j]);
                                	if(session.getItem("userId") != 20){
                                		if(menus[j].id == 48){
                                			if(menus[j].permission =="2"){
                                				menus[j].permission = "1";
                                			}
                                		}
                                	}
                                    for (var k = 0; k < data.data.length; k++) {
                                        if (menus[j].id == data.data[k].menuId) {
                                            temp = data.data.splice(k, 1)[0];
                                            break;
                                        }
                                    }
                                    if (temp) {
                                        menus[j].permissionId = temp.permissionId;
                                    } else {
                                        menus[j].permissionId = 0;
                                    }
                                    temp = null;
                                }
                                //console.log("menus:"+JSON.stringify(menus));
                                var treeobj = $.fn.zTree.init(treeMenu, {
                                    view: {
                                        selectedMulti: false
                                    }
                                    , data: {
                                        simpleData: {
                                            enable: true
                                        }
                                    }
                                    , callback: {
                                        onClick: function (event, treeId, treeNode) {
                                            layui.table.reload('menuTable', {data: treeobj.transformToArray(treeNode)});
                                        }
                                    }
                                }, menus);
                                layui.table.render({
                                    elem: '#table_menu'
                                    , cols: [[
                                        {
                                            title: '序号', type: 'numbers'
                                        }
                                        , {title: '菜单名称', field: 'name', width: 220}
                                        , {
                                            title: '操作设置', align:'center', templet: function (d) {
                                                return '<input type="radio"  name="' + d.id + '" lay-filter="permission" value="0" title="禁止"' + (d.permissionId == '0' ? 'checked' : '') + '>' +
                                                    '<input type="radio" name="' + d.id + '" lay-filter="permission" value="1" title="可访问"' + (d.permissionId == '1' ? 'checked' : '') + '>'
                                                    + '<input type="radio" name="' + d.id + '" lay-filter="permission" value="2" title="可修改"' + (d.permissionId == '2' ? 'checked' : '') + ' ' + (d.permission == '2' ? '' : 'disabled="disabled"') + '>';
                                            }, width: 240
                                        }
                                    ]]
                                    , id: 'menuTable'
                                    , page: true
                                    , height: '330px'
                                    , data: menus
                                });
                                layui.form.on('radio(permission)', function (obj) {
                                    treeobj.getNodeByParam('id', this.name, null).permissionId = this.value;
                                });
                                layer.open({
                                    type: 1
                                    , content: treeMenuDialog
                                    , title: '菜单授权:' + curUser.userName
                                    , area: ['700px', '500px']
                                    , shadeClose: true
                                    , end: function () {
                                        treeobj.destroy();
                                    }
                                    , btn: ['保存']
                                    , yes: function (index, layero) {
                                        var i = layer.load(2, {time: 5000});
                                        var nodes = treeobj.getNodes(), data = [];
                                        for (var j = 0; j < nodes.length; j++) {
                                            if (nodes[j].permission != 0)
                                                data.push({menuId: nodes[j].id, permissionId: nodes[j].permissionId});
                                        }
                                        doAjax("post",
                                        		"../api/userManager/v1/addUserMenuInfo",{
                                            "userId": curUser.id,
                                            "data": JSON.stringify(data),
                                            "token":session.getItem("token")
                                        },function (data) {
                                        	layer.close(i);
                                            if (!data /* || checkLogin(data) */) return null;
                                            if (data.code == 0) {
                                                layer.msg("授权成功");
                                                layer.close(index);
                                            } else {
                                                layer.msg(data.msg);
                                            }
                                        },function(err){
                                            layer.close(i);
                                            layer.msg("授权失败");
                                        });
                                        
/*                                         $.ajax({
                                            type: "post",
                                            data: {
                                                "userId": curUser.id,
                                                "data": JSON.stringify(data),
                                                "token":session.getItem("token")
                                            },
                                            url: "../api/userManager/v1/addUserMenuInfo",
                                            dataType: "json",
                                            success: function (data) {
                                                layer.close(i);
                                                checkForDataCode(data);
                                                if (!data /* || checkLogin(data) *//* ) return null; */
                                              /*   if (data.code == 0) {
                                                    layer.msg("授权成功");
                                                    layer.close(index);
                                                } else {
                                                    layer.msg(data.msg);
                                                }
                                            },
                                            error: function () {
                                                layer.close(i);
                                                layer.msg("授权失败");
                                            }
                                        }); */ 
                                    }
                                });
                            }
		        },function(err){
		        	
		        });
   /*              $.post('../api/userManager/v1/selectUserMenuList', {"userId":curUser.id,"token":session.getItem("token")}, function (data) {
                    layer.close(i);
                    checkForDataCode(data);
                    if (!data /* || checkLogin(data) *//* ) return null;
                    if (data.data) {
                        var menus = JSON.parse(window.localStorage.getItem('menus')), temp;
                        //console.log("menus:"+JSON.stringify(menus));
                        //console.log("data.data:"+JSON.stringify(data.data));
                        for (var j = 0; j < menus.length; j++) {
                        	//console.log(menus[j].id);
                            for (var k = 0; k < data.data.length; k++) {
                                if (menus[j].id == data.data[k].menuId) {
                                    temp = data.data.splice(k, 1)[0];
                                    break;
                                }
                            }
                            if (temp) {
                                menus[j].permissionId = temp.permissionId;
                            } else {
                                menus[j].permissionId = 0;
                            }
                            temp = null;
                        }
                        //console.log("menus:"+JSON.stringify(menus));
                        var treeobj = $.fn.zTree.init(treeMenu, {
                            view: {
                                selectedMulti: false
                            }
                            , data: {
                                simpleData: {
                                    enable: true
                                }
                            }
                            , callback: {
                                onClick: function (event, treeId, treeNode) {
                                    layui.table.reload('menuTable', {data: treeobj.transformToArray(treeNode)});
                                }
                            }
                        }, menus);
                        layui.table.render({
                            elem: '#table_menu'
                            , cols: [[
                                {
                                    title: '序号', type: 'numbers'
                                }
                                , {title: '菜单名称', field: 'name', width: 220}
                                , {
                                    title: '操作设置', align:'center', templet: function (d) {
                                        return '<input type="radio"  name="' + d.id + '" lay-filter="permission" value="0" title="禁止"' + (d.permissionId == '0' ? 'checked' : '') + '>' +
                                            '<input type="radio" name="' + d.id + '" lay-filter="permission" value="1" title="可访问"' + (d.permissionId == '1' ? 'checked' : '') + '>'
                                            + '<input type="radio" name="' + d.id + '" lay-filter="permission" value="2" title="可修改"' + (d.permissionId == '2' ? 'checked' : '') + ' ' + (d.permission == '2' ? '' : 'disabled="disabled"') + '>';
                                    }, width: 240
                                }
                            ]]
                            , id: 'menuTable'
                            , page: true
                            , height: '330px'
                            , data: menus
                        });
                        layui.form.on('radio(permission)', function (obj) {
                            treeobj.getNodeByParam('id', this.name, null).permissionId = this.value;
                        });
                        layer.open({
                            type: 1
                            , content: treeMenuDialog
                            , title: '菜单授权:' + curUser.userName
                            , area: ['700px', '500px']
                            , shadeClose: true
                            , end: function () {
                                treeobj.destroy();
                            }
                            , btn: ['保存']
                            , yes: function (index, layero) {
                                var i = layer.load(2, {time: 5000});
                                var nodes = treeobj.getNodes(), data = [];
                                for (var j = 0; j < nodes.length; j++) {
                                    if (nodes[j].permission != 0)
                                        data.push({menuId: nodes[j].id, permissionId: nodes[j].permissionId});
                                }
                                $.ajax({
                                    type: "post",
                                    data: {
                                        "userId": curUser.id,
                                        "data": JSON.stringify(data),
                                        "token":session.getItem("token")
                                    },
                                    url: "../api/userManager/v1/addUserMenuInfo",
                                    dataType: "json",
                                    success: function (data) {
                                        layer.close(i);
                                        checkForDataCode(data);
                                        if (!data  *//* || checkLogin(data) *//* ) return null;
                                        if (data.code == 0) {
                                            layer.msg("授权成功");
                                            layer.close(index);
                                        } else {
                                            layer.msg(data.msg);
                                        }
                                    },
                                    error: function () {
                                        layer.close(i);
                                        layer.msg("授权失败");
                                    }
                                });
                            }
                        });
                    }
                });  */ 
            }
            
            , query: function () {
                var where = {userName: '', phoneNo: '', idCard: ''};
                where[queryType.val()] = queryKey.val();
                layui.table.reload('userTable', {
                    page: {
                        curr: 1 //重新从第 1 页开始
                    }
                    , where: where
                });
            }
            , cancel: function () {
                layer.close(dialogIndex);
            }
            , dept: function () {
                if (deptInit) {
                    //deptInit = false;
                    layui.table.render({
                        elem: '#table_dept'
                        , url: '../api/deptManager/v1/selectDepartmentList'
                        , cols: [[
                            {
                                title: '序号', type: 'numbers'
                            }
                            , {title: '部门名称', field: 'deptName', sort: true, width: 200}
                            , {title: '添加时间', field: 'createTime', sort: true, width: 200}
                            , {title: '操作', align: 'center', toolbar: '#barChoose', fixed: 'right', width: 236}
                        ]]
                        , id: 'deptTable'
                        , page: true
                        , width: '700px'
                        , height: '400px'
                        ,contentType:'application/x-www-form-urlencoded'
                        , method: "post"
                        , where: {
                            ageId: curAgency.ageId,
                            token:function(){
                            	return session.getItem("token");
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
                                 		"data":res.data.deptList
                                 	}
                        		}else if(checkCode == "1005"){
                        			table.reload('deptTable', {
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
                             		"data":res.data.deptList
                             	}
                        	}
                        }
                        , done: function (res, curr, count) {
                            //checkLogin(res);
                            checkForDataCode(res);
                        }
                    });
                    layui.table.on('tool(deptTable)', function (obj) {
                        dept.text(obj.data.deptName);
                        deptId.prop('value', obj.data.deptId);
                        layer.close(deptIndex);
                    });
                }
                deptIndex = layer.open({
                    type: 1
                    , shadeClose: true
                    , maxmin: true
                    , title: '请选择部门'
                    , content: deptDialog
                    , area: ['700px', '500px']
                });
            }
            , role: function () {
                if (roleInit) {
                    //roleInit = false;
                    layui.table.render({
                        elem: '#table_role'
                        , url: '../api/roleManager/v1/selectRoleList'
                        , cols: [[
                            {
                                title: '序号', type: 'numbers'
                            }
                            , {title: '角色名称', field: 'roleName', sort: true, width: 200}
                            , {title: '添加时间', field: 'createTime', sort: true, width: 200}
                            , {title: '', align: 'center', toolbar: '#barChoose', fixed: 'right', width: 236}
                        ]]
                        , id: 'roleTable'
                        , page: true
                        , width: '700px'
                        , height: '400px'
                        ,contentType:'application/x-www-form-urlencoded'
                        , method: "post"
                        , where: {
                            ageId: curAgency.ageId,
                            token:function(){
                            	return session.getItem("token");
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
                                 		"data":res.data.roleList
                                 	}
                        		}else if(checkCode == "1005"){
                        			table.reload('roleTable', {
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
                             		"data":res.data.roleList
                             	}
                        	}
                        }
                        , done: function (res, curr, count) {
                            //checkLogin(res);
                            checkForDataCode(res);
                        }
                    });
                    layui.table.on('tool(roleTable)', function (obj) {
                        role.text(obj.data.roleName);
                        roleId.prop('value', obj.data.roleId);
                        layer.close(roleIndex);
                    });
                }
                roleIndex = layer.open({
                    type: 1
                    , shadeClose: true
                    , maxmin: true
                    , title: '请选择角色'
                    , content: roleDialog
                    , area: ['700px', '500px']
                });
            }
        },
	    checkForDataCode = function(data){
			if(!data.msg){
				data =  JSON.parse(data);
			}
			if(data.code == '1003'){
				layer.open({
	          		 content: '登录信息已过期,请重新登录!'
	          		  ,btn: ['确定']
	          		  ,closeBtn: 0
	          		  ,yes: function(index, layero){
	          			  outlogin();
	          		  }
	          		}); 
			}
		}
    
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
                url: "../php/api.php?action=getMacMain",
                autoParam: ["id", "level"],
                otherParam: {"ageId": session.getItem("agencyId")},
                dataFilter: function (treeId, parentNode, data) {
                	checkForDataCode(data);
                   if (!data || /* checkLogin(data) || */ !data.data) return null;
                    var childNodes = data.data;
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
        curAgency = {ageId: session.getItem("agencyId"), ageName: session.getItem("agencyName")}
        , treeAgency = $.fn.zTree.init($("#treeAgency"), {
            view: {
                addHoverDom: function (treeId, treeNode) {
                    var sObj = $("#" + treeNode.tId + "_span");
                    if (!treeNode.isParent || treeNode.editNameFlag || $("#refreshBtn_" + treeNode.tId).length > 0) return;
                    var addStr = "<span  id='refreshBtn_" + treeNode.tId
                        + "' title='刷新' onfocus='this.blur();' class='layui-icon'>&#xe9aa;</span>";
                    sObj.after(addStr);
                    var btn = $("#refreshBtn_" + treeNode.tId);
                    if (btn) btn.bind("click", function () {
                        treeAgency.reAsyncChildNodes(treeNode, 'refresh');
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
                url: "../api/agencyManager/v1/selectSystemAgencyList",
                autoParam: ["ageId=parentAgeId"],
                otherParam:{"token":function(){return session.getItem("token")}},
                dataFilter: function (treeId, parentNode, data) {
                	let checkCode = checkToken(data);
                    if(checkCode == "1005"){
                    	treeAgency.expandAll(false);
                    	treeAgency.refresh();
                    }else if(checkCode == "1004"){
                    	relogin(checkCode);
                    }
                    if (!data || /* checkLogin(data) || */ !data.data) return null;
                    var childNodes = data.data;
                    for (var i = 0, l = childNodes.length; i < l; i++) {
                        childNodes[i].isParent = true;
                    }
                    return childNodes;
                }
            }
            , data: {
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
                    curAgency = treeNode;
                    deptInit = roleInit = true;
                    reloadTable();
                }
            }
        }, {
            ageName: session.getItem("agencyName")
            , ageId: session.getItem("agencyId")
            , isParent: true
        });
    curAgency = treeAgency.getNodes()[0];
    var reloadTable = function () {
        layui.table.render({
            elem: '#LAY_table_user'
            , url: '../api/userManager/v1/selectUserList'
            , cols: [[
                {
                    title: '序号', type: 'numbers'
                }
                , {title: '管理员名称', field: 'userName', width: 120, sort: true}
                , {title: '登录账号', field: 'accountsName', width: 120, sort: true}
                , {
                    title: '性别', field: 'userSex', width: 70, sort: true, templet: function (d) {
                        return d.userSex == '0' ? '男' : '女';
                    }
                }
                , {title: '手机号', field: 'phoneNo', width: 118, sort: true}
                , {title: '身份证', field: 'idCard', sort: true}
                , {title: '部门', field: 'deptName', sort: true}
                , {title: '角色', field: 'roleName', sort: true}
                , {title: '添加时间', field: 'createTime', sort: true}
                , {title: '添加人', field: 'procreatorName', sort: true}
                , {title: '操作管理', align: 'center', toolbar: '#barUser', fixed: 'right', width: 180}
            ]]
            , id: 'userTable'
            , page: true
            , height: 'full-120'
            ,contentType:'application/x-www-form-urlencoded'
            , method: "post"
            , where: {
                ageId: curAgency.ageId,
                token:function(){
                	return session.getItem("token");
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
                     		"data":res.data.userList
                     	}
            		}else if(checkCode == "1005"){
	   	        		reloadTable();
	   	        	 }
            	}else if(res.code ==1004 ||res.code ==1003||res.code ==1002){
            		relogin(res);
            	}else{
            		return {
                 		"code":res.code,
                 		"msg":res.msg,
                 		"count":res.data.total,
                 		"data":res.data.userList
                 	}
            	}
            }
            , done: function (res, curr, count) {
                //checkLogin(res);
                checkForDataCode(res);
            }
        });
        layui.table.on('tool(userTable)', function (obj) {
            if (buttons[obj.event]) buttons[obj.event](obj);
        });
    };
    reloadTable();

    layui.form.on('submit(formSubmit)', function (data) {
        var url;
        if (typeForm) {
            url = '../api/userManager/v1/updateUserById';
            data.field.userId = curUser.id;
            data.field.token = session.getItem("token");
        } else {
            url = '../api/userManager/v1/addUserInfo';
            data.field.ageId = curAgency.ageId;
            data.field.token = session.getItem("token");
            data.field.procreatorId = session.getItem("id");
            data.field.birthday = '1970-01-01';
        }
        // data.field.userType = 1;
        var i = layer.load(2, {time: 5000});
        doAjax("post",url,data.field,function (data) {
        	layer.close(i);
            if (!data) return null;
            if (data.code == 0) {
                layer.msg("保存成功");
                layui.table.reload('userTable');
                layer.close(dialogIndex);
                userName.prop('value', '');
                phoneNo.prop('value', '');
                idCard.prop('value', '');
                deptId.prop('value', '0');
                roleId.prop('value', '0');
                dept.text('选择部门');
                role.text('选择角色');
            } else {
                layer.msg(data.msg);
            }
        },function(err){
        	
        });
/*         $.post(url, data.field, function (data) {
            layer.close(i);
            checkForDataCode(data);
            //if (!data || checkLogin(data)) return null;
            if (data.code == 0) {
                layer.msg("保存成功");
                layui.table.reload('userTable');
                layer.close(dialogIndex);
                userName.prop('value', '');
                phoneNo.prop('value', '');
                idCard.prop('value', '');
                deptId.prop('value', '0');
                roleId.prop('value', '0');
                dept.text('选择部门');
                role.text('选择角色');
            } else {
                layer.msg(data.msg);
            }
        }, 'json'); */
        return false;
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
  	  }
  	  
  	});
});
</script>
<script type="text/html" id="barUser">
{{# 
 if(window.sessionStorage.getItem("accountsName") =="smtAdmin" || d.id !=20 ){ }}
	<a class="layui-btn layui-btn-xs" lay-event="authority">授权</a>
{{#  } }}
    <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
</script>
<script type="text/html" id="barChoose">
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="none">选中</a>
</script>
<style type="text/css">
.layui-table-view .layui-form-radio{
	    line-height: 1.5;
}
</style>
</head>
<body>
<div class="child-body">
    <div id="treeMenuDialog" style="display: none;padding: 5px">
        <ul id="treeMenu" class="ztree layui-col-xs3" style="height: 390px"></ul>
        <div class="layui-col-xs9" style="padding-left: 5px">
            <table id="table_menu" lay-filter="menuTable"></table>
        </div>
    </div>
    <div id="treeMachineDialog" class="site-block" style="display: none">
        <ul id="treeMachine" class="ztree"></ul>
    </div>
    <div id="userDialog" class="site-block" style="display: none">
        <form class="layui-form">
            <input type="hidden" id="roleId" name="roleId" value="0">
            <input type="hidden" id="deptId" name="deptId" value="0">
            <div class="layui-form-item">
                <label class="layui-form-label">代理商</label>
                <div class="layui-input-block">
                    <input type="text" id="agency" class="layui-input layui-disabled" disabled="disabled">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">管理员类型</label>
                <div class="layui-input-block">
                    <input type="radio" id="adminA" name="userType" value="0" title="一般管理员" checked>
                    <input type="radio" id="adminB" name="userType" value="1" title="代理商管理员">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">登录账号</label>
                <div class="layui-input-block">
                    <input type="text" id="accountsName" name="accountsName" lay-verify="required|username"
                           placeholder="请输入账号" class="layui-input" >
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">姓名</label>
                <div class="layui-input-block">
                    <input type="text" id="userName" name="userName"  lay-verify="required"
                           placeholder="请输入名称" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">性别</label>
                <div class="layui-input-block">
                    <input type="radio" id="male" name="userSex" value="0" title="男" checked>
                    <input type="radio" id="female" name="userSex" value="1" title="女">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">手机号码</label>
                <div class="layui-input-block">
                    <input type="text" id="phoneNo" name="phoneNo" lay-verify="required|phone"
                           placeholder="请输入号码" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">身份证号</label>
                <div class="layui-input-block">
                    <input type="text" id="idCard" name="idCard" lay-verify="required|identity"
                           placeholder="请输入身份证号"
                           class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">部门</label>
                <div class="layui-input-block">
                    <button type="button" data-type="dept" id="dept"
                            class="layui-btn layui-btn-primary">
                        选择部门
                    </button>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">角色</label>
                <div class="layui-input-block">
                    <button type="button" data-type="role" id="role"
                            class="layui-btn layui-btn-primary">
                        选择角色
                    </button>
                </div>
            </div>
            <div class="layui-input-block">
                <button id="formSubmit" class="layui-btn" lay-submit lay-filter="formSubmit">保存
                </button>
                <button type="button" data-type="cancel" id="formCancel" class="layui-btn">取消</button>
            </div>
        </form>
    </div>
    <div id="deptDialog" style="display: none;padding: 5px">
        <table id="table_dept" lay-filter="deptTable"></table>
    </div>
    <div id="roleDialog" style="display: none;padding: 5px">
        <table id="table_role" lay-filter="roleTable"></table>
    </div>
    <ul id="treeAgency" class="ztree layui-col-xs2"></ul>
    <div id="divfirst"  style="padding-left: 5px">
        <div class="layui-form" style="margin: 10px">
            <div class="layui-form-item">
                <!--<div class="layui-inline">-->
                <!--<select id="queryType">-->
                <!--<option value="userName">根据名称搜索</option>-->
                <!--&lt;!&ndash;<option value="phoneNo">根据手机号搜索</option>&ndash;&gt;-->
                <!--&lt;!&ndash;<option value="idCard">根据身份证搜索</option>&ndash;&gt;-->
                <!--</select>-->
                <!--</div>-->
                <!--<div class="layui-inline">-->
                <!--<input class="layui-input" id="queryKey" placeholder="请输入关键字">-->
                <!--</div>-->
                <!--<button class="layui-btn" data-type="query">搜索</button>-->
                <button data-type="add" class="layui-btn layui-btn-normal"><i class="layui-icon">&#xe608;</i>添加管理员
                </button>
            </div>
        </div>
        <table id="LAY_table_user" lay-filter="userTable"></table>
    </div>
</div>
</body>
</html>