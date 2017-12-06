﻿/*********************************************************************************
*Copyright(C), 2015 YUNVA Company
*FileName:  YVProtocol.h
*Author:  Matt
*Version:  1.0.3
*Date:  2015-5-7
*Description:  联系人管理（好友黑名单）
**********************************************************************************/

#include "YVContactManager.h"
#include "YVSDK.h"

using namespace YVSDK;

bool YVContactManager::init()
{
	YVMsgDispatcher*  msgDispatcher = YVPlatform::getSingletonPtr()->getMsgDispatcher();

	//好友列表
	msgDispatcher->registerMsg(IM_FRIEND_LIST_NOTIFY, this, &YVContactManager::friendsNotifyCallback);
	//黑名单列表
	msgDispatcher->registerMsg(IM_FRIEND_BLACKLIST_NOTIFY, this, &YVContactManager::blacksNotifyCallback);
	//最近联系人列表
	msgDispatcher->registerMsg(IM_FRIEND_NEARLIST_NOTIFY, this, &YVContactManager::nearsNotifyCallback);
	//添加好友成功回应
	msgDispatcher->registerMsg(IM_FRIEND_ADD_RESP, this, &YVContactManager::addFriendCallback);
	//删除好友回应
	msgDispatcher->registerMsg(IM_FRIEND_DEL_RESP, this, &YVContactManager::delFriendCallback);
	//黑名单操作
	msgDispatcher->registerMsg(IM_FRIEND_OPER_RESP, this, &YVContactManager::blackControlCallback);
	//好友添加结果
	msgDispatcher->registerMsg(IM_FRIEND_ACCEPT_RESP, this, &YVContactManager::addFriendRetCallback);
	//搜索好友结果
	msgDispatcher->registerMsg(IM_FRIEND_SEARCH_RESP, this, &YVContactManager::searchResponceCallback);
	//推荐好结果
	msgDispatcher->registerMsg(IM_FRIEND_RECOMMAND_RESP, this, &YVContactManager::recommendNotifyCallback);
	//查看用户信息
	msgDispatcher->registerMsg(IM_USER_GETINFO_RESP, this, &YVContactManager::getUserInfoCallBack);
	//被好友删除了
	msgDispatcher->registerMsg(IM_FRIEND_DEL_NOTIFY, this, &YVContactManager::delFriendNotify);
	//好友状态推送//或者查询玩家（不限于好友）是否在线
	msgDispatcher->registerMsg(IM_FRIEND_STATUS_NOTIFY, this, &YVContactManager::friendStatusNotify);
	//查询玩家是否在线回应
	msgDispatcher->registerMsg(IM_FRIEND_QUERY_ONLINE_RESP, this, &YVContactManager::searchUserOnlineCallBack);
	//请求加好友通知;
	msgDispatcher->registerMsg(IM_FRIEND_ADD_NOTIFY, this, &YVContactManager::begAddFriendNotify);
	//云消息确认回应
	msgDispatcher->registerMsg(IM_CLOUDMSG_READ_RESP, this, &YVContactManager::CloundMsgConfirmCallback);
	//云消息推送
	msgDispatcher->registerMsg(IM_CLOUDMSG_NOTIFY, this, &YVContactManager::CloundMsgNotifyCallback);

	//修改个人信息响应
	msgDispatcher->registerMsg(IM_SETUSERINFO_RESP, this, &YVContactManager::setUserInfoCallBack);

	// 好友个人信息修改通知 
	msgDispatcher->registerMsg(IM_USER_SETINFO_NOTIFY, this, &YVContactManager::userSetInfoNotify);

	//  
	msgDispatcher->registerMsg(IM_REMOVE_CONTACTES_RESP, this, &YVContactManager::DelRecentCallback);


	Notifymsglist = new _YVMessageList();
	return true;
}

bool YVContactManager::destory()
{
	YVMsgDispatcher*  msgDispatcher = YVPlatform::getSingletonPtr()->getMsgDispatcher();
	//好友列表
	msgDispatcher->unregisterMsg(IM_FRIEND_LIST_NOTIFY, this);
	//黑名单列表
	msgDispatcher->unregisterMsg(IM_FRIEND_BLACKLIST_NOTIFY, this);
	//最近联系人列表
	msgDispatcher->unregisterMsg(IM_FRIEND_NEARLIST_NOTIFY, this);
	//添加好友成功回应
	msgDispatcher->unregisterMsg(IM_FRIEND_ADD_RESP, this);
	//删除好友回应
	msgDispatcher->unregisterMsg(IM_FRIEND_DEL_RESP, this);
	//黑名单操作
	msgDispatcher->unregisterMsg(IM_FRIEND_OPER_RESP, this);
	//别人加好友后，你的同意或者拒绝
	msgDispatcher->unregisterMsg(IM_FRIEND_ACCEPT_RESP, this);
	//搜索好友结果
	msgDispatcher->unregisterMsg(IM_FRIEND_SEARCH_RESP, this);
	//推荐好结果
	msgDispatcher->unregisterMsg(IM_FRIEND_RECOMMAND_RESP, this);
	//查看用户信息
	msgDispatcher->unregisterMsg(IM_USER_GETINFO_RESP, this);
	//被好友删除了
	msgDispatcher->unregisterMsg(IM_FRIEND_DEL_NOTIFY, this);
	//好友状态推送
	msgDispatcher->unregisterMsg(IM_FRIEND_STATUS_NOTIFY, this);
	//请求好友通知
	msgDispatcher->unregisterMsg(IM_FRIEND_ADD_NOTIFY, this);
	//云消息确认回应
	msgDispatcher->unregisterMsg(IM_CLOUDMSG_READ_RESP, this);
	//云消息推送
	msgDispatcher->unregisterMsg(IM_CLOUDMSG_NOTIFY, this);
	//修改个人信息响应
	msgDispatcher->unregisterMsg(IM_SETUSERINFO_RESP, this);
	// 好友个人信息修改通知 
	msgDispatcher->unregisterMsg(IM_USER_SETINFO_NOTIFY, this);
	//查询玩家是否在线回应
	msgDispatcher->unregisterMsg(IM_FRIEND_QUERY_ONLINE_RESP, this);

	msgDispatcher->unregisterMsg(IM_FRIEND_QUERY_ONLINE_RESP, this);
	//内存清理
	delAllBlackInfo();
	delAllFriendInfo();
	Notifymsglist->clear();
	return true;
}

bool YVContactManager::addFriend(uint32 uid, const std::string & greet)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher* msgDispatcher = platform->getMsgDispatcher();

	if (platform->getLoginUserInfo()->userid == uid)
	{
		return false;
	}

	AddFriendRequest r;
	r.userid = uid;
	r.greet = greet;
	return msgDispatcher->send(&r);
}

bool YVContactManager::delFriend(uint32 uid, bool isRmoveSelf)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher* msgDispatcher = platform->getMsgDispatcher();

	DelFriendRequest r;
	r.del_friend = uid;
	r.act = isRmoveSelf ? df_remove_from_list : df_exit_in_list;
	return  msgDispatcher->send(&r);
}

bool YVContactManager::addBlack(uint32 uid)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher* msgDispatcher = platform->getMsgDispatcher();

	
	BlackControlRequest r;
	r.operId = uid;
	r.userId = platform->getLoginUserInfo()->userid;
	r.act = oper_add_blacklist;

	return 	msgDispatcher->send(&r);
}

bool YVContactManager::delBlack(uint32 uid)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher* msgDispatcher = platform->getMsgDispatcher();


	BlackControlRequest r;
	r.operId = uid;
	r.userId = platform->getLoginUserInfo()->userid;
	r.act = oper_del_blacklist;

	return 	msgDispatcher->send(&r);
}

bool YVContactManager::opposeFriend(uint32 uid)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher* msgDispatcher = platform->getMsgDispatcher();

	FriendAcceptRequest q;
	q.affirm = af_refuse;
	q.userid = uid;

	return 	msgDispatcher->send(&q);
}

bool YVContactManager::agreeFriend(uint32 uid)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher* msgDispatcher = platform->getMsgDispatcher();
	
	FriendAcceptRequest q;
	q.affirm = af_agree_add;
	q.userid = uid;
	
	return 	msgDispatcher->send(&q);
}

bool YVContactManager::getUserInfoSync(uint32 uid)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher* msgDispatcher = platform->getMsgDispatcher();

	GetUserInfoRequest q;
	q.userid = uid;

	return 	msgDispatcher->send(&q);
}

bool YVContactManager::searchFiend(const std::string & keyWord, int start, int count)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher* msgDispatcher = platform->getMsgDispatcher();

	SearchFriendRequest r;
	r.count = count;
	r.start = start;
	r.keyword.append(keyWord);

	return 	msgDispatcher->send(&r);
}

bool YVContactManager::recommendFriend(int start, int count)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher* msgDispatcher = platform->getMsgDispatcher();

	RecommendFriendRequest r;
	r.count = count;
	r.start = start;

	return 	msgDispatcher->send(&r);
}

void YVContactManager::friendsNotifyCallback(YaYaRespondBase* request)
{
	FriendListNotify* r = (FriendListNotify*)request;
	for (std::vector<YaYaUserInfo*>::iterator it = r->userInfos.begin();
		it != r->userInfos.end(); ++it)
	{
		YaYaUserInfo* _netUserInfo = (*it);   //从网络层接收到的用户信息
		
		YVUInfoPtr userInfo = new _YVUInfo();
		userInfo->userid = _netUserInfo->userid;
		userInfo->nickname.append(_netUserInfo->nickname);
		
		userInfo->header = YVPlatform::getSingletonPtr()->getYVPathByUrl(_netUserInfo->iconurl);
		userInfo->level = _netUserInfo->userlevel;
		userInfo->vip = _netUserInfo->viplevel;
		userInfo->sex = _netUserInfo->sex;
		userInfo->ext = _netUserInfo->ext;
		userInfo->thirdUid = _netUserInfo->thirduid;
		userInfo->online = _netUserInfo->online;
		
		addFriendInfo(userInfo);
	}
	callFriendListListern(r);
}

void YVContactManager::blacksNotifyCallback(YaYaRespondBase* request)
{
	//m_blackInfos.clear();
	BlackListNotify* r = (BlackListNotify*)request;

	for (std::vector<YaYaUserInfo*>::iterator it = r->userInfos.begin();
		it != r->userInfos.end(); ++it)
	{
		YaYaUserInfo* _netUserInfo = (*it);   //从网络层接收到的用户信息

		YVUInfoPtr userInfo = new _YVUInfo();
		userInfo->userid = _netUserInfo->userid;
		userInfo->nickname.append(_netUserInfo->nickname);
		userInfo->level = _netUserInfo->userlevel;
		userInfo->vip = _netUserInfo->viplevel;
		userInfo->sex = _netUserInfo->sex;
		userInfo->thirdUid = _netUserInfo->thirduid;
		userInfo->ext = _netUserInfo->ext;

		userInfo->header = YVPlatform::getSingletonPtr()->getYVPathByUrl(_netUserInfo->iconurl);
		/*userInfo->headerPath = YVFilePath::getUrlPath(_netUserInfo->iconurl);
		userInfo->online = _netUserInfo->online;
		userInfo->userlevel.append(_netUserInfo->userlevel);
		userInfo->viplevel.append(_netUserInfo->viplevel);
		userInfo->shieldmsg = _netUserInfo->shieldmsg;
		userInfo->sex = _netUserInfo->sex;
		userInfo->ext.append(_netUserInfo->ext);
		userInfo->group.append(_netUserInfo->group);
		userInfo->note.append(_netUserInfo->note);*/

		addBlackInfo(userInfo);
	}
	callBlackListListern(r);
}

void YVContactManager::nearsNotifyCallback(YaYaRespondBase* respond)
{
	RecentListNotify* RecentNotify = (RecentListNotify*)respond;
	YVPlatform* platform = YVPlatform::getSingletonPtr();

	for (std::vector<YaYaRecentInfo*>::iterator it = RecentNotify->RecentConactList.begin();
		it != RecentNotify->RecentConactList.end(); ++it)
	{
		YaYaRecentInfo* _RecentInfo = (*it);
		_RecentInfo->unread;

 		YaYaP2PChatNotify* p2pmsg = static_cast<YaYaP2PChatNotify*> (_RecentInfo->Notifymsg);

		YVMessagePtr msg = NULL;

		switch (p2pmsg->type)
		{
		case chat_msgtype_text:
			msg = new _YVTextMessage(p2pmsg->data);
			break;
		case chat_msgtype_audio:
			msg = new _YVVoiceMessage(p2pmsg->data, true, p2pmsg->audiotime, p2pmsg->attach);
			break;
		case chat_msgtype_image:
			msg = new _YVImageMessage();
			break;
		default:
			break;
		}

		msg->sendTime = p2pmsg->sendtime;
		msg->state = p2pmsg->unread == 0 ? YVMessageStatusUnread : YVMessageStatusCreated;
		msg->ext = p2pmsg->ext1;
		//msg->source = Notifymsg->source;
		if (platform->getLoginUserInfo()->userid == p2pmsg->userid)
		{
			msg->sendId = _RecentInfo->userinfo->userid;
			msg->recvId = p2pmsg->userid;
		}
		else
		{
			msg->sendId = _RecentInfo->userinfo->userid;
			msg->recvId = platform->getLoginUserInfo()->userid;
		}
		msg->index = _RecentInfo->unread;     //未读条数
		msg->endId = _RecentInfo->endId;     
		msg->id = _RecentInfo->userinfo->userid;
	
		Notifymsglist->insertMessage(msg, true);

		//callFriendChatListern(msg);
		//onFriendChatListern(msg);

		//insertMessage(Notifymsg->id, msg, false);

		YVSDK::YVUInfoPtr uinfo = YVPlatform::getSingletonPtr()->getUInfoById(_RecentInfo->userinfo->userid);
		if (uinfo == NULL)
		{
			uinfo = new _YVUInfo();
			uinfo->header = platform->getYVPathByUrl(_RecentInfo->userinfo->iconurl);
			uinfo->nickname.append(_RecentInfo->userinfo->nickname);
			uinfo->userid = _RecentInfo->userinfo->userid;
			uinfo->level = _RecentInfo->userinfo->userlevel;
			uinfo->vip = _RecentInfo->userinfo->viplevel;
			uinfo->sex = _RecentInfo->userinfo->sex;
			uinfo->thirdUid = _RecentInfo->userinfo->thirduid;
			uinfo->ext = _RecentInfo->userinfo->ext;
			platform->updateUInfo(uinfo);
			//platform->getUserInfoSync(uinfo->userid);
		}

	}
	callNearsNotifyListern(RecentNotify);
}

void YVContactManager::addFriendRetCallback(YaYaRespondBase* respond)
{
	FriendAcceptRespond* r = (FriendAcceptRespond*)respond;
	YVAddFriendRetPtr ret = new _YVAddFriendRet;
	ret->way = ApplyAddFriend;  //主动请求加的好友

	if (r->affirm == af_agree || r->affirm == af_agree_add)
	{
		//判断是否是黑名单成员//
		YVUInfoPtr userInfo = getBlackInfo(r->userid);
		if (userInfo != NULL)
		{
			addFriendInfo(userInfo);
			delBlackInfo(r->userid);
		}
		else
		{
			//没有好友数据，网络请求之;
			userInfo = new _YVUInfo();
			userInfo->userid = r->userid;
			addFriendInfo(userInfo);
			getUserInfoSync(r->userid);
		}
		ret->ret = (r->affirm == af_agree_add ? BothAddFriend : OnlyAddFriend);
		ret->uinfo = userInfo;
	}
	else
	{
		YVUInfoPtr userInfo = new _YVUInfo();
		userInfo->userid = r->userid;
	//	getUserInfoSync(r->userid);
		ret->ret = RefuseAddFriend;
		ret->uinfo = userInfo;
	}
	callAddFriendRetListern(ret);
}

bool YVContactManager::DelRecent(uint32 uid)
{  
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher* msgDispatcher = platform->getMsgDispatcher();

	DelRecentRequest r;
	r.userid = uid;
	return  msgDispatcher->send(&r);
}

bool YVContactManager::setUserInfoRequest(const std::string& nickname, const std::string& iconUrl, const std::string& level, const std::string& vip, uint8 sex, const std::string& ext)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher* msgDispatcher = platform->getMsgDispatcher();
	SetUserInfoRequest r;
	r.nickname = nickname;
	r.iconUrl = iconUrl;
	r.level = level;
	r.vip = vip;
	r.sex = sex;
	r.ext = ext;
	return  msgDispatcher->send(&r);
}
void YVContactManager::setUserInfoCallBack(YaYaRespondBase*respond)
{
	SetUserInfoRespond* q = static_cast<SetUserInfoRespond*>(respond);
	if (q && q->result != 0)
	{

	}

	printf("setUserInfoCallBack ------------------q = %d",q->result);
	callsetUserInfoCallListern(q);

}

//查询玩家是否在线 uid:云娃id
bool YVContactManager::searchUserOnlineRequest(uint32 uid)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher* msgDispatcher = platform->getMsgDispatcher();
	UserOnlineRequest r;
	r.userid = uid;
	return  msgDispatcher->send(&r);
}

// 查询玩家是否在线回应 IM_FRIEND_QUERY_ONLINE_RESP  UserOnlineRespond
void YVContactManager::searchUserOnlineCallBack(YaYaRespondBase* respond)
{
	UserOnlineRespond* q = static_cast<UserOnlineRespond*>(respond);
	if (q && q->result != 0)
	{

	}

	printf("UserOnlineRespond ------------------q = %d", q->result);
}

void YVContactManager::updateFriendinfo(YVUInfoPtr info)
{

	YVUInfoMap::iterator it = m_friendInfos.find(info->userid);
	if (it == m_friendInfos.end())
	{
		m_friendInfos.insert(std::make_pair(info->userid, info));
	}
	else
	{
		info->online = it->second->online;
		it->second = info;
	}
}

// 好友个人信息修改通知 IM_USER_SETINFO_NOTIFY  UserSetInfoNotify
void YVContactManager::userSetInfoNotify(YaYaRespondBase*respond)
{
	UserSetInfoNotify* q = static_cast<UserSetInfoNotify*>(respond);
	_YVUInfo* info = new _YVUInfo();
	info->userid = q->userid;
	info->nickname = q->nickname;
	info->thirdNickName = q->nickname;
	info->level = q->userlevel;
	info->vip = q->viplevel;
	info->sex = q->sex;
	info->ext = q->ext;
//	YVPlatform::getSingletonPtr()->updateUInfo(info);
	updateFriendinfo(info);
	callUserSetInfonotifyListern(q);
}


//删除最近联系人回应
void YVContactManager::DelRecentCallback(YaYaRespondBase* respond)    
{
	DelRecentRepond* r = (DelRecentRepond*)respond;
}

void YVContactManager::addFriendCallback(YaYaRespondBase* respond)
{
	AddFriendRepond* r = (AddFriendRepond*)respond;

	YVPlatform::getSingletonPtr()->sendConfirmMsg(r->indexId,r->source);   //发送确认消息

	YVAddFriendRetPtr ret = new _YVAddFriendRet;
	ret->way = BegAddFriend;
	YVUInfoPtr userInfo = getBlackInfo(r->userid);
	if (userInfo == NULL)
	{
		userInfo = new _YVUInfo();
		userInfo->userid = r->userid;
		userInfo->nickname = r->name;
		userInfo->thirdUid = r->thirduid;
		if (r->url.length() > 0)
		{
			userInfo->header = YVPlatform::getSingletonPtr()->getYVPathByUrl(r->url);
		}
		//getUserInfoSync(r->userid);   //获取是呢称名不对
		YVPlatform::getSingletonPtr()->updateUInfo(userInfo);
	}

	//拒绝加好友
	if (r->affirm == af_refuse)
	{
		ret->ret = RefuseAddFriend;
	}
	else
	{
		ret->ret = (r->affirm == af_agree_add) ? BothAddFriend : OnlyAddFriend;
		addFriendInfo(userInfo);
		callAddFriendListern(userInfo);
		delBlackInfo(r->userid);
	}
	ret->uinfo = userInfo;
	callAddFriendRetListern(ret);
}

void YVContactManager::delFriendCallback(YaYaRespondBase* request)
{
	DelFriendRespond* r = (DelFriendRespond*)request;
	delFriendInfo(r->del_friend);
}

void YVContactManager::blackControlCallback(YaYaRespondBase* request)
{
	BlackControlRespond* r = (BlackControlRespond*)request;

	if (r->act == oper_add_blacklist)
	{
		//查找好友列表中的数据
		YVUInfoPtr userinfo = getFriendInfo(r->operId);
		if (userinfo != NULL)
		{
			addBlackInfo(userinfo);
			delFriendInfo(r->operId);
		}
		else
		{
			//好友列表里没有黑名单信息
			userinfo = new _YVUInfo();;
			userinfo->userid = r->operId;
			//userinfo->online = r->oper_state;
			addBlackInfo(userinfo);
			//获取黑名单信息
			getUserInfoSync(r->operId);
		}
	}
	else if (r->act == oper_del_blacklist)
	{
		delBlackInfo(r->operId);
		//查找好友列表中的数据
		YVUInfoPtr userinfo = getFriendInfo(r->operId);
		if (userinfo != NULL)
		{
			addFriendInfo(userinfo);
		}
		/*else
		{
			userinfo = new _YVUInfo();;
			userinfo->userid = r->operId;
			addFriendInfo(userinfo);
		}*/

	}
}

YVMessageListPtr YVContactManager::getNotifymsg()
{
	return Notifymsglist;
}
void YVContactManager::CloundMsgNotifyCallback(YaYaRespondBase* respond)
{
	CloundMsgNotify* Notifymsg = static_cast<CloundMsgNotify*>(respond);

//	return;
 	YVPlatform* platform = YVPlatform::getSingletonPtr();
	//platform->sendConfirmMsg(Notifymsg->id, Notifymsg->source);

	if (Notifymsg->unread == 0)
	{
		return;
	}
	//当为聊天消息时//
	if (Notifymsg->source == CLOUDMSG_FRIEND)
	{
		YaYaP2PChatNotify* p2pmsg = static_cast<YaYaP2PChatNotify*> (Notifymsg->packet);

		YVMessagePtr msg = NULL;

		switch (p2pmsg->type)
		{
		case chat_msgtype_text:
			msg = new _YVTextMessage(p2pmsg->data);
			break;
		case chat_msgtype_audio:
			msg = new _YVVoiceMessage(p2pmsg->data, true, p2pmsg->audiotime, p2pmsg->attach);
			break;
		case chat_msgtype_image:
			msg = new _YVImageMessage();
			break;
		default:
			break;
		}
		
		msg->sendTime = p2pmsg->sendtime;
		msg->state = p2pmsg->unread == 0 ? YVMessageStatusUnread : YVMessageStatusCreated;
		msg->source = Notifymsg->source;
		if (platform->getLoginUserInfo()->userid == p2pmsg->userid)
		{
			msg->sendId = p2pmsg->userid;
			msg->recvId = Notifymsg->id;
		}
		else
		{
			msg->sendId = Notifymsg->id;
			msg->recvId = platform->getLoginUserInfo()->userid;
		}
		msg->index = Notifymsg->unread;     //未读条数
		msg->id = Notifymsg->id;
		msg->endId = Notifymsg->endid;
		msg->ext = p2pmsg->ext1;
		Notifymsglist->insertMessage(msg, true);

		//callFriendChatListern(msg);
		//onFriendChatListern(msg);

		//insertMessage(Notifymsg->id, msg, false);

		YVSDK::YVUInfoPtr uinfo = YVPlatform::getSingletonPtr()->getUInfoById(Notifymsg->id);
		if (uinfo == NULL)
		{
			uinfo = new _YVUInfo();
			uinfo->header = platform->getYVPathByUrl(p2pmsg->headicon);
			uinfo->nickname.append(p2pmsg->name);
			uinfo->userid = Notifymsg->id;
			uinfo->thirdUid = p2pmsg->thirduid;
			platform->updateUInfo(uinfo);
			//getUserInfoSync(Notifymsg->id);
		}
	} 
	if (Notifymsg->source == CLOUDMSG_SYSTEM)
	{

	}
	//群
	if (Notifymsg->source == CLOUDMSG_GROUP)
	{
		callGCloundMsgListern(Notifymsg);
		return;
	}
	//Notifylist 消息列表保存
	callCloundMsgListern(Notifymsg);

}

void YVContactManager::insertMessage(uint32 chatWithId, YVMessagePtr messageBase, bool isCallFriendChatListern)
{

}

void YVContactManager::CloundMsgConfirmCallback(YaYaRespondBase* respond)
{
	CloundMsgReadStatusbackRequest* r = static_cast<CloundMsgReadStatusbackRequest*>(respond);
	callCloundMsgConfirmListern(r);
}

void YVContactManager::searchResponceCallback(YaYaRespondBase* respond)
{
	SearchFriendRespond* r = static_cast<SearchFriendRespond*>(respond);
	callSearchFriendRetListern(r);
}

void YVContactManager::recommendNotifyCallback(YaYaRespondBase* respond)
{
	RecommendFriendRespond* r = static_cast<RecommendFriendRespond*>(respond);
	callRecommendFriendRetListern(r);
}

void YVContactManager::begAddFriendNotify(YaYaRespondBase* respond)
{
	AddFriendNotify* r = static_cast<AddFriendNotify*>(respond);

	YVPlatform::getSingletonPtr()->sendConfirmMsg(r->indexId, r->source);   //发送确认消息

	YVUInfoPtr uinfo = new _YVUInfo;
	if (r->url.length() > 0)
	{
		uinfo->header = YVPlatform::getSingletonPtr()->getYVPathByUrl(r->url);
	}
	uinfo->nickname.append(r->name);
	uinfo->userid = r->userid;
	uinfo->thirdUid = r->thirduid; 
	YVBegFriendNotifyPtr notify = new _YVBegFriendNotify;
	notify->greet.append(r->greet);
	notify->uinfo = uinfo;

	//Notifymsglist->insertMessage(uinfo);

	callBegAddFriendListern(notify);
}

bool YVContactManager::addFriendInfo(YVUInfoPtr info)
{
	YVUInfoMap::iterator it = m_friendInfos.find(info->userid);
	if (it != m_friendInfos.end())
	{
		return false;
	}
	YVPlatform::getSingletonPtr()->updateUInfo(info);
	m_friendInfos.insert(std::make_pair(info->userid, info));
	return true;
}

bool YVContactManager::delFriendInfo(uint32 uid)
{
	YVUInfoMap::iterator it = m_friendInfos.find(uid);
	if (it == m_friendInfos.end())
	{
		return false;
	}
	YVUInfoPtr info =  it->second;
	m_friendInfos.erase(it);
	callDelFriendListern(info);
	return true;
}

bool YVContactManager::addBlackInfo(YVUInfoPtr info)
{
	if (info == NULL) return false;
	YVPlatform::getSingletonPtr()->updateUInfo(info);
	YVUInfoMap::iterator it = m_blackInfos.find(info->userid);
	if (it != m_blackInfos.end())
	{
		return false;
	}
	m_blackInfos.insert(std::make_pair(info->userid, info));	
	callAddBlackListern(info);
	return true;
}

bool YVContactManager::delBlackInfo(uint32 uid)
{
	YVUInfoMap::iterator it = m_blackInfos.find(uid);
	if (it == m_blackInfos.end())
	{
		return false;
	}
	YVUInfoPtr info = it->second;
	m_blackInfos.erase(it);
	callDelBlackListern(info);
	return true;
}

YVUInfoPtr YVContactManager::getFriendInfo(uint32 uid)
{
	YVUInfoMap::iterator it = m_friendInfos.find(uid);
	if (it == m_friendInfos.end())
	{
		return NULL;
	}
	return it->second;
}

YVUInfoPtr YVContactManager::getBlackInfo(uint32 uid)
{
	YVUInfoMap::iterator it = m_blackInfos.find(uid);
	if (it == m_blackInfos.end())
	{
		return NULL;
	}
	return it->second;
}

//获取好友资料返回
void YVContactManager::getUserInfoCallBack(YaYaRespondBase* respond)
{
	GetUserInfoFriendRespond* r = static_cast<GetUserInfoFriendRespond*>(respond);
	
	//更新黑名单数据
	if (r ==NULL) return;
	YVUInfoPtr blackInfo = getBlackInfo(r->userid);
	if (blackInfo != NULL)
	{
		
		blackInfo->nickname = r->nickname;
		blackInfo->header = YVPlatform::getSingletonPtr()->getYVPathByUrl(r->headicon);
		blackInfo->level = r->userlevel;
		blackInfo->vip = r->viplevel;
		blackInfo->sex = r->sex;
		blackInfo->ext = r->ext;
		blackInfo->thirdUid = r->thirdid;
		//更新数据
		callUpdateUserInfoListern(blackInfo);
		return;
	}

	//更新好友数据
	YVUInfoPtr friendInfo = getFriendInfo(r->userid);
	if (friendInfo != NULL)
	{
		
		friendInfo->nickname = r->nickname;
		friendInfo->header = YVPlatform::getSingletonPtr()->getYVPathByUrl(r->headicon);
		friendInfo->sex = r->sex;
		friendInfo->level = r->userlevel;
		friendInfo->vip = r->viplevel;
		friendInfo->ext = r->ext;
		friendInfo->thirdUid = r->thirdid;
		callUpdateUserInfoListern(friendInfo);
		return;
	}

	//非好友非黑名单成员
	YVUInfoPtr userinfo = new _YVUInfo();
	userinfo->userid = r->userid;	
	userinfo->nickname = r->nickname;     //昵称
	userinfo->header = YVPlatform::getSingletonPtr()->getYVPathByUrl(r->headicon);   //图像地址
	userinfo->sex = r->sex;     //性别
	userinfo->level = r->userlevel;     //用户等级
	userinfo->vip = r->viplevel;     //用户VIP等级
	userinfo->ext = r->ext;     //扩展字段
	userinfo->thirdUid = r->thirdid;

	callUpdateUserInfoListern(userinfo);
	YVPlatform::getSingletonPtr()->updateUInfo(userinfo);
}

void YVContactManager::delFriendNotify(YaYaRespondBase* respond)
{
	DelFriendNotify* r = static_cast<DelFriendNotify*>(respond);
	if (r->del_fromlist == df_remove_from_list)
	{
		delFriendInfo(r->del_friend);
	}
}

void YVContactManager::friendStatusNotify(YaYaRespondBase* respond)
{
 	FriendStatusNotify* r = static_cast<FriendStatusNotify*>(respond);
	YVPlatform* yv = YVPlatform::getSingletonPtr();
	//更新好友数据
	YVUInfoPtr friendInfo = getFriendInfo(r->userid);
	if (friendInfo != NULL)
	{
		friendInfo->online = r->status;
	}
	else
	{
		friendInfo = new _YVUInfo();
		friendInfo->userid = r->userid;
		friendInfo->online = r->status;
		yv->getUserInfoSync(r->userid);
	}


	yv->updateUInfo(friendInfo);
	callUpdateUserInfoListern(friendInfo);

}

YVUInfoMap& YVContactManager::getAllFriendInfo()
{
	return m_friendInfos;
}

YVUInfoMap& YVContactManager::getAllBlackInfo()
{
	return m_blackInfos;
}

void YVContactManager::delAllBlackInfo()
{
	m_blackInfos.clear();
}

void YVContactManager::delAllFriendInfo()
{
	m_friendInfos.clear();
}
