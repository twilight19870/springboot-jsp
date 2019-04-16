<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Date"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width" />
<script type="text/javascript" src="../js/selelogin.js?v=<%=new Date().getTime() %>"></script>
<script type="text/javascript"
	src="../js/check.js?v=<%=new Date().getTime() %>"></script>
<script src="../layui/layui.js"></script>
<script src="../js/jquery-3.3.1.js"></script>
<script src="../js/jquerysession.js"></script>
<link rel="stylesheet" href="../layui/css/layui.css" media="all">
<link rel="stylesheet"
	href="../css/style.css?v=<%= new Date().getTime() %>" media="all">
<title>分配设备</title>
<script type="text/javascript">
$(function(){
	selelogin();
	let menu = $.session.get('menu');
	let menujson = JSON.parse(menu);
	if(menujson["48"] != 2){
		$("#addDevice").hide();
		$("#bacth").hide();
		$("#downBut").hide();
	}
});
layui.config({
    base: "../js/"
}).use(['element', 'layer','form', 'table', 'ztree','upload'], function () {
    var $ = layui.$
        , macDialog = $('#macDialog')
        , statusDialog = $('#statusDialog')
        , secretDialog = $('#secretDialog')
        , table = layui.table
        , invalid = $('#invalid')
        , active = $('#active')
        , freeze = $('#freeze')
        , jin = $('#jin')
        , disable = $('#disable')
        , enable = $('#enable')
        , doorPhoneMac = $('#doorPhoneMac')
        , doorPhoneSerialId = $('#doorPhoneSerialId')
        , doorPhoneName = $('#doorPhoneName')
        , queryType = $('#queryType')
        , queryKey = $('#queryKey')
        , password = $('#password')
        , commName = $('#commName')
        , commId = $('#commId')
        , bldName = $('#bldName')
        , bldId = $('#bldId')
        , unitName = $('#unitName')
        , unitId = $('#unitId')
        , allCount = $('#allCount')
        , onlineCount = $('#onlineCount')
        , offlineCount = $('#offlineCount')
        ,chupin = $('#chupin')
        ,feichupin = $('#feichupin')
        ,shou = $('#shou')
        ,hengpin = $('#hengpin')
        ,shupin = $('#shupin')
        ,screenSize = $(":input[name='screenSize']")
        , typeForm = 0
        ,session = window.sessionStorage
        , dialogIndex
        , statusIndex
        , macObjT
        , ageData
        , allotData
        ,upload = layui.upload
        , buttons = {
    		allot: function(){
    			let data = table.checkStatus('macTable').data;
    			allotData = data;
    			//console.log(data);
    			$("#menjink1").empty();
    			$("#shoujiank1").empty();
    			let men=0;
    			let men_data={};
    			let shou_data={};
    			for(let i=0;i<data.length;i++){
    					switch(data[i].deviceType){
    					case '0':
    						if(!men_data[data[i].screenSize+'寸'+(data[i].touchScreen==0?"触屏":"非触屏")+"-"+(data[i].screenType==0?"横屏":"竖屏")]){
    							men_data[data[i].screenSize+'寸'+(data[i].touchScreen==0?"触屏":"非触屏")+"-"+(data[i].screenType==0?"横屏":"竖屏")]=1;
    						}else{
    							men_data[data[i].screenSize+'寸'+(data[i].touchScreen==0?"触屏":"非触屏")+"-"+(data[i].screenType==0?"横屏":"竖屏")]++;
    						}
    						break;
    					case '1':
    						if(!shou_data[data[i].screenSize+'寸'+(data[i].touchScreen==0?"触屏":"非触屏")+"-"+(data[i].screenType==0?"横屏":"竖屏")]){
    							shou_data[data[i].screenSize+'寸'+(data[i].touchScreen==0?"触屏":"非触屏")+"-"+(data[i].screenType==0?"横屏":"竖屏")]=1;
    						}else{
    							shou_data[data[i].screenSize+'寸'+(data[i].touchScreen==0?"触屏":"非触屏")+"-"+(data[i].screenType==0?"横屏":"竖屏")]++;
    						}
    						break;
    					}
    			}
    			for(let i in men_data){
    				//console.log(i);
    				//console.log(men_data[i]);
    				$("#menjink1").append("<p class='layui-col-md9'>"+i+":"+"</p>");
    				$("#menjink1").append("<p class='layui-col-md3'>"+"X"+men_data[i]+"</p>");
    			}
       			for(let i in shou_data){
    				$("#shoujiank1").append("<p class='layui-col-md9'>"+i+":"+"</p>");
    				$("#shoujiank1").append("<p class='layui-col-md3'>"+"X"+shou_data[i]+"</p>");
    			}
    			selectAllot = layer.open({
                    type: 1
                    , maxmin: true
                    , title: '分配设备名单'
                    , content: $("#table2-div")
                    , area: ['700px', '600px']
                });
    		},
    		allotbutton: function(){
    			if(!allotData || !allotData.length> 0){
    				layer.msg("请选择分配设备");
    				return false;
    			}
    			if(!ageData){
    				layer.msg("请选择的代理商");
    				return false;
    			}
    			//console.log(allotData);
    			//console.log(ageData);
    			doAjax("post","../api/doorManager/v1/allotDeviceInfo",{"allotData": JSON.stringify(allotData),
    				"ageData": JSON.stringify(ageData),"token":session.getItem("token")},function (data) {
    					if(data.code == '0'){
    						   layer.msg("设备分配成功！");
    						   layer.close(selectAllot);
    						   reloadTable();
    					   }else if(data.code == '4003'){
    						   let datas = data.data;
    						   //console.log(datas);
    						   layer.close(selectAllot);
    					    	  var reTable = layer.open({
    						            type: 1,
    						            content: $("#tableret-div"), 
    						            title : '已分配的数据，确定要重新分配吗？',
    						            area: ['800px', '620px'],
    						            btn: ['重新分配', '取消'],
    						      		success: function(layero, index){
    						      			table.render({
    						      	    	  elem: '#tableret'
    						      	    	  ,cols: [[
    						      	              {field: 'doorPhoneName', title: '设备名称',align: 'center'}
    						      	            ,{field: 'doorPhoneSerialId', title: '设备序号',align: 'center'}
    						      	          ,{field: 'doorPhoneMac', title: '设备MAC地址',align: 'center'}
    						      	            ]]
    						      				,page:true
    						      				,limit:10
    						      	      	   ,data:datas
    						      	      });
    						      		
    						        },
    						        yes: function(index, layero){
    						            //console.log("确定");
    						            doAjax("post","../api/doorManager/v1/updateDeviceInfo",
    						            		{"datas": JSON.stringify(datas),"token":session.getItem("token")},function (data) {
   						            			if(data.code == '0'){
       												layer.close(reTable);
       												layer.msg("重新分配成功");
       												reloadTable();
       											}else{
       												layer.msg(data.msg);
       												reloadTable();
       											}
								        },function(err){});
    						            /* $.post("../api/doorManager/v1/updateDeviceInfo",
    						            		{"datas": JSON.stringify(datas),"token":session.getItem("token")}, function (data) {
    											if(data.code == '0'){
    												layer.close(reTable);
    												layer.msg("重新分配成功");
    												reloadTable();
    											}else{
    												layer.msg(data.msg);
    												reloadTable();
    											}
    										}) */
    						          }
    						          ,btn2: function(index, layero){
    						            console.log("取消");
    						          }
    						    });
    					   }else{
    						   layer.msg(data.msg);
    					   }
		        },function(err){});
                /* $.post("../api/doorManager/v1/allotDeviceInfo", {"allotData": JSON.stringify(allotData),"ageData": JSON.stringify(ageData),
					"token":session.getItem("token")}, function (data) {
				   if(data.code == '0'){
					   layer.msg("设备分配成功！");
					   layer.close(selectAllot);
					   reloadTable();
				   }else if(data.code == '4003'){
					   let datas = data.data;
					   //console.log(datas);
					   layer.close(selectAllot);
				    	  var reTable = layer.open({
					            type: 1,
					            content: $("#tableret-div"), 
					            title : '已分配的数据，确定要重新分配吗？',
					            area: ['800px', '620px'],
					            btn: ['重新分配', '取消'],
					      		success: function(layero, index){
					      			table.render({
					      	    	  elem: '#tableret'
					      	    	  ,cols: [[
					      	              {field: 'doorPhoneName', title: '设备名称',align: 'center'}
					      	            ,{field: 'doorPhoneSerialId', title: '设备序号',align: 'center'}
					      	          ,{field: 'doorPhoneMac', title: '设备MAC地址',align: 'center'}
					      	            ]]
					      				,page:true
					      				,limit:10
					      	      	   ,data:datas
					      	      });
					      		
					        },
					        yes: function(index, layero){
					            //console.log("确定");
					            $.post("../api/doorManager/v1/updateDeviceInfo",
					            		{"datas": JSON.stringify(datas),"token":session.getItem("token")}, function (data) {
										if(data.code == '0'){
											layer.close(reTable);
											layer.msg("重新分配成功");
											reloadTable();
										}else{
											layer.msg(data.msg);
											reloadTable();
										}
									})
					          }
					          ,btn2: function(index, layero){
					            console.log("取消");
					          }
					    });
				   }else{
					   layer.msg(data.msg);
				   }
				}, 'json'); */
    			
    		},
            add: function () {
                typeForm = 0;
                doorPhoneMac.removeAttr("readonly");
                doorPhoneSerialId.removeAttr("readonly");
                dialogIndex = layer.open({
                    type: 1
                    , maxmin: true
                    , title: '添加设备'
                    , content: macDialog
                    , area: ['700px', '600px']
                });
               
             jin.click();         
             chupin.click();
             hengpin.click();
            layui.form.render('radio');
            doorPhoneName.prop('value', "");
            doorPhoneMac.prop('value', "");
            $(":input[name='screenSize']").prop('value', "");
            doorPhoneSerialId.prop('value', '');
            password.prop('value', '');
            }
            , edit: function (tobj) {
                typeForm = 1;
                macObjT = tobj;
                doorPhoneMac.attr("readonly", "readonly");
                doorPhoneSerialId.attr("readonly", "readonly");
                dialogIndex = layer.open({
                    type: 1
                    , maxmin: true
                    , title: '修改设备信息'
                    , content: macDialog
                    , area: ['700px', '600px']
                });
                //console.log(tobj.data);
                switch (tobj.data.deviceType) {
                    case '0':
                        jin.click();
                        break;
                    case '1':
                    	shou.click();
                    	break;
                }
                switch (tobj.data.touchScreen) {
                case '0':
                	chupin.click();
                    break;
                case '1':
                	feichupin.click();
                    break;
               
            	}
            	switch (tobj.data.screenType) {
                case '0':
                	hengpin.click();
                    break;
                case '1':
                	shupin.click();
                    break;
               
            	}
                layui.form.render('radio');
                doorPhoneName.prop('value', tobj.data.doorPhoneName);
                doorPhoneMac.prop('value', tobj.data.doorPhoneMac);
                screenSize.prop('value', tobj.data.screenSize);
                if (tobj.data.doorPhoneSerialId)
                    doorPhoneSerialId.prop('value', tobj.data.doorPhoneSerialId);
                else
                    doorPhoneSerialId.prop('value', '');

                if (tobj.data.password)
                    password.prop('value', tobj.data.password);
                else
                    password.prop('value', '');
            }
            , del: function (tobj) {
                layer.open({
                    type: 0
                    , content: "确定删除门口机设备：" + tobj.data.doorPhoneName + "?"
                    , shadeClose: true
                    , yes: function (index, layero) {
                        var i = layer.load(2, {time: 5000});
                        let url = '../api/doorManager/v1/deleteUnallotDeviceInfo';
                        doAjax("post",url,{"doorPhoneId": tobj.data.id,
							"token":session.getItem("token")},function (data) {
								layer.close(i);
							    if (!data) return null;
							    if (data.code == 0) {
							        layer.msg("删除成功");
							        tobj.del();
							        data
							    } else {
							        layer.msg(data.msg);
							    }
                        },function(err){});
                        /* $.post(url, {"doorPhoneId": tobj.data.id,
							"token":session.getItem("token")}, function (data) {
						    layer.close(i);
						    if (!data || checkLogin(data)) return null;
						    if (data.code == 0) {
						        layer.msg("删除成功");
						        tobj.del();
						        data
						    } else {
						        layer.msg(data.msg);
						    }
						}, 'json'); */
                    }
                });
            }
            , query: function () {
                var where = {doorPhoneName: '', doorPhoneMac: '',queryDeviceType:$("#queryDeviceType").val(),
                		screenType:$("#queryScreenType").val(),touchScreen:$("#queryTouchScreen").val(),
                		allotStatus:$("#queryAllotStatus").val()};
                where[queryType.val()] = queryKey.val();
                layui.table.reload('macTable', {
                    page: {
                        curr: 1 //重新从第 1 页开始
                    }
                    , where: where
                });
            }
            , cancel: function () {
                layer.close(dialogIndex);
            }
            , cancelStatus: function () {
                layer.close(statusIndex);
            }
            , secret: function () {
                treeSecret.checkAllNodes(false);
                layer.open({
                    type: 1
                    , title: "修改密码："
                    , content: secretDialog
                    , area: ['700px', '500px']
                    , shadeClose: true
                });
            }
        }
        , treeIndex, curNode
        , treeSecret = $.fn.zTree.init($("#treeSecret"), {
            check: {
                enable: true
            }
            , view: {
                addHoverDom: function (treeId, treeNode) {
                    var sObj = $("#" + treeNode.tId + "_span");
                    if (!treeNode.isParent || $("#refreshBtn_" + treeNode.tId).length > 0) return;
                    var addStr = "<span  id='refreshBtn_" + treeNode.tId
                        + "' title='刷新' onfocus='this.blur();' class='layui-icon'>&#xe9aa;</span>";
                    sObj.after(addStr);
                    var btn = $("#refreshBtn_" + treeNode.tId);
                    if (btn) btn.bind("click", function () {
                        treeSecret.reAsyncChildNodes(treeNode, 'refresh');
                        return false;
                    });
                }
                , addDiyDom: function (treeId, treeNode) {
                    if (treeNode.online) {
                        var aObj = $("#" + treeNode.tId + "_a");
                        // if ($("#diyBtn_space_" + treeNode.id).length > 0) return;
                        var editStr = '<span class="' + (treeNode.online === '0' ? 'highlight_green">[在线]' : 'highlight_red">[离线]') + '</span>';
                        aObj.append(editStr);
                    }
                }
                , removeHoverDom: function (treeId, treeNode) {
                    $("#refreshBtn_" + treeNode.tId).unbind().remove();
                }
                , selectedMulti: false
            }
            , async: {
                enable: true,
                url: "../php/api.php?action=getMacTree",
                autoParam: ["id", "level"],
                dataFilter: function (treeId, parentNode, data) {
                    if (!data || checkLogin(data) || !data.data) return null;
                    var childNodes = data.data;
                    for (var i = 0, l = childNodes.length; i < l; i++) {
                        childNodes[i].isParent = childNodes[i].level < 1;
                    }
                    return childNodes;
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
                    if (!data  || !data.data) return null;
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
                	ageData = treeNode;
                	//console.log(treeNode);
                	$("#ageName").text(treeNode.ageName);
                    treeAgency.expandAll(false);
                }
            }
        }, {
            ageName: session.getItem("agencyName")
            , ageId: session.getItem("agencyId")
            , isParent: true
        }),
    	treeCommunity = $.fn.zTree.init($("#treeCommunity"), {
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
                if (!data  || !data.data) return null;
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
            elem: '#machine_table'
            , url: '../api/doorManager/v1/selectAllotDeviceList'
            , cols: [[
                 {type: 'checkbox'}
                // ,
                
                ,{title: '编号', type: 'numbers' , width: 60,align: 'center'}
                , {title: '名称', field: 'doorPhoneName',align: 'center'}
                , {
                    title: '设备类型', width: 100,align: 'center', templet: function (d) {
                    	switch(d.deviceType){
                    	case '0':
                    		return '门禁机';
                    	case '1':
                    		return '收件箱';
                    	}
                    }
                }
                , {title: '序号', field: 'doorPhoneSerialId',width: 150,align: 'center'}
                , {title: 'MAC地址', field: 'doorPhoneMac', width: 150,align: 'center'}
                ,{title: '屏幕尺寸', align: 'center',  width: 120 ,templet: function (d) {
                    	return d.screenSize+"寸"
                    }
                }
                ,{title: '屏幕方向', width: 100,align: 'center', templet: function (d) {
                    	switch(d.screenType){
                    	case '0':
                    		return '横屏';
                    	case '1':
                    		return '竖屏';
                    	}
                    }
                }
                ,{title: '是否触屏', width: 100,align: 'center', templet: function (d) {
                	switch(d.touchScreen){
                	case '0':
                		return '是';
                	case '1':
                		return '否';
                	}
                }
            }
                ,{title: '分配状态', width: 120,align: 'center', templet: function (d) {
                	switch(d.allotStatus){
                	case '0':
                		return '未分配';
                	case '1':
                		return '已分配';
                	}
                }
            }
                , {title: '管理', align: 'center', toolbar: '#barMac', fixed: 'right', width: 200}
            ]]
            , id: 'macTable'
            , page: true
            ,limit:50
            , height: 'full-120'
            , where: {
                ageId: curAgency.ageId,
                allotStatus:$("#queryAllotStatus").val(),
                doorPhoneName:function(){
                	if(queryType.val() == "doorPhoneName"){
                		return queryKey.val();
                	}else{
                		return "";
                	}
                },
                doorPhoneMac :function(){
                	if(queryType.val() == "doorPhoneMac"){
                		return queryKey.val();
                	}else{
                		return "";
                	}
                },
                queryDeviceType:$("#queryDeviceType").val(),
                touchScreen:$("#queryTouchScreen").val(),
                screenType:$("#queryScreenType").val(),
                token:function(){
                	return session.getItem("token");
                }
            }
            , request: {
                pageName: 'pageNum'
                , limitName: 'pageSize'
            }
            , method: "post"
            ,contentType:'application/x-www-form-urlencoded'
            , parseData: function(res){
            	
            	if(res.code ==1005){
            		let checkCode = checkToken(res);
            		if(checkCode == "200"){
            			return {
                    		"code":res.code,
                    		"msg":res.msg,
                    		"count":res.data.total,
                    		"data":res.data.doorList
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
                		"data":res.data.doorList
                	}
            	}
            }
            , done: function (res, curr, count) {
                checkLogin(res);
            }
        });
        layui.table.on('tool(macTable)', function (obj) {
            if (buttons[obj.event]) buttons[obj.event](obj);
        });
    };
    reloadTable();
    layui.form.on('submit(formSubmit)', function (data) {
        // if (!typeForm && data.field.communityId.length < 1 && data.field.buildingId.length < 1 && data.field.unitId.length < 1) {
        //     buttons['choose']();
        //     return false;
        // }
        var url;
        data.field.ageId = curAgency.ageId;
        if (typeForm) {
        	url = '../api/doorManager/v1/updateUnallotDeviceInfo';
        	data.field.doorPhoneId = macObjT.data.id;
        } else {
            url = '../api/doorManager/v1/singleImportDevice';
        }
        data.field.token = session.getItem("token");
        var i = layer.load(2, {time: 5000});
        doAjax("post",url,data.field,function (data) {
        	layer.close(i);
            if (!data) return null;
            if (data.code == 0) {
                layer.msg("保存成功");
                if (typeForm)
                    layui.table.reload('macTable');
                else
                    layui.table.reload('macTable', {
                        page: {
                            curr: 1 //重新从第 1 页开始
                        }
                        , where: {doorPhoneName: '', doorPhoneMac: ''}
                    });
                layer.close(dialogIndex);
            } else {
                layer.msg(data.msg);
            }
        },function(err){});
        /* $.post(url, data.field, function (data) {
            layer.close(i);
            if (!data || checkLogin(data)) return null;
            if (data.code == 0) {
                layer.msg("保存成功");
                if (typeForm)
                    layui.table.reload('macTable');
                else
                    layui.table.reload('macTable', {
                        page: {
                            curr: 1 //重新从第 1 页开始
                        }
                        , where: {doorPhoneName: '', doorPhoneMac: ''}
                    });
                layer.close(dialogIndex);
            } else {
                layer.msg(data.msg);
            }
        }, 'json'); */
        return false;
    });
    layui.form.on('submit(submitStatus)', function (data) {
        var i = layer.load(2, {time: 5000});
        // if (macObjT.data.status == data.field.status) {
        //     layer.msg("保存成功");
        //     layer.close(i);
        //     layer.close(statusIndex);
        //     return false;
        // }
        var url, postData = {}, status = data.field.status;
        postData.doorPhoneId = macObjT.data.id;
        //console.log(macObjT.data.deviceType);
        switch (status) {
            case '0':
                postData.ageId = macObjT.data.ageId;
                postData.token = session.getItem("token");
                postData.doorPhoneMac = macObjT.data.doorPhoneMac;
                postData.doorPhoneRegId = macObjT.data.doorPhoneRegId;
                if(macObjT.data.deviceType == '1'){
                	url = '../api/doorManager/v1/closeActivationInboxById';
                }else{
                	url = '../api/doorManager/v1/closeActivationDoorPhoneById';
                }
                break;
            case '1':
                postData.ageId = macObjT.data.ageId;
                postData.doorPhoneMac = macObjT.data.doorPhoneMac;
                postData.token = session.getItem("token");
				if(macObjT.data.deviceType == '1'){
					url = '../api/doorManager/v1/activationInboxInfo';
                }else{
                	url = '../api/doorManager/v1/activationDoorPhoneInfo';
                }
                break;
            case '2':
            	postData.token = session.getItem("token");
				if(macObjT.data.deviceType == '1'){
					url = '../api/doorManager/v1/freezeInboxById';
                }else{
                	url = '../api/doorManager/v1/freezeDoorPhoneById';
                }
                break;
        }
        doAjax("post",url,postData,function (data) {
        	layer.close(i);
            if (!data) return null;
            if (data.code == 0) {
                layer.msg("保存成功");
                layui.table.reload('macTable');
                layer.close(statusIndex);
            } else {
                layer.msg(data.msg);
            }
        },function(err){});
        /* $.post(url, postData, function (data) {
            layer.close(i);
            if (!data || checkLogin(data)) return null;
            if (data.code == 0) {
                layer.msg("保存成功");
                layui.table.reload('macTable');
                layer.close(statusIndex);
            } else {
                layer.msg(data.msg);
            }
        }, 'json'); */
        return false;
    });
    layui.form.on('submit(submitSend)', function (data) {
        var nodes = treeSecret.getCheckedNodes(true), ids = [], all = 0, online = 0;
        for (var i = 0, len = nodes.length; i < len; i++) {
            if (nodes[i].level === 2) {
                all++;
                if (nodes[i].online === '0')
                    online++;
                ids[ids.length] = nodes[i].id;
            }
        }
        allCount.text(all);
        onlineCount.text(online);
        offlineCount.text(all - online);

        if (all) {
            this.parentElement.reset();
            layer.msg('假的发送成功' + JSON.stringify(data.field));
            // var i = layer.load(2, {time: 5000});
            // $.post('../php/api.php?action=sendAD', {
            //     id: icObjT.data.id,
            //     doorPhoneId: JSON.stringify(ids)
            // }, function (data) {
            //     layer.close(i);
            //     if (!data || checkLogin(data)) return null;
            //     if (data.code == 0) {
            //         layer.msg("发送成功");
            //     } else {
            //         layer.msg(data.msg);
            //     }
            // }, 'json');
        } else
            layer.msg('请选择门口机设备');
        return false;
    });
    var iUpload
    , uploadListIns =upload.render({
	    elem: '#bacth'
	    ,url: '../api/doorManager/v1/batchImportDevice'
	    ,accept: 'file' //普通文件
	    ,exts: 'xlsx|xls' //excel文件
	   	, before: function (obj) {
	   		this.data={token:function(){return session.getItem("token")},ageId : session.getItem("agencyId")};
	   		iUpload = layer.load(2, {time: 10000});
	   	}
	    ,done: function(res){
	      //console.log(res);
    	let checkCode = checkToken(res);
       	if(checkCode == "1005"){
       		uploadListIns.upload(); 
       	}else if(checkCode == "1004" || checkCode == "1003" || checkCode == "1002"){
       		relogin(checkCode);
       	}else{
       		let data = res.data;
  	      /* for(let i=0;i<data.length;i++){
  	    	  $("#tbody1").append('<tr><td>'+data[i].doorPhoneName+'</td><td>'+data[i].errorMessage+'</td></tr>'); 
  	      } */
  	      layer.close(iUpload);
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
  		      	              {field: 'doorPhoneName',width:200, title: '设备名称',align: 'center'}
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
  	    	  reloadTable();
  	      }
       	} 
	    }
	  });
    $('.layui-btn[data-type]').on('click', function () {
        var type = $(this).data('type');
        buttons[type] ? buttons[type].call(this) : '';
    });
});
function downloadExcel(){
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
<script type="text/html" id="barMac">
    <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
</script>
<style>
.highlight_black {
	color: #2f332a;
}

.highlight_red {
	color: #A60000;
}

.highlight_green {
	color: #61f42c;
}
.layui-table-cell .layui-form-checkbox[lay-skin="primary"]{
     top: 50%;
     transform: translateY(-50%);
}
.layui-col-md3{
    float: left;
    text-align: center;
}
.layui-col-md12{
	text-align: center;
}
#treeAgency{
	padding: 20px;
	margin-left:4.5%;
	border: 1px solid #eee;
	margin-bottom: 2%;
	margin-top: 1%;
}
.allot-text{
	border: 1px solid #eee;
	margin-top: 1%;
}
.grid-demo-bg1{
	border-bottom: 1px solid #eee;
	padding: 20px;
}
#ageName{
	float: left;
	color: red;
}
.allotBut{
	margin: 3% auto;
}
.layui-breadcrumb{
	margin-left: 20px;
}
.layui-breadcrumb:hover
{ 
background-color:yellow;
}
</style>
</head>
<body>
	<div id="tableret-div" style="display: none">
		<table class="layui-hide" id="tableret" lay-filter="table1Filter"></table>
	</div>
	<div id="table2-div" style="display: none" class="layui-row">
		<div class="layui-col-md11">
				<ul id="treeAgency" class="ztree layui-col-xs12"></ul>
		</div>
		<div class="layui-col-md12">
			<div class="layui-row grid-demo">
				<div class="layui-col-md5">
		          <div class="grid-demo grid-demo-bg3"><h3>选择分配的代理商：</h3></div>
		        </div>
		        <div class="layui-col-md7">
		          <div class="grid-demo grid-demo-bg2" ><h3 id="ageName"></h3></div>
		        </div>
	      	</div>
		</div>
		<div class="layui-col-md12 allot-text">
			<div class="layui-row grid-demo grid-demo-bg1">
				<div class="layui-col-md3">
		          <div class="grid-demo grid-demo-bg3"><h3>门禁设备：</h3></div>
		        </div>
		        <div class="layui-col-md9">
		          <div class="grid-demo grid-demo-bg2" id="menjink1"></div>
		        </div>
	      	</div>
	      	<div class="layui-row grid-demo grid-demo-bg1">
				<div class="layui-col-md3">
		          <div class="grid-demo grid-demo-bg3"><h3>收件设备：</h3></div>
		        </div>
		        <div class="layui-col-md9">
		          <div class="grid-demo grid-demo-bg2" id="shoujiank1"></div>
		        </div>
	      	</div>
		</div>
		<div class="layui-col-md12 allotBut">
				<button class="layui-btn layui-btn-warm"  data-type="allotbutton" ><i class="layui-icon">&#xe672;</i>确认分配</button>
		</div>
		
	</div>
	<div class="child-body">
	<div id="table1-div" style="display: none">
		<table class="layui-hide" id="table1" lay-filter="table1Filter"></table>
	</div>
		<div id="macDialog" class="site-block" style="display: none">
			<form class="layui-form">
			<div class="layui-form-item">
					<label class="layui-form-label">设备类型:</label>
					<div class="layui-input-block">
						<input type="radio" id="jin" name="deviceType" value="0"
							title="门禁机" checked>
						<input type="radio" id="shou"
							name="deviceType" value="1" title="收件箱">
					</div>
			</div>
			<div class="layui-form-item">
					<label class="layui-form-label">是否触摸屏:</label>
					<div class="layui-input-block">
						<input type="radio"   id="chupin"   name="touchScreen" value="0" title="是" checked>
						 <input type="radio"  id="feichupin"		name="touchScreen" value="1" title="否">
					</div>
			</div>
			<div class="layui-form-item">
					<label class="layui-form-label">屏幕方向:</label>
					<div class="layui-input-block">
						<input type="radio"  name="screenType" value="0" id="hengpin"
							title="横屏" checked>
						 <input type="radio"  id="shupin"
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
							placeholder="请输入设备序号" class="layui-input">
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
		<div id="statusDialog" class="site-block" style="display: none">
			<form class="layui-form">
				<div class="layui-form-item">
					<label class="layui-form-label">选择状态</label>
					<div class="layui-input-block">
						<input type="radio" id="invalid" name="status" value="0"
							title="取消激活" checked> <input type="radio" id="active"
							name="status" value="1" title="激活"> <input type="radio"
							id="freeze" name="status" value="2" title="冻结">
					</div>
				</div>
				<div class="layui-input-block">
					<button class="layui-btn" lay-submit lay-filter="submitStatus">保存
					</button>
					<button type="button" data-type="cancelStatus" class="layui-btn">取消</button>
				</div>
			</form>
		</div>
		<div id="secretDialog" style="display: none; padding: 5px">
			<ul id="treeSecret" class="ztree layui-col-xs6" style="height: 440px"></ul>
			<div class="layui-col-xs6" style="padding-left: 5px">
				<form class="layui-form">
					<div class="layui-form-item">
						<div class="layui-inline">
							<input type="text" lay-verify="required|number"
								class="layui-input" name="password" placeholder="请输入密码">
						</div>
					</div>
					<button class="layui-btn layui-btn-normal" lay-submit
						lay-filter="submitSend">
						<i class="layui-icon">&#xe609;</i>确定修改
					</button>
				</form>
				<fieldset class="layui-elem-field"
					style="margin-top: 10px; padding: 10px;">
					<legend>修改详情</legend>
					<div>
						<p>
							修改设备共 <span id="allCount" class="highlight_black">0</span> 台
						</p>
						<p>
							在线设备共 <span id="onlineCount" class="highlight_green">0</span> 台
						</p>
						<p>
							离线设备共 <span id="offlineCount" class="highlight_red">0</span> 台
						</p>
					</div>
				</fieldset>
			</div>
		</div>
        <ul id="treeCommunity" class="ztree layui-col-xs2"></ul>
		<div id="divfirst"  class="layui-col-xs10"
			style="padding-left: 5px">
			<div class="layui-form" style="margin: 10px">
				<div class="layui-form-item">
					<div class="layui-inline">
						<select id="queryType">
							<option value="doorPhoneName">根据名称搜索</option>
							<option value="doorPhoneMac">根据MAC标识符搜索</option>
						</select>
					</div>
					<div class="layui-inline" style="width:160px">
						<select id="queryDeviceType">
							<option value="">选择设备类型</option>
							<option value="0">门禁机</option>
							<option value="1">收件箱</option>
						</select>
					</div>
					<div class="layui-inline" style="width:160px">
						<select id="queryScreenType">
							<option value="">选择屏幕方向</option>
							<option value="0">横屏</option>
							<option value="1">竖屏</option>
						</select>
					</div>
					<div class="layui-inline" style="width:160px">
						<select id="queryTouchScreen">
							<option value="">选择屏幕类型</option>
							<option value="0">触屏</option>
							<option value="1">非触屏</option>
						</select>
					</div>
					<div class="layui-inline" style="width:120px">
						<select id="queryAllotStatus">
							<option value="0">未分配</option>
							<option value="1">已分配</option>
						</select>
					</div>
					<div class="layui-inline">
						<input class="layui-input" id="queryKey" placeholder="请输入关键字">
					</div>
					<button class="layui-btn" data-type="query">搜索</button>
					<button id="addDevice" data-type="add" class="layui-btn layui-btn-normal">
						<i class="layui-icon">&#xe608;</i>添加设备
					</button>
					<button type="button"  class="layui-btn" id="bacth"><i class="layui-icon"></i>批量导入设备</button>
					<button type="button"  data-type="allot"  class="layui-btn layui-btn-radius layui-btn-warm" id="">
						<i class="layui-icon">&#xe672;</i>分配设备</button>
					
<!-- 				    	<button class="layui-btn layui-btn-primary" onclick="downloadExcel()">
				    	<i class="layui-icon">&#xe601;</i>下载Excel模板</button> -->
				    	<span id="downBut" class="layui-breadcrumb">
						  <a href="javascript:downloadExcel();" ><cite>下载Excel模板</cite></a>
						</span>
				    
				    
					<!--                <button data-type="secret" class="layui-btn layui-btn-normal"><i class="layui-icon">&#xe631;</i>修改密码-->
					<!--                </button>-->
					<!--                <button data-type="assign" class="layui-btn layui-btn-normal"><i class="layui-icon">&#xe641;</i>分配-->
					<!--                </button>-->
				</div>
			</div>
			<table id="machine_table" lay-filter="macTable"></table>
		</div>
	</div>
</body>
</html>