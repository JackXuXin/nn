#ifndef _GROUPUSERMANAGER_H_
#define _GROUPUSERMANAGER_H_

#include <vector>
#include "YVListern/YVListern.h"
#include "YVType/YVType.h"

namespace YVSDK
{
	struct YaYaRespondBase;
	class YVGroupUserManager :public YVListern::YVFinishSpeechListern
	
	{
	public:
		bool init();
		bool destory(); 


		//************群请求接口************************

		//创建群请求    verify:群验证方式 name:群名称  iconUrl:群头像
		bool sendGroupCreate(uint32 verify,const std::string& name, const std::string& iconUrl="" );
		//搜索群 
		bool searchGroup(uint32 groupid);
		//加入群 
		bool joinGroup(uint32 groupid, const std::string& greet="");

		//退群 
		bool sendGroupExit(uint32 groupid);

		//修改群属性 name群名称, icon群图标, announcement群公告, msg_set群消息设置默认是1, alias名片修改
		bool sendGroupModify(uint32 groupid, const std::string& name, const std::string& icon, const std::string& announcement
			, uint8 verify, uint8 msg_set, const std::string& alias);

		//转移群主请求 
		bool sendGroupShiftOwner(uint32 groupid, uint32 userid);


		//同意/拒绝加群 userid用户申请者）ID,  agree是否同意加入群,  0拒绝, 1同意 , greet拒绝原因
		bool sendGroupJoinAccept(uint32 groupid, uint32 userid, uint8 agree, const std::string& greet="");

		//踢除群成员
		bool sendGroopKick(uint32 groupid, uint32 userid);

		//邀请好友入群  GroupInviteRequest  userid被邀请用户id, greet问候语
		bool sendGroupInvite(uint32 groupid, uint32 userid, const std::string& greet= "");

		//被邀请者同意或拒绝群邀请  GroupInviteAcceptRequest  
		//groupid群id, invitename邀请用户名,  inviteid邀请用户id, agree; 是否同意入群 e_group_invite ,  0:拒绝,1:同意 greet问候语
		bool sendGroupInviteAccept(uint32 groupid, const std::string& invitename, uint32 inviteid, uint32 agree
			, const std::string& greet="");

		//设置群成员角色请求
		bool sendGroupSetRole(uint32 groupid, uint32 userid, uint8 role);

		//解散群请求
		bool sendGroupDissolve(uint32 groupid);

		//管理员修改他人名片 或者 群成员修改自己的名片 GroupSetOtherRequest
		bool sendGroupSetOther(uint32 groupid, uint32 userid, const std::string& alias);


		//群聊 - 文本 GroupSendTextRequest  ext; //扩展字段 flag; //消息标记(可不传)
		bool sendGroupTextRequest(uint32 groupid, const std::string& text, const std::string& ext = "" );


		//群聊 - 文本重发
		bool SendMsgGroupTextRequest(uint32 groupid, uint64 id, const std::string& text, const std::string& ext="");
		
		//群聊 -  图片 GroupSendImageRequest  ext; //扩展字段 flag; //消息标记(可不传)
		bool sendGroupImageRequest(uint32 groupid, const std::string& image, const std::string& ext = "",const std::string& flag = "");

		//群聊 -  语音重发
		bool SendMsgGroupAutoRequest(uint32 groupid, uint64 id, const std::string& txt, YVFilePathPtr voicePath,
			uint32 time1, const std::string& ext);

		//群聊 -  语音 GroupSendAutoRequest  file音频文件路径 ;time音频文件播放时长(秒), txt附带文本(可选)
		bool sendGroupAutoRequest(uint32 groupid, YVFilePathPtr file, uint32 time,const std::string& txt = "", const std::string& ext = "");

		//获取历史消息   //groupid 群ID   index索引， 坐0开始
		bool getGroupHistoryData(uint32 groupid, int index);



		//************群回调接口*Manager层being***********************

		//创建群回应 IM_GROUP_CREATE_RESP 
		void groupCreateCallback(YaYaRespondBase*);
		
		//搜索群回应
		void searchGroupCallBack(YaYaRespondBase*);

		//加入群回应
		void joinGroupCallBack(YaYaRespondBase*);
		
		//申请加群结果通知
		void GroupJoinCallBackRespond(YaYaRespondBase*);

		//加入群通知(群主/管理员接收)
		void GroupJoinNotifyCallBack(YaYaRespondBase*);

		//同意/拒绝加群回应
		void groupJoinAcceptCallBack(YaYaRespondBase*);

		//退群响应  
		void groupExitBack(YaYaRespondBase*);
		//退群通知  
		void groupExitCallBack(YaYaRespondBase*);
		
		//修改群属性响应  
		void groupModifyCallBack(YaYaRespondBase*);

		//修改资料通知  
		void groupUserMdyNotify(YaYaRespondBase*);
		
		//转移群主通知 IM_GROUP_SHIFTOWNER_NOTIFY 
		void groupShiftOwnerCallBack(YaYaRespondBase*);

		//转移群主响应
		void groupShiftOwnerRespond(YaYaRespondBase*);
		
		//踢除群成员通知 GroupKickNotify
		void groupKickNotify(YaYaRespondBase*);

		//踢除群成员回调 GroupKickRespond
		void groupKickRespond(YaYaRespondBase*);
	
		//邀请好友入群回应 GroupInviteRespond
		void groupInviteRespond(YaYaRespondBase*);

		//被邀请入群通知 GroupInviteNotify
		void groupInviteNotify(YaYaRespondBase*);

		//被邀请者同意或拒绝群邀请响应 GroupInviteAcceptRespond
		void groupInviteAcceptRespond(YaYaRespondBase*);

		//被邀请者同意或拒绝群邀请通知 GroupInviteAcceptNotify
		void groupInviteAcceptNotify(YaYaRespondBase*);
			
		//设置群成员角色返回  GroupSetRoleRespond
		void groupSetRoleRespond(YaYaRespondBase*);

		//设置群成员角色通知  GroupSetRoleNotify
		void groupSetRoleNotify(YaYaRespondBase*);

		//解散群响应 GroupDissolveRespond
		void groupDissolveRespond(YaYaRespondBase*);

		//修改他人名片 或者 群成员修改自己名片 通知  GroupSetOtherNotify
		void groupSetOtherNotify(YaYaRespondBase*);

		//修改他人名片 或者 群成员修改自己名片 返回 GroupSetOtherRespond
		void groupSetOtherRespond(YaYaRespondBase*);
					
		//群属性通知(群列表) GroupPropertyNotify
		void groupPropertyNotify(YaYaRespondBase*);

		//群成员上线 GroupMemberOnlineNotify
		void groupMemberOnlineNotify(YaYaRespondBase*);

		//新成员加入群 GroupNewUserJoinNotify  
		void groupNewUserJoinNotify(YaYaRespondBase*);

		//群用户列表 IM_GROUP_USERLIST_NOTIFY 
		void groupUserListNotify(YaYaRespondBase*);

		//群聊天推送 IM_CHAT_GROUP_NOTIFY  
		void groupChatNotify(YaYaRespondBase*);

		//群聊消息发送响应 IM_CHAT_GROUPMSG_RESP
		void groupChatMsgNotify(YaYaRespondBase*);

		//这个通过getGroupHistoryData，获取历史消息或者离线消息，即是客户端主动请求才会有返回
		void cloundMsgNotifyCallback(YaYaRespondBase*);
		
		//**********群Manager层end**************



		//**********群*ui层监听函数begin**************

		////创建群回应
		InitListern(GroupCreate, GroupCreateRespond*);

		////搜索群回应
		InitListern(SearchGroup, GroupSearchRespond*);
		
		////加入群回应
		InitListern(JoinGroup, GroupJoinRespond*);

		////申请加群结果通知
		InitListern(GroupJoinCallBack, GroupJoinCallRespond*);

		////加入群通知(群主/管理员接收)
		InitListern(GroupJoinnotify, GroupJoinNotify*);

		//同意/拒绝加群回应
		InitListern(GroupJoinAccept, GroupJoinAcceptRespond*);
		
		//退群通知
		InitListern(GroupExit, GroupExitRespond*);

		//退群响应
		InitListern(GroupExitback, GroupExitBack*);

		//修改群属性响应
		InitListern(GroupModify, GroupModifyRespond*);

		//转移群主通知
		InitListern(GroupShiftOwnernotify, GroupShiftOwnerNotify*);

		//转移群主响应
		InitListern(GroupShiftOwnerrespond, GroupShiftOwnerRespond*);

		//踢除群成员通知
		InitListern(GroupKicknotify, GroupKickNotify*);
	
		//踢除群成员回调
		InitListern(GroupKick, GroupKickRespond*);

		//邀请好友入群回应
		InitListern(GroupInvite, GroupInviteRespond*);

		//被邀请入群通知
		InitListern(GroupInvitenotify, GroupInviteNotify*);

		//被邀请者同意或拒绝群邀请响应
		InitListern(GroupInviteAccept, GroupInviteAcceptRespond*); 

		//被邀请者同意或拒绝群邀请通知
		InitListern(GroupInviteAcceptnotify, GroupInviteAcceptNotify*);

		//设置群成员角色返回
		InitListern(GroupSetRole, GroupSetRoleRespond*);
	
		//设置群成员角色通知
		InitListern(GroupSetRolenotify, GroupSetRoleNotify*);
	
		//解散群响应
		InitListern(GroupDissolve, GroupDissolveRespond*);

		//修改他人名片通知
		InitListern(GroupSetOthernotify, GroupSetOtherNotify*);

		//修改资料通知
		InitListern(GroupUsermdy, GroupUserMdy*);

		//修改他人名片返回
		InitListern(GroupSetOther, GroupSetOtherRespond*);

		//群属性通知(群列表)
		InitListern(GroupProperty, GroupPropertyNotify*);

		//群成员上线
		InitListern(GroupMemberOnline, GroupMemberOnlineNotify*);

		//新成员加入群
		InitListern(GroupNewUserJoin, GroupNewUserJoinNotify*);

		//群用户列表
		InitListern(GroupUserListnotify, GroupUserListNotify*);


		//群聊天推送
		InitListern(GroupChatnotify, YVMessagePtr);

		//群聊消息发送响应
		InitListern(GroupChatMsgnotify, YVMessagePtr);

		//群历史消息
		InitListern(GroupHistoryChat, YVMessageListPtr);


		public:
			//根据群ID获取群信息
			YVSDK::GroupItemInfo* getGroupByGid(uint32 gid);

			//根据群id获取群用户列表
			YVSDK::GroupUserListNotify* getGroupUserListByGid(uint32 gid); 

			//修改群属性
			bool modifyGroup(YVSDK::GroupItemInfo*);

			//添加或者替换群用户列表
			void modifyGroupUserList(YVSDK::GroupUserListNotify* g); 

			//获取内存中的数据。
			YVMessageListPtr getCacheGroupData(uint32 groupid);
			YVMessageListPtr getGroupChatListById(uint32 groupid);
			void cleanGroupMessages(uint32 groupid);
			int	getcurrentGroupid();
			void setcurrentGroupid(int gid);
			void setGroupUserInfo(YVSDK::GroupUserListNotify* temp);
			//更新修改后的名片
			void releshOtherAlial(uint32 gid, uint32 uid, const std::string& alias);
			
			//群用户列表中删除群成员
			void delGroupUser(uint32 gid, uint32 uid);
			//群用户列表中添加群成员
			void addGroupUser(uint32 gid, YVSDK::GroupUserInfo* addUser);

			std::vector<YVSDK::GroupItemInfo*> m_myGroups;//我的群列表
			std::vector<YVSDK::GroupJoinNotify*> m_GroupJoinNotify;//申请加群用户列表
			std::vector<YVSDK::GroupInviteNotify*> m_GroupInviteNotify;//邀请我加群的列表
			

		protected:

			//以群ID为key，群用户列表为value的消息map类型
			typedef std::map<uint32, YVSDK::GroupUserListNotify*> GroupUserListMap;

			void insertMsg(int groupId, YVMessagePtr, bool isBack, bool isCallGroupChatnotifyListern = true);
			//结束识别接口
			void onFinishSpeechListern(SpeechStopRespond*);

			std::string expand;

			GroupMessageMap m_groupMesages;				//群消息备份
			GroupMessageMap m_ghistoryCache;            //群历史消息缓存
			YVMessageListPtr m_gsendMsgCache;            //发送中的消息备份

			uint8 PlatState;    //消息的播放状态 0：已播放， 1：未播放
		private:
			//获取本地缓存，申请加群信息
			YVSDK::GroupJoinNotify* getGroupJoinNotify(uint32 groupid, uint32 uid);
			//获取本地缓存，邀请我加群的信息
			YVSDK::GroupInviteNotify* getGroupInviteNotify(uint32 groupid, uint32 uid);
			int m_currentGroupid;
			GroupUserListMap m_allGroupUserLists;////所有群的用户列表
			//std::vector<YVSDK::GroupUserListNotify*> m_allGroupUserLists;//所有群的用户列表
			
		//**********群*ui层监听函数end*************
	};
}
#endif
