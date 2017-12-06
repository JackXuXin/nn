﻿#ifndef __FRIENDMANAGER_H_
#define __FRIENDMANAGER_H_

#include <string>
#include <vector>
#include "YVType/YVType.h"
#include "YVListern/YVListern.h"

namespace YVSDK
{
	struct YaYaRespondBase;
	class YVContactManager
	{
	public:
		bool init();
		bool destory();
		//请求加好友//
		bool addFriend(uint32 uid, const std::string & greet = "");
		//删除好友isRmoveSelf是否要求对方也删除你//
		bool delFriend(uint32 uid, bool isRmoveSelf = true);
		//拉黑好友//
		bool addBlack(uint32 uid);
		//移出黑名表//
		bool delBlack(uint32 uid);
		//同意加好友//
		bool agreeFriend(uint32 uid);
		//拒绝加好友//
		bool opposeFriend(uint32 uid);
		//查找好友//
		bool searchFiend(const std::string & keyWord, int start, int count);
		//获取推荐好友//
		bool recommendFriend(int start, int count);
		//从网络上拉取获取用户的信息//
		bool getUserInfoSync(uint32 uid);
		//删除最近联系人//
		bool DelRecent(uint32 uid);

		//修改个人信息 		
		//注意性别sex 参数 “0”:无定义， "1"：女， "2":男
		bool setUserInfoRequest(const std::string & nickname, const std::string & iconUrl = "", const std::string & level = "", const std::string & vip="", uint8 sex = 0, const std::string & ext = "");
		
		//查询玩家是否在线 uid:云娃id
		bool searchUserOnlineRequest(uint32 uid);

		YVUInfoPtr getFriendInfo(uint32 uid);
		YVUInfoPtr getBlackInfo(uint32 uid);

		YVUInfoMap& getAllFriendInfo();
		YVUInfoMap& getAllBlackInfo();
	public:
		void friendsNotifyCallback(YaYaRespondBase*);
		void blacksNotifyCallback(YaYaRespondBase*);
		void nearsNotifyCallback(YaYaRespondBase*);
		void addFriendCallback(YaYaRespondBase*);
		void delFriendCallback(YaYaRespondBase*);
		void blackControlCallback(YaYaRespondBase*);
		//主动同意加好友//
		void addFriendRetCallback(YaYaRespondBase*);
		void searchResponceCallback(YaYaRespondBase*);
		void recommendNotifyCallback(YaYaRespondBase*);
		//获取好友资料返回//
		void getUserInfoCallBack(YaYaRespondBase*);
		//好友删除你//
		void delFriendNotify(YaYaRespondBase*);
		//好友状态 或者查询玩家是否在线通知
		void friendStatusNotify(YaYaRespondBase*);
		//请求加好友//
		void begAddFriendNotify(YaYaRespondBase*);
		//云消息确认回应
		void CloundMsgConfirmCallback(YaYaRespondBase*);
		//云消息推送
		void CloundMsgNotifyCallback(YaYaRespondBase*);
		//删除最近联系人回应
		void DelRecentCallback(YaYaRespondBase*);

		//修改个人信息响应 IM_SETUSERINFO_RESP  SetUserInfoRespond
		void setUserInfoCallBack(YaYaRespondBase*);

		// 好友个人信息修改通知 IM_USER_SETINFO_NOTIFY  UserSetInfoNotify
		void userSetInfoNotify(YaYaRespondBase*);

		// 查询玩家是否在线回应 IM_FRIEND_QUERY_ONLINE_RESP  UserOnlineRespond
		void searchUserOnlineCallBack(YaYaRespondBase*);



		YVMessageListPtr getNotifymsg();
		void updateFriendinfo(YVUInfoPtr info);
	public:
		InitListern(AddFriend, YVUInfoPtr);
		InitListern(DelFriend, YVUInfoPtr);
		InitListern(DelBlack, YVUInfoPtr);
		InitListern(AddBlack, YVUInfoPtr);
		InitListern(UpdateUserInfo, YVUInfoPtr);
		InitListern(RecommendFriendRet, RecommendFriendRespond*);
		InitListern(SearchFriendRet, SearchFriendRespond*);
		
		InitListern(BegAddFriend, YVBegFriendNotifyPtr);
		InitListern(AddFriendRet, YVAddFriendRetPtr);

		InitListern(FriendList, FriendListNotify*);
		InitListern(BlackList, BlackListNotify*);

		InitListern(CloundMsgConfirm, CloundMsgReadStatusbackRequest*);
        InitListern(CloundMsg, CloundMsgNotify*);
		InitListern(GCloundMsg, CloundMsgNotify*);
		InitListern(setUserInfoCall, SetUserInfoRespond*);

		InitListern(UserSetInfonotify, UserSetInfoNotify*);

		InitListern(NearsNotify, RecentListNotify*);

		//InitListern(FriendChat, YVMessagePtr);

	private:
		bool addFriendInfo(YVUInfoPtr info);
		bool delFriendInfo(uint32 uid);
		bool addBlackInfo(YVUInfoPtr info);
		bool delBlackInfo(uint32 uid);

		void delAllBlackInfo();
		void delAllFriendInfo();

		YVUInfoMap m_friendInfos;
		YVUInfoMap m_blackInfos;
		YVUInfoMap m_nearInfos;

		void insertMessage(uint32 chatWithId, YVMessagePtr messageBase, bool isCallFriendChatListern = true);
		//云消息
		YVMessageListPtr Notifymsglist;
	};
}
#endif