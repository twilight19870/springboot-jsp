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
	src="../js/check.js?v=<%=new Date().getTime() %>"></script>
<script src="../layui/layui.js"></script>
<script src="../js/jquery-3.3.1.js"></script>
<script src="../js/jquerysession.js"></script>
<link rel="stylesheet" href="../layui/css/layui.css" media="all">
<link rel="stylesheet"
	href="../css/style.css?v=<%= new Date().getTime() %>" media="all">
<title>门禁历史记录</title>
<script>
$(function(){
	selelogin();
});
layui.use(['element', 'form', 'laydate', 'laypage'], function () {
    var laydate = layui.laydate
        , form = layui.form
        , laypage = layui.laypage
        ,session = window.sessionStorage
        , $ = layui.jquery;
    laydate.render({
        elem: '#startTime'
        , type: 'datetime'
    });
    laydate.render({
        elem: '#endTime'
        , type: 'datetime'
    });
    form.on('select(commId)', function (data) {
        $("#bldId option:not(:first)").remove();
        $("#unitId option:not(:first)").remove();
        $("#doorPhoneId option:not(:first)").remove();
        if (data.value)
        	doAjax("post",'../api/communityManager/v1/selectBuildingList', 
        			{commId: data.value,token:session.getItem("token")},function (data) {
      				if (!data) return null;
                      if (data.data) {
                          $(data.data).each(function (k, v) {
                              $('#bldId').append(new Option(v['bldName'], v['bldId']));
                          });
                          form.render('select');
                      }
            },function(err){});
/*             $.post('../api/communityManager/v1/selectBuildingList', {commId: data.value,token:session.getItem("token")}, 
            		function (data) {
                if (!data || checkLogin(data)) return null;
                if (data.data) {
                    $(data.data).each(function (k, v) {
                        $('#bldId').append(new Option(v['bldName'], v['bldId']));
                    });
                    form.render('select');
                }
            }, 'json'); */
        form.render('select');
    });

    form.on('select(bldId)', function (data) {
        $("#unitId option:not(:first)").remove();
        $("#doorPhoneId option:not(:first)").remove();
        if (data.value)
        	doAjax("post",'../api/communityManager/v1/selectUnitList', 
        		{bldId: data.value,token:session.getItem("token")},function (data) {
       				if (!data) return null;
                       if (data.data) {
                           $(data.data).each(function (k, v) {
                               $('#unitId').append(new Option(v['unitName'], v['unitId']));
                           });
                           form.render('select');
                       }
            },function(err){});
/*             $.post('../api/communityManager/v1/selectUnitList', {bldId: data.value,token:session.getItem("token")}, function (data) {
                if (!data || checkLogin(data)) return null;
                if (data.data) {
                    $(data.data).each(function (k, v) {
                        $('#unitId').append(new Option(v['unitName'], v['unitId']));
                    });
                    form.render('select');
                }
            }, 'json'); */
        form.render('select');
    });

    //监听提交
    form.on('submit(formQuery)', function (data) {
        // var content = $('.layui-tab-item.layui-show');
        // data.field['ageId'] = window.localStorage.getItem('ageId');
        query($('.layui-tab-item.layui-show'), data.field, 0, 10);
        return false;
    });

    function query(content, datapost, number, pageSize) {
        datapost['pageNum'] = number == 0 ? 1 : number;
        datapost['pageSize'] = pageSize;
        datapost['token'] = session.getItem("token");
        datapost['ageId'] = session.getItem("agencyId");
        let historyUrl = getHistoryUrl(content.attr('id'));
        //console.log("url:"+historyUrl);
        doAjax("post",historyUrl, datapost,function (data) {
            if (!data) return null;
            if (data.data) {
                if (number == 0) {
                    laypage.render({
                        elem: content.find(":first")
                        , count: data.data.total
                        , limit: data.data.pageSize
                        , layout: ['count', 'prev', 'page', 'next', 'limit', 'skip']
                        , jump: function (obj, first) {
                            //首次不执行
                            if (!first) {
                                query(content, datapost, obj.curr, obj.limit);
                            }
                        }
                    });
                }
                var table = content.find('tbody');
                table.find('tr').remove();
                switch (content.attr('id')) {
                    case 'call':
                        $(data.data.callDoorList).each(function (k, v) {
                            table.append('<tr><td>' + (v.userName ? v.userName : '无记录') +
                                '</td><td>' + v.commName +
                                '</td><td>' + v.bldName +
                                '</td><td>' + v.unitName +
                                '</td><td>' + v.doorPhoneName +
                                '</td><td>' + (v.startTime ? v.startTime : '无记录') +
                                '</td><td>' + (v.endTime ? v.endTime : '无记录') +
                                // '</td><td>' + (v.status == '1' ? '成功' : '失败') +
                                '</td><td><button class="layui-btn ' + (v.pictureUrl ? '' : 'layui-btn-disabled" disabled="disabled') +
                                '" img-src="' + v.pictureUrl +
                                '">查看图片</button>' +
                                '</td></tr>');
                        });
                        break;
                    case 'card':
                        $(data.data.cardDoorList).each(function (k, v) {
                            table.append('<tr><td>' + (v.userName ? v.userName : '无记录') +
                                '</td><td>' + v.commName +
                                '</td><td>' + v.bldName +
                                '</td><td>' + v.unitName +
                                '</td><td>' + v.doorPhoneName +
                                '</td><td>' + v.cardNo +
                                '</td><td>' + (v.openDoorTime ? v.openDoorTime : '无记录') +
                                '</td><td>' + (v.status == '0' ? '成功' : '失败') +
                                '</td><td><button class="layui-btn ' + (v.pictureUrl ? '' : 'layui-btn-disabled" disabled="disabled') +
                                '" img-src="' + v.pictureUrl +
                                '">查看图片</button>' +
                                '</td></tr>');
                        });
                        break;
                    case 'face':
                        $(data.data.faceLogList).each(function (k, v) {
                            table.append('<tr><td>' + (v.userName ? v.userName : '无记录') +
                                '</td><td>' + v.commName +
                                '</td><td>' + v.bldName +
                                '</td><td>' + v.unitName +
                                '</td><td>' + v.doorPhoneName +
                                '</td><td>' + (v.openDoorTime ? v.openDoorTime : '无记录') +
                                // '</td><td>' + (v.status == '1' ? '成功' : '失败') +
                                '</td><td><button class="layui-btn ' + (v.pictureUrl ? '' : 'layui-btn-disabled" disabled="disabled') +
                                '" img-src="' + v.pictureUrl +
                                '">查看图片</button>' +
                                '</td></tr>');
                        });
                        break;
                    case 'visitor':
                        $(data.data.visitorList).each(function (k, v) {
                            table.append('<tr><td>' + v.userName +
                                '</td><td>' + v.commName +
                                '</td><td>' + v.bldName +
                                '</td><td>' + v.unitName +
                                '</td><td>' + v.doorPhoneName +
                                '</td><td>' + (v.createTime ? v.createTime : '无记录') +
                                // '</td><td>' + (v.status == '1' ? '成功' : '失败') +
                                '</td><td><button class="layui-btn ' + (v.pictureUrl ? '' : 'layui-btn-disabled" disabled="disabled') +
                                '" img-src="' + v.pictureUrl +
                                '">查看图片</button>' +
                                '</td></tr>');
                        });
                        break;
                }

                table.find('button').click(function () {
                    layer.photos({
                        photos: {
                            "data": [{
                                "alt": "截图记录",
                                "src": $(this).attr('img-src')
                            }]
                        }
                    });
                });
            }
            },function(err){});
/*         $.post(historyUrl, datapost, function (data) {
           if (!data || checkLogin(data)) return null;
            if (data.data) {
                if (number == 0) {
                    laypage.render({
                        elem: content.find(":first")
                        , count: data.data.total
                        , limit: data.data.pageSize
                        , layout: ['count', 'prev', 'page', 'next', 'limit', 'skip']
                        , jump: function (obj, first) {
                            //首次不执行
                            if (!first) {
                                query(content, datapost, obj.curr, obj.limit);
                            }
                        }
                    });
                }
                var table = content.find('tbody');
                table.find('tr').remove();
                switch (content.attr('id')) {
                    case 'call':
                        $(data.data.callDoorList).each(function (k, v) {
                            table.append('<tr><td>' + (v.userName ? v.userName : '无记录') +
                                '</td><td>' + v.commName +
                                '</td><td>' + v.bldName +
                                '</td><td>' + v.unitName +
                                '</td><td>' + v.doorPhoneName +
                                '</td><td>' + (v.startTime ? v.startTime : '无记录') +
                                '</td><td>' + (v.endTime ? v.endTime : '无记录') +
                                // '</td><td>' + (v.status == '1' ? '成功' : '失败') +
                                '</td><td><button class="layui-btn ' + (v.pictureUrl ? '' : 'layui-btn-disabled" disabled="disabled') +
                                '" img-src="' + v.pictureUrl +
                                '">查看图片</button>' +
                                '</td></tr>');
                        });
                        break;
                    case 'card':
                        $(data.data.cardDoorList).each(function (k, v) {
                            table.append('<tr><td>' + (v.userName ? v.userName : '无记录') +
                                '</td><td>' + v.commName +
                                '</td><td>' + v.bldName +
                                '</td><td>' + v.unitName +
                                '</td><td>' + v.doorPhoneName +
                                '</td><td>' + v.cardNo +
                                '</td><td>' + (v.openDoorTime ? v.openDoorTime : '无记录') +
                                '</td><td>' + (v.status == '0' ? '成功' : '失败') +
                                '</td><td><button class="layui-btn ' + (v.pictureUrl ? '' : 'layui-btn-disabled" disabled="disabled') +
                                '" img-src="' + v.pictureUrl +
                                '">查看图片</button>' +
                                '</td></tr>');
                        });
                        break;
                    case 'face':
                        $(data.data.faceLogList).each(function (k, v) {
                            table.append('<tr><td>' + (v.userName ? v.userName : '无记录') +
                                '</td><td>' + v.commName +
                                '</td><td>' + v.bldName +
                                '</td><td>' + v.unitName +
                                '</td><td>' + v.doorPhoneName +
                                '</td><td>' + (v.openDoorTime ? v.openDoorTime : '无记录') +
                                // '</td><td>' + (v.status == '1' ? '成功' : '失败') +
                                '</td><td><button class="layui-btn ' + (v.pictureUrl ? '' : 'layui-btn-disabled" disabled="disabled') +
                                '" img-src="' + v.pictureUrl +
                                '">查看图片</button>' +
                                '</td></tr>');
                        });
                        break;
                    case 'visitor':
                        $(data.data.visitorList).each(function (k, v) {
                            table.append('<tr><td>' + v.userName +
                                '</td><td>' + v.commName +
                                '</td><td>' + v.bldName +
                                '</td><td>' + v.unitName +
                                '</td><td>' + v.doorPhoneName +
                                '</td><td>' + (v.createTime ? v.createTime : '无记录') +
                                // '</td><td>' + (v.status == '1' ? '成功' : '失败') +
                                '</td><td><button class="layui-btn ' + (v.pictureUrl ? '' : 'layui-btn-disabled" disabled="disabled') +
                                '" img-src="' + v.pictureUrl +
                                '">查看图片</button>' +
                                '</td></tr>');
                        });
                        break;
                }

                table.find('button').click(function () {
                    layer.photos({
                        photos: {
                            "data": [{
                                "alt": "截图记录",
                                "src": $(this).attr('img-src')
                            }]
                        }
                    });
                });
            }
        }); */
    }
    doAjax("post",'../api/communityManager/v1/selectCommunityList',{token:session.getItem("token"),
    	ageId:session.getItem("agencyId")},function (data) {
            if (!data) return null;
            if (data.data) {
                $(data.data).each(function (k, v) {
                    $('#commId').append(new Option(v['commName'], v['commId']));
                });
                form.render('select');
            }
    },function(err){});
/*     $.post('../api/communityManager/v1/selectCommunityList',{token:session.getItem("token"),
    	ageId:session.getItem("agencyId")} , function (data) {
    
        if (!data || checkLogin(data)) return null;
        if (data.data) {
            $(data.data).each(function (k, v) {
                $('#commId').append(new Option(v['commName'], v['commId']));
            });
            form.render('select');
        }
    }); */

    layui.element.on('tab(docDemoTabBrief)', function (data) {
        var content = $('.layui-tab-item.layui-show');
        if (content.find('tbody tr').length === 0)
            query(content, {}, 0, 10);
    });
    query($('.layui-tab-item.layui-show'), {}, 0, 10);
});
function getHistoryUrl(type){
	switch (type) {
    case 'call'://获取通话记录
       return '../api/doorManager/v1/getDoorPhoneConversationLogList';
    case 'visitor'://获取访客记录
    	return '../api/doorManager/v1/getOpenDoorPhoneVisitorLogList';
    case 'card'://获取刷卡记录
    	return '../api/doorManager/v1/getCardDoorPhonOpenList';
    case 'face'://获取人脸开门记录
    	return '../api/doorManager/v1/getDoorPhoneFaceRecognitionList';
	}
}
</script>
</head>
<body>
	<div class="child-body">
		<form class="layui-form" style="margin-top: 10px">
			<div class="layui-form-item">
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
			<div class="layui-form-item">
				<label class="layui-form-label">搜索范围</label>
				<div class="layui-input-inline">
					<select name="commId" id="commId" lay-filter="commId">
						<option value="">请选择小区</option>
					</select>
				</div>
				<div class="layui-input-inline">
					<select name="bldId" id="bldId" lay-filter="bldId">
						<option value="">请选择楼栋</option>
					</select>
				</div>
				<div class="layui-input-inline">
					<select name="unitId" id="unitId" lay-filter="unitId">
						<option value="">请选择单元</option>
					</select>
				</div>
				<!--<div class="layui-input-inline">-->
				<!--<select name="doorPhoneId" id="doorPhoneId">-->
				<!--<option value="">请选择门口机</option>-->
				<!--</select>-->
				<!--</div>-->
			</div>
			<div class="layui-form-item">
				<div class="layui-input-block">
					<button class="layui-btn" lay-submit lay-filter="formQuery"
						style="min-width: 150px">查询</button>
				</div>
			</div>
		</form>
		<div class="layui-tab layui-tab-brief" lay-filter="docDemoTabBrief">
			<ul class="layui-tab-title">
				<li class="layui-this">通话记录</li>
				<li>刷卡记录</li>
				<li>人脸开门记录</li>
				<li>访客记录</li>
			</ul>
			<div class="layui-tab-content">
				<div id="call" class="layui-tab-item layui-show">
					<div></div>
					<table class="layui-table" lay-size="sm">
						<thead>
							<tr>
								<th>用户</th>
								<th>小区</th>
								<th>楼栋</th>
								<th>单元</th>
								<th>门口机</th>
								<th>通话开始时间</th>
								<th>通话结束时间</th>
								<!--<th>开门</th>-->
								<th>截图信息</th>
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
				<div id="card" class="layui-tab-item">
					<div></div>
					<table class="layui-table" lay-size="sm">
						<thead>
							<tr>
								<th>用户</th>
								<th>小区</th>
								<th>楼栋</th>
								<th>单元</th>
								<th>门口机</th>
								<th>卡号</th>
								<th>时间</th>
								<th>开门</th>
								<th>截图信息</th>
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
				<div id="face" class="layui-tab-item">
					<div></div>
					<table class="layui-table" lay-size="sm">
						<thead>
							<tr>
								<th>用户</th>
								<th>小区</th>
								<th>楼栋</th>
								<th>单元</th>
								<th>门口机</th>
								<th>时间</th>
								<!--<th>开门</th>-->
								<th>截图信息</th>
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
				<div id="visitor" class="layui-tab-item">
					<div></div>
					<table class="layui-table" lay-size="sm">
						<thead>
							<tr>
								<th>邀请人</th>
								<th>小区</th>
								<th>楼栋</th>
								<th>单元</th>
								<th>门口机</th>
								<th>时间</th>
								<!--<th>开门</th>-->
								<th>截图信息</th>
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</body>
</html>