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
<title>设备管理</title>
<script type="text/javascript">
$(function(){
	selelogin();
	let menu = $.session.get('menu');
	let menujson = JSON.parse(menu);
	//console.log(menujson);
	if(menujson["3"] != 2){
		$("#treeAgency").hide();
		$("#divfirst").addClass("layui-col-xs12");
	}else{
		$("#divfirst").addClass("layui-col-xs10");
	}
});
layui.config({
    base: "../js/"
}).use(['form', 'table', 'ztree','laydate'], function () {
    var $ = layui.$
        , treeCommunityDialog = $('#treeCommunityDialog')
        , macDialog = $('#macDialog')
        , statusDialog = $('#statusDialog')
        , secretDialog = $('#secretDialog')
        , invalid = $('#invalid')
        , active = $('#active')
        , freeze = $('#freeze')
        , laydate = layui.laydate
        , wu = $('#wu')
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
        , roomName = $('#roomName')
        , roomId = $('#roomId')
        , allCount = $('#allCount')
        , onlineCount = $('#onlineCount')
        , offlineCount = $('#offlineCount')
        , typeForm = 0
        , roomTh = $("#roomTh")
        ,session = window.sessionStorage
        , dialogIndex
        , detailsDialog
        , editLatticOpen
        , statusIndex
        , macObjT
        , buttons = {
            add: function () {
                typeForm = 0;
                $('#jin').attr("disabled",false); 
                $('#shou').attr("disabled",false); 
                dialogIndex = layer.open({
                    type: 1
                    , maxmin: true
                    , title: '添加设备'
                    , content: macDialog
                    , area: ['700px', '600px']
                });
            }
            , edit: function (tobj) {
            	$('#jin').attr("disabled",false); 
                $('#shou').attr("disabled",false); 
                typeForm = 1;
                roomTh.hide();
                roomName.hide();
                macObjT = tobj;
                //console.log(tobj.data);
                dialogIndex = layer.open({
                    type: 1
                    , maxmin: true
                    , title: '修改设备信息'
                    , content: macDialog
                    , area: ['700px', '600px']
                });
                switch (tobj.data.deviceType) {
                    case '0':
                        jin.click();
                        break;
                    case '1':
                    	$('#shou').click();
                        roomTh.show();
                        roomName.show();
                    	break;
                }
                switch (tobj.data.doorPhoneType) {
                case '0':
                	$('#jincj').click();
                    break;
                case '1':
                	$('#wucj').click();
                	break;
           		 }
                switch (tobj.data.humanStatus) {
                    case '1':
                        humanStatusClose.click();
                        break;
                    case '0':
                        humanStatusOpen.click();
                        break;
                }
                if (tobj.data.faceStatus == '0')
                    disable.click();
                else
                    enable.click();
                $('#jin').attr("disabled",true); 
                $('#shou').attr("disabled",true); 
                layui.form.render('radio');
                doorPhoneName.prop('value', tobj.data.doorPhoneName);
                doorPhoneMac.prop('value', tobj.data.doorPhoneMac);
                doorPhoneMac.attr("disabled",true); 
                if (tobj.data.doorPhoneSerialId)
                    doorPhoneSerialId.prop('value', tobj.data.doorPhoneSerialId);
                else
                    doorPhoneSerialId.prop('value', '');
                doorPhoneSerialId.attr("disabled",true); 
                if (tobj.data.password)
                    password.prop('value', tobj.data.password);
                else
                    password.prop('value', '');
                if (tobj.data.communityId != 0) {
                    commId.prop('value', tobj.data.communityId);
                    commName.text(tobj.data.commName);
                } else {
                    commName.text('选择小区');
                    commId.prop('value', '');
                }
                if (tobj.data.unitId != 0) {
                    unitId.prop('value', tobj.data.unitId);
                    unitName.text(tobj.data.unitName);
                } else {
                    unitId.prop('value', '');
                    unitName.text('选择单元');
                }
                if (tobj.data.buildingId != 0) {
                    bldId.prop('value', tobj.data.buildingId);
                    bldName.text(tobj.data.bldName);
                } else {
                    bldId.prop('value', '');
                    bldName.text('选择楼栋');
                }
                if (tobj.data.roomId) {
                	roomId.prop('value', tobj.data.roomId);
                    roomName.text(tobj.data.roomName);
                } else {
                	roomId.prop('value', '');
                	roomName.text('选择房号');
                }
            }
            ,details:function(tobj){
            	macObjT = tobj;
            	//console.log(macObjT);
            	if(macObjT.data.deviceType == "0"){
            		let data = macObjT.data
            		$('#jinMac').attr("disabled",false); 
            		$('#shouMac').attr("disabled",false); 
            		$('#menjinMac').attr("disabled",false); 
            		$('#wuyeMac').attr("disabled",false); 
            		$('#rentikaiMac').attr("disabled",false); 
            		$('#rentiguanMac').attr("disabled",false); 
            		$('#renlianguanMac').attr("disabled",false); 
            		$('#renliankaiMac').attr("disabled",false); 
            		$('#zaixianMac').attr("disabled",false); 
            		$('#lixianMac').attr("disabled",false); 
            		$('#weijihuoMac').attr("disabled",false); 
            		$('#jihuoMac').attr("disabled",false); 
            		$('#dongjieMac').attr("disabled",false); 
            		switch(data.deviceType){
	            		case '0':
	            			$("#jinMac").click();
	            			break;
	            		case '1':
	            			$("#shouMac").click();
	            			break;
            		}
            		switch(data.doorPhoneType){
	            		case '0':
	            			$("#menjinMac").click();
	            			break;
	            		case '1':
	            			$("#wuyeMac").click();
	            			break;
        			}
            		switch(data.humanStatus){
	            		case '0':
	            			$("#rentikaiMac").click();
	            			break;
	            		case '1':
	            			$("#rentiguanMac").click();
	            			break;
    				}
            		switch(data.faceStatus){
	            		case '0':
	            			$("#renlianguanMac").click();
	            			break;
	            		case '1':
	            			$("#renliankaiMac").click();
	            			break;
					}
            		switch(data.onlineStatus){
	            		case '0':
	            			$("#zaixianMac").click();
	            			break;
	            		case '1':
	            			$("#lixianMac").click();
	            			break;
					}
            		switch(data.status){
	            		case '0':
	            			$("#weijihuoMac").click();
	            			break;
	            		case '1':
	            			$("#jihuoMac").click();
	            			break;
	            		case '2':
	            			$("#dongjieMac").click();
	            			break;
					}
            		$("#macDeviceName").prop('value', data.doorPhoneName);
            		$("#macDeviceSerialId").prop('value', data.doorPhoneSerialId);
            		$("#macDeviceMac").prop('value', data.doorPhoneMac);
            		$("#macDevicePassword").prop('value', data.password);
            		$("#macDeviceUcpaasAccountsId").prop('value', data.ucpaasAccountsId);
            		$("#macDeviceCommName").prop('value', data.commName);
            		$("#macDeviceBldname").prop('value', data.bldName);
            		$("#macDeviceUnit").prop('value', data.unitName);
            		$("#macDeviceBleName").prop('value', data.bleName);
            		$("#macDeviceBleMac").prop('value', data.bleMac);
            		$("#macDeviceLastHeartbeat").prop('value', data.lastHeartbeat);
            		$("#macDeviceCreateTime").prop('value', data.createTime);
            		$('#jinMac').attr("disabled",true); 
            		$('#shouMac').attr("disabled",true); 
            		$('#menjinMac').attr("disabled",true); 
            		$('#wuyeMac').attr("disabled",true); 
            		$('#rentikaiMac').attr("disabled",true); 
            		$('#rentiguanMac').attr("disabled",true); 
            		$('#renlianguanMac').attr("disabled",true); 
            		$('#renliankaiMac').attr("disabled",true); 
            		$('#zaixianMac').attr("disabled",true); 
            		$('#lixianMac').attr("disabled",true); 
            		$('#weijihuoMac').attr("disabled",true); 
            		$('#jihuoMac').attr("disabled",true); 
            		$('#dongjieMac').attr("disabled",true); 
            		$('#macDeviceName').attr("disabled",true); 
            		$('#macDeviceSerialId').attr("disabled",true); 
            		$('#macDeviceMac').attr("disabled",true); 
            		$('#macDevicePassword').attr("disabled",true); 
            		$('#macDeviceUcpaasAccountsId').attr("disabled",true); 
            		$('#macDeviceCommName').attr("disabled",true); 
            		$('#macDeviceBldname').attr("disabled",true); 
            		$('#macDeviceUnit').attr("disabled",true); 
            		$('#macDeviceBleName').attr("disabled",true); 
            		$('#macDeviceBleMac').attr("disabled",true); 
            		$('#macDeviceLastHeartbeat').attr("disabled",true); 
            		$('#macDeviceCreateTime').attr("disabled",true);
            		//$("#macDeviceName").prop('value', data.doorPhoneName);
            		layui.form.render();
            		layer.open({
            			type: 1
            			 , title: "设备详情"
                         , content: $("#macDetailsDialog")
                         , area: ['100%', '100%']
                         , shadeClose: true            			
            		});
            	}else if(macObjT.data.deviceType == "1"){
            		reloadDetail();
            	}	
            }
            , del: function (tobj) {
                layer.open({
                    type: 0
                    , content: "确定删除设备：" + tobj.data.doorPhoneName + "?"
                    , shadeClose: true
                    , yes: function (index, layero) {
                        var i = layer.load(2, {time: 5000});
                        let url = '../api/doorManager/v1/deleteDoorPhoneInfo';
                        doAjax("post",url,{"doorPhoneId": tobj.data.id,
							"token":session.getItem("token")},function (data) {
								 layer.close(i);
								    if (!data /* || checkLogin(data) */) return null;
								    if (data.code == 0) {
								        layer.msg("删除成功");
								        tobj.del();
								        data
								    } else {
								        layer.msg(data.msg);
								    }
							},function(err){
                        	
                        });
/*                         $.post(url, {"doorPhoneId": tobj.data.id,
							"token":session.getItem("token")}, function (data) {
						    layer.close(i);
						    if (!data /* || checkLogin(data) *//* ) return null;
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
            , queryRecord: function(tobj){
            	//console.log(tobj);
            	//console.log($("#startTime").val());
            	//console.log($("#endTime").val());
            	//console.log($("#queryOperate").val());
            	 var where = {};
                 where.startTime = $("#startTime").val();
                 where.endTime = $("#endTime").val();
                 where.operate = $("#queryOperate").val();
                 layui.table.reload('recordTable', {
                     page: {
                         curr: 1 //重新从第 1 页开始
                     }
                     , where: where
                 });
            }
            , query: function () {
                var where = {doorPhoneName: '', doorPhoneMac: '',queryDeviceType:$("#queryDeviceType").val()};
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
            , cancelLattice: function(){
            	layer.close(editLatticOpen);
            }
            , choose: function () {
                treeIndex = layer.open({
                    type: 1
                    , shadeClose: true
                    , title: '请选择位置'
                    , content: treeCommunityDialog
                    , area: ['700px', '500px']
                });
            }
            , status: function (tobj) {
                macObjT = tobj;
                switch (tobj.data.status) {
                    case '0':
                        invalid.click();
                        freeze.attr("disabled", true);
                        break;
                    case '1':
                        active.click();
                        freeze.attr("disabled", false);
                        break;
                    case '2':
                        freeze.click();
                        freeze.attr("disabled", false);
                        break;
                }
                layui.form.render('radio');
                statusIndex = layer.open({
                    type: 1
                    , title: "修改设备状态：" + tobj.data.doorPhoneName
                    , content: statusDialog
                    , shadeClose: true
                });
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
            , showRecord: function(tobj){
            	//console.log(tobj.data);
            	 layui.table.render({
                     elem: '#record_table'
                     , url: '../api/smallprogram/v1/selectInboxRecord'
                     , cols: [[
                         // {type: 'checkbox'}
                         // ,
                         {title: '序号', type: 'numbers' ,style: "text-align:center"}
                         , {title: '收件箱名称',  width: 186, style: "text-align:center", templet: function (d) {
								return tobj.data.inboxName;
                         }}
                         , {title: '格子编号',  width: 86, style: "text-align:center", templet: function (d) {
								return tobj.data.latticeName;
                      	 }}
                         , {
                             title: '操作信息', width: 120, style: "text-align:center", templet: function (d) {
                             	switch(d.operate){
                             	case '2048':
                             		return '格子打开成功';
                             	case '2049':
                             		return '格子关闭成功';
                             	case '2052':
                             		return '格子更新状态';
                             	case '2053':
                             		return '设置格子温度';
                             	case '2054':
                             		return '温度设置失败';
                             	}
                             }
                         }
                         // , {title: 'MAC地址', field: 'doorPhoneMac', width: 150, sort: true}
                         , {title: '操作人员姓名', field: 'historyOperatingPersonnelName', width: 120,style: "text-align:center"}
                         , {title: '操作人员电话', field: 'historyOperatingPersonnelPhone', width: 120,style: "text-align:center"}
                         , {title: '物品数量', field: 'goodsNumber', width: 90,style: "text-align:center"}
                         , {title: '物品重量', field: 'goodsWeight', width: 100,style: "text-align:center"}
                         , {title: '发送时间', field: 'callTime', width: 180,style: "text-align:center"}
                         , {title: '打开时间', field: 'openTime',width: 180,style: "text-align:center"}
                         , {title: '关闭时间', field: 'closeTime',width: 180,style: "text-align:center"}
                         , {title: '创建时间', field: 'createTime',style: "text-align:center"}
                     ]]
                     , id: 'recordTable'
                     , page: true
                     , height: 'full-120'
                     , where: {
                         ageId: curAgency.ageId,
                         latticeId:tobj.data.id,
                         startTime : $("#startTime").val(),
                         endTime : $("#endTime").val(),
                         operate : $("#queryOperate").val(),
                         token:function(){
                         	return session.getItem("token");
                         }
                     }
                     , request: {
                         pageName: 'pageNum'
                         , limitName: 'pageSize'
                     }
                     , method: "post"
                     , contentType:'application/x-www-form-urlencoded'
                     , parseData: function(res){
                     	if(res.code ==1005){
                    		let checkCode = checkToken(res);
                    		if(checkCode == "200"){
                    			return {
                             		"code":res.code,
                             		"msg":res.msg,
                             		"count":res.data.total,
                             		"data":res.data.recordList
                             	}
                    		}else if(checkCode == "1005"){
                    			table.reload('recordTable', {
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
                         		"data":res.data.recordList
                         	}
                    	}
                     }
                     , done: function (res, curr, count) {
                    	 checkForDataCode(res);
                        // checkLogin(res);
                     }
                 });
                 layui.table.on('tool(recordTable)', function (obj) {
                     if (buttons[obj.event]) buttons[obj.event](obj);
                 });
            	
            	latticeRecordOpen = layer.open({
                    type: 1
                    , title: "记录信息："+tobj.data.latticeName
                    , content: $("#inboxRecordDialog")
                    , area: ['100%', '100%']
                    , shadeClose: true
                });
            }
            , editLattice: function(tobj){
            	//console.log(tobj.data)
            	let data = tobj.data;
            	$("#latticeUpId").val(data.id);
            	$("#latticeNumber").val(data.latticeNumber);
            	$("#latticeOldType").val(data.latticeType);
            	$("#latticeName").val(data.latticeName);
            	$("#latticeCurrentTemperature").val(data.currentTemperature);
            	$("#latticeLoadBearing").val(data.loadBearing);
            	switch(data.latticeType){
            	case '0':
            		$("#latticeTypeUp option[value='0']").attr("selected","selected");
            		break;
            	case '1':
            		$("#latticeTypeUp option[value='1']").attr("selected","selected");
            		break;
            	case '2':
            		$("#latticeTypeUp option[value='2']").attr("selected","selected");
            		break;
            	}
            	layui.form.render('select');
            	editLatticOpen = layer.open({
                    type: 1
                    , title: "编辑信息："+data.latticeName
                    , content: $("#latticeDialog")
                    , area: ['700px', '500px']
                    , shadeClose: true
                });
            }
        }
    	, reloadDetail = function(){
    		$("#lattice_table").html("");
    		let tobj = macObjT;
	    	let data = tobj.data;
	    	$("#inboxId").val(data.id);
	    	if(data.deviceType=='1'){
	    		let url = '../api/doorManager/v1/selectLatticeInfo';
	    		doAjax("post",url,{"inboxId": data.id,"token":session.getItem("token")},function (data) {
					let dataList = data.data;
					//console.log(data);
					layui.table.render({
			            elem: '#lattice_table'
			            , cols: [[
			                // {type: 'checkbox'},
			                {title: '序号', type: 'numbers',style: "text-align:center"}
			                , {title: '格子编号', field: 'latticeName', width: 160,style: "text-align:center"}
			                , {
			                    title: '格子类型', width: 100,style: "text-align:center",  templet: function (d) {
			                    	switch(d.latticeType){
			                    	case '0':
			                    		return '普通';
			                    	case '1':
			                    		return '冷藏';
			                    	case '2':
			                    		return '冷冻';
			                    	}
			                    }
			                }
			                , {title: '承重(Kg)', field: 'loadBearing', width: 120,style: "text-align:center"}
			                , {title: '当前温度(°C)', field: 'currentTemperature', width: 120,style: "text-align:center"}
			                , {
			                    title: '格子状态', field: 'state',style: "text-align:center", templet: function (d) {
			                        var s = ''; 
			                        switch (d.state) {
			                            case '1':
			                                s = "禁用";
			                                break;
			                            case '0':
			                                s = '启用';
			                        }
			                        return s;
			                    }, width: 120
			                }
			                , {
			                    title: '开关状态', field: 'status',style: "text-align:center", templet: function (d) {
			                        var s = ''; 
			                        switch (d.status) {
			                            case '2':
			                                s = "异常状态";
			                                break;
			                            case '1':
			                                s = "开门";
			                                break;
			                            case '0':
			                                s = '关门';
			                        }
			                        return s;
			                    }, width: 120
			                }
			                , {
			                    title: '打开时间', field: 'openTime', width: 220,style: "text-align:center"
			                }
			                , {
			                    title: '创建时间', field: 'createTime', width: 220,style: "text-align:center"
			                }
			                , {title: '管理', align: 'center', toolbar: '#latticeMac', fixed: 'right', width: 320}
			            ]]
			            , id: 'latticeTable'
			            , page: true
			            , height: 'full-120'
			            , data:dataList
			        });
					layui.form.render('checkbox');
			        layui.table.on('tool(latticeTable)', function (obj) {
			            if (buttons[obj.event]) buttons[obj.event](obj);
			        });	
					},function(err){
                 	
                 });
	    		
/* 	           $.post(url, {"inboxId": data.id,
				"token":session.getItem("token")}, function (data) {
					let dataList = data.data;
					checkForDataCode(data);
					console.log(data);
					layui.table.render({
			            elem: '#lattice_table'
			            , cols: [[
			                // {type: 'checkbox'},
			                {title: '序号', type: 'numbers',style: "text-align:center"}
			                , {title: '格子编号', field: 'latticeName', width: 160,style: "text-align:center"}
			                , {
			                    title: '格子类型', width: 100,style: "text-align:center",  templet: function (d) {
			                    	switch(d.latticeType){
			                    	case '0':
			                    		return '普通';
			                    	case '1':
			                    		return '冷藏';
			                    	case '2':
			                    		return '冷冻';
			                    	}
			                    }
			                }
			                , {title: '承重(Kg)', field: 'loadBearing', width: 120,style: "text-align:center"}
			                , {title: '当前温度(°C)', field: 'currentTemperature', width: 120,style: "text-align:center"}
			                , {
			                    title: '格子状态', field: 'state',style: "text-align:center", templet: function (d) {
			                        var s = ''; 
			                        switch (d.state) {
			                            case '1':
			                                s = "禁用";
			                                break;
			                            case '0':
			                                s = '启用';
			                        }
			                        return s;
			                    }, width: 120
			                }
			                , {
			                    title: '开关状态', field: 'status',style: "text-align:center", templet: function (d) {
			                        var s = ''; 
			                        switch (d.status) {
			                            case '2':
			                                s = "异常状态";
			                                break;
			                            case '1':
			                                s = "开门";
			                                break;
			                            case '0':
			                                s = '关门';
			                        }
			                        return s;
			                    }, width: 120
			                }
			                , {
			                    title: '打开时间', field: 'openTime', width: 220,style: "text-align:center"
			                }
			                , {
			                    title: '创建时间', field: 'createTime', width: 220,style: "text-align:center"
			                }
			                , {title: '管理', align: 'center', toolbar: '#latticeMac', fixed: 'right', width: 320}
			            ]]
			            , id: 'latticeTable'
			            , page: true
			            , height: 'full-120'
			            , data:dataList
			        });
					layui.form.render('checkbox');
			        layui.table.on('tool(latticeTable)', function (obj) {
			            if (buttons[obj.event]) buttons[obj.event](obj);
			        });
					
				}) */
	    	}
	       detailsDialog =  layer.open({
	            type: 1
	            , maxmin: true
	            , title: '设备详情'
	            , shade: 0
	            , content: $("#detailsDialog")
	            , area: ['100%', '100%']
	        });
    	}
/*     	, checkForDataCode = function(data){
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
    	} */
        , treeIndex, curNode
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
                otherParam: {"token":function(){return session.getItem("token")}},
                dataFilter: function (treeId, parentNode, data) {
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
                        childNodes[i].isParent = childNodes[i].level < 4;
                    }
                    return childNodes; 
                }
            }
            , callback: {
                onClick: function (event, treeId, treeNode) {
                    layer.close(treeIndex);
                    if (curNode === treeNode) return;
                    curNode = treeNode;
                    switch (treeNode.level) {
                        case 0:
                            commName.text('请选择小区');
                            commId.prop('value', '');
                        case 1:
                            bldName.text('请选择楼栋');
                            bldId.prop('value', '');
                        case 2:
                            unitName.text('请选择单元');
                            unitId.prop('value', '');
                        case 3:
                        	roomName.text('请选择房号');
                            roomId.prop('value', '');
                            break
                    }
                    //console.log(treeNode.level);
                    switch (treeNode.level) {
                    	case 4:
                            roomName.text(treeNode.name);
                            roomId.prop('value', treeNode.id);
                            treeNode = treeNode.getParentNode();
                        case 3:
                            unitName.text(treeNode.name);
                            unitId.prop('value', treeNode.id);
                            treeNode = treeNode.getParentNode();
                        case 2:
                            bldName.text(treeNode.name);
                            bldId.prop('value', treeNode.id);
                            treeNode = treeNode.getParentNode();
                        case 1:
                            commName.text(treeNode.name);
                            commId.prop('value', treeNode.id);
                            break
                    }
                }
            }
        }, {
            name: session.getItem("agencyName")
            , id: session.getItem("agencyId")
            , isParent: true
        })
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
                    if (!data || /* checkLogin(data) || */ !data.data) return null;
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
                    if (!data || !data.data) return null;
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
        } , {
            ageName: session.getItem("agencyName")
            , ageId: session.getItem("agencyId")
            , isParent: true
        });
    curAgency = treeAgency.getNodes()[0];
	
    var reloadTable = function () {
    	let querytext1=queryType.val() == "doorPhoneName"?queryKey.val():"",
    		querytext2=queryType.val() == "doorPhoneMac"?queryKey.val():"";
    		querytext3=queryType.val() == "doorPhoneSerialId"?queryKey.val():"";
        layui.table.render({
            elem: '#machine_table'
            , url: '../api/doorManager/v1/selectDeviceList'
            , cols: [[
                // {type: 'checkbox'}
                // ,
                {title: '序号', type: 'numbers' ,style: "text-align:center"}
                , {title: '名称', field: 'doorPhoneName', width: 160, style: "text-align:center"}
                , {
                    title: '场景类型', width: 100, style: "text-align:center",sort: true, templet: function (d) {
                    	switch(d.doorPhoneType){
                    	case '0':
                    		return '门禁';
                    	case '1':
                    		return '物业';
                    	}
                    }
                }
                , {
                    title: '设备类型', width: 100,style: "text-align:center", sort: true, templet: function (d) {
                    	//console.log(11);
                    	switch(d.deviceType){
                    	case '0':
                    		return '门禁机';
                    	case '1':
                    		return '收件箱';
                    	}
                    }
                }
                // , {title: 'MAC地址', field: 'doorPhoneMac', width: 150, sort: true}
                , {title: '小区', field: 'commName', width: 120,style: "text-align:center"}
                , {title: '楼栋', field: 'bldName', width: 120,style: "text-align:center"}
                , {title: '单元', field: 'unitName', width: 120,style: "text-align:center"}
                , {title: '云之讯账号', field: 'ucpaasAccountsId',style: "text-align:center"}
                , {
                    title: '网络状态', field: 'onlineStatus',style: "text-align:center", templet: function (d) {
                        return '<span class="' + (d.onlineStatus === '0' ? 'highlight_green">在线' : 'highlight_red">离线') + '</span>';
                    }
                }
                , {
                    title: '设备状态', field: 'status',style: "text-align:center", templet: function (d) {
                        var s = '';
                        switch (d.status) {
                            case '2':
                                s = "已冻结";
                                break;
                            case '1':
                                s = "已激活";
                                break;
                            case '0':
                                s = '未激活';
                        }
                        return s;
                    }, width: 120
                }
                , {title: '管理', align: 'center',style: "text-align:center", toolbar: '#barMac', fixed: 'right', width: 240}
            ]]
            , id: 'macTable'
            , page: true
            , height: 'full-120'
            , where: {
                ageId: curAgency.ageId,
                doorPhoneName:querytext1,
                doorPhoneMac : querytext2,
                doorPhoneSerialId:querytext3,
                queryDeviceType:$("#queryDeviceType").val(),
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
            	checkForDataCode(res);
                //checkLogin(res);
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
        	url = '../api/doorManager/v1/updateDoorPhoneInfo';
        	data.field.doorPhoneId = macObjT.data.id;
        } else {
        	url = '../api/doorManager/v1/addDoorPhoneInfo';
        }
        data.field.token = session.getItem("token");
        var i = layer.load(2, {time: 5000});
        doAjax("post",url,data.field,function (data) {
            layer.close(i);
            if (!data /* || checkLogin(data) */) return null;
            if (data.code == 0) {
                layer.msg("保存成功");
                if (typeForm)
                    layui.table.reload('macTable');
                else
                    layui.table.reload('macTable', {
                        page: {
                            curr: 1 //重新从第 1 页开始
                        }
                        , where: {doorPhoneName: '', doorPhoneMac: '',doorPhoneSerialId:''}
                    });
                layer.close(dialogIndex);
                jin.click();
                $("#jincj").click();
                enable.click();
                doorPhoneMac.prop('value', '');
                doorPhoneName.prop('value', '');
                doorPhoneSerialId.prop('value', '');
                unitId.prop('value', '');
                bldId.prop('value', '');
                password.prop('value', '');
                commId.prop('value', '');
                unitName.text('请选择单元');
                bldName.text('请选择楼栋');
                commName.text('请选择小区');
            } else {
                layer.msg(data.msg);
            }
        },function(err){
        	
        });
        
/*         $.post(url, data.field, function (data) {
            layer.close(i);
            checkForDataCode(data);
            if (!data /* || checkLogin(data) *//* ) return null;
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
                jin.click();
                $("#jincj").click();
                enable.click();
                doorPhoneMac.prop('value', '');
                doorPhoneName.prop('value', '');
                doorPhoneSerialId.prop('value', '');
                unitId.prop('value', '');
                bldId.prop('value', '');
                password.prop('value', '');
                commId.prop('value', '');
                unitName.text('请选择单元');
                bldName.text('请选择楼栋');
                commName.text('请选择小区');
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
        //console.log(macObjT.data.doorPhoneType);
        switch (status) {
            case '0':
                postData.ageId = macObjT.data.ageId;
                postData.token = session.getItem("token");
                postData.doorPhoneMac = macObjT.data.doorPhoneMac;
                postData.doorPhoneRegId = macObjT.data.doorPhoneRegId;
                url = '../api/doorManager/v1/closeActivationDoorPhoneById';
                break;
            case '1':
                postData.ageId = macObjT.data.ageId;
                postData.doorPhoneMac = macObjT.data.doorPhoneMac;
                postData.token = session.getItem("token");
                url = '../api/doorManager/v1/activationDoorPhoneInfo';
                break;
            case '2':
            	postData.token = session.getItem("token");
                url = '../api/doorManager/v1/freezeDoorPhoneById';
                break;
        }
        doAjax("post",url,postData,function (data) {
            layer.close(i);
            if (!data  /* || checkLogin(data) */) return null;
            if (data.code == 0) {
                layer.msg("保存成功");
                layui.table.reload('macTable');
                layer.close(statusIndex);
            } else {
                layer.msg(data.msg);
            }
        },function(err){});
        
/*         $.post(url, postData, function (data) {
            layer.close(i);
            checkForDataCode(data);
            if (!data ) return null;
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
    layui.form.on('submit(submitLattice)', function (data) {
        var i = layer.load(2, {time: 5000});
        var url='../api/doorManager/v1/updateLatticeInfo', 
        		postData = {};
      		//console.log(data.field);
      		//console.log($("#latticeCurrentTemperature").val());
      		//console.log($("#latticeTypeUp").val());
      		postData.latticeId = data.field.latticeUpId;
      		postData.inboxId = data.field.inboxId;
      		postData.latticeNumber = data.field.latticeNumber;
      		postData.latticeNumber = data.field.latticeNumber;
      		postData.userId = session.getItem("userId");
      		postData.userType = "4";
      		postData.token = session.getItem("token");
      		if($("#latticeTypeUp").val()!=data.field.latticeOldType){
      			postData.latticeType = $("#latticeTypeUp").val();
      		}
      		if(data.field.latticeOldFlag == 0){
      			let currentTemperature = $("#latticeCurrentTemperature").val();
   				postData.temperatureFlag = data.field.latticeOldFlag;
       			postData.currentTemperature = currentTemperature;
      		}
      		//console.log(postData);
            doAjax("post",url,postData,function (data) {
            	layer.close(i);
            	//console.log(data);
                if (!data /* || checkLogin(data) */) return null;
                if (data.code == 0) {
                    layer.msg("保存成功");
                    reloadDetail();
                    layer.close(editLatticOpen);
                } else {
                    layer.msg(data.msg);
                }
            },function(err){
            	
            });
/*         $.post(url, postData, function (data) {
            layer.close(i);
            checkForDataCode(data);
            if (!data) return null;
            if (data.code == 0) {
                layer.msg("保存成功");
                reloadDetail();
                layer.close(editLatticOpen);
            } else {
                layer.msg(data.msg);
            }
        }, 'json');  */
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
    layui.form.on('switch(switchState)', function(data){
    	var i = layer.load(2, {time: 5000});
    	//console.log(data);
    	//console.log(data.elem.checked); 
        var postData = {}, state = 1;
        if(data.elem.checked){
        	state = 0;
        }
        let url = '../api/doorManager/v1/updateLatticeInfo';
        postData.userId = session.getItem("userId");
        postData.token = session.getItem("token");
        postData.state = state;
        postData.latticeId = data.value;
        //console.log(postData);
        doAjax("post",url,postData,function (data) {
        	//console.log(data);
            layer.close(i);
            if (data.code == 0) {
                layer.msg("保存成功");
                reloadDetail();
            } else {
                layer.msg(data.msg);
            }
        },function(err){
        	
        });
      /*   $.post(url, postData, function (data) {
        	console.log(data);
            layer.close(i);
            checkForDataCode(data);
            if (data.code == 0) {
                layer.msg("保存成功");
                reloadDetail();
            } else {
                layer.msg(data.msg);
            }
        }, 'json');   */
    }); 
    layui.form.on('switch(switchTFlag)', function(data){
		//console.log(data);
		//console.log(data.elem.checked); 
		if(data.elem.checked){
			$("#latticeCurrentTemperature").attr("readonly",false);
			$("#latticeOldFlag").val("0");
		}else{
			$("#latticeOldFlag").val("1");
			$("#latticeCurrentTemperature").attr("readonly",true);
		}
    }); 
    $('.layui-btn[data-type]').on('click', function () {
        var type = $(this).data('type');
        buttons[type] ? buttons[type].call(this) : '';
    });
    layui.form.verify({
        numberOrEmpty: function (value, item) {
        	var regPos = /^\d+(\.\d+)?$/; //非负浮点数
        	let  regNeg = /^(-(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*)))$/; //负浮点数
            if (value != '') {
                if (!regPos.test(value) && !regNeg.test(value)) {
                	return '只能填写数字';
                }
            }
        }
    }); 
    laydate.render({
        elem: '#startTime'
        , type: 'datetime'
    });
    laydate.render({
        elem: '#endTime'
        , type: 'datetime'
    });
});
</script>
<script type="text/html" id="barMac">
    <a class="layui-btn layui-btn-xs" lay-event="status">激活/冻结</a>
    <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-xs" lay-event="details">详情</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
</script>
<script type="text/html" id="latticeMac">
	{{#  if(d.state > 0){ }}
    <input type="checkbox" name="state" lay-filter="switchState" lay-skin="switch" lay-text="启用|禁用"
		 value={{ d.id }}>
  	{{#  }else{  }}
    <input type="checkbox" name="state" lay-filter="switchState" lay-skin="switch" lay-text="启用|禁用" checked
		value={{d.id  }}>
  	{{#  } }}
    <a class="layui-btn layui-btn-xs" lay-event="editLattice">编辑</a>
	<a class="layui-btn layui-btn-primary layui-btn-xs" lay-event="showRecord">查看记录</a>
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
</style>
</head>
<body>
	<div class="child-body">
		<div id="treeCommunityDialog" class="site-block" style="display: none">
			<ul id="treeCommunity" class="ztree"></ul>
		</div>
		<div id="detailsDialog" class="site-block" style="display: none">
			<table id="lattice_table" lay-filter="latticeTable"></table>
		</div>
		<div id="macDetailsDialog" class="site-block" style="display: none">
			<form class="layui-form layui-form-pane" >
			<div class="layui-form-item">
			    <label class="layui-form-label">设备类型</label>
			    <div class="layui-input-block" >
			    	<input type="radio" id="jinMac" name="macDeviceType" value="0" title="门禁机"  > 
						<input type="radio" id="shouMac" name="macDeviceType" value="1" title="收件箱"  >
			    </div>
			  </div>
			  <div class="layui-form-item">
			    <label class="layui-form-label">使用场景</label>
			    <div class="layui-input-block">
			    	<input type="radio" id="menjinMac" name="macDeviceDoorType" value="0" title="门禁" > 
					<input type="radio" id="wuyeMac" name="macDeviceDoorType" value="1" title="物业"  >
			    </div>
			  </div>
			  			  <div class="layui-form-item">
			    <label class="layui-form-label">人体感应</label>
			    <div class="layui-input-block">
			      <input type="radio" id="rentikaiMac" name="macDeviceHumanStatus" value="0" title="开启" >
			      <input type="radio" id="rentiguanMac" name="macDeviceHumanStatus" value="1" title="关闭" >
			    </div>
			  </div>
			  <div class="layui-form-item">
			    <label class="layui-form-label">人脸识别</label>
			    <div class="layui-input-block">
			    	<input type="radio" id="renliankaiMac" name="macDeviceFaceStatus" value="1" title="开启" >
			    	<input type="radio" id="renlianguanMac" name="macDeviceFaceStatus" value="0" title="关闭" >
			    </div>
			  </div>
			  <div class="layui-form-item">
			    <label class="layui-form-label">网络状态</label>
			    <div class="layui-input-block">
			    	<input type="radio" id="zaixianMac" name="macDeviceOnlineStatus" value="0" title="在线" >
			    	<input type="radio" id="lixianMac" name="macDeviceOnlineStatus" value="1" title="离线" >
			    </div>
			  </div>
			  <div class="layui-form-item">
			    <label class="layui-form-label">设备状态</label>
			    <div class="layui-input-block">
			    	<input type="radio" id="weijihuoMac" name="macDeviceStatus" value="0" title="未激活" > 
					<input type="radio" id="jihuoMac" name="macDeviceStatus" value="1" title="已激活" >
					<input type="radio" id="dongjieMac" name="macDeviceStatus" value="2" title="已冻结" >
			    </div>
			  </div>
			  <div class="layui-form-item">
			    <label class="layui-form-label">设备名称</label>
			    <div class="layui-input-block">
			      <input type="text"  id="macDeviceName" autocomplete="off"class="layui-input">
			    </div>
			  </div>
			  <div class="layui-form-item">
			    <label class="layui-form-label">设备序列号</label>
			    <div class="layui-input-block">
			      <input type="text" id="macDeviceSerialId" autocomplete="off"class="layui-input">
			    </div>
			  </div>
			  <div class="layui-form-item">
			    <label class="layui-form-label">设备MAC</label>
			    <div class="layui-input-block">
			      <input type="text" id="macDeviceMac" autocomplete="off"class="layui-input">
			    </div>
			  </div>
			  <div class="layui-form-item">
			    <label class="layui-form-label">设备密码</label>
			    <div class="layui-input-block">
			      <input type="text" id="macDevicePassword" autocomplete="off"class="layui-input">
			    </div>
			  </div>
			  <div class="layui-form-item">
			    <label class="layui-form-label">云之讯账号</label>
			    <div class="layui-input-block">
			      <input type="text" id="macDeviceUcpaasAccountsId" autocomplete="off"class="layui-input">
			    </div>
			  </div>
			  <div class="layui-form-item">
			    <label class="layui-form-label">所在小区</label>
			    <div class="layui-input-block">
			      <input type="text" id="macDeviceCommName" autocomplete="off"class="layui-input">
			    </div>
			  </div>
			  <div class="layui-form-item">
			    <label class="layui-form-label">所在楼栋</label>
			    <div class="layui-input-block">
			      <input type="text" id="macDeviceBldname" autocomplete="off"class="layui-input">
			    </div>
			  </div>
			  <div class="layui-form-item">
			    <label class="layui-form-label">所在单元</label>
			    <div class="layui-input-block">
			      <input type="text" id="macDeviceUnit" autocomplete="off"class="layui-input">
			    </div>
			  </div>
			  <div class="layui-form-item">
			    <label class="layui-form-label">蓝牙名称</label>
			    <div class="layui-input-block">
			      <input type="text" id="macDeviceBleName" autocomplete="off"class="layui-input">
			    </div>
			  </div>
			  <div class="layui-form-item">
			    <label class="layui-form-label">蓝牙MAC</label>
			    <div class="layui-input-block">
			      <input type="text" id="macDeviceBleMac" autocomplete="off"class="layui-input">
			    </div>
			  </div>
			  <div class="layui-form-item">
			    <label class="layui-form-label">心跳时间</label>
			    <div class="layui-input-block">
			      <input type="text" id="macDeviceLastHeartbeat" autocomplete="off"class="layui-input">
			    </div>
			  </div>
			  <div class="layui-form-item">
			    <label class="layui-form-label">创建时间</label>
			    <div class="layui-input-block">
			      <input type="text" id="macDeviceCreateTime" autocomplete="off"class="layui-input">
			    </div>
			  </div>
			</form>
		</div>
		<div id="inboxRecordDialog" class="site-block" style="display: none">
				<div class="layui-form" >
				<div class="layui-form-item">
					<div class="layui-inline">
						<select id="queryOperate">
							<option value="">根据操作搜索</option>
							<option value="2048">格子打开成功</option>
							<option value="2049">格子关闭成功</option>
							<option value="2052">格子更新状态</option>
							<option value="2053">设置格子温度</option>
							<option value="2054">温度设置失败</option>
						</select>
					</div>
					<div class="layui-inline">
						<label class="layui-form-label" for="startTime">起始时间</label>
						<div class="layui-input-inline">
							<input type="text" class="layui-input" id="startTime"
								name="startTime">
						</div>
						<label class="layui-form-label" for="endTime">结束时间</label>
						<div class="layui-input-inline">
							<input type="text" class="layui-input" id="endTime" name="endTime">
						</div>
					</div>
					<button class="layui-btn" data-type="queryRecord">搜索</button>
				</div>
			</div>
			<table id="record_table" lay-filter="recordTable"></table>
		</div>
		<div id="macDialog" class="site-block" style="display: none">
			<form class="layui-form">
				<input type="hidden" id="unitId" name="unitId"> 
				<input type="hidden" id="bldId" name="buildingId">
				 <input type="hidden" id="commId" name="communityId">
				 <input type="hidden" id="roomId" name="roomId">
				<div class="layui-form-item">
					<label class="layui-form-label">设备类型</label>
					<div class="layui-input-block">
						<input type="radio" id="jin" name="deviceType" value="0"
							title="门禁机" checked> 
						<input type="radio" id="shou"
							name="deviceType" value="1" title="收件箱" >
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">场景类型</label>
					<div class="layui-input-block">
						<input type="radio" id="jincj" name="doorPhoneType" value="0"
							title="门禁" checked> 
						<input type="radio" id="wucj"
							name="doorPhoneType" value="1" title="物业">
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">人体感应</label>
					<div class="layui-input-block">
						<input type="radio" id="humanStatusOpen" name="humanStatus"
							value="0" title="开启" checked> <input type="radio"
							id="humanStatusClose" name="humanStatus" value="1" title="关闭">
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">人脸识别</label>
					<div class="layui-input-block">
						<input type="radio" id="disable" name="faceStatus" value="0"
							title="关闭" checked> <input type="radio" id="enable"
							name="faceStatus" value="1" title="开启">
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">设备名称</label>
					<div class="layui-input-block">
						<input type="text" id="doorPhoneName" name="doorPhoneName"
							lay-verify="required" placeholder="请输入名称" class="layui-input">
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">设备序列号</label>
					<div class="layui-input-block">
						<input type="text" id="doorPhoneSerialId" name="doorPhoneSerialId"
							class="layui-input">
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">MAC地址</label>
					<div class="layui-input-block">
						<input type="text" id="doorPhoneMac" name="doorPhoneMac"
							class="layui-input">
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">设备密码</label>
					<div class="layui-input-block">
						<input type="text" id="password" name="password"
							placeholder="请输入设备密码" class="layui-input">
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">绑定位置</label>
					<div class="layui-input-block">
						<button type="button" data-type="choose"
							class="layui-btn layui-btn-normal">选择位置</button>
					</div>
					<div class="layui-input-block">
						<table class="layui-table" lay-size="sm">
							<colgroup>
								<col width="130">
								<col width="130">
								<col width="130">
							</colgroup>
							<thead>
								<tr>
									<th>小区</th>
									<th>楼栋</th>
									<th>单元</th>
									<th id="roomTh">房号</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td id="commName">请选择小区</td>
									<td id="bldName">请选择楼栋</td>
									<td id="unitName">请选择单元</td>
									<td id="roomName">请选择房号</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="layui-input-block">
					<button class="layui-btn" lay-submit lay-filter="formSubmit">保存
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
		<div id="latticeDialog" class="site-block" style="display: none">
			<form class="layui-form">
				<input type="hidden" id="latticeUpId" name="latticeUpId">
				<input type="hidden" id="inboxId" name="inboxId">
				<input type="hidden" id="latticeNumber" name="latticeNumber">
				<input type="hidden" id="latticeOldType" name="latticeOldType">
				<input type="hidden" id="latticeOldFlag" name="latticeOldFlag">
				<div class="layui-form-item">
					<label class="layui-form-label">格子编号</label>
					<div class="layui-input-block">
						<input type="text"  class="layui-input"  id="latticeName" disabled="disabled">
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">格子承重(Kg)</label>
					<div class="layui-input-block">
						<input type="text"  class="layui-input"  id="latticeLoadBearing" disabled="disabled">
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">格子类型</label>
					<div class="layui-input-block">
						<select id="latticeTypeUp">
							<option value="0">普通</option>
							<option value="1">冷藏</option>
							<option value="2">冷冻</option>
						</select>
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">温度控制</label>
					<div class="layui-input-block">
						<input type="checkbox" name="state" lay-filter="switchTFlag" lay-skin="switch" lay-text="启用|禁用" >
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">当前温度</label>
					<div class="layui-input-block">
						<input type="text"  class="layui-input"  lay-verify="numberOrEmpty" id="latticeCurrentTemperature"  readonly="readonly">
					</div>
				</div>
				</div>
				<div class="layui-input-block">
					<button class="layui-btn" lay-submit lay-filter="submitLattice">保存
					</button>
					<button type="button" data-type="cancelLattice" class="layui-btn">取消</button>
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
        <ul id="treeAgency" class="ztree layui-col-xs2"></ul>
		<div id="divfirst" 
			style="padding-left: 5px">
			<div class="layui-form" style="margin: 10px">
				<div class="layui-form-item">
					<div class="layui-inline">
						<select id="queryType">
							<option value="doorPhoneName">根据名称搜索</option>
							<option value="doorPhoneMac">根据MAC标识符搜索</option>
							<option value="doorPhoneSerialId">根据序列号搜索</option>
						</select>
					</div>
					<div class="layui-inline">
						<select id="queryDeviceType">
							<option value="">选择设备类型</option>
							<option value="0">门禁机</option>
							<option value="1">收件箱</option>
						</select>
					</div>
					<div class="layui-inline">
						<input class="layui-input" id="queryKey" placeholder="请输入关键字">
					</div>
					<button class="layui-btn" data-type="query">搜索</button>
					<!-- <button data-type="add" class="layui-btn layui-btn-normal">
						<i class="layui-icon">&#xe608;</i>添加设备
					</button> -->
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