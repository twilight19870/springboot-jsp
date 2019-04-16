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
<title>广告管理</title>
<script type="text/javascript">
layui.config({
    base: "../js/"
}).use(['form', 'table', 'laydate', 'ztree', 'upload', 'element'], function () {
    var date = new Date(),
    session = window.sessionStorage;
    date.setFullYear(date.getFullYear() + 1);
    layui.laydate.render({
        elem: '#expireDate'
        , type: 'date'
        , value: date
        , isInitValue: true
    });
    layui.table.render({
        elem: '#ic_table'
        , url: '../api/advertiseManager/v1/selectAdvertiseList'
        , cols: [[
            {title: '序号', type: 'numbers'},
            {title: '广告名', field: 'name', width: 120, sort: true},
            // {title: '创建人', field: 'userName', width: 74},
            {title: '创建时间', field: 'createTime', width: 200},
            {title: '有效期', field: 'activeTime', width: 200},
            {title: '备注', field: 'describe'},
            {title: '操作管理', align: 'center', toolbar: '#barIC', fixed: 'right', width: 210}
        ]]
        , id: 'icTable'
        , page: true
        , height: 'full-120'
        , method: "post"
        ,contentType:'application/x-www-form-urlencoded'
        , where: {
            token :  function(){
            	return session.getItem("token");
            }
           	,ageId : session.getItem("agencyId")
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
                		"data":res.data.advList
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
            		"data":res.data.advList
            	}
        	}
        	if(res.code!==0 || !res.data || !res){
    			alert("登录信息已超时！");
                window.top.location = "./login.jsp";
    		}
        	return {
        		"code":res.code,
        		"msg":res.msg,
        		"count":res.data.total,
        		"data":res.data.advList
        	}
        }
        , done: function (res, curr, count) {
            checkLogin(res);
        }
    });
    layui.table.on('tool(icTable)', function (obj) {
        if (buttons[obj.event]) buttons[obj.event](obj);
    });
    var $ = layui.$
        , preview = $('#preview')
        , adNote = $('#adNote')
        ,fileName = ""
        ,fileType = -1
        , adName = $('#adName')
        , expireDate = $('#expireDate')
        , uploadDialog = $('#uploadDialog')
        , icDialog = $('#icDialog')
        , statusDialog = $('#statusDialog')
        , queryType = $('#queryType')
        , queryKey = $('#queryKey')
        , queryResKey = $('#queryResKey')
        , allCount = $('#allCount')
        , onlineCount = $('#onlineCount')
        , offlineCount = $('#offlineCount')
        , dialogIndex
        , icObjT
        , queryResource = function (content, datapost, number, pageSize) {
            var type = content.data('value');
            datapost['type'] = type;
            datapost['token'] = session.getItem("token");
            datapost['ageId'] = session.getItem("agencyId");
            datapost['pageNum'] = number == 0 ? 1 : number;
            datapost['pageSize'] = pageSize;
            doAjax("post",'../api/advertiseManager/v1/selectAdvertiseVideoPictureList',datapost,function (data) {
            	if (!data) return null;
                var child = content.children();
                if (data.data) {
                    if (number == 0) {
                        layui.laypage.render({
                            elem: child[0]
                            , count: data.data.total
                            , limit: data.data.pageSize
                            , layout: ['prev', 'page', 'next', 'skip', 'limit']
                            , jump: function (obj, first) {
                                //首次不执行
                                if (!first) {
                                    queryResource(content, datapost, obj.curr, obj.limit);
                                }
                            }
                        });
                    }
                    child.eq(1).html("");
                    var srcStr = 'img';
                    if (type === 1)
                        srcStr = 'video';
                    $(data.data.advertiseList).each(function (k, v) {
                        var div = $('<div class="item-style" >' +
                            '<p class="text" ">' + v.name + '</p>' +
                            '<' + srcStr + ' src="' + v.path + '" height="100px" width="100px"/>' +
                            '<div><a href="javascript:"><i class="layui-icon layui-icon-add-1"/></a>' +
                            '<a href="javascript:"><i class="layui-icon layui-icon-delete"/></a></div>' +
                            '</div>');
                        var as = div.find('a');
                        as.eq(0).on('click', function () {
                            treeManifest.addNodes(treeManifest.getNodes()[0], -1, v);
                            var srcStr = 'img';
                            if (v.type === '1')
                                srcStr = 'video controls="controls" ';
                            preview.html('<' + srcStr + ' width="100%" height="100%" src="' + v.path + '" />');
                        });
                        as.eq(1).on('click', function () {
                            layer.open({
                                type: 0
                                , content: "确定删除：" + v.name + "?"
                                , shadeClose: true
                                , yes: function (index, layero) {
                                    var i = layer.load(2, {time: 5000});
                                    doAjax("post",'../api/advertiseManager/v1/deleteAdvertiseVideoPictureById',{id: v.id,
                                    	token:session.getItem("token")},function (data) {
                                    		layer.close(i);
                                            if (!data) return null;
                                            if (data.code == 0) {
                                                layer.msg("删除成功");
                                                div.remove();
                                            } else {
                                                layer.msg(data.msg);
                                            }
                                    },function(err){});
                                    /* $.post('../api/advertiseManager/v1/deleteAdvertiseVideoPictureById', {id: v.id,
                                    	token:session.getItem("token")}, function (data) {
                                        layer.close(i);
                                        if (!data || checkLogin(data)) return null;
                                        if (data.code == 0) {
                                            layer.msg("删除成功");
                                            div.remove();
                                        } else {
                                            layer.msg(data.msg);
                                        }
                                    }); */
                                }
                            });
                        });
                        child.eq(1).append(div);
                    });
                }
            },function(err){});
            /* $.post('../api/advertiseManager/v1/selectAdvertiseVideoPictureList', datapost, function (data) {
                if (!data || checkLogin(data)) return null;
                var child = content.children();
                if (data.data) {
                    if (number == 0) {
                        layui.laypage.render({
                            elem: child[0]
                            , count: data.data.total
                            , limit: data.data.pageSize
                            , layout: ['prev', 'page', 'next', 'skip', 'limit']
                            , jump: function (obj, first) {
                                //首次不执行
                                if (!first) {
                                    queryResource(content, datapost, obj.curr, obj.limit);
                                }
                            }
                        });
                    }
                    child.eq(1).html("");
                    var srcStr = 'img';
                    if (type === 1)
                        srcStr = 'video';
                    $(data.data.advertiseList).each(function (k, v) {
                        var div = $('<div class="item-style" >' +
                            '<p class="text" ">' + v.name + '</p>' +
                            '<' + srcStr + ' src="' + v.path + '" height="100px" width="100px"/>' +
                            '<div><a href="javascript:"><i class="layui-icon layui-icon-add-1"/></a>' +
                            '<a href="javascript:"><i class="layui-icon layui-icon-delete"/></a></div>' +
                            '</div>');
                        var as = div.find('a');
                        as.eq(0).on('click', function () {
                            treeManifest.addNodes(treeManifest.getNodes()[0], -1, v);
                            var srcStr = 'img';
                            if (v.type === '1')
                                srcStr = 'video controls="controls" ';
                            preview.html('<' + srcStr + ' width="100%" height="100%" src="' + v.path + '" />');
                        });
                        as.eq(1).on('click', function () {
                            layer.open({
                                type: 0
                                , content: "确定删除：" + v.name + "?"
                                , shadeClose: true
                                , yes: function (index, layero) {
                                    var i = layer.load(2, {time: 5000});
                                    $.post('../api/advertiseManager/v1/deleteAdvertiseVideoPictureById', {id: v.id,
                                    	token:session.getItem("token")}, function (data) {
                                        layer.close(i);
                                        if (!data || checkLogin(data)) return null;
                                        if (data.code == 0) {
                                            layer.msg("删除成功");
                                            div.remove();
                                        } else {
                                            layer.msg(data.msg);
                                        }
                                    });
                                }
                            });
                        });
                        child.eq(1).append(div);
                    });
                }
            }); */
        }
        , buttons = {
            add: function () {
                icObjT = null;
                dialogIndex = layer.open({
                    type: 1
                    , maxmin: true
                    , title: '添加广告'
                    , content: icDialog
                    // , cancel: function (index, layero) {
                    //     if (confirm('确定要关闭么')) { //只有当点击confirm框的确定时，该层才会关闭
                    //         layer.close(index)
                    //     }
                    //     return false;
                    // }
                    , area: ['100%', '100']
                });
            }
            , edit: function (tobj) {
                icObjT = tobj;
                var i = layer.load(2, {time: 5000});
                doAjax("post",'../api/advertiseManager/v1/selectAdvertiseDetail',{id: tobj.data.id,
                	token:session.getItem("token")},function (data) {
                		layer.close(i);
                        if (!data) return null;
                        if (data.code == 0 && data.data.advDetail) {
                            adNote.prop('value', data.data.advDetail.describe);
                            if (data.data.advDetail.activeTime)
                                expireDate.prop('value', data.data.advDetail.activeTime.substring(0, 10));
                            var parentNode = treeManifest.getNodes()[0];
                            treeManifest.removeChildNodes(parentNode);
                            preview.html('');
                            treeManifest.addNodes(parentNode, -1, data.data.advDetail.advList);
                            adNote.prop('value', data.data.advDetail.describe);
                            adName.prop('value', data.data.advDetail.name);
                            dialogIndex = layer.open({
                                type: 1
                                , maxmin: true
                                , title: '编辑广告'
                                , content: icDialog
                                , area: ['100%', '100%']
                            });
                        } else {
                            layer.msg(data.msg);
                        }
                },function(err){});
                /* $.post('../api/advertiseManager/v1/selectAdvertiseDetail', {id: tobj.data.id,
                	token:session.getItem("token")}, function (data) {
                    layer.close(i);
                    if (!data || checkLogin(data)) return null;
                    if (data.code == 0 && data.data.advDetail) {
                        adNote.prop('value', data.data.advDetail.describe);
                        if (data.data.advDetail.activeTime)
                            expireDate.prop('value', data.data.advDetail.activeTime.substring(0, 10));
                        var parentNode = treeManifest.getNodes()[0];
                        treeManifest.removeChildNodes(parentNode);
                        preview.html('');
                        treeManifest.addNodes(parentNode, -1, data.data.advDetail.advList);
                        adNote.prop('value', data.data.advDetail.describe);
                        adName.prop('value', data.data.advDetail.name);
                        dialogIndex = layer.open({
                            type: 1
                            , maxmin: true
                            , title: '编辑广告'
                            // , cancel: function (index, layero) {
                            //     // if (confirm('确定要关闭么')) { //只有当点击confirm框的确定时，该层才会关闭
                            //     //     layer.close(index);
                            //     // }
                            //     layer.confirm('确定要关闭么?', {icon: 3, title:'提示'}, function(index){
                            //         //do something
                            //
                            //         layer.close(index);
                            //     });
                            //     return false;
                            // }
                            , content: icDialog
                            , area: ['100%', '100%']
                        });
                    } else {
                        layer.msg(data.msg);
                    }
                }); */
            }
            , del: function (tobj) {
                layer.open({
                    type: 0
                    , content: "确定删除广告：" + tobj.data.name + "?"
                    , shadeClose: true
                    , yes: function (index, layero) {
                        var i = layer.load(2, {time: 5000});
                        doAjax("post",'../api/advertiseManager/v1/deleteAdvertiseById',{id: tobj.data.id
                        	,token:session.getItem("token")},function (data) {
                        		layer.close(i);
                                if (!data) return null;
                                if (data.code == 0) {
                                    layer.msg("删除成功");
                                    tobj.del();
                                } else {
                                    layer.msg(data.msg);
                                }
                        },function(err){});
                        /* $.post('../api/advertiseManager/v1/deleteAdvertiseById', {id: tobj.data.id
                        	,token:session.getItem("token")}, function (data) {
                            layer.close(i);
                            if (!data || checkLogin(data)) return null;
                            if (data.code == 0) {
                                layer.msg("删除成功");
                                tobj.del();
                            } else {
                                layer.msg(data.msg);
                            }
                        }); */
                    }
                });
            }
            , query: function () {
                var where = {name: '', describe: ''};
                where[queryType.val()] = queryKey.val();
                layui.table.reload('icTable', {
                    page: {
                        curr: 1 //重新从第 1 页开始
                    }
                    , where: where
                });
            }
            , queryRes: function () {
                queryResource($('.layui-tab-item.layui-show'), {'name': queryResKey.val()}, 0, 10);
            }
            , refreshRes: function () {
                queryResource($('.layui-tab-item.layui-show'), {}, 0, 10);
            }
            , cancel: function () {
                layer.close(dialogIndex);
            }
            , status: function (tobj) {
                icObjT = tobj;
                treeCommunity.checkAllNodes(false);
                layer.open({
                    type: 1
                    , title: "发布广告：" + tobj.data.name
                    , content: statusDialog
                    , area: ['700px', '500px']
                    , shadeClose: true
                });
            }
            , upload: function () {
                layer.open({
                    type: 1
                    , title: '文件上传'
                    // , shade: 0
                    , content: uploadDialog
                    , area: ['100%', '100%']
                });
            }
            , send: function () {
                var nodes = treeCommunity.getCheckedNodes(true), ids = [], all = 0, online = 0;
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
                    var i = layer.load(2, {time: 5000});
                    doAjax("post",'../api/advertiseManager/v1/doorPhoneAdvertising',{
                        id: icObjT.data.id,
                        token: session.getItem("token"),
                        doorPhoneId: JSON.stringify(ids)
                    },function (data) {
                    	layer.close(i);
                        if (!data) return null;
                        if (data.code == 0) {
                            layer.msg("发送成功");
                        } else {
                            layer.msg(data.msg);
                        }
                    },function(err){});
                    /* $.post('../api/advertiseManager/v1/doorPhoneAdvertising', {
                        id: icObjT.data.id,
                        token: session.getItem("token"),
                        doorPhoneId: JSON.stringify(ids)
                    }, function (data) {
                        layer.close(i);
                        if (!data || checkLogin(data)) return null;
                        if (data.code == 0) {
                            layer.msg("发送成功");
                        } else {
                            layer.msg(data.msg);
                        }
                    }, 'json'); */
                } else
                    layer.msg('请选择门口机设备');
            }
        }
        , treeCommunity = $.fn.zTree.init($("#treeCommunity"), {
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
                        treeCommunity.reAsyncChildNodes(treeNode, 'refresh');
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
                url: getMacMain,
                otherParam: {"token":function(){return session.getItem("token")},"ageId":session.getItem("agencyId")},
                dataFilter: function (treeId, parentNode, data) {
                	let checkCode = checkToken(data);
                    if(checkCode == "1005"){
                    	treeCommunity.expandAll(false);
                    	treeCommunity.refresh();
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
            // , callback: {
            // onClick: function (event, treeId, treeNode) {
            //     if (treeNode.level < 5) return;
            //     layer.close(treeIndex);
            //     if (curNode === treeNode) return;
            //     curNode = treeNode;
            //     userId.prop('value', treeNode.id);
            //     userName.text(treeNode.name);
            //     treeNode = treeNode.getParentNode();
            //     // roomId.prop('value', treeNode.id);
            //     roomName.text(treeNode.name);
            //     treeNode = treeNode.getParentNode();
            //     unitName.text(treeNode.name);
            //     treeNode = treeNode.getParentNode();
            //     bldName.text(treeNode.name);
            //     treeNode = treeNode.getParentNode();
            //     commName.text(treeNode.name);
            //     commId.prop('value', treeNode.id);
            // }
            // }
        }, {
            name: session.getItem("agencyName")
            , isParent: true
        })
        , treeManifest = $.fn.zTree.init(
        $("#treeManifest")
        , {
            edit: {
                drag: {
                    inner: function (treeId, nodes, targetNode) {
                        return targetNode != null && targetNode.isParent;
                    }
                },
                enable: true,
                showRenameBtn: false,
                showRemoveBtn: function (treeId, treeNode) {
                    return treeNode.level !== 0;
                },
                removeTitle: '删除'
            },
            callback: {
                beforeDrop: function (treeId, treeNodes, targetNode, moveType) {
                    return !(targetNode == null || (moveType != "inner" && !targetNode.parentTId));
                },
                onClick: function (event, treeId, treeNode) {
                    if (treeNode.level === 0) return;
                    var srcStr = 'img';
                    if (treeNode.type === '1')
                        srcStr = 'video controls="controls" ';
                    preview.html('<' + srcStr + ' width="100%" height="100%" src="' + treeNode.path + '" />');
                }
            }
        }, {
            name: "根", open: true,
            children: []
        })
        //多文件列表示例
        , demoListView = $('#demoList')
        , files
        , fileIndexi = 0
        , fileLength = 0
        , datastr = ""
        , indexlist = new Array()
        , uploadListIns = layui.upload.render({
            elem: '#testList'
            , url: '../api/advertiseManager/v1/addAdvertiseVideoPictureInfoList'
            , accept: 'file'
            , acceptMime: 'image/*, video/*'
            , multiple: true
            , auto: false
            , bindAction: '#testListAction'
            , choose: function (obj) {
                files = this.files = obj.pushFile(); //将每次选择的文件追加到文件队列
                //读取本地文件
                obj.preview(function(index, file, result){
                	let fileType = -1;
                	if(file.type.indexOf("image") !=-1){
                		//console.log("图片");
                		fileType = 0;
                	}else if(file.type.indexOf("video") !=-1){
                		//console.log("视频");
                		fileType = 1;
                	}
                	indexlist.push({"fileName":file.name,"setName":"","fileType":fileType});
                	//console.log(index);
                	//console.log(files[index]);
                	//console.log(files);
                    var tr = $(['<tr id="upload-' + index + '">'
                        , '<td>' + file.name + '</td>'
                        , '<td><input type="text" name="'+"fileName"+file.name+'" class="layui-input"></td>'
                        , '<td>' + (file.size / 1014).toFixed(1) + 'kb</td>'
                        , '<td>等待上传</td>'
                        , '<td>'
                        , '<button class="layui-btn layui-btn-mini demo-reload layui-hide">重传</button>'
                        , '<button class="layui-btn layui-btn-mini layui-btn-danger demo-delete">删除</button>'
                        , '</td>'
                        , '</tr>'].join(''));

                    //单个重传
                    tr.find('.demo-reload').on('click', function () {
                        obj.upload(index, file);
                    });

                    //删除
                    tr.find('.demo-delete').on('click', function () {
                    	//console.log("对应的文件："+files[index].name);
                    	for(i=0;i<indexlist.length;i++){
                    		if(indexlist[i].fileName == files[index].name){
                    			indexlist.splice( i, 1 );
                    		}
                    	}
                        delete files[index]; //删除对应的文件
                        tr.remove();
                        uploadListIns.config.elem.next()[0].value = ''; //清空 input file 值，以免删除后出现同名文件不可选
                    });
                    demoListView.append(tr);
                });
            }
        	
            , before: function (obj) { //obj参数包含的信息，跟 choose回调完全一致，可参见上文。
                //console.log("JSON:"+$("input[name*='fileName']").val());
                //console.log("JSON.stringify:"+JSON.stringify($("input[name*='fileName']").val()));
                if(this.files && JSON.stringify(this.files) != "{}"){
                	//console.log("this.files:"+JSON.stringify(this.files));
                	//console.log("indexlist.length:"+indexlist.length);
                	layer.load(); //上传loading
                }
                fileLength = indexlist.length;
                for(i=0;i<indexlist.length;i++){
                	let inputval = $("input[name='fileName"+indexlist[i].fileName+"']").val();
                	if(inputval){
                		indexlist[i].setName = inputval;
                	}else{
                		let filenamestr = indexlist[i].fileName;
                		if(filenamestr.length > 15){
                			//alert("默认文件名过长，请设置文件名或者重命名文件！");
                			layer.close(layer.index);
                			 layer.open({
									title: '请重新输入文件名'
                                 , area: ['350px', '200px']
                                 , content:'默认文件名过长，请设置文件名或者重命名文件！'
                             });
                			return false;
                		}else{
                			
                			indexlist[i].setName = filenamestr;
                		}
                	}
                	
                }
                //console.log(indexlist);
                //console.log(JSON.stringify(indexlist));
                datastr = "1111111";
                //layer.load(); //上传loading
                this.data={token : function(){return session.getItem("token")},
                		nameList : JSON.stringify(indexlist),
                		ageId : session.getItem("agencyId")
                };
               
               // session.setItem("indexlist",indexlist);
               
            }
           /*  ,data: {
        		token: session.getItem("token"),
        		name : datastr,
        		ageId : session.getItem("agencyId")
        		
        	} */
            , done: function (res, index, upload) {
            	//console.log(res);
            	let checkCode = checkToken(res);
            	if(checkCode == "1005"){
            		uploadListIns.upload(); 
            	}else if(checkCode == "1004" || checkCode == "1003" || checkCode == "1002"){
            		relogin(checkCode);
            	}else{
            		if (res.code == 0) { //上传成功
                        var tr = demoListView.find('tr#upload-' + index)
                            , tds = tr.children();
                        tds.eq(3).html('<span style="color: #5FB878;">上传成功</span>');
                        tds.eq(4).html(''); //清空操作
                    	++fileIndexi;
                    	/* console.log("fileIndexi:"+fileIndexi);
                    	console.log("fileLength:"+fileLength); */
                    	if(fileIndexi == fileLength){
                    		layer.close(layer.index);
                    	}
                    	for(i=0;i<indexlist.length;i++){
                    		
                    	}
                        return delete this.files[index]; //删除文件队列已经上传成功的文件
                    }
                    this.error(index, upload, res.msg,res.code);
            	}
            }
            , error: function (index, upload, msg,code) {
            	//console.log("code:"+code);
                var tr = demoListView.find('tr#upload-' + index)
                    , tds = tr.children();
                if(code == "1002"){
                	tds.eq(3).html('<span style="color: #FF5722;">上传失败' + (msg=="?????" ? '(默认文件名过长)' : '') + '</span>');
                }else{
                	tds.eq(3).html('<span style="color: #FF5722;">上传失败' + (msg ? '(' + msg + ')' : '') + '</span>');
                }   
                tds.eq(4).find('.demo-reload').removeClass('layui-hide'); //显示重传
            }
        });
    $('#clearDone').on('click', function () {
        var trs = demoListView.children();
        for (var i = 0; i < trs.length; i++) {
            var tds = trs.eq(i).find('td');
            if (tds.eq(3).text() == '上传成功')
                trs[i].remove();
        }
    });
    layui.form.on('submit(formSubmit)', function (data) {
        data.field.videoPictureId = [];
        var children = treeManifest.getNodes()[0].children;
        if (children)
            for (var i = 0, len = children.length; i < len; i++) {
                data.field.videoPictureId[i] = children[i].id;
            }
        data.field.videoPictureId = JSON.stringify(data.field.videoPictureId);
        var i = layer.load(2, {time: 5000}), url;
        if (icObjT) {
            url = '../api/advertiseManager/v1/updateAdvertiseById';
            data.field.id = icObjT.data.id;
            data.field.token = session.getItem("token");
        } else{
        	url = '../api/advertiseManager/v1/createAdvertiseInfo';
        	data.field.token = session.getItem("token");
        	data.field.ageId = session.getItem("agencyId");
        }
        doAjax("post",url,data.field,function (data) {
        	layer.close(i);
            if (!data) return null;
            if (data.code == 0) {
                if (icObjT)
                    layui.table.reload('icTable');
                else
                    layui.table.reload('icTable', {
                        page: {
                            curr: 1 //重新从第 1 页开始
                        }
                        , where: {name: '', describe: ''}
                    });
                layer.msg("保存成功");
                layer.close(dialogIndex);
                treeManifest.removeChildNodes(treeManifest.getNodes()[0]);
                preview.html('');
            } else {
                layer.msg(data.msg);
            }
        },function(err){});
        /* $.post(url, data.field, function (data) {
            layer.close(i);
            if (!data || checkLogin(data)) return null;
            if (data.code == 0) {
                if (icObjT)
                    layui.table.reload('icTable');
                else
                    layui.table.reload('icTable', {
                        page: {
                            curr: 1 //重新从第 1 页开始
                        }
                        , where: {name: '', describe: ''}
                    });
                layer.msg("保存成功");
                layer.close(dialogIndex);
                treeManifest.removeChildNodes(treeManifest.getNodes()[0]);
                preview.html('');
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
    buttons['refreshRes']();
    var initResource = true;
    layui.element.on('tab(resource)', function (data) {
        if (initResource) {
            initResource = false;
            buttons['refreshRes']();
        }
    });
});
function getUploadUrl(){
	//console.log('indexlist:'+window.sessionStorage.getItem("indexlist"));
	if(window.sessionStorage.getItem("indexlist")){
		let name = window.sessionStorage.getItem("indexlist");
		//console.log("window.sessionStorage:"+window.sessionStorage.getItem("indexlist"))
		//console.log("getUploadUrlname:"+name)
		let type = window.sessionStorage.getItem("fileType");
		//console.log('../api/advertiseManager/v1/addAdvertiseVideoPictureInfo');
		return '../api/advertiseManager/v1/addAdvertiseVideoPictureInfo';
	}else{
		return "";
	}
	
}
function getFileNameList(indexlist){
	
	return ;
}
</script>
<script type="text/html" id="barIC">
    <a class="layui-btn layui-btn-xs" lay-event="status">发布</a>
    <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
</script>
<style>
.flex-box {
	display: flex;
	flex-wrap: wrap;
	/*justify-content: space-around;*/
	overflow: auto;
	max-height: 400px;
	padding: 10px;
	/*background-color: grey;*/
}

.item-style {
	position: relative;
	margin: 6px;
	width: 100px;
	text-align: center;
}

.item-style div {
	background-color: rgba(145, 112, 44, 0.31);
	width: 100px;
	display: block;
}

.item-style a {
	margin: 3px
}

.item-style a i {
	font-size: 20px
}

.text {
	display: none;
	padding: 3px;
	position: absolute;
	background-color: rgba(255, 255, 255, 0.7);
	width: 100px;
	max-width: 100px;
	max-height: 100px;
}

.item-style:hover .text {
	display: block;
}

video::-internal-media-controls-download-button {
	display: none;
}

video::-webkit-media-controls-enclosure {
	overflow: hidden;
}

video::-webkit-media-controls-panel {
	width: calc(100% + 30px);
}

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
		<div id="uploadDialog" class="site-block" style="display: none">
			<button type="button" class="layui-btn layui-btn-normal"
				id="testList">选择图片/视频</button>
			<button type="button" class="layui-btn layui-btn-normal"
				id="clearDone">清除已完成</button>
			<button type="button" class="layui-btn" id="testListAction">开始上传</button>
			<div class="layui-upload-list">
				<table class="layui-table">
					<thead>
						<tr>
							<th lay-data="{width:100}">文件名</th>
							<th>设置文件名</th>
							<th>大小</th>
							<th>状态</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody id="demoList"></tbody>
				</table>
			</div>
		</div>
		<div id="icDialog" style="display: none">
			<div class="layui-row layui-col-space10" style="margin: 5px">
				<div class="layui-col-xs3" style="height: 620px;">
					<ul id="treeManifest" class="ztree"></ul>
				</div>
				<div class="layui-col-xs5" style="height: 620px;">
					<div id="preview" class="block-radius"></div>
				</div>
				<div class="layui-col-xs4" style="height: 620px;">
					<div class="block-radius">
						<div class="layui-form" style="margin: 10px">
							<div class="layui-form-item">
								<button class="layui-btn" data-type="refreshRes">刷新</button>
								<div class="layui-inline">
									<input class="layui-input" id="queryResKey"
										placeholder="请输入关键字">
								</div>
								<button class="layui-btn" data-type="queryRes">搜索</button>
								<button data-type="upload" class="layui-btn layui-btn-normal">
									<i class="layui-icon">&#xe67c;</i>上传文件
								</button>
							</div>
						</div>
						<div class="layui-tab" lay-filter="resource">
							<ul class="layui-tab-title">
								<li class="layui-this">图片</li>
								<li>视频</li>
							</ul>
							<div class="layui-tab-content" style="height: 460px">
								<div data-value="0" class="layui-tab-item layui-show">
									<div></div>
									<div class="flex-box"></div>
								</div>
								<div data-value="1" class="layui-tab-item">
									<div></div>
									<div class="flex-box"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="site-block" style="">
				<form class="layui-form">
					<div class="layui-inline">
						<label class="layui-form-label">广告名</label>
						<div class="layui-input-inline">
							<input type="text" id="adName" name="name" required
								lay-verify="required" placeholder="请输入标题" autocomplete="off"
								class="layui-input">
						</div>
					</div>
					<div class="layui-inline">
						<label class="layui-form-label" for="expireDate">失效时间</label>
						<div class="layui-input-inline">
							<input type="text" class="layui-input" id="expireDate"
								name="activeTime">
						</div>
					</div>
					<div class="layui-inline">
						<label class="layui-form-label">备注</label>
						<div class="layui-input-inline">
							<input type="text" id="adNote" name="describe" placeholder="备注详情"
								autocomplete="off" class="layui-input">
						</div>
					</div>
					<div class="layui-inline">
						<div class="layui-input-block">
							<button class="layui-btn" lay-submit lay-filter="formSubmit">保存</button>
							<!--                        <button type="reset" class="layui-btn layui-btn-primary">重置</button>-->
						</div>
					</div>
				</form>
			</div>
		</div>
		<div id="statusDialog" style="display: none; padding: 5px">
			<ul id="treeCommunity" class="ztree layui-col-xs6"
				style="height: 440px"></ul>
			<div class="layui-col-xs6" style="padding-left: 5px">
				<button data-type="send" class="layui-btn layui-btn-normal">
					<i class="layui-icon">&#xe609;</i>确定发布
				</button>
				<fieldset class="layui-elem-field"
					style="margin-top: 10px; padding: 10px;">
					<legend>发送详情</legend>
					<div>
						<p>
							发送设备共 <span id="allCount" class="highlight_black">0</span> 台
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

		<div class="layui-form" style="margin: 10px">
			<div class="layui-form-item">
				<div class="layui-inline">
					<select id="queryType">
						<option value="name">根据广告名搜索</option>
						<option value="describe">根据备注搜索</option>
					</select>
				</div>
				<div class="layui-inline">
					<input class="layui-input" id="queryKey" placeholder="请输入关键字">
				</div>
				<button class="layui-btn" data-type="query">搜索</button>
				<button data-type="add" class="layui-btn layui-btn-normal">
					<i class="layui-icon">&#xe608;</i>添加广告
				</button>
				<button data-type="upload" class="layui-btn layui-btn-normal">
					<i class="layui-icon">&#xe67c;</i>上传文件
				</button>
			</div>
		</div>
		<table id="ic_table" lay-filter="icTable"></table>
	</div>
</body>
</html>