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
<title>部门管理</title>
<script type="text/javascript">
layui.config({
    base: "../js/"
}).use(['table'], function () {
	var session = window.sessionStorage,
	table = layui.table;

    layui.table.render({
        elem: '#ic_table'
        , url: '../api/deptManager/v1/selectDepartmentList'
        , cols: [[
            {
                title: '序号', type: 'numbers'
            }
            , {title: '部门名称', field: 'deptName', sort: true}
            , {title: '添加时间', field: 'createTime', sort: true}
            , {title: '操作管理', align: 'center', toolbar: '#barIC', fixed: 'right', width: 210}
        ]]
        , id: 'icTable'
        , page: true
        , height: 'full-120'
        ,contentType:'application/x-www-form-urlencoded'
        , method: "post"
        , where: {
            ageId: session.getItem("agencyId"),
            token: function(){
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
            		"data":res.data.deptList
            	}
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
        // , queryType = $('#queryType')
        // , queryKey = $('#queryKey')
        , deptDialog = $('#deptDialog')
        , buttons = {
            add: function () {
                layer.prompt({title: '添加部门'}, function (value, index, elem) {
                    var i = layer.load(2, {time: 5000});
                    doAjax("post",'../api/deptManager/v1/addDepartmentInfo',{
                        ageId: session.getItem("agencyId"),
                        deptName: value,
                        token: session.getItem("token")
                    },function (data) {
                    	layer.close(i);
                        if (!data) return null;
                        if (data.code == 0) {
                            layui.table.reload('icTable');
                            layer.close(index);
                            layer.msg("添加成功");
                        } else {
                            layer.msg(data.msg);
                        }
                    },function(err){});
/*                     $.post('../api/deptManager/v1/addDepartmentInfo', {
                        ageId: session.getItem("agencyId"),
                        deptName: value,
                        token: session.getItem("token")
                    }, function (data) {
                        layer.close(i);
                        if (!data || checkLogin(data)) return null;
                        if (data.code == 0) {
                            layui.table.reload('icTable');
                            layer.close(index);
                            layer.msg("添加成功");
                        } else {
                            layer.msg(data.msg);
                        }
                    }, 'json'); */
                });
            }
            , edit: function (tobj) {
                layer.prompt({
                    title: '修改部门名称：' + tobj.data.deptName,
                    value: tobj.data.deptName
                }, function (value, index, elem) {
                    var i = layer.load(2, {time: 5000});
                    doAjax("post",'../api/deptManager/v1/updateDepartmentById',{
                    	ageId: session.getItem("agencyId"),
                        deptName: value,
                        token:session.getItem("token"),
                        deptId: tobj.data.deptId
                    },function (data) {
                    	layer.close(i);
                        if (!data) return null;
                        if (data.code == 0) {
                            // layui.table.reload('icTable');
                            tobj.update({deptName: value});
                            layer.close(index);
                            layer.msg("修改成功");
                        } else {
                            layer.msg(data.msg);
                        }
                    },function(err){});
/*                     $.post('../api/deptManager/v1/updateDepartmentById', {
                    	ageId: session.getItem("agencyId"),
                        deptName: value,
                        token:session.getItem("token"),
                        deptId: tobj.data.deptId
                    }, function (data) {
                        layer.close(i);
                        if (!data || checkLogin(data)) return null;
                        if (data.code == 0) {
                            // layui.table.reload('icTable');
                            tobj.update({deptName: value});
                            layer.close(index);
                            layer.msg("修改成功");
                        } else {
                            layer.msg(data.msg);
                        }
                    }, 'json'); */
                });
            }
            , del: function (tobj) {
                layer.open({
                    type: 0
                    , content: "确定删除部门：" + tobj.data.deptName + "?"
                    , shadeClose: true
                    , yes: function (index, layero) {
                        var i = layer.load(2, {time: 5000});
                        doAjax("post",'../api/deptManager/v1/deleteDepartmentById',{"deptId": tobj.data.deptId,
                        	token:session.getItem("token")},function (data) {
                        		layer.close(i);
                                if (!data) return null;
                                if (data.code == 0) {
                                    layer.msg("删除成功");
                                    tobj.del();
                                } else {
                                    layer.msg(data.msg);
                                }
                        },function(err){});
                        /* $.post('../api/deptManager/v1/deleteDepartmentById', {"deptId": tobj.data.deptId,
                        	token:session.getItem("token")}, function (data) {
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
            // , query: function () {
            //     var where = {userName: '', cardNo: ''};
            //     where[queryType.val()] = queryKey.val();
            //     layui.table.reload('icTable', {
            //         page: {
            //             curr: 1 //重新从第 1 页开始
            //         }
            //         , where: where
            //     });
            // }
            , detail: function (tobj) {
                layer.open({
                    type: 1
                    , maxmin: true
                    , title: '部门成员'
                    , content: deptDialog
                    , area: ['700px', '500px']
                });
            }
        };
    $('.layui-btn[data-type]').on('click', function () {
        var type = $(this).data('type');
        buttons[type] ? buttons[type].call(this) : '';
    });
});
</script>
<script type="text/html" id="barIC">
    <!--<a class="layui-btn layui-btn-xs" lay-event="detail">查看成员</a>-->
    <a class="layui-btn layui-btn-xs" lay-event="edit">修改名称</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
</script>
</head>
<body>
<div class="child-body">
    <div id="deptDialog" style="display: none;padding: 5px">
        <table id="table_member" lay-filter="memberTable"></table>
    </div>
    <div class="layui-form" style="margin: 10px">
        <div class="layui-form-item">
            <!--<div class="layui-inline">-->
            <!--<select id="queryType">-->
            <!--<option value="userName">根据用户搜索</option>-->
            <!--<option value="cardNo">根据卡号搜索</option>-->
            <!--</select>-->
            <!--</div>-->
            <!--<div class="layui-inline">-->
            <!--<input class="layui-input" id="queryKey" placeholder="请输入关键字">-->
            <!--</div>-->
            <!--<button class="layui-btn" data-type="query">搜索</button>-->
            <button data-type="add" class="layui-btn layui-btn-normal"><i class="layui-icon">&#xe608;</i>添加部门</button>
        </div>
    </div>
    <table id="ic_table" lay-filter="icTable"></table>
</div>
</body>
</html>