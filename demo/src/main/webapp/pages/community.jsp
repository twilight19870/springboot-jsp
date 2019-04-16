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
<title>小区管理</title>
<script type="text/javascript">
var resen = false;
$(function(){
	selelogin();
	let menu = $.session.get('menu');
	let menujson = JSON.parse(menu);
	if(menujson["3"] != 2){
		$("#divfirst").addClass("layui-col-xs10");
		$("#treeAgency").hide();
	}else{
		resen = true;
		window.sessionStorage.setItem("resen",resen);
		$("#divfirst").addClass("layui-col-xs8");
	}
});
layui.config({
    base: "../js/"
}).use(['ztree', 'form'], function () {
    var $ = layui.jquery, 
    	curNode, ageName = $('#ageName'), 
    	community = $('#community'),
        provinceId = $('#provinceId'),
        cityId = $('#cityId'), 
        areaId = $('#areaId'), 
        building = $('#building'), 
        room = $('#room'),
        unit = $('#unit'), 
        commName = $('#commName'), 
        bldName = $('#bldName'), 
        bldCode = $('#bldCode'),
        unitName = $('#unitName'), 
        unitCode = $('#unitCode'), 
        roomName = $('#roomName'), 
        roomCode = $('#roomCode'),
        ye = $('#ye'), 
        wu = $('#wu'), 
        actionItem = $('#actionItem'), 
        formSubmit = $('#formSubmit'),
        formCancel = $('#formCancel'), 
        btnDel = $('#btnDel'), 
        addCom = $('#addCom'),
        addBuilding = $('#addBuilding'), 
        addUnit = $('#addUnit'), 
        addRoom = $('#addRoom'),
        btnEdit = $('#btnEdit'), 
        type = 0, 
        table = layui.table,
      	session = window.sessionStorage,
        cancelfun = function () {
            if (type !== 0) {
                type = 0;
                provinceId.attr("disabled", true);
                cityId.attr("disabled", true);
                areaId.attr("disabled", true);
                commName.attr("disabled", true);
                commName.addClass("layui-disabled");
                layui.form.render('select');
                bldName.attr("disabled", true);
                bldName.attr('lay-verify', '');
                bldName.addClass("layui-disabled");
                bldCode.attr("disabled", true);
                bldCode.attr('lay-verify', '');
                bldCode.addClass("layui-disabled");
                unitName.attr("disabled", true);
                unitName.attr('lay-verify', '');
                unitName.addClass("layui-disabled");
                unitCode.attr("disabled", true);
                unitCode.attr('lay-verify', '');
                unitCode.addClass("layui-disabled");
                roomName.attr("disabled", true);
                roomName.attr('lay-verify', '');
                roomName.addClass("layui-disabled");
                roomCode.attr("disabled", true);
                roomCode.attr('lay-verify', '');
                roomCode.addClass("layui-disabled");
                ye.attr("disabled", true);
                wu.attr("disabled", true);
                layui.form.render('radio');
                actionItem.hide('normal');
                fixContent();
            }
        }
        , fixContent = function () {
            if (curNode.level == 0) {
                btnDel.addClass("layui-btn-disabled");
                btnDel.attr("disabled", true);
                btnEdit.addClass("layui-btn-disabled");
                btnEdit.attr("disabled", true);
                if (type === 0)
                    cancelfun();
            } else {
                btnDel.removeClass("layui-btn-disabled");
                btnDel.attr("disabled", false);
                if (type === 0) {
                    btnEdit.removeClass("layui-btn-disabled");
                    btnEdit.attr("disabled", false);
                }
            }
            switch (curNode.level) {
                case 0:
                    community.hide('fast');
                    addBuilding.addClass("layui-btn-disabled");
                    addBuilding.attr("disabled", true);
                case 1:
                    building.hide('fast');
                    addUnit.addClass("layui-btn-disabled");
                    addUnit.attr("disabled", true);
                case 2:
                    unit.hide('fast');
                    addRoom.addClass("layui-btn-disabled");
                    addRoom.attr("disabled", true);
                case 3:
                    room.hide('fast');
                    break
            }
            var tmpNode = curNode;
            switch (tmpNode.level) {
                case 4:
                    room.show('normal');
                    roomName.prop('value', tmpNode.name);
                    roomCode.prop('value', tmpNode.code);
                    if (tmpNode.type === '0')
                    // ye.click();
                        ye.prop('checked', 'checked');
                    else
                    // wu.click();
                        wu.prop('checked', 'checked');
                    layui.form.render('radio');
                    tmpNode = tmpNode.getParentNode();
                case 3:
                    addRoom.removeClass("layui-btn-disabled");
                    addRoom.attr("disabled", false);
                    unit.show('normal');
                    unitName.prop('value', tmpNode.name);
                    unitCode.prop('value', tmpNode.code);
                    tmpNode = tmpNode.getParentNode();
                case 2:
                    addUnit.removeClass("layui-btn-disabled");
                    addUnit.attr("disabled", false);
                    building.show('normal');
                    bldName.prop('value', tmpNode.name);
                    bldCode.prop('value', tmpNode.code);
                    tmpNode = tmpNode.getParentNode();
                case 1:
                    addBuilding.removeClass("layui-btn-disabled");
                    addBuilding.attr("disabled", false);
                    community.show('normal');
                    commName.prop('value', tmpNode.name);
                    provinceId.val(tmpNode.provinceId);
                    cityId.find('option:not(:first)').remove();
                    cityId.append(new Option(tmpNode.cityName, tmpNode.cityId));
                    cityId.val(tmpNode.cityId);
                    areaId.find('option:not(:first)').remove();
                    areaId.append(new Option(tmpNode.areaName, tmpNode.areaId));
                    areaId.val(tmpNode.areaId);
                    layui.form.render('select');
                    break
            }
        }
        , clickE = function () {
            actionItem.show('normal');
            switch (type) {
                case 2:
                    building.hide('fast');
                case 3:
                    unit.hide('fast');
                case 4:
                    room.hide('fast');
                    break;
            }
            switch (type) {
                case 1:
                    switch (curNode.level) {
                        case 1:
                            provinceId.attr("disabled", false);
                            cityId.attr("disabled", false);
                            areaId.attr("disabled", false);
                            commName.attr("disabled", false);
                            commName.removeClass("layui-disabled");
                            layui.form.render('select');
                            break;
                        case 2:
                            bldName.attr("disabled", false);
                            bldName.removeClass("layui-disabled");
                            bldName.attr('lay-verify', 'required');
                            bldCode.attr("disabled", false);
                            bldCode.removeClass("layui-disabled");
                            bldCode.attr('lay-verify', 'required|number');
                            break;
                        case 3:
                            unitName.attr("disabled", false);
                            unitName.removeClass("layui-disabled");
                            unitName.attr('lay-verify', 'required');
                            unitCode.attr("disabled", false);
                            unitCode.removeClass("layui-disabled");
                            unitCode.attr('lay-verify', 'required|number');
                            break;
                        case 4:
                            ye.attr("disabled", false);
                            wu.attr("disabled", false);
                            layui.form.render('radio');
                            roomName.attr("disabled", false);
                            roomName.removeClass("layui-disabled");
                            roomName.attr('lay-verify', 'required');
                            roomCode.attr("disabled", false);
                            roomCode.removeClass("layui-disabled");
                            roomCode.attr('lay-verify', 'required|number');
                            break;
                    }
                    break;
                case 5:
                    room.show('normal');
                case 4:
                    unit.show('normal');
                case 3:
                    building.show('normal');
                case 2:
                    community.show('normal');
                    btnEdit.addClass("layui-btn-disabled");
                    btnEdit.attr("disabled", true);
                    break;
            }
        };
    btnEdit.click(function () {
        if (type !== 1) {
            type = 1;
            formSubmit.text("保存修改");
            clickE();
        }
    });
    addCom.click(function () {
        if (type !== 2) {
            cancelfun();
            type = 2;
            formSubmit.text("保存小区");
            commName.prop('value', '');
            provinceId.attr("disabled", false);
            cityId.attr("disabled", false);
            areaId.attr("disabled", false);
            commName.attr("disabled", false);
            commName.removeClass("layui-disabled");
            layui.form.render('select');
            clickE();
        }
    });
    addBuilding.click(function () {
        if (type !== 3) {
            cancelfun();
            type = 3;
            formSubmit.text("保存楼栋");
            bldName.prop('value', '');
            bldCode.prop('value', '');
            bldName.attr("disabled", false);
            bldName.removeClass("layui-disabled");
            bldName.attr('lay-verify', 'required');
            bldCode.attr("disabled", false);
            bldCode.removeClass("layui-disabled");
            bldCode.attr('lay-verify', 'required|number');
            clickE();
        }
    });
    addUnit.click(function () {
        if (type !== 4) {
            cancelfun();
            type = 4;
            formSubmit.text("保存单元");
            unitName.prop('value', '');
            unitCode.prop('value', '');
            unitName.attr("disabled", false);
            unitName.removeClass("layui-disabled");
            unitName.attr('lay-verify', 'required');
            unitCode.attr("disabled", false);
            unitCode.removeClass("layui-disabled");
            unitCode.attr('lay-verify', 'required|number');
            clickE();
        }
    });
    addRoom.click(function () {
        if (type !== 5) {
            cancelfun();
            type = 5;
            formSubmit.text("保存房间");
            roomName.prop('value', '');
            roomCode.prop('value', '');
            ye.attr("disabled", false);
            wu.attr("disabled", false);
            layui.form.render('radio');
            roomName.attr("disabled", false);
            roomName.removeClass("layui-disabled");
            roomName.attr('lay-verify', 'required');
            roomCode.attr("disabled", false);
            roomCode.removeClass("layui-disabled");
            roomCode.attr('lay-verify', 'required|number');
            clickE();
        }
    });
    formCancel.click(cancelfun);
    var
        ztreeAgency = function () {
            var zTreeObj;
            zTreeObj = $.fn.zTree.init($("#treeAgency"), {
                view: {
                    addHoverDom: function (treeId, treeNode) {
                        var sObj = $("#" + treeNode.tId + "_span");
                        if (!treeNode.isParent || treeNode.editNameFlag || $("#refreshBtn_" + treeNode.tId).length > 0) return;
                        var addStr = "<span  id='refreshBtn_" + treeNode.tId
                            + "' title='刷新' onfocus='this.blur();' class='layui-icon'>&#xe9aa;</span>";
                        sObj.after(addStr);
                        var btn = $("#refreshBtn_" + treeNode.tId);
                        if (btn) btn.bind("click", function () {
                            zTreeObj.reAsyncChildNodes(treeNode, 'refresh');
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
                    otherParam: {"token":function(){return session.getItem("token")}},
                    dataFilter: function (treeId, parentNode, data) {
                    	let checkCode = checkToken(data);
                        if(checkCode == "1005"){
                        	zTreeObj.expandAll(false);
                       		zTreeObj.refresh();
                        }else if(checkCode == "1004"){
                        	relogin(checkCode);
                        }
                        if (!data|| !data.data) return null;
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
                        ztreeCom.reload({id: treeNode.ageId, name: treeNode.ageName, isParent: true});
                    }
                }
            }, {
                ageName: session.getItem("agencyName")
                , ageId: session.getItem("agencyId")
                , isParent: true
            });

            return {}
        }()
        ,
        ztreeCom = function () {
            var zTreeObj
                , setting = {
                view: {
                    addHoverDom: function (treeId, treeNode) {
                        var sObj = $("#" + treeNode.tId + "_span");
                        if (!treeNode.isParent || treeNode.editNameFlag || $("#refreshBtn_" + treeNode.tId).length > 0) return;
                        var addStr = "<span  id='refreshBtn_" + treeNode.tId
                            + "' title='刷新' onfocus='this.blur();' class='layui-icon'>&#xe9aa;</span>";
                        sObj.after(addStr);
                        var btn = $("#refreshBtn_" + treeNode.tId);
                        if (btn) btn.bind("click", function () {
                            zTreeObj.reAsyncChildNodes(treeNode, 'refresh');
                            if (!curNode.getParentNode()) {
                                type = -1;
                                curNode = treeNode;
                                cancelfun();
                            }
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
                    	//console.log("treeId:"+treeId);
                    	//console.log("parentNode:"+JSON.stringify(parentNode));
                      // console.log("data:"+JSON.stringify(data));
                    	let checkCode = checkToken(data);
                        if(checkCode == "1005"){
                        	zTreeObj.expandAll(false);
                       		zTreeObj.refresh();
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
                        if (curNode === treeNode) return;
                        if (type !== 0) {
                            type = -1;
                            cancelfun();
                        }
                        curNode = treeNode;
                        fixContent();
                    }
                }
            };

            zTreeObj = $.fn.zTree.init($("#treeCommunity"), setting, {
                name: "小区列表"
                , id: session.getItem("agencyId")
                , isParent: true
            });
            curNode = zTreeObj.getNodes()[0];
            return {
                reload: function (node) {
                    zTreeObj = $.fn.zTree.init($("#treeCommunity"), setting, node);
                    curNode = zTreeObj.getNodes()[0];
                    ageName.prop('value', curNode.name);
                    type = -1;
                    cancelfun();
                }
                , refresh: function (parentNode) {
                    zTreeObj.reAsyncChildNodes(parentNode, 'refresh', false, function () {
                        if (curNode != parentNode)
                            curNode = zTreeObj.getNodeByParam("id", curNode.id, parentNode);
                        fixContent();
                    });
                }
            }
        }();

    btnDel.click(function () {
        layer.open({
            type: 0,
            content: "确定删除" + (curNode.level == 1 ? "小区" : curNode.level == 2 ? "楼栋" : curNode.level == 3 ? "单元" : "房间") + "：" + curNode.name + "?",
            shadeClose: true,
            yes: function (index, layero) {
                var i = layer.load(2, {time: 5000});
                //console.log("level:"+curNode.level);
                //console.log("id:"+curNode.id);
                let postUrl = delPlace(curNode.level,curNode.id);
                doAjax("post",postUrl,{"token":session.getItem("token")},function (data) {
                	if (data.code == 0) {
                        layer.msg("删除成功");
                        curNode = curNode.getParentNode();
                        ztreeCom.refresh(curNode);
                        type = -1;
                        cancelfun();
                    } else {
                        layer.msg(data.msg);
                    }
                },function(err){});
                /* $.post(postUrl, {"token":session.getItem("token")}, function (data) {
                    layer.close(i);
                 //   if (!data || checkLogin(data)) return null;
                    if (data.code == 0) {
                        layer.msg("删除成功");
                        curNode = curNode.getParentNode();
                        ztreeCom.refresh(curNode);
                        type = -1;
                        cancelfun();
                    } else {
                        layer.msg(data.msg);
                    }
                }, 'json'); */
            }
        });
    });
    layui.form.on('submit(formSubmit)', function (data) {
        var url, postData = {}, node = curNode;
        if (type === 1) {
            var done = false;
            switch (node.level) {
                default:
                    return false;
                case 1:
                    if (data.field['areaId'] == node.areaId && data.field['commName'] == node.name) {
                        done = true;
                        break;
                    }
                    url = '../api/communityManager/v1/updateCommunityInfo';
                    postData['areaId'] = data.field['areaId'];
                    postData['commName'] = data.field['commName'];
                    postData['id'] = node.id;
                    postData['token'] = session.getItem("token");
                    break;
                case 2:
                    if (data.field['bldCode'] == node.code && data.field['bldName'] == node.name) {
                        done = true;
                        break;
                    }
                    url = '../api/communityManager/v1/updateBuildingInfo';
                    postData['bldId'] = node.id;
                    postData['bldName'] = data.field['bldName'];
                    postData['bldCode'] = data.field['bldCode'];
                    postData['token'] = session.getItem("token");
                    break;
                case 3:
                    if (data.field['unitCode'] == node.code && data.field['unitName'] == node.name) {
                        done = true;
                        break;
                    }
                    url = '../api/communityManager/v1/updateUnitInfo';
                    postData['unitId'] = node.id;
                    postData['unitName'] = data.field['unitName'];
                    postData['unitCode'] = data.field['unitCode'];
                    postData['token'] = session.getItem("token");
                    break;
                case 4:
                    if (data.field['roomCode'] == node.code && data.field['roomName'] == node.name && data.field['type'] == node.type) {
                        done = true;
                        break;
                    }
                    url = '../api/communityManager/v1/updateRoomInfo';
                    postData['roomId'] = node.id;
                    postData['roomName'] = data.field['roomName'];
                    postData['roomCode'] = data.field['roomCode'];
                    postData['type'] = data.field['type'];
                    postData['token'] = session.getItem("token");
                    break;
            }
            if (done) {
                layer.msg("保存成功");
                cancelfun();
                return false;
            }
        } else {
            var c = type - 2;
            while (c < node.level)
                node = node.getParentNode();
            switch (type) {
                default:
                    return false;
                case 2:
                    url = '../api/communityManager/v1/addCommunityInfo';
                    postData['areaId'] = data.field['areaId'];
                    postData['commName'] = data.field['commName'];
                    postData['ageId'] = node.id;
                    postData['token'] = session.getItem("token");
                    break;
                case 3:
                    url = '../api/communityManager/v1/addBuildingInfo';
                    postData['commId'] = node.id;
                    postData['bldName'] = data.field['bldName'];
                    postData['bldCode'] = data.field['bldCode'];
                    postData['token'] = session.getItem("token");
                    break;
                case 4:
                    url = '../api/communityManager/v1/addUnitInfo';
                    postData['bldId'] = node.id;
                    postData['unitName'] = data.field['unitName'];
                    postData['unitCode'] = data.field['unitCode'];
                    postData['token'] = session.getItem("token");
                    break;
                case 5:
                    url = '../api/communityManager/v1/addRoomInfo';
                    postData['unitId'] = node.id;
                    postData['roomName'] = data.field['roomName'];
                    postData['roomCode'] = data.field['roomCode'];
                    postData['type'] = data.field['type'];
                    postData['token'] = session.getItem("token");
                    break;
            }
        }
        var i = layer.load(2, {time: 5000});
        doAjax("post",url,postData,function (data) {
        	layer.close(i);
            if (!data) return null;
            if (data.code == 0) {
                layer.msg("保存成功");
                if (type === 1)
                    ztreeCom.refresh(curNode.getParentNode());
                else
                    ztreeCom.refresh(node);
                cancelfun();
            } else {
                layer.msg(data.msg);
            }
        },function(err){});
        /* $.post(url, postData, function (data) {
            layer.close(i);
            if (!data || checkLogin(data)) return null;
            if (data.code == 0) {
                layer.msg("保存成功");
                if (type === 1)
                    ztreeCom.refresh(curNode.getParentNode());
                else
                    ztreeCom.refresh(node);
                cancelfun();
            } else {
                layer.msg(data.msg);
            }
        }, 'json'); */
        return false;
    });

    layui.form.on('select(provinceId)', function (data) {
        cityId.find('option:not(:first)').remove();
        areaId.find('option:not(:first)').remove();
        if (data.value)
        	doAjax("post",'../api/aHousingEstateManager/v1/getCityList',{'addr': "2", 'provinceId': data.value,
            	"token":session.getItem("token")},function (data) {
           		 if (!data) return null;
                    if (data.data) {
                        $(data.data).each(function (k, v) {
                            cityId.append(new Option(v['citName'], v['cityId']));
                        });
                        layui.form.render('select');
                    }
            },function(err){});
            /* $.post('../api/aHousingEstateManager/v1/getCityList', {'addr': "2", 'provinceId': data.value,
            	"token":session.getItem("token")}, function (data) {
            
                if (!data || checkLogin(data)) return null;
                if (data.data) {
                    $(data.data).each(function (k, v) {
                        cityId.append(new Option(v['citName'], v['cityId']));
                    });
                    layui.form.render('select');
                }
            }); */
        layui.form.render('select');
    });

    layui.form.on('select(cityId)', function (data) {
        areaId.find('option:not(:first)').remove();
        if (data.value)
        	doAjax("post",'../api/aHousingEstateManager/v1/getCityAreaList',{'addr': "3", 'cityId': data.value,
            	"token":session.getItem("token")},function (data) {
           		if (!data) return null;
                   if (data.data) {
                       $(data.data).each(function (k, v) {
                           areaId.append(new Option(v['areaName'], v['areaId']));
                       });
                       layui.form.render('select');
                   }
            },function(err){});
            /* $.post('../api/aHousingEstateManager/v1/getCityAreaList', {'addr': "3", 'cityId': data.value,
            	"token":session.getItem("token")}, function (data) {
            
                if (!data || checkLogin(data)) return null;
                if (data.data) {
                    $(data.data).each(function (k, v) {
                        areaId.append(new Option(v['areaName'], v['areaId']));
                    });
                    layui.form.render('select');
                }
            }); */
        layui.form.render('select');
    });
    doAjax("post",'../api/aHousingEstateManager/v1/getProvinceList',{'addr': "1","token":session.getItem("token")},function (data) {
    	if (!data) return null;
        if (data.data) {
            $(data.data).each(function (k, v) {
                provinceId.append(new Option(v['provinceName'], v['provinceId']));
            });
            layui.form.render('select');
        }
    },function(err){});
/*     $.post('../api/aHousingEstateManager/v1/getProvinceList', {'addr': "1","token":session.getItem("token")}, function (data) {
        if (!data || checkLogin(data)) return null;
        if (data.data) {
            $(data.data).each(function (k, v) {
                provinceId.append(new Option(v['provinceName'], v['provinceId']));
            });
            layui.form.render('select');
        }
    }); */
});
</script>
</head>
<body>
<div class="child-body">
    <ul id="treeAgency" class="ztree layui-col-xs2"></ul>
    <ul id="treeCommunity" class="ztree layui-col-xs2"></ul>
    <div id="divfirst" style="padding-left: 5px">
        <div class="layui-btn-container">
            <button id="addCom" class="layui-btn"><i class="layui-icon">&#xe608;</i>添加小区</button>
            <button id="addBuilding" class="layui-btn layui-btn-disabled" disabled="disabled"><i class="layui-icon">&#xe608;</i>添加楼栋
            </button>
            <button id="addUnit" class="layui-btn layui-btn-disabled" disabled="disabled"><i
                        class="layui-icon">&#xe608;</i>添加单元
            </button>
            <button id="addRoom" class="layui-btn layui-btn-disabled" disabled="disabled"><i
                        class="layui-icon">&#xe608;</i>添加房间
            </button>
            <button id="btnEdit" class="layui-btn layui-btn-warm layui-btn-disabled" disabled="disabled"><i
                        class="layui-icon">&#xe642;</i>编辑
            </button>
            <button id="btnDel" class="layui-btn layui-btn-danger layui-btn-disabled" disabled="disabled"><i
                        class="layui-icon">&#xe640;</i>删除
            </button>
        </div>
        <div class="site-block layui-col-xs8">
            <form class="layui-form">
                <div class="layui-form-item">
                    <label class="layui-form-label">所属代理商</label>
                    <div class="layui-input-block">
                        <input type="text" id="ageName"
                               value="本代理商"
                               class="layui-input layui-disabled" disabled="disabled">
                    </div>
                </div>
                <div id="community" style="display: none">
                    <div class="layui-form-item">
                        <label class="layui-form-label">地区</label>
                        <div class="layui-input-inline">
                            <select name="provinceId" id="provinceId" lay-filter="provinceId" lay-verify="required"
                                    disabled="disabled">
                                <option value="">请选择</option>
                            </select>
                        </div>
                        <div class="layui-input-inline">
                            <select name="cityId" id="cityId" lay-filter="cityId" lay-verify="required"
                                    disabled="disabled">
                                <option value="">请选择</option>
                            </select>
                        </div>
                        <div class="layui-input-inline">
                            <select name="areaId" id="areaId" lay-filter="areaId" lay-verify="required"
                                    disabled="disabled">
                                <option value="">请选择</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">小区名</label>
                        <div class="layui-input-block">
                            <input type="text" id="commName" name="commName" lay-verify="required" disabled="disabled"
                                   placeholder="请输入名称"
                                   autocomplete="off" class="layui-input layui-disabled">
                        </div>
                    </div>
                </div>
                <div id="building" style="display: none">
                    <div class="layui-form-item">
                        <label class="layui-form-label">楼栋名</label>
                        <div class="layui-input-block">
                            <input type="text" id="bldName" name="bldName" disabled="disabled"
                                   placeholder="请输入名称"
                                   autocomplete="off" class="layui-input layui-disabled">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">楼栋呼叫码</label>
                        <div class="layui-input-block">
                            <input type="text" id="bldCode" name="bldCode" disabled="disabled"
                                   placeholder="请输入呼叫码码"
                                   autocomplete="off" class="layui-input layui-disabled">
                        </div>
                    </div>
                </div>

                <div id="unit" style="display: none">
                    <div class="layui-form-item">
                        <label class="layui-form-label">单元名</label>
                        <div class="layui-input-block">
                            <input type="text" id="unitName" name="unitName" disabled="disabled"
                                   placeholder="请输入名称"
                                   autocomplete="off" class="layui-input layui-disabled">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">单元呼叫码</label>
                        <div class="layui-input-block">
                            <input type="text" id="unitCode" name="unitCode" disabled="disabled"
                                   placeholder="请输入呼叫码码"
                                   autocomplete="off" class="layui-input layui-disabled">
                        </div>
                    </div>
                </div>
                <div id="room" style="display: none">
                    <div class="layui-form-item">
                        <label class="layui-form-label">房间名</label>
                        <div class="layui-input-block">
                            <input type="text" id="roomName" name="roomName" disabled="disabled"
                                   placeholder="请输入名称"
                                   autocomplete="off" class="layui-input layui-disabled">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">房间呼叫码</label>
                        <div class="layui-input-block">
                            <input type="text" id="roomCode" name="roomCode" disabled="disabled"
                                   placeholder="请输入呼叫码码"
                                   autocomplete="off" class="layui-input layui-disabled">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">房间类型</label>
                        <div class="layui-input-block">
                            <input type="radio" id="ye" name="type" value="0" title="业主" checked disabled="disabled">
                            <input type="radio" id="wu" name="type" value="1" title="物业" disabled="disabled">
                        </div>
                    </div>
                </div>
                <div id="actionItem" class="layui-form-item" style="display:none;">
                    <div class="layui-input-block">
                        <button id="formSubmit" class="layui-btn" lay-submit
                                lay-filter="formSubmit">保存修改
                        </button>
                        <button type="button" id="formCancel" class="layui-btn">取消</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>