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
<title>角色管理</title>
<script>
    layui.config({
        base: "../js/"
    }).use(['table'], function () {
    	var session = window.sessionStorage,table = layui.table;
        layui.table.render({
            elem: '#ic_table'
            , url: '../api/roleManager/v1/selectRoleList'
            , cols: [[
                {
                    title: '序号', type: 'numbers'
                }
                , {title: '角色名称', field: 'roleName', sort: true}
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
                    		"data":res.data.roleList
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
                		"data":res.data.roleList
                	}
            	}
            }
            , done: function (res, curr, count) {
            	checkForDataCode(res);
            }
        });
        layui.table.on('tool(icTable)', function (obj) {
            if (buttons[obj.event]) buttons[obj.event](obj);
        });
        var $ = layui.$
            // , queryType = $('#queryType')
            // , queryKey = $('#queryKey')
            , roleDialog = $('#roleDialog')
            , buttons = {
                add: function () {
                    layer.prompt({title: '添加角色'}, function (value, index, elem) {
                        var i = layer.load(2, {time: 5000});
                        doAjax("post",'../api/roleManager/v1/addRoleInfo',{
                            ageId: session.getItem("agencyId"),
                            token: session.getItem("token"),
                            roleName: value
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
	                        },function(err){
	                        	
	                     });
/*                         $.post('../api/roleManager/v1/addRoleInfo', {
                            ageId: session.getItem("agencyId"),
                            token: session.getItem("token"),
                            roleName: value
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
                        title: '修改角色名称：' + tobj.data.roleName,
                        value: tobj.data.roleName
                    }, function (value, index, elem) {
                        var i = layer.load(2, {time: 5000});
                        doAjax("post",'../api/roleManager/v1/updateRoleById',{
                            ageId: session.getItem("agencyId"),
                            token: session.getItem("token"),
                            roleName: value,
                            roleId: tobj.data.roleId
                        },function (data) {
	                        	layer.close(i);
	                            if (!data) return null;
	                            if (data.code == 0) {
	                                // layui.table.reload('icTable');
	                                tobj.update({roleName: value});
	                                layer.close(index);
	                                layer.msg("修改成功");
	                            } else {
	                                layer.msg(data.msg);
	                            }
	                        },function(err){
	                        	
	                     });
                        /* $.post('../api/roleManager/v1/updateRoleById', {
                            ageId: session.getItem("agencyId"),
                            token: session.getItem("token"),
                            roleName: value,
                            roleId: tobj.data.roleId
                        }, function (data) {
                            layer.close(i);
                            if (!data || checkLogin(data)) return null;
                            if (data.code == 0) {
                                // layui.table.reload('icTable');
                                tobj.update({roleName: value});
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
                        , content: "确定删除角色：" + tobj.data.roleName + "?"
                        , shadeClose: true
                        , yes: function (index, layero) {
                            var i = layer.load(2, {time: 5000});
                            doAjax("post",'../api/roleManager/v1/deleteRoleById',{roleId: tobj.data.roleId,
                            	token: session.getItem("token"),},function (data) {
                            		layer.close(i);
                                    if (!data) return null;
                                    if (data.code == 0) {
                                        layer.msg("删除成功");
                                        tobj.del();
                                    } else {
                                        layer.msg(data.msg);
                                    }
    	                        },function(err){
    	                        	
    	                     });
                            /* $.post('../api/roleManager/v1/deleteRoleById', {roleId: tobj.data.roleId,
                            	token: session.getItem("token"),}, function (data) {
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
                        , title: '角色成员'
                        , content: roleDialog
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
<style>

</style>
</head>
<body>
<div class="child-body">
    <div id="roleDialog" style="display: none;padding: 5px">
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
            <button data-type="add" class="layui-btn layui-btn-normal"><i class="layui-icon">&#xe608;</i>添加角色</button>
        </div>
    </div>
    <table id="ic_table" lay-filter="icTable"></table>
</div>
</body>
</html>