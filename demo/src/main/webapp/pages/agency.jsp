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
<title>代理商管理</title>
<script>
$(function(){
	selelogin();
});
layui.config({
    base: "../js/"
}).use(['ztree', 'form'], function () {
    var $ = layui.jquery, 
    	agency = $('#agency'), 
    	parent = $('#parent'), 
    	curNode,
    	session = window.sessionStorage,
        actionItem = $('#actionItem'),
        formSubmit = $('#formSubmit'),
        formCancel = $('#formCancel'), btnDel = $('#btnDel'), btnAdd = $('#btnAdd'), btnEdit = $('#btnEdit')
        , type = 0
        , cancelfun = function () {
            if (type !== 0) {
                type = 0;
                agency.addClass("layui-disabled");
                agency.attr("disabled", true);
                actionItem.hide('normal');
                fixContent();
            }
        }
        , fixContent = function () {
            if (type === 1) {
                parent.prop('value', curNode.getParentNode().ageName);
                agency.prop('value', curNode.ageName);
                return;
            }
            if (type === 0) {
                if (curNode.level == 0) {
                    parent.prop('value', '父级代理商');
                } else {
                    parent.prop('value', curNode.getParentNode().ageName);
                }
                agency.prop('value', curNode.ageName);
            } else {
                parent.prop('value', curNode.ageName);
            }
            if (curNode.level == 0) {
                btnDel.addClass("layui-btn-disabled");
                btnDel.attr("disabled", true);
                btnEdit.addClass("layui-btn-disabled");
                btnEdit.attr("disabled", true);
            } else {
                btnDel.removeClass("layui-btn-disabled");
                btnDel.attr("disabled", false);
                btnEdit.removeClass("layui-btn-disabled");
                btnEdit.attr("disabled", false);
            }
        }
        , clickE = function () {
            agency.removeClass("layui-disabled");
            agency.attr("disabled", false);
            actionItem.show('normal');
            fixContent();
        };
    btnEdit.click(function () {
        if (type !== 1) {
            type = 1;
            formSubmit.text("保存修改");
            clickE();
        }
    });
    btnAdd.click(function () {
        if (type !== 2) {
            type = 2;
            formSubmit.text("添加");
            agency.prop('value', '');
            clickE();
        }
    });
    formCancel.click(cancelfun);
    var ztree = function () {
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
                url: "../api/agencyManager/v1/selectSystemAgencyList",
                autoParam: ["ageId=parentAgeId"],
                otherParam:{"token":function(){return session.getItem("token")}},
                dataFilter: function (treeId, parentNode, data) {
                	let checkCode = checkToken(data);
                    if(checkCode == "1005"){
                    	zTreeObj.expandAll(false);
                    	zTreeObj.refresh();
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
                    if (curNode === treeNode) return;
                    if (type === 1) {
                        type = 0;
                        agency.addClass("layui-disabled");
                        agency.attr("disabled", true);
                        actionItem.hide('normal');
                    }
                    curNode = treeNode;
                    fixContent();
                }
            }
        };

        zTreeObj = $.fn.zTree.init($("#treeDemo"), setting, {
            ageName: session.getItem("agencyName")
            , ageId: session.getItem("agencyId")
            , isParent: true
        });
        curNode = zTreeObj.getNodes()[0];
        return {
            refresh: function (parentNode) {
                zTreeObj.reAsyncChildNodes(parentNode, 'refresh', false, function () {
                    if (curNode != parentNode)
                    curNode = zTreeObj.getNodeByParam("ageId", curNode.ageId, parentNode);
                    fixContent();
                });
            }
        }
    }();

    btnDel.click(function () {
        layer.open({
            type: 0
            , content: "确定删除代理商：" + curNode.ageName + "?"
            , shadeClose: true
            , yes: function (index, layero) {
                var i = layer.load(2, {time: 5000});
                doAjax("post",'../api/agencyManager/v1/deleteSystemAgencyById',
                		{ageId: curNode.ageId,token:session.getItem("token")},function (data) {
                    if (!data) return null;
                    if (data) {
                        layer.close(i);
                        if (data.code == 0) {
                            layer.msg("删除成功");
                            curNode = curNode.getParentNode();
                            ztree.refresh(curNode);
                            type = 3;
                            cancelfun();
                        } else {
                            layer.msg(data.msg);
                        }
                    }
                },function(err){});
                /* $.post('../api/agencyManager/v1/deleteSystemAgencyById', 
                		{ageId: curNode.ageId,token:session.getItem("token")}, function (data) {
                    if (data) {
                        layer.close(i);
                        if (data.code == 0) {
                            layer.msg("删除成功");
                            curNode = curNode.getParentNode();
                            ztree.refresh(curNode);
                            type = 3;
                            cancelfun();
                        } else {
                            layer.msg(data.msg);
                        }
                    }
                }, 'json'); */
            }
        });
    });
    layui.form.on('submit(formSubmit)', function (data) {
        var url;
        if (type === 1) {
            url = '../api/agencyManager/v1/updateSystemAgencyInfo';
            data.field['ageId'] = curNode.ageId;
            data.field['token'] = session.getItem("token");
        } else if (type === 2) {
            url = '../api/agencyManager/v1/addSystemAgencyInfo';
            data.field['parentAgeId'] = curNode.ageId;
            data.field['token'] = session.getItem("token");
        } else return false;
        var i = layer.load(2, {time: 5000});
        doAjax("post",url,data.field,function (data) {
            layer.close(i);
            if (!data) return null;
            if (data) {
                layer.close(i);
                if (data.code == 0) {
                    layer.msg("保存成功");
                    if (type === 1)
                        ztree.refresh(curNode.getParentNode());
                    else if (type === 2)
                        ztree.refresh(curNode);
                    cancelfun();
                } else {
                    layer.msg(data.msg);
                }
            }
        },function(err){});
        /* $.post(url, data.field, function (data) {
            if (data) {
                layer.close(i);
                if (data.code == 0) {
                    layer.msg("保存成功");
                    if (type === 1)
                        ztree.refresh(curNode.getParentNode());
                    else if (type === 2)
                        ztree.refresh(curNode);
                    cancelfun();
                } else {
                    layer.msg(data.msg);
                }
            }
        }, 'json'); */
        return false;
    });
});
</script>
</head>
<body>
<div class="child-body">
    <ul id="treeDemo" class="ztree layui-col-xs2"></ul>
    <div class="layui-col-xs10" style="padding-left: 5px">
        <div class="layui-btn-container">
            <button id="btnAdd" class="layui-btn"><i class="layui-icon">&#xe608;</i>添加</button>
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
                    <label class="layui-form-label">父级代理商</label>
                    <div class="layui-input-block">
                        <input type="text" id="parent"
                               value="父级代理商"
                               autocomplete="off" class="layui-input layui-disabled" disabled="disabled">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">子代理商</label>
                    <div class="layui-input-block">
                        <input type="text" id="agency" name="ageName" value="本代理商" lay-verify="required"
                               disabled="disabled"
                               placeholder="请输入代理商名称"
                               autocomplete="off" class="layui-input layui-disabled">
                    </div>
                </div>
                <div id="actionItem" class="layui-form-item" style="display: none">
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