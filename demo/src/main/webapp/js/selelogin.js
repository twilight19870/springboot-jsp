function selelogin(){
	var token = $.session.get('token');
	if(!token)
		window.location.href= "login.jsp"; 
}
function delPlace(level,id){
	//console.log("level:"+level);
	//console.log("id:"+id);
	
	if(level == 1){
		return "../api/communityManager/v1/deleteCommunityById?"+"id="+id;
	}else if(level == 2){
		return "../api/communityManager/v1/deleteBuildingById?"+"bldId="+id;
	}else if(level == 3){
		return "../api/communityManager/v1/deleteUnitById?"+"unitId="+id;
	}else if(level == 4){
		return "../api/communityManager/v1/deleteRoomById?"+"roomId="+id;
	}
}
function getMacMain(treeId,treeNode){
	//console.log("id:"+treeId);
	//console.log("treeNode:"+JSON.stringify(treeNode));
	if(treeNode.level == 0){
		return "../api/communityManager/v1/selectCommunityList";
	}else if(treeNode.level == 1){
		return "../api/doorManager/v1/selectPropertyPhoneList?"+"communityId="+treeNode.id;
	}
}
function forTreeAgentCommunityParentData(data){
	let dataStr = JSON.stringify(data).replace(/commId/g, 'id').replace(/commName/g, 'name');
	   //console.log("dataStr:"+dataStr);
	   let reponseData = JSON.parse(dataStr);
	   reponseData.forEach(function(item,index,arr){
		   item.level = 1;
	   });
	   //console.log(reponseData);
	   return reponseData;
}
function forTreeAgentIntelligentParentData(data){
	let dataStr = JSON.stringify(data).replace(/homeId/g, 'homeId').replace(/homeName/g, 'name');
	   let reponseData = JSON.parse(dataStr);
	   reponseData.forEach(function(item,index,arr){
		   item.level = 1;
		   item.id=item.homeId;
	   });
	   return reponseData;
}
function getPlace(treeId,treeNode){
	//console.log("id:"+treeId);
	//console.log("treeNode:"+JSON.stringify(treeNode));
	var dataarr = [];
	if(treeNode.level == 0){
		return "../api/communityManager/v1/selectCommunityList?"+"ageId="+treeNode.id;
	}else if(treeNode.level == 1){
		return "../api/communityManager/v1/selectBuildingList?"+"commId="+treeNode.id;
	}else if(treeNode.level == 2){
		return "../api/communityManager/v1/selectUnitList?"+"bldId="+treeNode.id;
	}else if(treeNode.level == 3){
		return "../api/communityManager/v1/selectRoomList?"+"unitId="+treeNode.id;
	}else if(treeNode.level == 4){
		return "../api/userManager/v1/getAppUserByRoomId?"+"roomId="+treeNode.id;
	}
}
function getIntelligentZtree(treeId,treeNode){
	//console.log("id:"+treeId);
	//console.log("treeNode:"+JSON.stringify(treeNode));
	var dataarr = [];
	if(treeNode.level == 0){
		return "../api/smartFurniture/v1/getHomeList";
	}else if(treeNode.level == 1){
		return "../api/smartFurniture/v1/getHomeStoreyList?"+"homeId="+treeNode.homeId;
	}else if(treeNode.level == 2){
		return "../api/smartFurniture/v1/getHomeRoomList?"+"storeyId="+treeNode.storeyId;
	}
}
function fortreeMacParentData(data){
	let dataStr = JSON.stringify(data).replace(/commId/g, 'id').replace(/commName/g, 'name');
	   //console.log("dataStr:"+dataStr);
	   let reponseData = JSON.parse(dataStr);
	   reponseData.forEach(function(item,index,arr){
		   item.level = 0;
	   });
	   return reponseData;
}
function fortreeMacLevelOneData(data){
	let dataStr = JSON.stringify(data).replace(/doorPhoneName/g, 'name');
	   //console.log("dataStr:"+dataStr);
	   let reponseData = JSON.parse(dataStr);
	   reponseData.forEach(function(item,index,arr){
		   item.level = 1;
	   });
	   return reponseData;
}
function forTreeAgentCommunityLevelOneData(data){
	let dataStr = JSON.stringify(data).replace(/bldId/g, 'id').replace(/bldName/g, 'name').replace(/bldCode/g, 'code');
	   //console.log("dataStr:"+dataStr);
	   let reponseData = JSON.parse(dataStr);
	   reponseData.forEach(function(item,index,arr){
		   item.level = 2;
	   });
	   return reponseData;
}
function forTreeAgentIntelligentLevelOneData(data){
	let dataStr = JSON.stringify(data).replace(/storeyId/g, 'storeyId').replace(/storeyName/g, 'name');
	   //console.log("dataStr:"+dataStr);
	   let reponseData = JSON.parse(dataStr);
	   reponseData.forEach(function(item,index,arr){
		   item.level = 2;
		   item.id=item.storeyId;
	   });
	   return reponseData;
}
function forTreeAgentCommunityLevelTwoData(data){
	let dataStr = JSON.stringify(data).replace(/unitId/g, 'id').replace(/unitName/g, 'name').replace(/unitCode/g, 'code');
	   //console.log("dataStr:"+dataStr);
	   let reponseData = JSON.parse(dataStr);
	   reponseData.forEach(function(item,index,arr){
		   item.level = 3;
	   });
	   return reponseData;
}
function forTreeAgentIntelligentLevelTwoData(data){
	let dataStr = JSON.stringify(data).replace(/roomId/g, 'roomId').replace(/roomName/g, 'name');
	   //console.log("dataStr:"+dataStr);
	   let reponseData = JSON.parse(dataStr);
	   reponseData.forEach(function(item,index,arr){
		   item.level = 3;
		   item.id=item.roomId;
	   });
	   return reponseData;
}
function forTreeAgentCommunityLevelThreeData(data){
	let dataStr = JSON.stringify(data).replace(/roomId/g, 'id').replace(/roomName/g, 'name').replace(/roomCode/g, 'code');
	   //console.log("dataStr:"+dataStr);
	   let reponseData = JSON.parse(dataStr);
	   reponseData.forEach(function(item,index,arr){
		   item.level = 4;
	   });
	   return reponseData;
}
function forTreeAgentCommunityLevelFourData(data){
	let dataStr = JSON.stringify(data).replace(/userId/g, 'id').replace(/userName/g, 'name');
	   //console.log("dataStr:"+dataStr);
	   let reponseData = JSON.parse(dataStr);
	   reponseData.forEach(function(item,index,arr){
		   item.level = 5;
	   });
	   return reponseData;
}

function outlogin(){
	$.session.remove("token");
	window.top.location = "./login.jsp";
}
function relogin(res){
	let text;
	if(res == "1003"){
		text = '登录权限已失效,请重新登录!';
	}else if(res == "1004"){
		text = '登录信息已过期,请重新登录!';
	}else if(res == "1002"){
		text = '未登录，请先登录!';
	}
	layer.open({
		 content: text
		  ,btn: ['确定']
		  ,closeBtn: 0
		  ,yes: function(index, layero){
			  outlogin();
		  }
		}); 
}
function checkOutLogin(){
	layer.open({
		 content: '确认退出吗？'
		  ,btn: ['确定']
		  ,closeBtn: 1
		  ,yes: function(index, layero){
			  outlogin();
		  }
		}); 
}
function doAjax(method,url,data,success,error){
		 $.ajax({
	         url:url,
	         method:method,
	         data:data,
	         success:function(res){
	        	 let checkCode = checkToken(res);
	        	 if(checkCode == "1005"){
/*	        		 console.log(data);
	        		 console.log("获取token:"+$.session.get("token"));*/
	        		 data.token = $.session.get("token");
	        		 //console.log(data);
	        		 doAjax(method,url,data,success,error);
	        	 }else if(checkCode == "1003"){
	        		 relogin(checkCode);
	        	 }else if(checkCode == "1004"){
	        		 relogin(checkCode);
	        	 }else if(checkCode == "1002"){
	        		 relogin(checkCode);
	        	 }else if(checkCode == "200"){
	        		 success(res);
	        	 }else {
	        		 success(res);
	        	 }
	         },error:function (err){
	             error(err);
	         }
	     })
}

function doAjaxAtAsync(method,url,data,success,error){
	 $.ajax({
        url:url,
        method:method,
        data:data,
        async:false,
        success:function(res){
       	 let checkCode = checkToken(res);
       	 if(checkCode == "1005"){
/*	        		 console.log(data);
       		 console.log("获取token:"+$.session.get("token"));*/
       		 data.token = $.session.get("token");
       		 //console.log(data);
       		 doAjax(method,url,data,success,error);
       	 }else if(checkCode == "1003"){
       		 relogin(checkCode);
       	 }else if(checkCode == "1004"){
       		 relogin(checkCode);
       	 }else if(checkCode == "200"){
       		 success(res);
       	 }
        },error:function (err){
            error(err);
        }
    })


}

function checkForDataCode(res){
	 let checkCode = checkToken(res);
	 if(checkCode == "1005"){
		 return false;
	 }else if(checkCode == "1003"){
		 relogin(checkCode);
		 return false;
	 }else if(checkCode == "1004"){
		 relogin(checkCode);
		 return false;
	 }else if(checkCode == "200"){
		 return true;
	 }
}

function checkToken(res){
	var checkCodeThan = "0";
	if(!res.msg){
		res =  JSON.parse(res);
	}
	switch(res.code){
	case 0:
	case 4002:
	case 4004:
	case 4005:
		checkCodeThan = "200";
		return checkCodeThan;
		break;
	case 1003:
		checkCodeThan = "1003";
		return checkCodeThan;
		break;
	case 1004:
		checkCodeThan = "1004";
		return checkCodeThan;
		break;
	case 1005:
		$.ajax({
	        url:'../api/common/v1/updataToken',
	        method:"post",
	        async:false,
	        data:{token:$.session.get("token")},
	        success:function(res){
	        	//console.log(res);
	        	//console.log(res.code);
	            if(res.code == 0 ){
	                $.session.set("token",res.data.token);
	                window.sessionStorage.setItem("token",res.data.token);
	                checkCodeThan = "1005";
	            }else if(res.code == 1004){
	            	checkCodeThan = "1004";
	            }else if(res.code == 200){
	            	checkCodeThan = "200";
	            }
	        },error:function (err){
	        	checkCodeThan = "1004";
	        }
	    })
	    return checkCodeThan;
		break;
	}
	
}

function isEquals(arguments){
	var i, j;
	for(i = 0; i < arguments.length; i++){
		for(j = i + 1; j < arguments.length; j++){
			if(arguments[i] == arguments[j]){
			return true;
			}
		}
	}
	return false;
}