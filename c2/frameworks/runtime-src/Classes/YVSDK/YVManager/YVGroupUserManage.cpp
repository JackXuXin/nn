///*********************************************************************************
//*Copyright(C), 2015 YUNVA Company
//*FileName:  YVGroupUserManager.cpp
//*Author:  cch
//*Version:  1.5.0
//*Date:  2015-12-16
//*Description:  群聊天实现类
//**********************************************************************************/
//
#include "YVGroupUserManager.h"
#include "YVUtils/YVMsgDispatcher.h"
#include "YVSDK.h"
//
////#include "cocos2d.h"
//

#include <assert.h>
#include <time.h>
//
using namespace YVSDK;
//
bool YVGroupUserManager::init()
{
//	m_historyCache = new _YVMessageList();
	m_gsendMsgCache = new _YVMessageList();
	m_myGroups.clear();
	m_allGroupUserLists.clear();
	m_GroupJoinNotify.clear();
	m_GroupInviteNotify.clear();
	expand = "";
	m_currentGroupid = -1;
	YVMsgDispatcher*  msgDispatcher = YVPlatform::getSingletonPtr()->getMsgDispatcher();

	//创建群回应
	msgDispatcher->registerMsg(IM_GROUP_CREATE_RESP, this,
		&YVGroupUserManager::groupCreateCallback);

	//搜索群回应
	msgDispatcher->registerMsg(IM_GROUP_SEARCH_RESP, this,
		&YVGroupUserManager::searchGroupCallBack);
	
	//加入群回应
	msgDispatcher->registerMsg(IM_GROUP_JOIN_RESPON, this,
		&YVGroupUserManager::joinGroupCallBack);

	//申请加群结果通知
	msgDispatcher->registerMsg(IM_GROUP_JOIN_RESP, this,
		&YVGroupUserManager::GroupJoinCallBackRespond);

	//加入群通知(群主/管理员接收)
	msgDispatcher->registerMsg(IM_GROUP_JOIN_NOTIFY, this,
		&YVGroupUserManager::GroupJoinNotifyCallBack);

	//同意/拒绝加群回应
	msgDispatcher->registerMsg(IM_GROUP_JOIN_ACCEPT_RESP, this,
		&YVGroupUserManager::groupJoinAcceptCallBack);

	//退群通知  
	msgDispatcher->registerMsg(IM_GROUP_EXIT_NOTIFY, this,
		&YVGroupUserManager::groupExitCallBack);

	//退群返回
	msgDispatcher->registerMsg(IM_GROUP_EXIT_RESP, this,
		&YVGroupUserManager::groupExitBack);

	//修改群属性响应  
	msgDispatcher->registerMsg(IM_GROUP_MODIFY_RESP, this,
		&YVGroupUserManager::groupModifyCallBack);

	//转移群主通知  
	msgDispatcher->registerMsg(IM_GROUP_SHIFTOWNER_NOTIFY, this,
		&YVGroupUserManager::groupShiftOwnerCallBack);

	//转移群主响应  
	msgDispatcher->registerMsg(IM_GROUP_SHIFTOWNER_RESP, this,
		&YVGroupUserManager::groupShiftOwnerRespond);

	//踢除群成员通知  
	msgDispatcher->registerMsg(IM_KGROUP_KICK_NOTIFY, this,
		&YVGroupUserManager::groupKickNotify);

	//踢除群成员回调  
	msgDispatcher->registerMsg(IM_GROUP_KICK_RESP, this,
		&YVGroupUserManager::groupKickRespond);

	//邀请好友入群回应  
	msgDispatcher->registerMsg(IM_GROUP_INVITE_RESPON, this,
		&YVGroupUserManager::groupInviteRespond);
	
	//被邀请入群通知  
	msgDispatcher->registerMsg(IM_GROUP_INVITE_NOTIFY, this,
		&YVGroupUserManager::groupInviteNotify);
	
	//被邀请者同意或拒绝群邀请响应  
	msgDispatcher->registerMsg(IM_GROUP_INVITE_ACCEPT_RESP, this,
		&YVGroupUserManager::groupInviteAcceptRespond);

	//被邀请者同意或拒绝群邀请通知  
	msgDispatcher->registerMsg(IM_GROUP_INVITE_RESP, this,
		&YVGroupUserManager::groupInviteAcceptNotify);

	//设置群成员角色返回  
	msgDispatcher->registerMsg(IM_GROUP_SETROLE_RESP, this,
		&YVGroupUserManager::groupSetRoleRespond);

	//设置群成员角色通知  
	msgDispatcher->registerMsg(IM_GROUP_SETROLE_NOTIFY, this,
		&YVGroupUserManager::groupSetRoleNotify);

	//解散群响应  
	msgDispatcher->registerMsg(IM_GROUP_DISSOLVE_RESP, this,
		&YVGroupUserManager::groupDissolveRespond);

	//修改他人名片通知  
	msgDispatcher->registerMsg(IM_GROUP_SETOTHER_NOTIFY, this,
		&YVGroupUserManager::groupSetOtherNotify);

	//修改他人名片返回  
	msgDispatcher->registerMsg(IM_GROUP_SETOTHER_RESP, this,
		&YVGroupUserManager::groupSetOtherRespond);

	//群属性通知(群列表)
	msgDispatcher->registerMsg(IM_GROUP_PROPERTY_NOTIFY, this,
		&YVGroupUserManager::groupPropertyNotify);

	//群成员上线
	msgDispatcher->registerMsg(IM_GROUP_MEMBER_ONLINE, this,
		&YVGroupUserManager::groupMemberOnlineNotify);
	
	//新成员加入群
	msgDispatcher->registerMsg(IM_GROUP_USERJOIN_NOTIFY, this,
		&YVGroupUserManager::groupNewUserJoinNotify);

	//修改资料通知
	msgDispatcher->registerMsg(IM_GROUP_USERMDY_NOTIFY, this,
		&YVGroupUserManager::groupUserMdyNotify);


	//群用户列表
	msgDispatcher->registerMsg(IM_GROUP_USERLIST_NOTIFY, this,
		&YVGroupUserManager::groupUserListNotify);

	//群聊天推送
	msgDispatcher->registerMsg(IM_CHAT_GROUP_NOTIFY, this,
		&YVGroupUserManager::groupChatNotify);


	//群聊消息发送响应
	msgDispatcher->registerMsg(IM_CHAT_GROUPMSG_RESP, this,
		&YVGroupUserManager::groupChatMsgNotify);

	//获取群聊历史消息或者离线消息回应
	msgDispatcher->registerMsg(IM_CLOUDMSG_LIMIT_NOTIFY, this,
		&YVGroupUserManager::cloundMsgNotifyCallback);
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	platform->addFinishSpeechListern(this);

	return true;
}
//
int	YVGroupUserManager::getcurrentGroupid()
{
	return m_currentGroupid;
}
void YVGroupUserManager::setcurrentGroupid(int gid)
{
	m_currentGroupid = gid;
}
bool YVGroupUserManager::destory()
{
	m_currentGroupid = -1;
	YVMsgDispatcher*  msgDispatcher = YVPlatform::getSingletonPtr()->getMsgDispatcher();


	////创建群回应
	msgDispatcher->unregisterMsg(IM_GROUP_CREATE_RESP, this);

	////搜索群回应
	msgDispatcher->unregisterMsg(IM_GROUP_SEARCH_RESP, this);

	////加入群回应
	msgDispatcher->unregisterMsg(IM_GROUP_JOIN_RESPON, this);
	
	////申请加群结果通知
	msgDispatcher->unregisterMsg(IM_GROUP_JOIN_RESP, this);
	
	////加入群通知(群主/管理员接收)
	msgDispatcher->unregisterMsg(IM_GROUP_JOIN_NOTIFY, this);
	
	////同意/拒绝加群回应
	msgDispatcher->unregisterMsg(IM_GROUP_JOIN_ACCEPT_RESP, this);
	
	////退群通知  
	msgDispatcher->unregisterMsg(IM_GROUP_EXIT_NOTIFY, this);

	//退群返回
	msgDispatcher->unregisterMsg(IM_GROUP_EXIT_RESP, this);
	

	////修改群属性响应  
	msgDispatcher->unregisterMsg(IM_GROUP_MODIFY_RESP, this);
	
	////转移群主通知  
	msgDispatcher->unregisterMsg(IM_GROUP_SHIFTOWNER_NOTIFY, this);

	////转移群主响应  
	msgDispatcher->unregisterMsg(IM_GROUP_SHIFTOWNER_RESP, this);

	////踢除群成员通知  
	msgDispatcher->unregisterMsg(IM_KGROUP_KICK_NOTIFY, this);

	////踢除群成员回调  
	msgDispatcher->unregisterMsg(IM_GROUP_KICK_RESP, this);
	
	////邀请好友入群回应  
	msgDispatcher->unregisterMsg(IM_GROUP_INVITE_RESPON, this);
	
	////被邀请入群通知  
	msgDispatcher->unregisterMsg(IM_GROUP_INVITE_NOTIFY, this);

	////被邀请者同意或拒绝群邀请响应  
	msgDispatcher->unregisterMsg(IM_GROUP_INVITE_ACCEPT_RESP, this);

	////被邀请者同意或拒绝群邀请通知  
	msgDispatcher->unregisterMsg(IM_GROUP_INVITE_RESP, this);
	
	////设置群成员角色返回  
	msgDispatcher->unregisterMsg(IM_GROUP_SETROLE_RESP, this);

	////设置群成员角色通知  
	msgDispatcher->unregisterMsg(IM_GROUP_SETROLE_NOTIFY, this);
	
	////解散群响应  
	msgDispatcher->unregisterMsg(IM_GROUP_DISSOLVE_RESP, this);
	
	////修改他人名片通知  
	msgDispatcher->unregisterMsg(IM_GROUP_SETOTHER_NOTIFY, this);

	////修改他人名片返回  
	msgDispatcher->unregisterMsg(IM_GROUP_SETOTHER_RESP, this);
	
	////群属性通知(群列表)
	msgDispatcher->unregisterMsg(IM_GROUP_PROPERTY_NOTIFY, this);
	
	////群成员上线
	msgDispatcher->unregisterMsg(IM_GROUP_MEMBER_ONLINE, this);
	
	////新成员加入群
	msgDispatcher->unregisterMsg(IM_GROUP_USERJOIN_NOTIFY, this);

	//修改资料通知
	msgDispatcher->unregisterMsg(IM_GROUP_USERMDY_NOTIFY, this);

	//群用户列表
	msgDispatcher->unregisterMsg(IM_GROUP_USERLIST_NOTIFY, this);

	//创建群回应
	msgDispatcher->unregisterMsg(IM_CHAT_GROUP_NOTIFY, this);

	//群聊消息发送响应
	msgDispatcher->unregisterMsg(IM_CHAT_GROUPMSG_RESP, this);

	// 获取群聊历史消息或者离线消息回应
	msgDispatcher->unregisterMsg(IM_CLOUDMSG_LIMIT_NOTIFY, this);
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	platform->delFinishSpeechListern(this);
	m_myGroups.clear();
	m_allGroupUserLists.clear();
	m_GroupJoinNotify.clear();
	m_GroupInviteNotify.clear();
	return true;
}


bool YVGroupUserManager::sendGroupCreate(uint32 verify, const std::string& name, const std::string& iconUrl)
{

	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher*  msgDispatcher = platform->getMsgDispatcher();
	GroupCreateRequest q;
	q.verify = verify;
	q.name = name;
	q.iconUrl = iconUrl;

	return msgDispatcher->send(&q);

}


void YVGroupUserManager::groupCreateCallback(YaYaRespondBase* respond)
{
	GroupCreateRespond* r = static_cast<GroupCreateRespond*>(respond);
	if (r->result == 0)
	{
		printf("GroupCreate success: groupid = %d", r->groupid);
	}
	else
	{
		printf("GroupCreate fail");
	}
	callGroupCreateListern(r);
}


//搜索群 
bool YVGroupUserManager::searchGroup(uint32 groupid)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher*  msgDispatcher = platform->getMsgDispatcher();
	GroupSearchRequest q;
	q.groupid = groupid;
	return msgDispatcher->send(&q);
}

//搜索群回应
void YVGroupUserManager::searchGroupCallBack(YaYaRespondBase*respond)
{
	GroupSearchRespond* r = static_cast<GroupSearchRespond*>(respond);
	if (r->result == 0)
	{
		printf("GroupSearch success: groupid = %d", r->groupid);
	}
	else
	{
		printf("GroupSearch fail msg:%s", r->msg.c_str());
	}
	callSearchGroupListern(r);
}



//加入群 
bool YVGroupUserManager::joinGroup(uint32 groupid, const std::string& greet)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher*  msgDispatcher = platform->getMsgDispatcher();
	GroupJoinRequest q;
	q.groupid = groupid;
	q.greet = greet;
	return msgDispatcher->send(&q);
}
 
//加入群回应
void YVGroupUserManager::joinGroupCallBack(YaYaRespondBase* respond)
{
	GroupJoinRespond* r = static_cast<GroupJoinRespond*>(respond);
	if (r->result == 0)
	{
		printf("GroupJoin success: groupid = %d", r->groupid);
	}
	else
	{
		printf("GroupJoin fail");
	}
	callJoinGroupListern(r);
	
}


//申请加群结果通知
void YVGroupUserManager::GroupJoinCallBackRespond(YaYaRespondBase*respond)
{
	GroupJoinCallRespond* r = static_cast<GroupJoinCallRespond*>(respond);
	callGroupJoinCallBackListern(r);
}

//加入群通知(群主/管理员接收)
void YVGroupUserManager::GroupJoinNotifyCallBack(YaYaRespondBase*respond)
{
	GroupJoinNotify* r = static_cast<GroupJoinNotify*>(respond);

	if (r && getGroupJoinNotify(r->groupid, r->userid))
	{
		return;
	}
	GroupJoinNotify* n = new GroupJoinNotify();
	n->groupid = r->groupid;
	n->userid = r->userid;
	n->username = r->username;
	n->groupname = r->groupname;
	n->greet = r->greet;
	n->iconurl = r->iconurl;
	
	m_GroupJoinNotify.push_back(n);
	callGroupJoinnotifyListern(r);
}

//获取本地缓存，申请加群信息
YVSDK::GroupJoinNotify* YVGroupUserManager::getGroupJoinNotify(uint32 groupid, uint32 uid)
{
	if (m_GroupJoinNotify.size() == 0)
	{
		return NULL;
	}
	for (std::vector<YVSDK::GroupJoinNotify*>::iterator it = m_GroupJoinNotify.begin(); it != m_GroupJoinNotify.end(); ++it)
	{
		YVSDK::GroupJoinNotify* info = (*it);
		if (info && info->groupid == groupid && info->userid == uid)
		{
			return info;
		}
	}
	return NULL;
}

//获取本地缓存，邀请我加群的信息
YVSDK::GroupInviteNotify* YVGroupUserManager::getGroupInviteNotify(uint32 groupid, uint32 uid)
{
	if (m_GroupInviteNotify.size() == 0)
	{
		return NULL;
	}
	for (std::vector<YVSDK::GroupInviteNotify*>::iterator it = m_GroupInviteNotify.begin(); it != m_GroupInviteNotify.end(); ++it)
	{
		YVSDK::GroupInviteNotify* info = (*it);
		if (info && info->groupid == groupid && info->inviteid == uid)
		{
			return info;
		}
	}
	return NULL;
}


//同意/拒绝加群 userid用户申请者）ID,  agree是否同意加入群,  0拒绝, 1同意 , greet拒绝原因
bool YVGroupUserManager::sendGroupJoinAccept(uint32 groupid, uint32 userid, uint8 agree, const std::string& greet)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher*  msgDispatcher = platform->getMsgDispatcher();
	GroupJoinAcceptRequest q;
	q.groupid = groupid;
	q.userid = userid;
	q.agree = agree;
	q.greet = greet;
	return msgDispatcher->send(&q);
	

}

//同意/拒绝加群回应
void YVGroupUserManager::groupJoinAcceptCallBack(YaYaRespondBase*respond)
{
	GroupJoinAcceptRespond* r = static_cast<GroupJoinAcceptRespond*>(respond);

	callGroupJoinAcceptListern(r);
	
}

//退群 
bool YVGroupUserManager::sendGroupExit(uint32 groupid)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher*  msgDispatcher = platform->getMsgDispatcher();
	GroupExitRequest q;
	q.groupid = groupid;
	
	return msgDispatcher->send(&q);
}

//退群响应  
void YVGroupUserManager::groupExitBack(YaYaRespondBase*respond)
{
	GroupExitBack* r = static_cast<GroupExitBack*>(respond);

	
	if (r->result == 0 )
	{
		for (std::vector<YVSDK::GroupItemInfo*>::iterator it = m_myGroups.begin(); it != m_myGroups.end(); ++it)
		{
			YVSDK::GroupItemInfo* info = (*it);
			if (r->groupid == info->groupid)
			{
				m_myGroups.erase(it);
				break;
			}
		}
	}
	callGroupExitbackListern(r);
}

//退群通知  
void YVGroupUserManager::groupExitCallBack(YaYaRespondBase*respond)
{
	GroupExitRespond* r = static_cast<GroupExitRespond*>(respond);
	if (r)
	{
		delGroupUser(r->groupid, r->userid);
	}
	callGroupExitListern(r);

}

//修改群属性 name群名称, icon群图标, announcement群公告, msg_set群消息设置, alias名片修改
bool YVGroupUserManager::sendGroupModify(uint32 groupid, const std::string& name, const std::string& icon,
	const std::string& announcement, uint8 verify, uint8 msg_set, const std::string& alias)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher*  msgDispatcher = platform->getMsgDispatcher();
	GroupModifyRequest q;
	q.groupid = groupid;
	q.name = name;
	q.icon = icon;
	q.announcement = announcement;
	q.verify = verify;
	//q.msg_set = msg_set;
	q.alias = alias;

	return msgDispatcher->send(&q);
}


//修改群属性响应  
void YVGroupUserManager::groupModifyCallBack(YaYaRespondBase*respond)
{
	GroupModifyRespond* q = static_cast<GroupModifyRespond*>(respond);
	if (q->result == 0)
	{	
	}
	callGroupModifyListern(q);
}

//修改资料通知  
void YVGroupUserManager::groupUserMdyNotify(YaYaRespondBase*respond)
{
	GroupUserMdy* q = static_cast<GroupUserMdy*>(respond);
	if (q)
	{	
		YVSDK::GroupItemInfo* oldG = getGroupByGid(q->groupid);
		YVSDK::GroupItemInfo* group = new YVSDK::GroupItemInfo();
		group->groupid = q->groupid;
		group->announcement = q->announcement.empty() ? oldG->announcement:q->announcement;
		group->currentnum = oldG->currentnum;
		group->groupicon = q->icon.empty()? oldG->groupicon : q->icon;
		group->groupname = q->name.empty()? oldG->groupname: q->name;
		group->msg_set = oldG->msg_set;
		group->ownerid = oldG->ownerid;
		group->numbercount = oldG->numbercount;
		group->role = oldG->role;
		group->verify = q->verify == 0 ? oldG->verify: q->verify;
		modifyGroup(group);

		if (!q->alias.empty())
		{
			releshOtherAlial(q->groupid, q->userId, q->alias);//个人名片修改刷新
		}
	}
	callGroupUsermdyListern(q);
}



//转移群主请求 
bool YVGroupUserManager::sendGroupShiftOwner(uint32 groupid, uint32 userid)
{
	
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher*  msgDispatcher = platform->getMsgDispatcher();
	GroupShiftOwnerRequest q;
	q.groupid = groupid;
	q.userid = userid;

	return msgDispatcher->send(&q);
}
//转移群主通知 IM_GROUP_SHIFTOWNER_NOTIFY 
void YVGroupUserManager::groupShiftOwnerCallBack(YaYaRespondBase*respond)
{
	GroupShiftOwnerNotify* q = static_cast<GroupShiftOwnerNotify*>(respond);
	YVPlatform* p = YVPlatform::getSingletonPtr();
	for (std::vector<YVSDK::GroupItemInfo*>::iterator it1 = m_myGroups.begin(); it1 != m_myGroups.end(); ++it1)
	{
		YVSDK::GroupItemInfo* info = (*it1);
		if (info->groupid == q->groupid)
		{
			if(info->ownerid == q->userid)
			{
				info->ownerid = q->shiftid;
				
			}
			if (p->getLoginUserInfo()->userid == q->shiftid)
			{
				info->role = 2;
			}

			if (p->getLoginUserInfo()->userid == q->userid)
			{
				info->role = 4;
			}
		}
	}

	uint8 ismdfnum = 0;
	GroupUserListMap::iterator itor = m_allGroupUserLists.find(q->groupid);
	if (itor != m_allGroupUserLists.end())
	{
		std::vector<GroupUserInfo*>* tempUserlist = &itor->second->GroupUserlist; //群用户列表
		for (std::vector<YVSDK::GroupUserInfo*>::iterator it1 = tempUserlist->begin(); it1 != tempUserlist->end(); ++it1)
		{
			YVSDK::GroupUserInfo* guser = (*it1);
			if (guser->userId == q->userid)
			{
				guser->role = 4;
				ismdfnum++;
			}
			if (guser->userId == q->shiftid)
			{
				guser->role = 2;
				ismdfnum++;
			}
			if (ismdfnum == 2)
			{
				break;
			}
		}
	}

	callGroupShiftOwnernotifyListern(q);
}

//转移群主响应
void YVGroupUserManager::groupShiftOwnerRespond(YaYaRespondBase*respond)
{
	GroupShiftOwnerRespond* q = static_cast<GroupShiftOwnerRespond*>(respond);
	callGroupShiftOwnerrespondListern(q);
}

//踢除群成员
bool YVGroupUserManager::sendGroopKick(uint32 groupid, uint32 userid)
{
	
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher*  msgDispatcher = platform->getMsgDispatcher();
	GroupKickRequest q;
	q.groupid = groupid;
	q.userid = userid;

	return msgDispatcher->send(&q);
}

//踢除群成员通知 
void YVGroupUserManager::groupKickNotify(YaYaRespondBase*respond)
{
	GroupKickNotify* q = static_cast<GroupKickNotify*>(respond);
	if (q)
	{
		delGroupUser(q->groupid, q->kickid);
	}

	callGroupKicknotifyListern(q);
}

//踢除群成员回调 
void YVGroupUserManager::groupKickRespond(YaYaRespondBase*respond)
{
	GroupKickRespond* q = static_cast<GroupKickRespond*>(respond);
	callGroupKickListern(q);
}


//邀请好友入群    userid被邀请用户id, greet问候语
bool YVGroupUserManager::sendGroupInvite(uint32 groupid, uint32 userid, const std::string& greet)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher*  msgDispatcher = platform->getMsgDispatcher();
	GroupInviteRequest q;
	q.groupid = groupid;
	q.userid = userid;
	q.greet = greet;
	return msgDispatcher->send(&q);
}

//邀请好友入群回应 
void YVGroupUserManager::groupInviteRespond(YaYaRespondBase*respond)
{
	GroupInviteRespond* q = static_cast<GroupInviteRespond*>(respond);
	if (q && q->result == 0)
	{

	} 
	else
	{
		printf("msg:%s", q->msg.c_str());
	}

	callGroupInviteListern(q);
}

//被邀请入群通知 
void YVGroupUserManager::groupInviteNotify(YaYaRespondBase*respond)
{
	GroupInviteNotify* q = static_cast<GroupInviteNotify*>(respond);
	if (q && getGroupInviteNotify(q->groupid, q->inviteid))
	{
		return;
	}
	GroupInviteNotify* n = new GroupInviteNotify();
	n->groupid = q->groupid;
	n->inviteid = q->inviteid;
	n->invitename = q->invitename;
	n->greet = q->greet;
	n->groupname = q->groupname;
	n->groupicon = q->groupicon;
	m_GroupInviteNotify.push_back(n);
	callGroupInvitenotifyListern(q);
	
}

//被邀请者同意或拒绝群邀请
//groupid群id, invitename邀请用户名,  inviteid邀请用户id, agree; 是否同意入群 e_group_invite ,  0:拒绝,1:同意 greet问候语
bool YVGroupUserManager::sendGroupInviteAccept(uint32 groupid, const std::string& invitename, uint32 inviteid, uint32 agree
	, const std::string& greet)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher*  msgDispatcher = platform->getMsgDispatcher();
	GroupInviteAcceptRequest q;
	q.groupid = groupid;
	q.invitename = invitename;
	q.inviteid = inviteid;
	q.agree = agree;
	q.greet = greet;
	
	return msgDispatcher->send(&q);
}

//被邀请者同意或拒绝群邀请响应 
void YVGroupUserManager::groupInviteAcceptRespond(YaYaRespondBase*respond)
{
	GroupInviteAcceptRespond* q = static_cast<GroupInviteAcceptRespond*>(respond);
	if (q && q->result == 0)
	{

	}
	else
	{
		printf("msg:%s", q->msg.c_str());
	}
	callGroupInviteAcceptListern(q);
}

//被邀请者同意或拒绝群邀请通知 
void YVGroupUserManager::groupInviteAcceptNotify(YaYaRespondBase*respond)
{
	GroupInviteAcceptNotify* q = static_cast<GroupInviteAcceptNotify*>(respond);
	callGroupInviteAcceptnotifyListern(q);
}



//设置群成员角色请求
bool YVGroupUserManager::sendGroupSetRole(uint32 groupid, uint32 userid, uint8 role)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher*  msgDispatcher = platform->getMsgDispatcher();
	GroupSetRoleRequest q;
	q.groupid = groupid;
	q.userid = userid;
	q.role = role;

	return msgDispatcher->send(&q);
}

//设置群成员角色返回  GroupSetRoleRespond
void YVGroupUserManager::groupSetRoleRespond(YaYaRespondBase*respond)
{
	GroupSetRoleRespond* q = static_cast<GroupSetRoleRespond*>(respond);
	if (q && q->result == 0)
	{

	}
	else
	{
		printf("msg:%s", q->msg.c_str());
	}
	callGroupSetRoleListern(q);
}

//设置群成员角色通知  GroupSetRoleNotify
void YVGroupUserManager::groupSetRoleNotify(YaYaRespondBase*respond)
{
	GroupSetRoleNotify* q = static_cast<GroupSetRoleNotify*>(respond);
	if (q == NULL)
	{
		return;
	}
	YVPlatform* p = YVPlatform::getSingletonPtr();
	if (q->byuserid == p->getLoginUserInfo()->userid)
	{
		for (std::vector<YVSDK::GroupItemInfo*>::iterator it = m_myGroups.begin(); it != m_myGroups.end(); ++it)
		{
			YVSDK::GroupItemInfo* info = (*it);
			if (q->groupid == info->groupid)
			{
				info->role = q->role;
				break;
			}
		}
	}
	
	GroupUserListMap::iterator itetor = m_allGroupUserLists.find(q->groupid);
	if (itetor != m_allGroupUserLists.end())
	{
		std::vector<GroupUserInfo*>* tempUserlist = &itetor->second->GroupUserlist; //群用户列表
		for (std::vector<YVSDK::GroupUserInfo*>::iterator it1 = tempUserlist->begin(); it1 != tempUserlist->end(); ++it1)
		{
			YVSDK::GroupUserInfo* guser = (*it1);

			if (guser->userId == q->byuserid)
			{
				guser->role = q->role;
				break;
			}
		}
	}

	
	callGroupSetRolenotifyListern(q);
	
}

//解散群请求
bool YVGroupUserManager::sendGroupDissolve(uint32 groupid)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher*  msgDispatcher = platform->getMsgDispatcher();
	GroupDissolveRequest q;
	q.groupid = groupid;
	

	return msgDispatcher->send(&q);
}


//解散群响应 GroupDissolveRespond
void YVGroupUserManager::groupDissolveRespond(YaYaRespondBase*respond)
{
	GroupDissolveRespond* q = static_cast<GroupDissolveRespond*>(respond);
	if (q && q->result == 0)
	{
		for (std::vector<YVSDK::GroupItemInfo*>::iterator it = m_myGroups.begin(); it != m_myGroups.end(); ++it)
		{
			YVSDK::GroupItemInfo* info = (*it);
			if (q->groupid == info->groupid)
			{
				m_myGroups.erase(it);
				break;
			}
		}
	}
	else
	{
		printf("msg:%s", q->msg.c_str());
	}
	callGroupDissolveListern(q);
}


//管理员修改他人名片 或者 群成员修改自己的名片 GroupSetOtherRequest  
bool YVGroupUserManager::sendGroupSetOther(uint32 groupid, uint32 userid, const std::string& alias)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher*  msgDispatcher = platform->getMsgDispatcher();
	GroupSetOtherRequest q;
	q.groupid = groupid;
	q.userid = userid;
	q.alias = alias;
	return msgDispatcher->send(&q);
}

//群聊 - 文本重发
bool YVGroupUserManager::SendMsgGroupTextRequest(uint32 groupid, uint64 id, const std::string& text, const std::string& ext)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher*  msgDispatcher = platform->getMsgDispatcher();
	//发送消息

	GroupSendTextRequest q;
	q.groupid = groupid;
	q.text = text;
	q.ext = ext;
	uint64 msgID = id;
	q.flag.append(toString(msgID));

	return msgDispatcher->send(&q);
}

//群聊 - 文本 GroupSendTextRequest  ext; //扩展字段 flag; //消息标记(可不传)
bool YVGroupUserManager::sendGroupTextRequest(uint32 groupid, const std::string& text, const std::string& ext)
{
	///////////
	if (text.length() == 0)
	{
		return false;
	}
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher*  msgDispatcher = platform->getMsgDispatcher();
	//消息存入缓存//
	YVSDK::GroupItemInfo* g = getGroupByGid(groupid);
	YVUInfoPtr uinfo = platform->getLoginUserInfo();
	std::string inSendheadurl = uinfo->header->getLocalPath();
	YVMessagePtr msg = new _YVGroupTextMessage(text, uinfo->thirdNickName, inSendheadurl, g->groupname, g->groupicon);
	msg->recvId = groupid;
	msg->sendId = uinfo->userid;
	msg->state = YVMessageStatusSending;
	msg->sendTime = time(0);
	msg->ext = ext;
	//缓存消息
	insertMsg(groupid, msg, true);
	//放至消息发送列表里
	if (m_gsendMsgCache->getMessageById(msg->id) == NULL)
		m_gsendMsgCache->insertMessage(msg, true);

	//SendMsgCache(channelKeyId,msg);
	if (!platform->GetNetState())
	{
		msg->state = YVMessageStatusSendingFailed;
		callGroupChatMsgnotifyListern(msg);
	}

	GroupSendTextRequest q;
	q.groupid = groupid;
	q.text = text;
	q.ext = ext;
	uint64 msgID = msg->id;
	q.flag.append(toString(msgID));
	return msgDispatcher->send(&q);
}

//群聊 -  图片 GroupSendImageRequest  ext; //扩展字段 flag; //消息标记(可不传)
bool YVGroupUserManager::sendGroupImageRequest(uint32 groupid, const std::string& image, const std::string& ext, const std::string& flag)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher*  msgDispatcher = platform->getMsgDispatcher();
	GroupSendImageRequest q;
	q.groupid = groupid;
	q.image = image;
	q.ext = ext;
	q.flag = flag;
	return msgDispatcher->send(&q);
}

bool YVGroupUserManager::SendMsgGroupAutoRequest(uint32 groupid, uint64 id, const std::string& txt, YVFilePathPtr voicePath,
	uint32 time1, const std::string& ext)
{
	if (voicePath == NULL) return false;
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher*  msgDispatcher = platform->getMsgDispatcher();
	//发送前需要识别语音
	if (platform->speechWhenSend)
	{
		return platform->speechVoice(voicePath);
	}
	else
	{
		GroupSendAutoRequest q;
		q.groupid = groupid;
		q.file = voicePath->getLocalPath();
		q.time = time1;
		q.txt = txt;
		q.ext = ext;
		uint64 msgID = id;
		q.flag.append(toString(msgID));

		return msgDispatcher->send(&q);
	}
}

//群聊 -  语音 GroupSendAutoRequest  file音频文件路径 ;time音频文件播放时长(秒), txt附带文本(可选)
bool YVGroupUserManager::sendGroupAutoRequest(uint32 groupid, YVFilePathPtr voicePath, uint32 time1, const std::string& txt, const std::string& ext)
{
	////
	if (voicePath == NULL) return false;
	if (!(voicePath->getState() == OnlyLocalState
		|| voicePath->getState() == BothExistState))
	{
		return false;
	}
	expand = "";
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher*  msgDispatcher = platform->getMsgDispatcher();
	YVSDK::GroupItemInfo* g = getGroupByGid(groupid);
	YVUInfoPtr uinfo = platform->getLoginUserInfo();
	std::string inSendheadurl = uinfo->header->getLocalPath();
	//消息存入缓存//
	YVMessagePtr msg = new _YVGroupVoiceMessage(voicePath, time1, txt, uinfo->thirdNickName, inSendheadurl, g->groupname, g->groupicon);
	msg->recvId = groupid;
	msg->sendId = uinfo->userid;
	msg->state = YVMessageStatusSending;
	msg->sendTime = time(0);
	msg->ext = ext;
	//缓存消息
	insertMsg(groupid, msg, true);
	//放至消息发送列表里
	if (m_gsendMsgCache->getMessageById(msg->id) == NULL)
		m_gsendMsgCache->insertMessage(msg,true);


	if (!platform->GetNetState())
	{
		msg->state = YVMessageStatusSendingFailed;
		callGroupChatMsgnotifyListern(msg);
	}

	//SendMsgCache(channelKeyId, msg);
	//发送前需要识别语音
	if (platform->speechWhenSend)
	{
		expand = ext;
		return platform->speechVoice(voicePath);
	}
	else
	{
		GroupSendAutoRequest q;
		q.groupid = groupid;
		q.file = voicePath->getLocalPath();
		q.time = time1;
	//	q.txt = txt;
		q.ext = ext;
		uint64 msgID = msg->id;
		q.flag.append(toString(msgID));
		return msgDispatcher->send(&q);
	}


	//YVPlatform* platform = YVPlatform::getSingletonPtr();
//	YVMsgDispatcher*  msgDispatcher = platform->getMsgDispatcher();
	//GroupSendAutoRequest q;
	//q.groupid = groupid;
	//q.file = voicePath->getLocalPath();
	//q.time = time;
	//q.txt = txt;
	//q.ext = ext;
	//q.flag = flag;
	//return msgDispatcher->send(&q);
}


void YVGroupUserManager::onFinishSpeechListern(SpeechStopRespond* r)
{
	std::vector<YVMessagePtr>& sendingmsgs = m_gsendMsgCache->getMessageList();
	for (std::vector<YVMessagePtr>::iterator it = sendingmsgs.begin();
		it != sendingmsgs.end(); ++it)
	{
		YVMessagePtr msg = *it;
		if (msg == NULL)continue;
		if (msg->type != YVMessageTypeAudio) continue;
		YVGroupVoiceMessagePtr voiceMsg = msg;
		if (voiceMsg->voicePath != r->filePath) continue;
		voiceMsg->attach.clear();
		if (r->err_id == 0)
			voiceMsg->attach.append(r->result);
		else
			voiceMsg->attach.append("\xe8\xaf\x86\xe5\x88\xab\xe5\xa4\xb1\xe8\xb4\xa5\xef\xbc\x81");

		GroupSendAutoRequest q;
		q.groupid = voiceMsg->recvId;
		q.file = r->filePath->getLocalPath();
		q.time = voiceMsg->voiceTimes;
		q.txt = r->result;
		q.ext = expand;
		q.flag.append(toString(msg->id));

		//发送消息//
		YVPlatform* platform = YVPlatform::getSingletonPtr();
		YVMsgDispatcher*  msgDispatcher = platform->getMsgDispatcher();
		msgDispatcher->send(&q);
	}
}

//群聊天推送 IM_CHAT_GROUP_NOTIFY 
void YVGroupUserManager::groupChatNotify(YaYaRespondBase* respond)
{
	GroupChatNotify* q = static_cast<GroupChatNotify*>(respond);
//	callGroupChatnotifyListern(q);


	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher*  msgDispatcher = platform->getMsgDispatcher();
	//消息存入缓存//
	YVMessagePtr msg = NULL;


	if (q->type == chat_msgtype_text)
	{
		msg = new _YVGroupTextMessage(q->data, q->sendnickname, q->sendheadurl,q->groupname, q->groupicon);
	}
	else if (q->type == chat_msgtype_audio)
	{
		msg = new _YVGroupVoiceMessage(q->data, true, q->audiotime, q->attach, q->sendnickname, q->sendheadurl, q->groupname, q->groupicon);
		
	}
	if (msg == NULL) return;
	msg->recvId = q->groupid;
	msg->sendId = q->sendid;
	msg->playState = 1;
	msg->sendTime = q->time;
	msg->ext = q->ext1;
	msg->index = q->index;
	msg->source = q->source;

	YVUInfoPtr uinfo = platform->getUInfoById(msg->sendId);
	if (uinfo == NULL)
	{
		_YVUInfo* _info = new _YVUInfo;
		_info->userid = q->sendid;
		_info->nickname = q->sendnickname;
		uinfo = _info;
	}
	else
	{
		uinfo->nickname = q->sendnickname;

	}
	platform->updateUInfo(uinfo);
	//缓存消息
	insertMsg(q->groupid, msg, true);
	
}

//群聊消息发送响应 GroupChatMsgNotify
void YVGroupUserManager::groupChatMsgNotify(YaYaRespondBase* respond)
{
	GroupChatMsgNotify* q = static_cast<GroupChatMsgNotify*>(respond);

	if (q)
	{
		uint64 id = 0;
		id = toNumber(q->flag);
		GroupMessageMap::iterator it = m_groupMesages.find(q->groupid);
		if (it != m_groupMesages.end())
		{
			YVMessagePtr msg1 =	it->second->getMessageById(id);
			if (msg1 == NULL) return;
			msg1->index = q->index;
			msg1->state = q->result == 0 ? YVMessageStatusCreated : YVMessageStatusSendingFailed;
		}
	}
	else
	{
		return;
	}


	uint64 id = 0;
	id = toNumber(q->flag);
	YVMessagePtr msg = m_gsendMsgCache->getMessageById(id);
	if (msg == NULL) return;
	msg->state = q->result == 0 ? YVMessageStatusCreated : YVMessageStatusSendingFailed;
	callGroupChatMsgnotifyListern(msg);
	if (msg->state != YVMessageStatusSendingFailed)
		m_gsendMsgCache->delMessageById(id);
}




//修改他人名片通知 GroupSetOtherNotify
void YVGroupUserManager::groupSetOtherNotify(YaYaRespondBase*respond)
{
	GroupSetOtherNotify* q = static_cast<GroupSetOtherNotify*>(respond);
	if (q)
	{
		releshOtherAlial(q->groupid, q->userid, q->alias);
	}
	
	callGroupSetOthernotifyListern(q);
}

//修改他人名片返回 GroupSetOtherRespond
void YVGroupUserManager::groupSetOtherRespond(YaYaRespondBase*respond)
{
	GroupSetOtherRespond* q = static_cast<GroupSetOtherRespond*>(respond);
	callGroupSetOtherListern(q);
}

//群属性通知(群列表) GroupPropertyNotify
void YVGroupUserManager::groupPropertyNotify(YaYaRespondBase*respond)
{
	GroupPropertyNotify* q = static_cast<GroupPropertyNotify*>(respond);
	if (q)
	{
		YVSDK::GroupItemInfo* group = new YVSDK::GroupItemInfo();
		group->groupid = q->groupid;
		group->announcement = q->announcement;
		group->currentnum = q->user_count;
		group->groupicon = q->icon;
		group->groupname = q->name;
	//	group->level = q->level;
		group->msg_set = q->msg_set;
		group->ownerid = q->owner;
		group->numbercount = q->number_limit;
		group->role = q->role;
		group->verify = q->verify;
		bool ishas = false;
		for (std::vector<YVSDK::GroupItemInfo*>::iterator it = m_myGroups.begin(); it != m_myGroups.end(); ++it)
		{
			YVSDK::GroupItemInfo* info = (*it);
			if (info->groupid == group->groupid)
			{
				ishas = true;
				break;
			}
		}
		if (!ishas)
		{
			m_myGroups.push_back(group);
		}
	}
	callGroupPropertyListern(q);
}


//群成员上线 GroupMemberOnlineNotify
void YVGroupUserManager::groupMemberOnlineNotify(YaYaRespondBase*respond)
{
	GroupMemberOnlineNotify* q = static_cast<GroupMemberOnlineNotify*>(respond);
	callGroupMemberOnlineListern(q);
}

//新成员加入群 GroupNewUserJoinNotify
void YVGroupUserManager::groupNewUserJoinNotify(YaYaRespondBase*respond)
{
	GroupNewUserJoinNotify* q = static_cast<GroupNewUserJoinNotify*>(respond);
	GroupUserInfo* info = new GroupUserInfo();
	info->userId = q->groupUserInfo.userId;
	info->nickname = q->groupUserInfo.nickname;
	info->iconurl = q->groupUserInfo.iconurl;
	info->sex = q->groupUserInfo.sex;
	info->alias = q->groupUserInfo.alias;
	info->role = q->groupUserInfo.role;
	info->lately_online = q->groupUserInfo.lately_online;
	info->online = q->groupUserInfo.online;
	info->thirduid = q->groupUserInfo.thirduid;

	addGroupUser(q->groupid, info);
	callGroupNewUserJoinListern(q);
}

// 群用户列表 IM_GROUP_USERLIST_NOTIFY
void YVGroupUserManager::groupUserListNotify(YaYaRespondBase*respond)
{
	GroupUserListNotify* q = static_cast<GroupUserListNotify*>(respond);
	modifyGroupUserList(q);
	callGroupUserListnotifyListern(q);
}



YVSDK::GroupItemInfo* YVGroupUserManager::getGroupByGid(uint32 gid)
{
	if (m_myGroups.size() > 0)
	{
		for (std::vector<YVSDK::GroupItemInfo*>::iterator it = m_myGroups.begin(); it != m_myGroups.end(); ++it)
		{
			YVSDK::GroupItemInfo* info = (*it);
			if (gid == info->groupid)
			{
				return info;
			}
		}
	}else
	{
		return NULL;
	}
	
}


YVSDK::GroupUserListNotify* YVGroupUserManager::getGroupUserListByGid(uint32 gid)
{

	GroupUserListMap::iterator itetor = m_allGroupUserLists.find(gid);

	if (itetor != m_allGroupUserLists.end())
	{
		return itetor->second;
	}

	return NULL;
}

void YVGroupUserManager::releshOtherAlial(uint32 gid, uint32 uid, const std::string& alias)
{

	GroupUserListMap::iterator itetor = m_allGroupUserLists.find(gid);
	if (itetor != m_allGroupUserLists.end())
	{
		for (std::vector<YVSDK::GroupUserInfo*>::iterator it = itetor->second->GroupUserlist.begin(); it != itetor->second->GroupUserlist.end(); ++it)
		{
			YVSDK::GroupUserInfo* uinfo = (*it);
			if (uinfo->userId == uid)
			{
				uinfo->alias = alias;
				break;
			}
		}
	}

}


//删除群成员
void YVGroupUserManager::delGroupUser(uint32 gid, uint32 uid)
{
	bool isDel = false;

	GroupUserListMap::iterator itetor = m_allGroupUserLists.find(gid);
	if (itetor != m_allGroupUserLists.end())
	{
		std::vector<GroupUserInfo*>* tempUserlist = &itetor->second->GroupUserlist; //群用户列表
		for (std::vector<YVSDK::GroupUserInfo*>::iterator it1 = tempUserlist->begin(); it1 != tempUserlist->end(); ++it1)
		{
			YVSDK::GroupUserInfo* deluser = (*it1);
			if (deluser->userId == uid)
			{
				tempUserlist->erase(it1);
				isDel = true;
				break;
			}
		}
	}

	
	if (isDel)
	{
		//std::vector<YVSDK::GroupItemInfo*> m_myGroups
		YVPlatform* p = YVPlatform::getSingletonPtr();
		for (std::vector<YVSDK::GroupItemInfo*>::iterator it1 = m_myGroups.begin(); it1 != m_myGroups.end(); ++it1)
		{
			YVSDK::GroupItemInfo* info = (*it1);
			if (info->groupid == gid)
			{
				if (uid == p->getLoginUserInfo()->userid)
				{
					m_myGroups.erase(it1);
				}
				else{
					info->currentnum--;
				}
				break;
			}
		}
	}
}

//添加群成员
void YVGroupUserManager::addGroupUser(uint32 gid, YVSDK::GroupUserInfo* addUser)
{
	YVPlatform* p = YVPlatform::getSingletonPtr();
	bool isHave = false;

	GroupUserListMap::iterator itetor = m_allGroupUserLists.find(gid);
	if (itetor != m_allGroupUserLists.end())
	{
		std::vector<GroupUserInfo*>* tempUserlist = &itetor->second->GroupUserlist; //群用户列表
		for (std::vector<YVSDK::GroupUserInfo*>::iterator it1 = tempUserlist->begin(); it1 != tempUserlist->end(); ++it1)
		{
			YVSDK::GroupUserInfo* guser = (*it1);
			if (guser->userId == addUser->userId)
			{
				isHave = true;
				break;
			}

		}

		if (isHave == false)
		{
			itetor->second->GroupUserlist.push_back(addUser);
			for (std::vector<YVSDK::GroupItemInfo*>::iterator it1 = m_myGroups.begin(); it1 != m_myGroups.end(); ++it1)
			{
				YVSDK::GroupItemInfo* info = (*it1);
				if (info->groupid == gid)
				{
					info->currentnum++;
					break;
				}
			}
		}

	}



}


void YVGroupUserManager::modifyGroupUserList(YVSDK::GroupUserListNotify* g)
{
	uint32 index = 0;
	bool mdf = false;
	YVSDK::GroupUserListNotify* temp = new YVSDK::GroupUserListNotify();
	temp->groupid = g->groupid;
	temp->GroupUserlist = g->GroupUserlist;
	setGroupUserInfo(temp);


	GroupUserListMap::iterator itetor = m_allGroupUserLists.find(g->groupid);
	if (itetor != m_allGroupUserLists.end())
	{
		itetor->second = temp;
		mdf = true;
	}
	if (mdf == false)
	{
		m_allGroupUserLists.insert(std::make_pair(g->groupid, temp));
	}
}

void  YVGroupUserManager::setGroupUserInfo(YVSDK::GroupUserListNotify* temp)
{
	if (temp)
	{
		YVPlatform* platform = YVPlatform::getSingletonPtr();
		std::vector<GroupUserInfo*> groupUserlist = temp->GroupUserlist;
		for (std::vector<YVSDK::GroupUserInfo*>::iterator it = groupUserlist.begin(); it != groupUserlist.end(); ++it)
		{
			YVSDK::GroupUserInfo* info = (*it);
			if (info)
			{
				YVUInfoPtr uinfo = platform->getUInfoById(info->userId);
				if (uinfo == NULL)
				{
					_YVUInfo* _info = new _YVUInfo;
					_info->userid = info->userId;
					_info->nickname = info->nickname;
					uinfo = _info;
				}
			
				platform->updateUInfo(uinfo); 
			}
		}
	}




	/*YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVUInfoPtr uinfo = platform->getUInfoById(msg->sendId);
	if (uinfo == NULL)
	{
	_YVUInfo* _info = new _YVUInfo;
	_info->userid = q->sendid;
	_info->nickname = q->sendnickname;
	uinfo = _info;
	}
	else
	{
	uinfo->nickname = q->sendnickname;

	}
	platform->updateUInfo(uinfo);*/
}


bool YVGroupUserManager::modifyGroup(YVSDK::GroupItemInfo* g)
{
	uint32 index = 0;
	for (std::vector<YVSDK::GroupItemInfo*>::iterator it = m_myGroups.begin(); it != m_myGroups.end(); ++it)
	{
		YVSDK::GroupItemInfo* info = (*it);
		if (g->groupid == info->groupid)
		{
			m_myGroups[index] = g;
			return true;
		}
		index++;
	}
	return false;
}

void YVGroupUserManager::insertMsg(int groupId, YVMessagePtr msg, bool isBack, bool isCallGroupChatnotifyListern)
{
	GroupMessageMap::iterator it = m_groupMesages.find(groupId);
	if (it == m_groupMesages.end())
	{
		YVPlatform* platform = YVPlatform::getSingletonPtr();
		YVMessageListPtr messageList = new _YVMessageList();
		messageList->setMaxNum(platform->groupCacheNum);
		messageList->setChatWithID((uint32)groupId);
		m_groupMesages.insert(std::make_pair((uint32)groupId, messageList));
		it = m_groupMesages.find((uint32)groupId);
	}
	it->second->insertMessage(msg, isBack);
	//调用消息回调//
	if (isCallGroupChatnotifyListern)
	{
		callGroupChatnotifyListern(msg);
	}
}

YVMessageListPtr YVGroupUserManager::getCacheGroupData(uint32 groupid)
{
	GroupMessageMap::iterator it = m_groupMesages.find(groupid);
	if (it == m_groupMesages.end())
	{
		return NULL;
	}
	return (it->second);
}

YVMessageListPtr YVGroupUserManager::getGroupChatListById(uint32 groupid)
{
	GroupMessageMap::iterator it = m_groupMesages.find(groupid);
	if (it != m_groupMesages.end())
	{
		return (it->second);
	}
	return NULL;
}
void YVGroupUserManager::cleanGroupMessages(uint32 groupid)
{
	GroupMessageMap::iterator it = m_groupMesages.find(groupid);
	if (it != m_groupMesages.end())
	{
		it->second->clear();
	}
}

//获取历史消息   //groupid 群ID   index索引， 坐0开始
bool YVGroupUserManager::getGroupHistoryData(uint32 groupid, int index)
{
	//这里候已经拉到顶了，呵呵
	if (index == -1) return true;
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher* msgDispatcher = platform->getMsgDispatcher();

	GroupMessageMap::iterator it = m_ghistoryCache.find(groupid);
	if (it != m_ghistoryCache.end())
	{
		it->second->clear();
	}

//	YVMessageListPtr Notifymsg = platform->getNotifymsg();   //取私聊信息条数
	YVMessageListPtr Notifymsg = platform->getGroupChatListById(groupid); //取私聊信息条数

	CloundMsgRequest q;
	q.end = index == 0 ? index : index;
	if (Notifymsg !=NULL && Notifymsg->getMessageById(groupid) != NULL && Notifymsg->getMessageById(groupid)->index > 0 && index == 0)
	{
		q.limit = -Notifymsg->getMessageById(groupid)->index;
		if (Notifymsg->getMessageById(groupid)->index > 20)
		{
			q.end = Notifymsg->getMessageById(groupid)->endId;
		}
		PlatState = 1;
	}
	else
	{
		PlatState = 0;
		q.limit = -platform->groupHistoryChatNum;
	}

	//q.limit = 50;

	q.source = CLOUDMSG_GROUP;
	q.id = groupid;

	return msgDispatcher->send(&q);
}

void YVGroupUserManager::cloundMsgNotifyCallback(YaYaRespondBase*respond)
{
	CloundMsgLimitNotify* cmsg = static_cast<CloundMsgLimitNotify*>(respond);

	YVPlatform* platform = YVPlatform::getSingletonPtr();
	//if (cmsg->count)
	platform->sendConfirmMsg(cmsg->indexId, cmsg->sourceback);

	if (cmsg->ChatMsglist.size() == 0)
	{
		return;
	}
	//当为聊天消息时//
	if (cmsg->source == CLOUDMSG_GROUP)
	{
		int index = cmsg->indexId + cmsg->count - 1;
		for (std::vector<YaYaxNotify*>::reverse_iterator it = cmsg->ChatMsglist.rbegin();
			it != cmsg->ChatMsglist.rend(); ++it)
		{
			YaYaGroupChatNotify* p2pmsg = static_cast<YaYaGroupChatNotify*> (*it);

			YVMessagePtr msg = NULL;
			switch (p2pmsg->type)
			{
			case chat_msgtype_text:
				msg = new _YVGroupTextMessage(p2pmsg->data, p2pmsg->sendnickname, p2pmsg->sendheadIconurl, p2pmsg->groupname, p2pmsg->groupicon);
				break;
			case chat_msgtype_audio:
				msg = new _YVGroupVoiceMessage(p2pmsg->data, true, p2pmsg->audiotime, p2pmsg->attach, p2pmsg->sendnickname, p2pmsg->sendheadIconurl, p2pmsg->groupname, p2pmsg->groupicon);
				break;
			case chat_msgtype_image:
			//	msg = new _YVGroupImageMessage();
				break;
			default:
				break;
			}

			msg->sendTime = p2pmsg->time;
			msg->state = p2pmsg->unread == 0 ? YVMessageStatusUnread : YVMessageStatusCreated;
			msg->source = cmsg->source;

			msg->sendId = p2pmsg->sendid;
			msg->recvId = p2pmsg->groupid;
			msg->index = index;
			index--;
			msg->playState = PlatState;
			msg->ext = p2pmsg->ext1;
			insertMsg(p2pmsg->groupid, msg,false, false);

			//收完全了数据，上屏显示回调
			//上屏回调
			GroupMessageMap::iterator itCache = m_ghistoryCache.find(p2pmsg->groupid);
			if (itCache == m_ghistoryCache.end())
			{
				YVMessageListPtr msgList = new _YVMessageList();
				msgList->setChatWithID(p2pmsg->groupid);
				m_ghistoryCache.insert(std::make_pair(p2pmsg->groupid, msgList));
				itCache = m_ghistoryCache.find(p2pmsg->groupid);
			}
			itCache->second->insertMessage(msg, false);
			uint32 buffSize = itCache->second->getMessageList().size();
			if (buffSize == cmsg->count)
			{
				callGroupHistoryChatListern(itCache->second);
				itCache->second->clear();
			}
		}
	}
}

//time_t StringToDatetime(const std::string &str)
//{
//	struct tm tm_;
//	int year, month, day, hour, minute, second;
//	sscanf(str.c_str(), "%d-%d-%d %d:%d:%d", &year, &month, &day, &hour, &minute, &second);
//	tm_.tm_year = year - 1900;
//	tm_.tm_mon = month - 1;
//	tm_.tm_mday = day;
//	tm_.tm_hour = hour;
//	tm_.tm_min = minute;
//	tm_.tm_sec = second;
//	tm_.tm_isdst = 0;
//
//	time_t t_ = mktime(&tm_); //已经减了8个时区  
//	return t_; //秒时间  
//}
///////////////////
//
