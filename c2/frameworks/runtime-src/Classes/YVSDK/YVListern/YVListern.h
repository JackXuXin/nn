#ifndef _YVSDK_YVLISTERN_H_
#define _YVSDK_YVLISTERN_H_
#include <iostream>
#include <algorithm>
#include <list>
#include "YVType/YVType.h"
#include "YVProtocol/YVProtocol.h"

namespace YVSDK
{
	//========================================================================================
#define InitListern(Name, ArgcType)  \
public:  \
	typedef YVListern::YV##Name##Listern Name##Lister;  \
	void add##Name##Listern(Name##Lister* lister)  \
	{ \
	del##Name##Listern(lister);   \
	m_##Name##listerList.push_back(lister); \
} \
	void del##Name##Listern(Name##Lister* lister)  \
	{  \
	std::list<Name##Lister* >::iterator iter = m_##Name##listerList.begin(); \
	for (;iter != m_##Name##listerList.end(); ++iter) {if ((*iter) == lister)break;} \
	if (iter != m_##Name##listerList.end()) \
	{ \
	m_##Name##listerList.erase(iter); \
} \
} \
	void call##Name##Listern(ArgcType t) \
	{ \
	std::list<Name##Lister* >::iterator _listenerItr = m_##Name##listerList.begin(); \
	while (_listenerItr != m_##Name##listerList.end())  \
	{  \
	Name##Lister* lister = *_listenerItr; \
	++_listenerItr; \
	lister->on##Name##Listern(t); \
}  \
} \
private: \
	std::list<Name##Lister* > m_##Name##listerList;

	//========================================================================================

	class YVListern
	{
	public:

		//CP登录事件 
		class YVCPLoginListern
		{
		public:
			virtual void onCPLoginListern(CPLoginResponce*) = 0;
		};

		//呀呀帐号登录事件
		class YVYYLoginListern
		{
		public:
			virtual void onYYLoginListern(LoginResponse*) = 0;
		};

		//好友列表事件 
		class YVFriendListListern
		{
		public:
			virtual void onFriendListListern(FriendListNotify*) = 0;
		};
		
		//黑名单列表事件
		class YVBlackListListern
		{
		public:
			virtual void onBlackListListern(BlackListNotify*) = 0;
		};
	    
		//添加好友
		class YVAddFriendListern
		{
		public:
			virtual void onAddFriendListern(YVUInfoPtr) = 0;
		};

		//移除好友
		class YVDelFriendListern
		{
		public:
			virtual void onDelFriendListern(YVUInfoPtr) = 0;
		};

		//请求加对方为好友
		class YVBegAddFriendListern
		{
		public:
			virtual void onBegAddFriendListern(YVBegFriendNotifyPtr) = 0;
		};

		//最近联系人
		class YVNearsNotifyListern
		{
		public:
			virtual void onNearsNotifyListern(RecentListNotify*) = 0;
		};
		//添加好友的结果(一种是主动请求，一种是被请求)
		class YVAddFriendRetListern
		{
		public:
			virtual void onAddFriendRetListern(YVAddFriendRetPtr) = 0;
		};

		//添加黑色单
		class YVAddBlackListern
		{
		public:
			virtual void onAddBlackListern(YVUInfoPtr) = 0;
		};

		//移除黑名单
		class YVDelBlackListern
		{
		public:
			virtual void onDelBlackListern(YVUInfoPtr) = 0;
		};

		//刷新用户信息(可能是好友信息，也有可能是黑名单信息)
		class YVUpdateUserInfoListern
		{
		public:
			virtual void onUpdateUserInfoListern(YVUInfoPtr) = 0;
		};

		//好友的搜索结果
		class YVSearchFriendRetListern
		{
		public:
			virtual void onSearchFriendRetListern(SearchFriendRespond*) = 0;
		};

		//好友的推荐结果
		class YVRecommendFriendRetListern
		{
		public:
			virtual void onRecommendFriendRetListern(RecommendFriendRespond*) = 0;
		};

		//重连事件 
		class YVReConnectListern
		{
		public:
			virtual void onReConnectListern(ReconnectionNotify*) = 0;
		};

		//结束录音事件
		class YVStopRecordListern
		{
		public:
			virtual void onStopRecordListern(RecordStopNotify*) = 0;
		};

		//完成识别事件
		class YVFinishSpeechListern
		{
		public:
			virtual void onFinishSpeechListern(SpeechStopRespond*) = 0;
		};

		//结束播放事件 
		class YVFinishPlayListern
		{
		public:
			virtual void onFinishPlayListern(StartPlayVoiceRespond*) = 0;
		};

		//上传事件 
		class YVUpLoadFileListern
		{
		public:
			virtual void onUpLoadFileListern(UpLoadFileRespond*) = 0;
		};

		//下载事件 
		class YVDownLoadFileListern
		{
		public:
			virtual void onDownLoadFileListern(YVFilePathPtr) = 0;
		};

		//网络状态事件 
		class YVNetWorkSateListern
		{
		public:
			virtual void onNetWorkSateListern(NetWorkStateNotify*) = 0;
		};

		////录音音量事件
		class YVRecordVoiceListern
		{
		public:
			virtual void onRecordVoiceListern(RecordVoiceNotify*) = 0;
		};

		///频道历史消息事件
		class YVChannelHistoryChatListern
		{
		public:
			virtual void onChannelHistoryChatListern(YVMessageListPtr) = 0;
		};
		
		//收到频道消息事件 
		class YVChannelChatListern
		{
		public:
			virtual void onChannelChatListern(YVMessagePtr) = 0;
		};

		//发送消息频道状态事件 
		class YVChannelChatStateListern
		{
		public:
			virtual void onChannelChatStateListern(YVMessagePtr) = 0;
		};

		//收到频道push消息事件 
		class YVChannelPushChatListern
		{
		public:
			virtual void onChannelPushChatListern(ChannelPushMessageNotify*) = 0;
		};

		//好友历史消息
		class YVFriendHistoryChatListern
		{
		public:
			virtual void onFriendHistoryChatListern(YVMessageListPtr) = 0;
		};

		//云消息确认返回
		class YVCloundMsgConfirmListern
		{
		public:
			virtual void onCloundMsgConfirmListern(CloundMsgReadStatusbackRequest*) = 0;
		};

		//好友实时消息
		class YVFriendChatListern
		{
		public:
			virtual void onFriendChatListern(YVMessagePtr) = 0;
		};

		//发送好友消息状态事件 
		class YVFriendChatStateListern
		{
		public:
			virtual void onFriendChatStateListern(YVMessagePtr) = 0;
		};


		//修改个人信息响应  IM_USER_SETINFO_RESP  SetUserInfoRespond
		class YVsetUserInfoCallListern
		{
		public:
			virtual void onsetUserInfoCallListern(SetUserInfoRespond*) = 0;
		};

		//好友个人信息修改通知 IM_USER_SETINFO_NOTIFY  UserSetInfoNotify
		class YVUserSetInfonotifyListern
		{
		public:
			virtual void onUserSetInfonotifyListern(UserSetInfoNotify*) = 0;
		};

		
		//收到云消息推送
		class YVCloundMsgListern
		{
		public:
			virtual void onCloundMsgListern(CloundMsgNotify*) = 0;
		};

		//收到群云消息推送
		class YVGCloundMsgListern
		{
		public:
			virtual void onGCloundMsgListern(CloundMsgNotify*) = 0;
		};

		//频道修改返回
		class YVModChannelIdListern
		{
		public:
			virtual void onModChannelIdListern(ModChannelIdRespond*) = 0;
		};
		//频道登录返回 
		class YVChannalloginListern
		{
		public:
			virtual void onChannalloginListern(ChanngelLonginRespond*) = 0;
		};
		//获取第三方信息
		class YVGetCpuUserListern
		{
		public:
			virtual void onGetCpuUserListern(GetCpmsgRepond*) = 0;
		};

		//获取地理位置
		class YVGetlocationListern
		{
		public:
			virtual void onGetlocationListern(GetlocationRespond*) = 0;
		};

		//获取更新地理位置
		class YVUpdatelocationListern
		{
		public:
			virtual void onUpdatelocationListern(UpdatelocationRespond*) = 0;
		};


		//设置LBS本地化语言
		class YVLbsSetLocalLangListern
		{
		public:
			virtual void onLbsSetLocalLangListern(LbsSetLocalLangRespond*) = 0;
		};


		//搜索（附近）用户(包括更新位置)
		class YVSearchAroundListern
		{
		public:
			virtual void onSearchAroundListern(SearchAroundRespond*) = 0;
		};


		//设置隐藏地理位置
		class YVLbsShareListern
		{
		public:
			virtual void onLbsShareListern(LbsShareRespond*) = 0;
		};

		//获取支持的（包括搜索、返回信息等）本地化语言列表//
		class YVLbsGetSupportlangListern
		{
		public:
			virtual void onLbsGetSupportlangListern(LbsGetSupportlangRespond*) = 0;
		};

		//设置定位方式//
		class YVLbsSetLocatingListern
		{
		public:
			virtual void onLbsSetLocatingListern(LbsSetLocatingRespond*) = 0;
		};



		//**********群**begin*************

		////创建群回应
		class YVGroupCreateListern
		{
		public:
			virtual void onGroupCreateListern(GroupCreateRespond*) = 0;
		};

		////搜索群回应
		class YVSearchGroupListern
		{
		public:
			virtual void onSearchGroupListern(GroupSearchRespond*) = 0;
		};
	
		////加入群回应
		class YVJoinGroupListern
		{
		public:
			virtual void onJoinGroupListern(GroupJoinRespond*) = 0;
		};
		
		////申请加群结果通知
		class YVGroupJoinCallBackListern
		{
		public:
			virtual void onGroupJoinCallBackListern(GroupJoinCallRespond*) = 0;
		};
		

		////加入群通知(群主/管理员接收)
		class YVGroupJoinnotifyListern
		{
		public:
			virtual void onGroupJoinnotifyListern(GroupJoinNotify*) = 0;
		};


		//同意/拒绝加群回应
		class YVGroupJoinAcceptListern
		{
		public:
			virtual void onGroupJoinAcceptListern(GroupJoinAcceptRespond*) = 0;
		};

		//退群通知
		class YVGroupExitListern
		{
		public:
			virtual void onGroupExitListern(GroupExitRespond*) = 0;
		};

		//退群响应
		class YVGroupExitbackListern
		{
		public:
			virtual void onGroupExitbackListern(GroupExitBack*) = 0;
		};

		//修改群属性响应
		class YVGroupModifyListern
		{
		public:
			virtual void onGroupModifyListern(GroupModifyRespond*) = 0;
		};


		//转移群主通知
		class YVGroupShiftOwnernotifyListern
		{
		public:
			virtual void onGroupShiftOwnernotifyListern(GroupShiftOwnerNotify*) = 0;
		};


		//转移群主响应
		class YVGroupShiftOwnerrespondListern
		{
		public:
			virtual void onGroupShiftOwnerrespondListern(GroupShiftOwnerRespond*) = 0;
		};
		
		//踢除群成员通知
		class YVGroupKicknotifyListern
		{
		public:
			virtual void onGroupKicknotifyListern(GroupKickNotify*) = 0;
		};
		
		//踢除群成员回调
		class YVGroupKickListern
		{
		public:
			virtual void onGroupKickListern(GroupKickRespond*) = 0;
		};
		

		//邀请好友入群回应
		class YVGroupInviteListern
		{
		public:
			virtual void onGroupInviteListern(GroupInviteRespond*) = 0;
		};


		//被邀请入群通知
		class YVGroupInvitenotifyListern
		{
		public:
			virtual void onGroupInvitenotifyListern(GroupInviteNotify*) = 0;
		};

		
		//被邀请者同意或拒绝群邀请响应
		class YVGroupInviteAcceptListern
		{
		public:
			virtual void onGroupInviteAcceptListern(GroupInviteAcceptRespond*) = 0;
		};


		//被邀请者同意或拒绝群邀请通知  
		class YVGroupInviteAcceptnotifyListern
		{
		public:
			virtual void onGroupInviteAcceptnotifyListern(GroupInviteAcceptNotify*) = 0;
		};
	

		//设置群成员角色返回
		class YVGroupSetRoleListern
		{
		public:
			virtual void onGroupSetRoleListern(GroupSetRoleRespond*) = 0;
		};


		//设置群成员角色通知
		class YVGroupSetRolenotifyListern
		{
		public:
			virtual void onGroupSetRolenotifyListern(GroupSetRoleNotify*) = 0;
		};


		//解散群响应
		class YVGroupDissolveListern
		{
		public:
			virtual void onGroupDissolveListern(GroupDissolveRespond*) = 0;
		};
		

		//修改他人名片通知
		class YVGroupSetOthernotifyListern
		{
		public:
			virtual void onGroupSetOthernotifyListern(GroupSetOtherNotify*) = 0;
		};


		//修改他人名片返回
		class YVGroupSetOtherListern
		{
		public:
			virtual void onGroupSetOtherListern(GroupSetOtherRespond*) = 0;
		};
	

		//群属性通知(群列表)
		class YVGroupPropertyListern
		{
		public:
			virtual void onGroupPropertyListern(GroupPropertyNotify*) = 0;
		};


		//群成员上线
		class YVGroupMemberOnlineListern
		{
		public:
			virtual void onGroupMemberOnlineListern(GroupMemberOnlineNotify*) = 0;
		};
		
		
		//新成员加入群
		class YVGroupNewUserJoinListern
		{
		public:
			virtual void onGroupNewUserJoinListern(GroupNewUserJoinNotify*) = 0;
		};


		//修改资料通知
		class YVGroupUsermdyListern
		{
		public:
			virtual void onGroupUsermdyListern(GroupUserMdy*) = 0;
		};

		//群消息推送
		class YVGroupChatnotifyListern
		{
		public:
			virtual void onGroupChatnotifyListern(YVMessagePtr) = 0;
		};

		//群聊消息发送响应
		class YVGroupChatMsgnotifyListern
		{
		public:
			virtual void onGroupChatMsgnotifyListern(YVMessagePtr) = 0;
		};


		//群用户列表
		class YVGroupUserListnotifyListern
		{
		public:
			virtual void onGroupUserListnotifyListern(GroupUserListNotify*) = 0;
		};


		//群历史消息
		class YVGroupHistoryChatListern
		{
		public:
			virtual void onGroupHistoryChatListern(YVMessageListPtr) = 0;
		};
		
		////**********群**end*************


	};
};
#endif
