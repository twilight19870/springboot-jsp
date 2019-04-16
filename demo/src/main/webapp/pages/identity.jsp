<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Date"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width" />
<script type="text/javascript" src="../js/selelogin.js?v=<%= new Date().getTime() %>"></script>
<script type="text/javascript"
	src="../js/check.js?v=<%= new Date().getTime() %>"></script>
<script src="../layui/layui.js"></script>
<script src="../js/jquery-3.3.1.js"></script>
<script src="../js/jquerysession.js"></script>
<link rel="stylesheet" href="../layui/css/layui.css" media="all">
<link rel="stylesheet"
	href="../css/style.css?v=<%= new Date().getTime() %>" media="all">
<title>身份证门禁管理</title>
<script>
    layui.config({
        base: "../js/"
    }).use(['form', 'table', 'laydate', 'ztree'], function () {
        var date = new Date(),
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
            , url: '../api/cardManager/v1/selectIdentityCardList'
            , cols: [[
                {
                    title: '序号', type: 'numbers'
                }
                , {title: '卡号', field: 'cardNo', width: 106, sort: true}
                , {title: '持卡人', field: 'userName', width: 74}
                , {title: '手机号', field: 'userPhone', width: 118}
                , {title: '小区', field: 'commName', width: 120}
                , {
                    title: '类型', width: 74, sort: true, templet: function (d) {
                        return d.cardType == '0' ? '普通卡' : '超级卡';
                    }
                }
                , {title: '生效时间', field: 'validDate'}
                , {title: '失效时间', field: 'expireDate'}
                , {
                    title: '状态', field: 'status', templet: function (d) {
                        var s = '';
                        switch (d.status) {
                            case '2':
                                s = ",已冻结";
                            case '1':
                                s = "已激活" + s;
                                break;
                            case '0':
                                s = '未激活';
                        }
                        return s;
                    }, width: 120
                }
                , {title: '', align: 'center', toolbar: '#barIC', fixed: 'right', width: 210}
            ]]
            , id: 'icTable'
            , page: true
            , height: 'full-120'
            ,contentType:'application/x-www-form-urlencoded'
            , method: "post"
            , where: {
                ageId: session.getItem("agencyId"),
                token: session.getItem("token")
            }
            , request: {
                pageName: 'pageNum'
                , limitName: 'pageSize'
            }
            , parseData: function(res){
            	if(res.code!==0 || !res.data || !res){
        			alert("登录信息已超时！");
                    window.top.location = "./login.jsp";
        		}
            	return {
            		"code":res.code,
            		"msg":res.msg,
            		"count":res.data.total,
            		"data":res.data.cardList
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
            , treeCommunityDialog = $('#treeCommunityDialog')
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
                    layer.prompt({title: '请刷身份证输入'}, function (value, index, elem) {
                        var i = layer.load(2, {time: 5000});
                        $.post('../api/cardManager/v1/addIdentityCardInfo', {
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
                    });
                }
                , bind: function (tobj) {
                    icObjT = tobj;
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
                        , content: "确定删除身份证卡：" + tobj.data.cardNo + "?"
                        , shadeClose: true
                        , yes: function (index, layero) {
                            var i = layer.load(2, {time: 5000});
                            $.post('../api/cardManager/v1/deleteIdentityCardById', {id: tobj.data.id,
                            	token:session.getItem("token")}, function (data) {
                                layer.close(i);
                                if (!data || checkLogin(data)) return null;
                                if (data.code == 0) {
                                    layer.msg("删除成功");
                                    tobj.del();
                                } else {
                                    layer.msg(data.msg);
                                }
                            }, 'json');
                        }
                    });
                }
                , query: function () {
                    var where = {userName: '', cardNo: ''};
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
                        , title: "修改身份证卡状态：" + tobj.data.cardNo
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
                    otherParam: {"token":session.getItem("token")}, 
                    dataFilter: function (treeId, parentNode, data) {
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
            data.field.token = session.getItem("token");
            data.field.id = icObjT.data.id;
            var i = layer.load(2, {time: 5000});
            $.post('../api/cardManager/v1/updateIdentityCardById', data.field, function (data) {
                layer.close(i);
                if (!data || checkLogin(data)) return null;
                if (data.code == 0) {
                    layer.msg("保存成功");
                    layui.table.reload('icTable');
                    layer.close(dialogIndex);
                } else {
                    layer.msg(data.msg);
                }
            }, 'json');
            return false;
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
                    postData.ageId = icObjT.data.ageId;
                    postData.token = session.getItem("token");
                    postData.id = icObjT.data.id;
                    url = '../api/cardManager/v1/cancelActivationIdentityCardById';
                    break;
                case '1':
                    postData.ageId = icObjT.data.ageId;
                    postData.token = session.getItem("token");
                    postData.id = icObjT.data.id;
                    url = '../api/cardManager/v1/activationIdentityCardById';
                    break;
                case '2':
                    postData.id = icObjT.data.id;
                    postData.token = session.getItem("token");
                    url = '../api/cardManager/v1/cfreezeIdentityCardById';
                    break;
            }
            $.post(url, postData, function (data) {
                layer.close(i);
                if (!data || checkLogin(data)) return null;
                if (data.code == 0) {
                    layer.msg("保存成功");
                    layui.table.reload('icTable');
                    layer.close(statusIndex);
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

    <div class="layui-form" style="margin: 10px">
        <div class="layui-form-item">
            <div class="layui-inline">
                <select id="queryType">
                    <option value="userName">根据用户搜索</option>
                    <option value="cardNo">根据卡号搜索</option>
                </select>
            </div>
            <div class="layui-inline">
                <input class="layui-input" id="queryKey" placeholder="请输入关键字">
            </div>
            <button class="layui-btn" data-type="query">搜索</button>
            <button data-type="add" class="layui-btn layui-btn-normal"><i class="layui-icon">&#xe608;</i>添加身份证卡</button>
        </div>
    </div>
    <table id="ic_table" lay-filter="icTable"></table>
</div>
</body>
</html>