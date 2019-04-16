<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Date"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width" />
<script type="text/javascript"
	src="../js/selelogin.js?v=<%= new Date().getTime() %>"></script>
<script type="text/javascript"
	src="../js/check.js?v=<%= new Date().getTime() %>"></script>
<script src="../layui/layui.js"></script>
<script src="../js/jquery-3.3.1.js"></script>
<script src="../js/jquerysession.js"></script>
<link rel="stylesheet" href="../layui/css/layui.css" media="all">
<link rel="stylesheet"
	href="../css/style.css?v=<%= new Date().getTime() %>" media="all">
<title>门禁卡管理</title>
<script>
$(function(){
	doAjax("post","../api/communityManager/v1/selectCommunityList",
			{ageId:$.session.get("agencyId"),token:$.session.get("token")},function (data) {
		//console.log("data:"+JSON.stringify(data));
		if(data.code == 0 && data.data){
			let resdata = data.data;
			for(i=0;i<resdata.length;i++){
				$("#queryCommunity").append("<option value="+resdata[i].commId+">"+resdata[i].commName+"</option>");
				//console.log($("#queryCommunity"));
				//console.log("内部加载完毕")
			}
			layui.form.render('select');
			addColumn();
		}else{
			relogin("1004");
		}
		//console.log("加载完毕")
    },function(err){
    	
    });
/* 	$.post("../api/communityManager/v1/selectCommunityList",
			{ageId:$.session.get("agencyId"),token:$.session.get("token")},function(data){
		//console.log("data:"+JSON.stringify(data));
		if(data.code == 0 && data.data){
			let resdata = data.data;
			for(i=0;i<resdata.length;i++){
				//console.log("resdata[i]:"+resdata[i].commName);
				$("#queryCommunity").append("<option value="+resdata[i].commId+">"+resdata[i].commName+"</option>");
				//console.log($("#queryCommunity"));
				//console.log("内部加载完毕")
			}
			layui.form.render('select');
			addColumn();
		}else{
			alert("登录信息已超时！");
            window.top.location = "./login.jsp";
		}
		//console.log("加载完毕")
	}); */
	
});

layui.config({
    base: "../js/"
}).use(['form', 'table', 'laydate', 'ztree'], function () {
    var date = new Date(),
    $ = layui.$,
    table = layui.table,
    session = window.sessionStorage;
    layui.laydate.render({
        elem: '#validDate'
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
    layui.table.render({
        elem: '#ic_table'
        , url: '../api/cardManager/v1/selectIcCardByAgeIdList'
        , cols: [[
            {
                title: '编号', type: 'numbers'
            }
            , {title: '卡号', field: 'cardNo', width: 106, sort: true}
            , {title: '用户', field: 'userName', width: 74}
            , {title: '所在小区', field: 'commName', width: 120}
            , {title: '生效时间', field: 'validDate'}
            , {title: '结束时间', field: 'expireDate'}
            , {
                title: '状态', field: 'status', templet: function (d) {
                    var s = '';
                    switch (d.status) {
                        case '2':
                            return "已冻结";
                        case '1':
                        	 return "已激活" + s;
                        case '0':
                        	 return '未激活';
                    }
                }, width: 120
            }
            , {
                title: '类型', width: 120, sort: true, templet: function (d) {
                    if("iccard" == d.cardCategory){
                    	return "IC卡"
                    }else if("idcard" == d.cardCategory){
                    	return "ID卡"
                    }else if("identitycard" == d.cardCategory){
                    	return "身份证卡"
                    }
                }
            }
            , {title: '操作管理', align: 'center', toolbar: '#barIC', fixed: 'right', width: 210}
        ]]
        , id: 'icTable'
        , page: true
        , height: 'full-120'
        , method: "post"
        ,contentType:'application/x-www-form-urlencoded'
        , where: {
            ageId: session.getItem("agencyId"),
            token:function(){
             	return session.getItem("token");
             },
    		userName:function(){
   				if($('#queryType').val() == "userName"){
   					return $('#queryKey').val();
   				}else{
   					return "";
   				}
   			},
   			cardNo:function(){
   				if($('#queryType').val() == "cardNo"){
   					return $('#queryKey').val();
   				}else{
   					return "";
   				}
   			},
   			commId:function(){
   				return $("#queryCommunity").val();
   			},
   			cardType:function(){
   				return $("#queryCardType").val();
   			},
   			cardStatus:function(){
   				return $("#queryCardStatus").val();
   			}
        }
        , request: {
            pageName: 'pageNum'
            , limitName: 'pageSize'
        }
        , parseData: function(res){
        	//console.log(res);
        	if(res.code ==1005){
        		let checkCode = checkToken(res);
        		if(checkCode == "200"){
        			return {
                		"code":res.code,
                		"msg":res.msg,
                		"count":res.data.total,
                		"data":res.data.cardList
                	}
        		}else if(checkCode == "1005"){
        			table.reload('icTable', {
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
            		"data":res.data.cardList
            	}
        	}
        	
        	/* if(res.code!==0 || !res.data || !res){
    			alert("登录信息已超时！");
                window.top.location = "./login.jsp";
    		}
        	return {
        		"code":res.code,
        		"msg":res.msg,
        		"count":res.data.total,
        		"data":res.data.cardList
        	} */
        }
        , done: function (res, curr, count) {
        	 checkForDataCode(res);
        }
    });
    layui.table.on('tool(icTable)', function (obj) {
        if (buttons[obj.event]) buttons[obj.event](obj);
    });
    var  treeCommunityDialog = $('#treeCommunityDialog')
        , validDate = $('#validDate')
        , expireDate = $('#expireDate')
        , icDialog = $('#icDialog')
        , statusDialog = $('#statusDialog')
        , invalid = $('#invalid')
        , active = $('#active')
        , freeze = $('#freeze')
        , queryType = $('#queryType')
        , queryKey = $('#queryKey')
        , commName = $('#commName')
        , commId = $('#commId')
        , bldName = $('#bldName')
        // , bldId = $('#bldId')
        , unitName = $('#unitName')
        // , unitId = $('#unitId')
        , roomName = $('#roomName')
        // , roomId = $('#roomId')
        , userName = $('#userName')
        , userId = $('#userId')
        , dialogIndex
        , statusIndex
        , icObjT
        , buttons = {
            add: function () {
            	dialogIndex = layer.open({
                    type: 1
                    , maxmin: true
                    , title: '添加门禁卡'
                    , content: $("#addUserDialog")
                    , area: ['700px', '610px']
                });
                layer.full(dialogIndex);
                
                /* layer.prompt({title: '添加门禁卡号'}, function (value, index, elem) {
                    var i = layer.load(2, {time: 5000});
                    $.post('../php/api.php?action=addIC', {
                        ageId: session.getItem("agencyId"),
                        token: session.getItem("token"),
                        cardNo: value
                    }, function (data) {
                        layer.close(i);
                        if (!data || checkLogin(data)) return null;
                        if (data.code == 0) {
                            layui.table.reload('icTable', {
                                page: {
                                    curr: 1 //重新从第 1 页开始
                                }
                                , where: {userName: '', cardNo: ''}
                            });
                            layer.close(index);
                            layer.msg("添加成功");
                        } else {
                            layer.msg(data.msg);
                        }
                    }, 'json');
                }); */
            }
            , bind: function (tobj) {
                icObjT = tobj;
                //console.log(tobj.data);
                dialogIndex = layer.open({
                    type: 1
                    , maxmin: true
                    , title: '绑定用户'
                    , content: icDialog
                    , area: ['700px', '500px']
                });
                if (tobj.data.validDate)
                    validDate.prop('value', tobj.data.validDate.substring(0, 10));
                if (tobj.data.expireDate)
                    expireDate.prop('value', tobj.data.expireDate.substring(0, 10));
                userId.prop('value', tobj.data.userId);
                if (tobj.data.userName)
                    userName.text(tobj.data.userName);
                else
                    userName.text('请选择用户');
                // roomId.prop('value', tobj.data.roomId);
                if (tobj.data.roomName)
                    roomName.text(tobj.data.roomName);
                else
                    roomName.text('请选择房间');
                if (tobj.data.unitName)
                    unitName.text(tobj.data.unitName);
                else
                    unitName.text('请选择单元');
                if (tobj.data.bldName)
                    bldName.text(tobj.data.bldName);
                else
                    bldName.text('请选择楼栋');
                commId.prop('value', tobj.data.commId);
                if (tobj.data.commName)
                    commName.text(tobj.data.commName);
                else
                    commName.text('请选择小区');
            }
            , del: function (tobj) {
                layer.open({
                    type: 0
                    , content: "确定删除门禁卡：" + tobj.data.cardNo + "?"
                    , shadeClose: true
                    , yes: function (index, layero) {
                        var i = layer.load(2, {time: 5000});
                        let delurl = ""
                        if(tobj.data.cardCategory == "iccard"){
                        	delurl = "../api/cardManager/v1/deleteIcCardById";
                        }else if(tobj.data.cardCategory == "idcard"){
                        	delurl = "../api/cardManager/v1/deleteIdCardById";
                        }else if(tobj.data.cardCategory == "identitycard"){
                        	delurl = "../api/cardManager/v1/deleteIdentityCardById";
                        }
                        doAjax("post",delurl,{id: tobj.data.id,token:session.getItem("token")},function (data) {
                        	layer.close(i);
                            if (!data) return null;
                            if (data.code == 0) {
                                layer.msg("删除成功");
                                tobj.del();
                            } else {
                                layer.msg(data.msg);
                            }
                        },function(err){});
                        /* $.post(delurl, {id: tobj.data.id,token:session.getItem("token")}, function (data) {
                            layer.close(i);
                            if (!data || checkLogin(data)) return null;
                            if (data.code == 0) {
                                layer.msg("删除成功");
                                tobj.del();
                            } else {
                                layer.msg(data.msg);
                            }
                        }, 'json'); */
                    }
                });
            }
            , query: function () {
                var where = {userName: '', cardNo: '',commId:$("#queryCommunity").val(),
                		cardType:$("#queryCardType").val(),cardStatus:$("#queryCardStatus").val()};
                where[queryType.val()] = queryKey.val();
                layui.table.reload('icTable', {
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
            , choose: function () {
                treeIndex = layer.open({
                    type: 1
                    , shadeClose: true
                    , title: '请选择用户'
                    , content: treeCommunityDialog
                    , area: ['700px', '500px']
                });
            }
            , status: function (tobj) {
                icObjT = tobj;
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
                    , title: "修改门禁卡状态：" + tobj.data.cardNo
                    , content: statusDialog
                    , shadeClose: true
                });
            }
        }
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
                otherParam:{"token":function(){return session.getItem("token")}}, 
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
                        childNodes[i].isParent = childNodes[i].level < 5;
                    }
                    return childNodes; 
                }
            }
            , callback: {
                onClick: function (event, treeId, treeNode) {
                    if (treeNode.level < 5) return;
                    layer.close(treeIndex);
                    if (curNode === treeNode) return;
                    curNode = treeNode;
                    userId.prop('value', treeNode.id);
                    userName.text(treeNode.name);
                    treeNode = treeNode.getParentNode();
                    // roomId.prop('value', treeNode.id);
                    roomName.text(treeNode.name);
                    treeNode = treeNode.getParentNode();
                    unitName.text(treeNode.name);
                    treeNode = treeNode.getParentNode();
                    bldName.text(treeNode.name);
                    treeNode = treeNode.getParentNode();
                    commName.text(treeNode.name);
                    commId.prop('value', treeNode.id);
                }
            }
        }, {
            name: session.getItem("agencyName")
            , id: session.getItem("agencyId")
            , isParent: true
        });
    layui.form.on('submit(formSubmit)', function (data) {
        data.field.ageId = session.getItem("agencyId");
        data.field.id = icObjT.data.id;
        data.field.token = session.getItem("token");
        var i = layer.load(2, {time: 5000});
        let updateurl = ""
        if(icObjT.data.cardCategory == "iccard"){
        	updateurl = "../api/cardManager/v1/updateIcCardById";
        }else if(icObjT.data.cardCategory == "idcard"){
        	updateurl = "../api/cardManager/v1/updateIdCardById";
        }else if(icObjT.data.cardCategory == "identitycard"){
        	updateurl = "../api/cardManager/v1/updateIdentityCardById";
        }
        doAjax("post",updateurl,data.field,function (data) {
        	layer.close(i);
            if (!data) return null;
            if (data.code == 0) {
                layer.msg("保存成功");
                layui.table.reload('icTable');
                layer.close(dialogIndex);
            } else {
                layer.msg(data.msg);
            }
        },function(err){});
        /* $.post(updateurl, data.field, function (data) {
            layer.close(i);
            if (!data || checkLogin(data)) return null;
            if (data.code == 0) {
                layer.msg("保存成功");
                layui.table.reload('icTable');
                layer.close(dialogIndex);
            } else {
                layer.msg(data.msg);
            }
        }, 'json'); */
        return false;
    });
    layui.form.on('submit(addSubmit)', function (data) {
    	console.log(JSON.stringify(data));
    	let datares = JSON.stringify(data.field);
    	let indexs = datares.split("cardNo").length-1;
    	console.log("最开始的indexs"+indexs);
    	let successindex = 0;
    	let startindex = 0;
    	let arryIc = [];
    	let arryId = [];
    	let arryIdentity = [];
    	for(i=1,j=0,k=0,l=0;i<indexs+1;i++){
    		if(data.field["cardNo"+i]){
    			if(data.field["cardType"+i] == "iccard"){
    				arryIc[j] = data.field["cardNo"+i];
    				j++;
    			}else if(data.field["cardType"+i] == "idcard"){
    				arryId[k] = data.field["cardNo"+i];
    				k++;
    			}else if(data.field["cardType"+i] == "identitycard"){
    				arryIdentity[l] = data.field["cardNo"+i];
    				l++;
    			}
    		}
    	}
    	console.log("IC:"+arryIc);
    	console.log("ID:"+arryId);
    	console.log("IDentity:"+arryIdentity);
    	if(arryIc.length>1){
    		if(isEquals(arryIc)){
    			layer.msg("添加的IC卡卡号有重复!");
    			return false;
    		}
    	}
    	if(arryId.length>1){
    		if(isEquals(arryId)){
    			layer.msg("添加的ID卡卡号有重复!");
    			return false;
    		}
    	}
    	if(arryIdentity.length>1){
    		if(isEquals(arryIdentity)){
    			layer.msg("添加的身份证卡卡号有重复!");
    			return false;
    		}
    	}
    	var j = layer.load(2, {time: 5000});
    	 for(i=1;i<indexs+1;i++){
    		let url = "";
    		if(data.field["cardType"+i] == "iccard"){
    			//console.log("iccard");
    			 url = "../api/cardManager/v1/addIcCardInfo";
    		}else if(data.field["cardType"+i] == "idcard"){
    			//console.log("idcard");
   			 	url = "../api/cardManager/v1/addIdCardInfo";
    		}else if(data.field["cardType"+i] == "identitycard"){
    			//console.log("idcard");
   			 	url = "../api/cardManager/v1/addIdentityCardInfo";
    		}
    		if(data.field["cardNo"+i]){
    			startindex++;
    			doAjax("post",url,{
                    ageId: session.getItem("agencyId"),
                    token: session.getItem("token"),
                    cardNo: data.field["cardNo"+i]
                },function (data) {
                	successindex++;
                    if (!data) return null;
                    if (data.code == 0) {
                        layui.table.reload('icTable', {
                            page: {
                                curr: 1 //重新从第 1 页开始
                            }
                            , where: {userName: '', cardNo: ''}
                        });
                        console.log(startindex);
                        console.log(successindex);
                        if(startindex == successindex){
                        	layer.close(j);
                            layer.msg("添加成功");
                            layer.close(dialogIndex);
                        }
                    } else {
                        layer.msg(data.msg);
                    }
                },function(err){});
    		}
/*     		$.post(url, {
                ageId: session.getItem("agencyId"),
                token: session.getItem("token"),
                cardNo: data.field["cardNo"+i]
            }, function (data) {
            	successindex++;
                layer.close(i);
                if (!data || checkLogin(data)) return null;
                if (data.code == 0) {
                    layui.table.reload('icTable', {
                        page: {
                            curr: 1 //重新从第 1 页开始
                        }
                        , where: {userName: '', cardNo: ''}
                    });
                    if(successindex == indexs){
                    	layer.close(layer.index);
                        layer.msg("添加成功");
                    }
                } else {
                    layer.msg(data.msg);
                }
            }, 'json'); */
    	}
    	//console.log( datares.split("cardNo").length-1);
    });
    layui.form.on('submit(submitStatus)', function (data) {
        var i = layer.load(2, {time: 5000});
        // if (icObjT.data.status == data.field.status) {
        //     layer.msg("保存成功");
        //     layer.close(i);
        //     layer.close(statusIndex);
        //     return false;
        // }
        var url, postData = {}, status = data.field.status;
        switch (status) {
            case '0':
            	if(icObjT.data.cardCategory == "iccard"){
            		 postData.ageId = icObjT.data.ageId;
                     postData.token = session.getItem("token");
                     postData.id = icObjT.data.id;
                     url = '../api/cardManager/v1/cancelActivationIcCardById';
                     break;
            	}else if(icObjT.data.cardCategory == "idcard"){
            		postData.ageId = icObjT.data.ageId;
                    postData.token = session.getItem("token");
                    postData.id = icObjT.data.id;
                    url = '../api/cardManager/v1/cancelActivationIdCardById';
                    break;
            	}else if(icObjT.data.cardCategory == "identitycard"){
            		postData.ageId = icObjT.data.ageId;
                    postData.token = session.getItem("token");
                    postData.id = icObjT.data.id;
                    url = '../api/cardManager/v1/cancelActivationIdentityCardById';
                    break;
            	}
               
            case '1':
            	//console.log("icObjT.data.status:"+JSON.stringify(icObjT));
            	//console.log("icObjT.data.status:"+JSON.stringify(icObjT.data.cardCategory));
            	if(icObjT.data.cardCategory == "iccard"){
            		postData.ageId = icObjT.data.ageId;
                    postData.token = session.getItem("token");
                    postData.id = icObjT.data.id;
                    url = '../api/cardManager/v1/activationIcCardById';
                    break;
            	}else if(icObjT.data.cardCategory == "idcard"){
            		postData.ageId = icObjT.data.ageId;
                    postData.token = session.getItem("token");
                    postData.id = icObjT.data.id;
                    url = '../api/cardManager/v1/activationIdCardById';
                    break;
            	}else if(icObjT.data.cardCategory == "identitycard"){
            		postData.ageId = icObjT.data.ageId;
                    postData.token = session.getItem("token");
                    postData.id = icObjT.data.id;
                    url = '../api/cardManager/v1/activationIdentityCardById';
                    break;
            	}
               
            case '2':
            	if(icObjT.data.cardCategory == "iccard"){
           		 postData.ageId = icObjT.data.ageId;
                    postData.token = session.getItem("token");
                    postData.id = icObjT.data.id;
                    url = '../api/cardManager/v1/cfreezeIcCardById';
                    break;
           	}else if(icObjT.data.cardCategory == "idcard"){
           		postData.ageId = icObjT.data.ageId;
                   postData.token = session.getItem("token");
                   postData.id = icObjT.data.id;
                   url = '../api/cardManager/v1/cfreezeIdCardById';
                   break;
           	}else if(icObjT.data.cardCategory == "identitycard"){
           		postData.ageId = icObjT.data.ageId;
                   postData.token = session.getItem("token");
                   postData.id = icObjT.data.id;
                   url = '../api/cardManager/v1/cfreezeIdentityCardById';
                   break;
           	}
        }
        doAjax("post",url,postData,function (data) {
        	layer.close(i);
            if (!data) return null;
            if (data.code == 0) {
                layer.msg("保存成功");
                layui.table.reload('icTable');
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
                layui.table.reload('icTable');
                layer.close(statusIndex);
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
});
function addColumn(){
	let index = $("#addUserDialogTbody tr").length;
	$("#addUserDialogTbody").append(
			"<tr id="+(index+1)+"><th><div name='trindex'>"+(index+1)+"</div></th><th><div class='layui-input-block' style='margin:0'>"
			+"<input type='text' class='layui-input' name='cardNo"+(index+1)+"'>"
			+"</div></th><th><div class='layui-inline'>"
			+"<select name='cardType"+(index+1)+"'>"
			+"<option value='iccard'>IC卡</option>"
			+"<option value='idcard'>ID卡</option>"
			+"<option value='identitycard'>身份证卡</option>"
			+"</select></div></th><th>"
			+"<button class='layui-btn layui-btn-danger' onclick='delColumn("+(index+1)+")'>删除</button></th></tr>");
	layui.form.render('select');
}
function delColumn(index){
	 $("#addUserDialogTbody tr[id='"+index+"']").remove();//删除当前行
}
</script>
<script type="text/html" id="barIC">
    <a class="layui-btn layui-btn-xs" lay-event="status">激活/冻结</a>
    <a class="layui-btn layui-btn-xs" lay-event="bind">绑定用户</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
</script>
</head>
<body>
<div class="child-body">
    <div id="treeCommunityDialog" class="site-block" style="display: none">
        <ul id="treeCommunity" class="ztree"></ul>
    </div>
    <div id="icDialog" class="site-block" style="display: none">
        <form class="layui-form">
            <input type="hidden" id="userId" name="userId">
            <input type="hidden" id="commId" name="commId">
            <div class="layui-form-item">
                <div class="layui-form-item">
                    <label class="layui-form-label" for="validDate">生效时间</label>
                    <div class="layui-input-inline">
                        <input type="text" class="layui-input" id="validDate" name="validDate">
                    </div>
                    <label class="layui-form-label" for="expireDate">结束时间</label>
                    <div class="layui-input-inline">
                        <input type="text" class="layui-input" id="expireDate"
                               name="expireDate">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">绑定用户</label>
                <div class="layui-input-block">
                    <button type="button" data-type="choose" class="layui-btn layui-btn-normal">
                        选择用户
                    </button>
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
                            <th>用户</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td id="commName"></td>
                            <td id="bldName"></td>
                            <td id="unitName"></td>
                            <td id="roomName"></td>
                            <td id="userName"></td>
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
                    <input type="radio" id="invalid" name="status" value="0" title="取消激活" checked>
                    <input type="radio" id="active" name="status" value="1" title="激活">
                    <input type="radio" id="freeze" name="status" value="2" title="冻结">
                </div>
            </div>
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit lay-filter="submitStatus">保存
                </button>
                <button type="button" data-type="cancelStatus" class="layui-btn">取消</button>
            </div>
        </form>
    </div>
	<div id="addUserDialog" class="site-block" style="display: none">
		<div class="layui-form" style="margin: 10px">
			<table class="layui-table">
			 <thead>
			    <tr>
			      <th>序号</th>
			      <th>卡号</th>
			      <th>类型</th>
			      <th>管理</th>
			    </tr> 
			  </thead>
			  <tbody id="addUserDialogTbody">
			  	
			  </tbody>
			  
			  	
                
		</table>
		<div>
	  	<button class="layui-btn" onclick="addColumn()">增加栏位</button>
		<button id="addSubmit" class="layui-btn" lay-submit lay-filter="addSubmit">确定添加</button>
		</div>
	  	
	</div>
		
	</div>
    <div class="layui-form" style="margin: 10px">
        <div class="layui-form-item">
            <div class="layui-inline">
                <select id="queryType">
                    <option value="userName">按用户名称查询</option>
                    <option value="cardNo">按卡号查询</option>
                </select>
            </div>
            <div class="layui-inline">
            	<select id="queryCommunity">
                    <option value="" >按照小区查询</option>
                </select>
            </div>
            <div class="layui-inline">
            	 <select id="queryCardType">
                    <option value="">按照卡类型查询</option>
                    <option value="iccardtype">IC卡</option>
                    <option value="idcardtype">ID卡</option>
                    <option value="identitytype">身份证</option>
                </select>
            </div>
            <div class="layui-inline">
            	<select id="queryCardStatus">
                    <option value="">按照状态查询查询</option>
                    <option value="1">已激活</option>
                    <option value="2">已冻结</option>
                    <option value="3">已过期</option>
                    <option value="0">未激活</option>
                </select>
            </div>
            <div class="layui-inline">
                <input class="layui-input" id="queryKey" placeholder="请输入关键字">
            </div>
            <button class="layui-btn" data-type="query">搜索</button>
            <button data-type="add" class="layui-btn layui-btn-normal"><i class="layui-icon">&#xe608;</i>添加卡号</button>
        </div>
    </div>
    <table id="ic_table" lay-filter="icTable"></table>
</div>
</body>
</html>