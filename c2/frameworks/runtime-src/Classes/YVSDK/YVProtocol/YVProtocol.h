#ifndef _YVSDK_YVPROTOCOL_H_
#define _YVSDK_YVPROTOCOL_H_
/*********************************************************************************
*Copyright(C), 2015 YUNVA Company
*FileName:  YVProtocol.h
*Author:  Matt
*Version:  1.0.0
*Date:  2015-5-5
*Description:  定义协议的调用结构体
**********************************************************************************/

#include <string>
#include <iostream>
#include <vector>
#include "IMSDK.h"
#include "YVIMCmdDef.h"
#include "YvLBSSdk.h"
#include "YVUtils/yvpacket_overloaded.h"
#include <time.h>
#include "YVType/YVType.h"

namespace YVSDK
{
	//==========================智能析构指针==========================================
	class YVRef
	{
	public:
		YVRef(){ _refCount = 1; }
		virtual ~YVRef(){};
		void addRef(){ ++_refCount; };
		void release(){ if ((--_refCount) <= 0)delete this; }
	private:
		unsigned int _refCount;
	};
	//==================================协议基类=====================================

	//请求的基类
	struct YaYaRequestBase :public  YVRef
	{
		virtual ~YaYaRequestBase(){};
		CmdChannel m_requestChannel;
		uint32 m_requestCmd;
		YaYaRequestBase(CmdChannel channel, uint32 cmd)
		{
			m_requestChannel = channel;
			m_requestCmd = cmd;
		}

		virtual YV_PARSER encode() = 0;
	};

	//响应基类
	struct YaYaRespondBase :public YVRef
	{
		virtual ~YaYaRespondBase(){};
		virtual void decode(YV_PARSER parser) = 0;
	};

	//=============================登录模块==================================

	//云娃登录请求 IM_LOGIN_REQ
	struct LoginRequest :YaYaRequestBase
	{
		uint32 userid;                        //用户ID
		std::string	 pwd;                     //用户密码
		std::string	 pgameServiceID;          //游戏服务ID
		std::vector<std::string>  wildCard;   //通配符
		uint8 readstatus;                     //消息需要确认么

		LoginRequest()
			:YaYaRequestBase(IM_LOGIN, IM_LOGIN_REQ)
		{

		}

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint32(parser, x11000::userid, userid);
			parser_set_cstring(parser, x11000::pwd, pwd.c_str());
			parser_set_cstring(parser, x11000::pgameServiceID, pgameServiceID.c_str());
			parser_set_uint8(parser, x11000::readstatus, readstatus);

			for (std::vector<std::string>::iterator it = wildCard.begin(); it < wildCard.end(); ++it)
			{
				parser_set_cstring(parser, x11000::wildCard, it->c_str());
			}

			return parser;
		}
	};

	//云娃登陆请求响应 IM_LOGIN_RESP
	struct LoginResponse :YaYaRespondBase
	{
		uint32 result; //返回结果 不为0即为失败
		std::string msg; //错误描述
		std::string nickname; //用户昵称
		uint32 userId; //用户ID
		std::string iconurl; //用户图像地址
		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x11001::result);
			msg = parser_get_string(parser, x11001::msg);
			nickname = parser_get_string(parser, x11001::nickname);
			userId = parser_get_uint32(parser, x11001::userId);
			iconurl = parser_get_string(parser, x11001::iconurl);
		}
	};

	//CP账号登陆请求
	struct CPLoginRequest : public YaYaRequestBase
	{
		CPLoginRequest()
		:YaYaRequestBase(IM_LOGIN, IM_THIRD_LOGIN_REQ)
		{

		}
	
		std::string tt;  //cp登录凭证
		std::string pgameServiceID; //游戏服务ID
		std::vector<std::string>  wildCard; //通配符,注意这个vector的长度是十，即是0-9个频道号，里面的存的就是通配符字符串
		uint8 readstatus;    //消息需要确认么
		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_cstring(parser, x11002::tt, tt.c_str());
			parser_set_cstring(parser, x11002::pgameServiceID, pgameServiceID.c_str());
			parser_set_uint8(parser, x11002::readstatus, readstatus);

			for (std::vector<std::string>::iterator it = wildCard.begin(); it < wildCard.end(); ++it)
			{
				parser_set_cstring(parser, x11002::wildCard, it->c_str());
			}
			return parser;
		}
	};

	struct CPLoginResponce : public YaYaRespondBase
	{
		uint32 result; //返回结果 不为0即为失败
		std::string msg; //错误描述
		uint32 userid;//云娃ID
		std::string nickName;//用户昵称
		std::string iconUrl; //用户图像地址
		std::string thirdUserId; //第三方用户ID
		std::string thirdUserName; //第三方用户名
		std::string level; ///用户等级
		std::string vip; //用户vip等级
		uint8 sex; //性别
		std::string ext; //扩展字段


		void decode(YV_PARSER parser)
		{
			this->result = parser_get_uint32(parser, x11003::result);
			this->msg = parser_get_string(parser, x11003::msg);
			this->userid = parser_get_uint32(parser, x11003::userid);
			this->nickName = parser_get_string(parser, x11003::nickName);
			this->iconUrl = parser_get_string(parser, x11003::iconUrl);
			this->thirdUserId = parser_get_string(parser, x11003::thirdUserId);
			this->thirdUserName = parser_get_string(parser, x11003::thirdUserName);
			this->level = parser_get_string(parser, x11003::level);
			this->vip = parser_get_string(parser, x11003::vip);
			this->sex = parser_get_uint8(parser, x11003::sex);
			this->ext = parser_get_string(parser, x11003::ext);
		}
	};

	//注销登录 IM_LOGOUT_REQ
	struct CPLogoutRequest :YaYaRequestBase
	{
		CPLogoutRequest()
		:YaYaRequestBase(IM_LOGIN, IM_LOGOUT_REQ)
		{

		}

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			return parser;
		}
	};

	//重连通知 IM_RECONNECTION_NOTIFY
	struct ReconnectionNotify : YaYaRespondBase
	{
		uint32	userid;;

		void decode(YV_PARSER parser)
		{
			userid = parser_get_uint32(parser, x11013::userid);
		}
	};

//获取第三方账号信息
//#define IM_GET_THIRDBINDINFO_REQ             0x11014
	struct GetCpmsgRequest :YaYaRequestBase
	{
		GetCpmsgRequest()
		:YaYaRequestBase(IM_LOGIN, IM_GET_THIRDBINDINFO_REQ)
		{

		}

		std::string Uid;                        //第三方用户ID
		uint32 appid;                           //appid
		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint32(parser, x11014::appid, appid);
			parser_set_cstring(parser, x11014::uid, Uid.c_str());
			return parser;
		}
	};

	//获取第三方账号回应 IM_GET_THIRDBINDINFO_RESP
	struct GetCpmsgRepond :YaYaRespondBase
	{
		uint32		result;
		std::string msg; //
		uint32 yunvaid; //云娃ID
		std::string nickname; //用户名称
		std::string iconUrl; //头像地址
		std::string level; //问候语
		std::string vip; //Vip
		uint8 sex;
		std::string ext; //
		uint32 thirdid; //用户ID


		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x11015::result);
			yunvaid = parser_get_uint32(parser, x11015::yunvaid);
			nickname = parser_get_string(parser, x11015::nickname);
			iconUrl = parser_get_string(parser, x11015::iconUrl);
			level = parser_get_string(parser, x11015::level);
			vip = parser_get_string(parser, x11015::vip);
			msg = parser_get_string(parser, x11015::msg);
			sex = parser_get_uint8(parser, x11015::sex);
			ext = parser_get_string(parser, x11015::ext);
			thirdid = parser_get_uint32(parser, x11015::uid);
		}
	};



	//用户信息
	struct YaYaUserInfo :YVRef
	{
		std::string nickname; //用户昵称
		uint32 userid; //用户ID
		std::string iconurl; //用户图像地址
		uint8  online; //是否在线
		std::string userlevel; //用户等级
		std::string viplevel; //vip等级
		std::string ext; //扩展字段
		uint8  shieldmsg; //是否屏蔽聊天消息
		uint8  sex; //性别
		std::string group; //所在组名称
		std::string note; //备注
		std::string thirduid; //第三方uid
	};

	//主动请求添加好友 IM_FRIEND_ADD_REQ
	struct AddFriendRequest :YaYaRequestBase
	{
		AddFriendRequest()
		:YaYaRequestBase(IM_FRIEND, IM_FRIEND_ADD_REQ)
		{

		}

		uint32 userid; //用户ID
		std::string greet; //问候语

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint32(parser, x12000::userid, userid);
			parser_set_cstring(parser, x12000::greet, greet.c_str());
			return parser;
		}
	};

	//主动添加好友回应 IM_FRIEND_ADD_RESP
	struct AddFriendRepond :YaYaRespondBase
	{
		e_addfriend_affirm affirm; //返回结果 e_addfriend_affirm
		uint32 userid; //用户ID
		std::string name; //用户名称
		std::string url; //头像地址
		std::string greet; //问候语
		uint32 indexId; //消息iD
		std::string source; //来源
		std::string thirduid;//第三方uid


		void decode(YV_PARSER parser)
		{
			affirm = (e_addfriend_affirm)parser_get_uint32(parser, x12001::affirm);
			userid = parser_get_uint32(parser, x12001::userid);
			name = parser_get_string(parser, x12001::name);
			url = parser_get_string(parser, x12001::url);
			greet = parser_get_string(parser, x12001::greet);
			thirduid = parser_get_string(parser, x12001::uid);
			indexId = parser_get_uint32(parser, CLOUDMSG_ID);
			source = parser_get_string(parser, CLOUDMSG_SOURCE);
		}
	};

	//被动好友请求通知  IM_FRIEND_ADD_NOTIFY  
	struct  AddFriendNotify :YaYaRespondBase
	{
		uint32 userid;  //用户ID
		std::string name;  //用户名称
		std::string greet;  //问候语
		std::string sign;	//签名
		std::string url;  //头像地址
		uint32 indexId; //消息iD
		std::string source; //来源
		std::string thirduid; //第三方uid
		void decode(YV_PARSER parser)
		{
			userid = parser_get_uint32(parser, x12002::userid);
			name = parser_get_string(parser, x12002::name);
			greet = parser_get_string(parser, x12002::greet);
			sign = parser_get_string(parser, x12002::sign);
			url = parser_get_string(parser, x12002::url);
			thirduid = parser_get_string(parser, x12002::uid);
			indexId = parser_get_uint32(parser, CLOUDMSG_ID);
			source = parser_get_string(parser, CLOUDMSG_SOURCE);

		}
	};

	//被动同意添加好友 IM_FRIEND_ADD_ACCEPT
	struct  FriendAcceptRequest :YaYaRequestBase
	{
		FriendAcceptRequest()
		:YaYaRequestBase(IM_FRIEND, IM_FRIEND_ADD_ACCEPT)
		{

		}

		uint32  userid; //用户ID
		e_addfriend_affirm	affirm;	//是否同意 e_addfriend_affirm
		std::string	greet;	//问候语
		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint32(parser, x12003::userid, userid);
			parser_set_uint8(parser, x12003::affirm, affirm);
			parser_set_cstring(parser, x12003::greet, greet.c_str());
			return parser;
		}
	};

	//被动添加好友结果回应 IM_FRIEND_ACCEPT_RESP
	struct  FriendAcceptRespond :YaYaRespondBase
	{
		uint32  userid; //用户ID
		e_addfriend_affirm	affirm;	//是否同意 e_addfriend_affirm
		std::string	greet;	//问候语
		void decode(YV_PARSER parser)
		{
			userid = parser_get_uint32(parser, x12004::userid);
			affirm = (e_addfriend_affirm)parser_get_uint8(parser, x12004::affirm);
			greet = parser_get_string(parser, x12004::greet);
		}
	};

	//删除好友请求 IM_FRIEND_DEL_REQ
	struct DelFriendRequest :YaYaRequestBase
	{
		DelFriendRequest()
		:YaYaRequestBase(IM_FRIEND, IM_FRIEND_DEL_REQ)
		{

		}

		uint32	del_friend;  //删除好友id
		e_delfriend  act;  //动作 e_delfriend

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint32(parser, x12005::del_friend, del_friend);
			parser_set_uint8(parser, x12005::act, act);

			return parser;
		}
	};

	//删除好友返回 IM_FRIEND_DEL_RESP
	struct DelFriendRespond :YaYaRespondBase
	{
		uint32		result;
		std::string		msg;
		uint32	    del_friend; //删除好友id
		e_delfriend       act;  //动作 e_delfriend

		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x12006::result);
			del_friend = parser_get_uint32(parser, x12006::del_friend);
			act = (e_delfriend)parser_get_uint8(parser, x12006::act);
			msg = parser_get_string(parser, x12006::msg);
		}
	};

	//删除好友通知 IM_FRIEND_DEL_NOTIFY
	struct DelFriendNotify :YaYaRespondBase
	{
		uint32		del_friend;
		e_delfriend       del_fromlist;  //动作 e_delfriend

		void decode(YV_PARSER parser)
		{
			del_friend = parser_get_uint32(parser, x12007::del_friend);
			del_fromlist = (e_delfriend)parser_get_uint8(parser, x12007::del_fromlist);
		}
	};

	//搜索好友请求 IM_FRIEND_SEARCH_REQ 
	struct SearchFriendRequest :YaYaRequestBase
	{
		SearchFriendRequest()
		:YaYaRequestBase(IM_FRIEND, IM_FRIEND_SEARCH_REQ)
		{

		}

		std::string keyword; //搜索关键字
		uint32 start; //搜索起始位置
		uint32 count; //返回结果总数

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_cstring(parser, x12018::keyworld, keyword.c_str());
			parser_set_uint32(parser, x12018::start, start);
			parser_set_uint32(parser, x12018::count, count);
			return parser;
		}
	};

	//推荐好友 IM_FRIEND_RECOMMAND_REQ 
	struct RecommendFriendRequest :YaYaRequestBase
	{
		RecommendFriendRequest()
		:YaYaRequestBase(IM_FRIEND, IM_FRIEND_RECOMMAND_REQ)
		{

		}
		uint32 start; //结果列表的起始位置
		uint32 count; //返回结果条目
		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint32(parser, x12008::start, start);
			parser_set_uint32(parser, x12008::count, count);
			return parser;
		}
	};

	//获取个人信息
	struct GetUserInfoRequest :YaYaRequestBase
	{
		GetUserInfoRequest()
		:YaYaRequestBase(IM_FRIEND, IM_USER_GETINFO_REQ)
		{

		}
		uint32 userid;
		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint32(parser, x12020::userid, userid);
			return parser;
		}
	};

	//获取个人信息回应 IM_USER_GETINFO_RESP 
	struct GetUserInfoFriendRespond :YaYaRespondBase
	{
		uint32 result;
		std::string msg;
		uint32  userid; //云娃id
		uint8   sex;     //性别
		std::string  nickname;     //昵称
		std::string  headicon;     //图像地址
		std::string  userlevel;     //用户等级
		std::string  viplevel;     //用户VIP等级
		std::string  ext;     //扩展字段
		std::string thirdid; //第三方uid



		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x12021::result);
			msg = parser_get_string(parser, x12021::msg);
			userid = parser_get_uint32(parser, x12021::userid);
			sex = parser_get_uint8(parser, x12021::sex);
			nickname = parser_get_string(parser, x12021::nickname);
			headicon = parser_get_string(parser, x12021::headicon);
			userlevel = parser_get_string(parser, x12021::userlevel);
			viplevel = parser_get_string(parser, x12021::viplevel);
			ext = parser_get_string(parser, x12021::ext);
			thirdid = parser_get_string(parser, x12021::uid);
		}
	};

	//查询指定用户是否在线（不限于好友，查询成功推送IM_FRIEND_STATUS_NOTIFY通知）
	//IM_FRIEND_QUERY_ONLINE_REQ
	struct UserOnlineRequest :YaYaRequestBase
	{
		UserOnlineRequest()
		:YaYaRequestBase(IM_FRIEND, IM_FRIEND_QUERY_ONLINE_REQ)
		{

		}
		uint32 userid;//云娃id
		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint32(parser, x12034::userid, userid);
			return parser;
		}
	};


	//查询指定用户是否在线回应 IM_FRIEND_QUERY_ONLINE_RESP 
	struct UserOnlineRespond :YaYaRespondBase
	{
		uint32		result;
		std::string		msg;
		uint32 userid;
		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x12035::result);
			msg = parser_get_string(parser, x12035::msg);
			userid = parser_get_uint32(parser, x12035::userid);
		}
	};

	//修改个人账号信息 
	struct SetUserInfoRequest :YaYaRequestBase
	{
		SetUserInfoRequest()
		:YaYaRequestBase(IM_LOGIN, IM_SETUSERINFO_REQ)
		{

		}
		std::string nickname; //第三方用户nickname
		std::string iconUrl;
		std::string level;
		std::string vip;
		std::string ext;
		uint8 sex;
		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_cstring(parser, x11019::nickname, nickname.c_str());
			parser_set_cstring(parser, x11019::iconUrl, iconUrl.c_str());
			parser_set_cstring(parser, x11019::level, level.c_str());
			parser_set_cstring(parser, x11019::vip, vip.c_str());
			parser_set_cstring(parser, x11019::ext, ext.c_str());
			parser_set_uint8(parser, x11019::sex, sex);
			return parser;
		}
	};


	//修改个人账号信息响应 IM_SETUSERINFO_RESP 
	struct SetUserInfoRespond :YaYaRespondBase
	{
		uint32		result;
		std::string		msg;
		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x11020::result);
			msg = parser_get_string(parser, x11020::msg);
		}
	};


	//好友个人信息修改通知 IM_USER_SETINFO_NOTIFY 
	struct UserSetInfoNotify :YaYaRespondBase
	{
		uint32  userid; //yunva id
		std::string nickname; //用户昵称
		std::string iconurl;//	用户图像地址
		std::string userlevel;//用户等级
		std::string viplevel;//	vip等级
		std::string ext;//扩展字段
		uint8 sex;//性别
		void decode(YV_PARSER parser)
		{
			userid = parser_get_uint32(parser, x12024::userid);
			nickname = parser_get_string(parser, x12024::nickname);
			iconurl = parser_get_string(parser, x12024::iconurl);
			userlevel = parser_get_string(parser, x12024::userlevel);
			viplevel = parser_get_string(parser, x12024::viplevel);
			ext = parser_get_string(parser, x12024::ext);
			sex = parser_get_uint8(parser, x12024::sex);
		}
	};


	struct SearchRetInfo
	{
		uint32 yunvaId;
		std::string userId; //用户ID
		std::string nickName; //用户昵称
		std::string iconUrl; //用户图像地址
		std::string level; //用户等级
		std::string vip; //用户VIP等级
		uint8 sex;//性别
		std::string Ext; //扩展字段
	};

	//搜索好友回应 IM_FRIEND_SEARCH_RESP  
	struct SearchFriendRespond :YaYaRespondBase
	{
		uint32		result;
		std::string msg;
		std::vector<SearchRetInfo> searchRetInfo;

		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x12019::result);
			msg = parser_get_string(parser, x12019::msg);
			int index = 0;
			while (true)
			{
				if (parser_is_empty(parser, x12019::userinfo, index))
					return;

				YV_PARSER Object = yvpacket_get_parser_object(parser);
				parser_get_object(parser, x12019::userinfo, Object, index);

				SearchRetInfo userInfo;
				userInfo.yunvaId = parser_get_uint32(Object, xSearchInfo::yunvaId);
				userInfo.userId = parser_get_string(Object, xSearchInfo::userId);
				userInfo.nickName = parser_get_string(Object, xSearchInfo::nickName);
				userInfo.iconUrl = parser_get_string(Object, xSearchInfo::iconUrl);
				userInfo.level = parser_get_string(Object, xSearchInfo::level);
				userInfo.vip = parser_get_string(Object, xSearchInfo::vip);
				userInfo.sex  = parser_get_uint8(Object, xSearchInfo::sex);
				userInfo.Ext = parser_get_string(Object, xSearchInfo::Ext);
				searchRetInfo.push_back(userInfo);
				++index;
			}
		}
	};

	//推荐好友回应 IM_FRIEND_RECOMMAND_RESP 
	struct RecommendFriendRespond :YaYaRespondBase
	{
		uint32	result; //结果信息
		std::string		msg; //错误信息
		std::vector<SearchRetInfo> userInfos; //用户信息
		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x12009::result);
			msg = parser_get_string(parser, x12009::msg);
			int index = 0;
			while (true)
			{
				if (parser_is_empty(parser, x12009::userinfo, index))
					return;

				YV_PARSER Object = yvpacket_get_parser_object(parser);
				parser_get_object(parser, x12009::userinfo, Object, index);

				SearchRetInfo userInfo;
				userInfo.yunvaId = parser_get_uint32(Object, xSearchInfo::yunvaId);
				userInfo.userId = parser_get_string(Object, xSearchInfo::userId);
				userInfo.nickName = parser_get_string(Object, xSearchInfo::nickName);
				userInfo.iconUrl = parser_get_string(Object, xSearchInfo::iconUrl);
				userInfo.level = parser_get_string(Object, xSearchInfo::level);
				userInfo.vip = parser_get_string(Object, xSearchInfo::vip);
				userInfo.Ext = parser_get_string(Object, xSearchInfo::Ext);
				userInfos.push_back(userInfo);

				++index;
			}
		}
	};

	//好友操作请求(黑名单) IM_FRIEND_OPER_REQ	
	struct BlackControlRequest :YaYaRequestBase
	{
		BlackControlRequest()
		:YaYaRequestBase(IM_FRIEND, IM_FRIEND_OPER_REQ)
		{

		}
		uint32	userId;	//用户ID
		uint32	operId;	//要操作的黑名的用户的id
		e_oper_friend_act	act;	//动作   oper_friend_act

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint8(parser, x12010::act, act);
			parser_set_uint32(parser, x12010::userId, userId);
			parser_set_uint32(parser, x12010::operId, operId);
			return parser;
		}
	};

	//好友操作回应(黑名单) IM_FRIEND_OPER_RESP	
	struct BlackControlRespond :YaYaRespondBase
	{
		uint32	userId;	//用户ID
		uint32	operId;	//要操作的黑名的用户的id
		e_oper_friend_act	act;	//动作   oper_friend_act
		e_friend_status	oper_state; //对方状态

		void decode(YV_PARSER parser)
		{
			userId = parser_get_uint32(parser, x12011::userId);
			operId = parser_get_uint32(parser, x12011::operId);
			act = (e_oper_friend_act)parser_get_uint8(parser, x12011::act);
			oper_state = (e_friend_status)parser_get_uint8(parser, x12011::oper_state);
		}
	};

	//好友列表推送 IM_FRIEND_LIST_NOTIFY
	struct FriendListNotify :YaYaRespondBase
	{

		~FriendListNotify()
		{
			for (std::vector<YaYaUserInfo*>::iterator it = userInfos.begin();
				it != userInfos.end(); ++it)
			{
				(*it)->release();
			}
		}

		std::vector<YaYaUserInfo*> userInfos;
		void decode(YV_PARSER parser)
		{
			int index = 0;
			while (true)
			{
				if (parser_is_empty(parser, x12012::userinfo, index))
					return;

				YV_PARSER Object = yvpacket_get_parser_object(parser);
				parser_get_object(parser, x12012::userinfo, Object, index);

				YaYaUserInfo* userInfo = new YaYaUserInfo();
				userInfo->nickname = parser_get_string(Object, xUserInfo::nickname);
				userInfo->userid = parser_get_uint32(Object, xUserInfo::userid);
				userInfo->iconurl = parser_get_string(Object, xUserInfo::iconurl);
				userInfo->online = parser_get_uint8(Object, xUserInfo::online);
				userInfo->userlevel = parser_get_string(Object, xUserInfo::userlevel);
				userInfo->viplevel = parser_get_string(Object, xUserInfo::viplevel);
				userInfo->ext = parser_get_string(Object, xUserInfo::ext);
				userInfo->sex = parser_get_uint8(Object, xUserInfo::sex);
				userInfo->group = parser_get_string(Object, xUserInfo::group);
				userInfo->note = parser_get_string(Object, xUserInfo::remark);
				userInfo->shieldmsg = parser_get_uint8(Object, xUserInfo::shieldmsg);
				userInfo->thirduid = parser_get_string(Object, xUserInfo::uid);
				userInfos.push_back(userInfo);
				++index;
			}
		}
	};

	//黑名单列表推送 IM_FRIEND_BLACKLIST_NOTIFY
	struct BlackListNotify :YaYaRespondBase
	{
		~BlackListNotify()
		{
			for (std::vector<YaYaUserInfo*>::iterator it = userInfos.begin();
				it != userInfos.end(); ++it)
			{
				(*it)->release();
			}
		}
		std::vector<YaYaUserInfo*> userInfos;
		void decode(YV_PARSER parser)
		{
			int index = 0;
			while (true)
			{
				if (parser_is_empty(parser, x12013::userinfo, index))
					return;

				YV_PARSER Object = yvpacket_get_parser_object(parser);
				parser_get_object(parser, x12013::userinfo, Object, index);

				YaYaUserInfo* userInfo = new YaYaUserInfo();
				userInfo->nickname = parser_get_string(Object, xUserInfo::nickname);
				userInfo->userid = parser_get_uint32(Object, xUserInfo::userid);
				userInfo->iconurl = parser_get_string(Object, xUserInfo::iconurl);
				userInfo->online = parser_get_uint8(Object, xUserInfo::online);
				userInfo->userlevel = parser_get_string(Object, xUserInfo::userlevel);
				userInfo->viplevel = parser_get_string(Object, xUserInfo::viplevel);
				userInfo->ext = parser_get_string(Object, xUserInfo::ext);
				userInfo->sex = parser_get_uint8(Object, xUserInfo::sex);
				userInfo->group = parser_get_string(Object, xUserInfo::group);
				userInfo->note = parser_get_string(Object, xUserInfo::remark);
				userInfo->thirduid = parser_get_string(Object, xUserInfo::uid);
				userInfos.push_back(userInfo);
				++index;
			}
		}
	};


	//好友状态推送 IM_FRIEND_STATUS_NOTIFY 
	struct FriendStatusNotify :YaYaRespondBase
	{
		uint32 userid;
		e_friend_status  status;

		void decode(YV_PARSER parser)
		{
			userid = parser_get_uint32(parser, x12015::userid);
			status = (e_friend_status)parser_get_uint8(parser, x12015::status);
		}
	};

	//设置好友信息 IM_FRIEND_INFOSET_REQ
	struct FriendInfoSetRequest :YaYaRequestBase
	{
		FriendInfoSetRequest()
		:YaYaRequestBase(IM_FRIEND, IM_FRIEND_INFOSET_REQ)
		{

		}
		uint32 friendId; //好友ID
		std::string group; //好友所在组
		std::string note; //好友备注

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_cstring(parser, x12016::group, group.c_str());
			parser_set_uint32(parser, x12016::friendId, friendId);
			parser_set_cstring(parser, x12016::note, note.c_str());
			return parser;
		}
	};

	//云消息的父类
	struct YaYaxNotify
	{
		uint32 unread;
	};
	//好友离线结构
	struct YaYaP2PChatNotify :YaYaxNotify
	{
		uint32 userid; //用户ID
		std::string name; //用户名称
		std::string signature; //用户签名
		std::string headicon; //图像地址
		uint32 sendtime; //消息发送时间
		e_chat_msgtype  type; //消息类型 e_chat_msgtype
		std::string data; //若为文本类型，则是消息内容，其他则是文件地址
		std::string imageurl; //若为图片，则是小图像地址
		uint32 audiotime; //若为音频文件, 则为文件播放时长(秒)
		std::string attach; //若为音频文件，则是附加文本(没有附带文本时为空)
		std::string ext1; //扩展字段
		std::string thirduid;//第三方uid
	};

	//群离线结构
	struct YaYaGroupChatNotify :YaYaxNotify
	{
		uint32 groupid; //群ID
		uint32 sendid; //发送者ID
		std::string sendnickname;//发送者昵称
		std::string sendheadIconurl;//发送者头像
		uint32 time; //消息发送时间
		std::string groupicon; //群图像地址
		std::string groupname; //群名称
		e_chat_msgtype  type; //消息类型 e_chat_msgtype
		std::string data; //若为文本类型，则是消息内容，其他则是文件地址
		std::string imageurl;//若为图片， 则是小图像地址
		uint32 audiotime; //若为音频文件, 则为文件播放时长(秒)
		std::string attach;//若为音频文件， 则为附加文本（没有附带文本时为空）
		std::string ext1;//扩展字段
		std::string thirduid;//第三方uid
	};

	//云消息推送 IM_CLOUDMSG_NOTIFY 
	struct CloundMsgNotify :YaYaRespondBase
	{
		std::string source; //来源(SYSTEM 系统消息 PUSH 推送消息 userId 好友消息)
		uint32 id; //若是好友消息, 则为好友ID
		uint32 beginid;  //开始索引
		uint32 endid; //结束索引
		uint32 time; //结束索引时间
		uint32 unread; //未读消息数
		YaYaxNotify*  packet;  //结束索引内容  xP2PChatMsg,  xGroupChatMsg

		CloundMsgNotify()
		{
			packet = NULL;
		}
		~CloundMsgNotify()
		{
			if (packet != NULL)
			{
				delete packet;
			}
		}

		void decode(YV_PARSER parser)
		{
			this->source = parser_get_string(parser, x15002::source);
			this->id = parser_get_uint32(parser, x15002::id);
			this->beginid = parser_get_uint32(parser, x15002::beginid);
			this->endid = parser_get_uint32(parser, x15002::endid);
			this->time = parser_get_uint32(parser, x15002::time);
			this->unread = parser_get_uint32(parser, x15002::unread);
			/*	if (this->unread == 0)
				{
				packet = NULL;
				return;
				}
				*/
			YV_PARSER yayaParser = yvpacket_get_parser_object(parser);
			parser_get_object(parser, x15002::packet, yayaParser);
			if (this->source == CLOUDMSG_FRIEND)
			{
				YaYaP2PChatNotify* p2pmsg = new YaYaP2PChatNotify();
				p2pmsg->unread = this->unread;
				p2pmsg->userid = parser_get_uint32(yayaParser, xP2PChatMsg::userid);
				p2pmsg->name = parser_get_string(yayaParser, xP2PChatMsg::name);
				p2pmsg->signature = parser_get_string(yayaParser, xP2PChatMsg::signature);
				p2pmsg->headicon = parser_get_string(yayaParser, xP2PChatMsg::headurl);
				p2pmsg->sendtime = parser_get_uint32(yayaParser, xP2PChatMsg::sendtime);
				p2pmsg->type = (e_chat_msgtype)parser_get_uint8(yayaParser, xP2PChatMsg::type);
				p2pmsg->data = parser_get_string(yayaParser, xP2PChatMsg::data);
				p2pmsg->imageurl = parser_get_string(yayaParser, xP2PChatMsg::imageurl);
				p2pmsg->audiotime = parser_get_uint32(yayaParser, xP2PChatMsg::audiotime);
				p2pmsg->attach = parser_get_string(yayaParser, xP2PChatMsg::attach);
				p2pmsg->ext1 = parser_get_string(yayaParser, xP2PChatMsg::ext1);
				p2pmsg->thirduid = parser_get_string(yayaParser, xP2PChatMsg::uid);

				packet = p2pmsg;
			}
			else if (this->source == CLOUDMSG_GROUP)
			{
				YaYaGroupChatNotify* groupmsg = new YaYaGroupChatNotify();
				
				groupmsg->groupid = parser_get_uint32(yayaParser, xGroupChatMsg::groupid);
				groupmsg->sendid = parser_get_uint32(yayaParser, xGroupChatMsg::sendid);
				groupmsg->sendnickname = parser_get_string(yayaParser, xGroupChatMsg::sendnickname);
				groupmsg->sendheadIconurl = parser_get_string(yayaParser, xGroupChatMsg::sendheadurl);
				groupmsg->groupicon = parser_get_string(yayaParser, xGroupChatMsg::groupicon);
				groupmsg->groupname = parser_get_string(yayaParser, xGroupChatMsg::groupname);
				groupmsg->time = parser_get_uint32(yayaParser, xGroupChatMsg::time);
				groupmsg->type = (e_chat_msgtype)parser_get_uint8(yayaParser, xGroupChatMsg::type);
				groupmsg->data = parser_get_string(yayaParser, xGroupChatMsg::data);
				groupmsg->audiotime = parser_get_uint32(yayaParser, xGroupChatMsg::audiotime);
				groupmsg->attach = parser_get_string(yayaParser, xGroupChatMsg::attach);
				groupmsg->ext1 = parser_get_string(yayaParser, xGroupChatMsg::ext1);

				packet = groupmsg;
			}
			else
			{
				//CCLOG("not has this Notify logic:%s", this->source.c_str());
			}
		}
	};




	//最近联系人信息
	struct YaYaRecentInfo :YVRef
	{
		uint32 endId;   //结束索引
		uint32 unread;   //未读消息数
		YaYaUserInfo* userinfo;  //联系人资料
		YaYaP2PChatNotify* Notifymsg; //最后一条消息
	};

	// 	namespace xRecentConactList {
	// 		enum e_recent_user {
	// 			/*uint32*/        endId = 1, //结束索引
	// 			/*uint32*/        unread = 2, //未读消息数
	// 			/*xP2PChatMsg*/   msg = 3, //最后一条消息
	// 			/*xNearChatInfo*/ user = 4,
	// 		};
	// 	}
	//最近联系人列表推送 IM_FRIEND_NEARLIST_NOTIFY
	struct RecentListNotify :YaYaRespondBase
	{
		~RecentListNotify()
		{
			for (std::vector<YaYaRecentInfo*>::iterator it = RecentConactList.begin();
				it != RecentConactList.end(); ++it)
			{
				(*it)->release();
			}
		}
		std::vector<YaYaRecentInfo*> RecentConactList;

		void decode(YV_PARSER parser)
		{
			int index = 0;
			while (true)
			{
				if (parser_is_empty(parser, x12014::recent, index))
					return;

				YV_PARSER Object = yvpacket_get_parser_object(parser);
				parser_get_object(parser, x12014::recent, Object, index);

				YaYaRecentInfo* RecentInfo = new YaYaRecentInfo();

				RecentInfo->endId = parser_get_uint32(Object, xRecentConactList::endId);
				RecentInfo->unread = parser_get_uint32(Object, xRecentConactList::unread);

				YV_PARSER Objectinfo = yvpacket_get_parser_object(parser);
				parser_get_object(Object, xRecentConactList::user, Objectinfo);

				YV_PARSER Objectmsg = yvpacket_get_parser_object(parser);
				parser_get_object(Object, xRecentConactList::msg, Objectmsg);


				//YV_PARSER Objectinfo = yvpacket_get_parser_object(xRecentConactList::user);

				//YV_PARSER Objectmsg = yvpacket_get_parser_object(xRecentConactList::msg);


				YaYaP2PChatNotify* p2pmsg = new YaYaP2PChatNotify();

				//p2pmsg->unread = RecentInfo->unread;
				p2pmsg->userid = parser_get_uint32(Objectmsg, xP2PChatMsg::userid);
				p2pmsg->name = parser_get_string(Objectmsg, xP2PChatMsg::name);
				p2pmsg->signature = parser_get_string(Objectmsg, xP2PChatMsg::signature);
				p2pmsg->headicon = parser_get_string(Objectmsg, xP2PChatMsg::headurl);
				p2pmsg->sendtime = parser_get_uint32(Objectmsg, xP2PChatMsg::sendtime);
				p2pmsg->type = (e_chat_msgtype)parser_get_uint8(Objectmsg, xP2PChatMsg::type);
				p2pmsg->data = parser_get_string(Objectmsg, xP2PChatMsg::data);
				p2pmsg->imageurl = parser_get_string(Objectmsg, xP2PChatMsg::imageurl);
				p2pmsg->audiotime = parser_get_uint32(Objectmsg, xP2PChatMsg::audiotime);
				p2pmsg->attach = parser_get_string(Objectmsg, xP2PChatMsg::attach);
				p2pmsg->ext1 = parser_get_string(Objectmsg, xP2PChatMsg::ext1);
				p2pmsg->thirduid = parser_get_string(Objectmsg, xP2PChatMsg::uid);
				RecentInfo->Notifymsg = p2pmsg;

				YaYaUserInfo* userInfo = new YaYaUserInfo();
				userInfo->nickname = parser_get_string(Objectinfo, xUserInfo::nickname);
				userInfo->userid = parser_get_uint32(Objectinfo, xUserInfo::userid);
 				userInfo->iconurl = parser_get_string(Objectinfo, xUserInfo::iconurl);
				userInfo->online = parser_get_uint8(Objectinfo, xUserInfo::online);
				userInfo->userlevel = parser_get_string(Objectinfo, xUserInfo::userlevel);
				userInfo->viplevel = parser_get_string(Objectinfo, xUserInfo::viplevel);
				userInfo->ext = parser_get_string(Objectinfo, xUserInfo::ext);
				userInfo->sex = parser_get_uint8(Objectinfo, xUserInfo::sex);
				userInfo->group = parser_get_string(Objectinfo, xUserInfo::group);
				userInfo->note = parser_get_string(Objectinfo, xUserInfo::remark);
				userInfo->thirduid = parser_get_string(Object, xUserInfo::uid);
				RecentInfo->userinfo = userInfo;


				RecentConactList.push_back(RecentInfo);
				++index;
			}
		}
	};


	//删除最近联系人IM_REMOVE_CONTACTES_REQ 
	struct DelRecentRequest : YaYaRequestBase
	{
		uint32 userid;     //若是好友消息, 则为好友ID

		DelRecentRequest()
			:YaYaRequestBase(IM_FRIEND, IM_REMOVE_CONTACTES_REQ)
		{

		}
		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint32(parser, x12026::userid, userid);
			return parser;
		}
	};

	//删除最近联系人响应 IM_REMOVE_CONTACTES_RESP 
	struct DelRecentRepond :YaYaRespondBase
	{
		uint32 result;  //结果信息     
		std::string msg;     //错误信息
		uint32 userid; //

		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x12027::result);
			msg = parser_get_string(parser, x12027::msg);
			userid = parser_get_uint32(parser, x12027::userid);
		}
	};

	//请求云消息IM_CLOUDMSG_LIMIT_REQ 
	struct CloundMsgRequest : YaYaRequestBase
	{
		std::string source; //来源(userId 好友消息)
		uint32 id;     //若是好友消息, 则为好友ID
		uint32 end;    //获取到位置（endid）
		int limit;     //获取条数 

		CloundMsgRequest()
			:YaYaRequestBase(IM_CLOUND, IM_CLOUDMSG_LIMIT_REQ)
		{

		}
		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_cstring(parser, x15003::source, source.c_str());
			parser_set_uint32(parser, x15003::id, id);
			parser_set_uint32(parser, x15003::index, end);
			parser_set_integer(parser, x15003::limit, limit);
			return parser;
		}
	};

	//请求云消息回应 IM_CLOUDMSG_LIMIT_RESP 
	struct CloundMsgRepond :YaYaRespondBase
	{
		uint32 result;  //结果信息     
		std::string msg;     //错误信息
		std::string source; //来源(userId 好友消息)
		uint32 index;   //起始位置
		uint32 id; //若是好友消息, 则为好友ID
		uint32 limit; //获取条数

		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x15004::result);
			msg = parser_get_string(parser, x15004::msg);
			source = parser_get_string(parser, x15004::source);
			id = parser_get_uint32(parser, x15004::id);
			index = parser_get_uint32(parser, x15004::index);
			limit = parser_get_uint32(parser, x15004::limit);
		}
	};

	//消息状态推送 IM_CHATT_FRIEND_RESP 
	struct FriendMsgStateNotify :YaYaRespondBase
	{
		uint32 result;
		uint32 userid;  //好友ID
		std::string  msg;
		std::string flag;  //消息标记
		uint32 index;
		uint8 type;
		std::string ext1;
		std::string ext;

		void decode(YV_PARSER parser)
		{
			index = parser_get_uint32(parser, x14004::indexid);
			result = parser_get_uint32(parser, x14004::result);
			userid = parser_get_uint32(parser, x14004::userid);
			flag = parser_get_string(parser, x14004::flag);
			msg = parser_get_string(parser, x14004::msg);
			type = parser_get_uint8(parser, x14004::type);
			ext = parser_get_string(parser, x14004::text);
			ext1 = parser_get_string(parser, x14004::ext1);
		}
	};


	//云消息推送 IM_CLOUDMSG_LIMIT_NOTIFY  取历史消息回应
	struct CloundMsgLimitNotify :YaYaRespondBase
	{
		std::string source; //来源(SYSTEM 系统消息 PUSH 推送消息 userId 好友消息)
		uint32 id; //若是好友消息, 则为好友ID
		uint32 count;  //消息数
		uint32 indexId;  //当前消息索引
		uint32 ptime; //当前消息时间
		std::string sourceback;

		//YaYaP2PChatNotify*  packet;  //结束索引内容  xP2PChatMsg,  xGroupChatMsg

		std::vector<YaYaxNotify*> ChatMsglist;

		void decode(YV_PARSER parser)
		{
			this->source = parser_get_string(parser, x15005::source);
			this->id = parser_get_uint32(parser, x15005::id);
			this->count = parser_get_uint32(parser, x15005::count);
			this->indexId = parser_get_uint32(parser, x15005::indexId);
			this->ptime = parser_get_uint32(parser, x15005::ptime);

			//this->indexId = parser_get_uint32(parser, CLOUDMSG_ID);
			this->sourceback = parser_get_string(parser, CLOUDMSG_SOURCE);

			//YV_PARSER yayaParser = yvpacket_get_parser_object(parser);
			//parser_get_object(parser, x15002::packet, yayaParser);

			int index = 0;
			while (true)
			{
				if (parser_is_empty(parser, x15002::packet, index))
					return;

				YV_PARSER yayaParser = yvpacket_get_parser_object(parser);
				parser_get_object(parser, x15002::packet, yayaParser, index);

				if (this->source == CLOUDMSG_FRIEND)
				{
					YaYaP2PChatNotify* p2pmsg = new YaYaP2PChatNotify();

					p2pmsg->userid = parser_get_uint32(yayaParser, xP2PChatMsg::userid);
					p2pmsg->name = parser_get_string(yayaParser, xP2PChatMsg::name);
					p2pmsg->signature = parser_get_string(yayaParser, xP2PChatMsg::signature);
					p2pmsg->headicon = parser_get_string(yayaParser, xP2PChatMsg::headurl);
					p2pmsg->sendtime = parser_get_uint32(yayaParser, xP2PChatMsg::sendtime);
					p2pmsg->type = (e_chat_msgtype)parser_get_uint8(yayaParser, xP2PChatMsg::type);
					p2pmsg->data = parser_get_string(yayaParser, xP2PChatMsg::data);
					p2pmsg->imageurl = parser_get_string(yayaParser, xP2PChatMsg::imageurl);
					p2pmsg->audiotime = parser_get_uint32(yayaParser, xP2PChatMsg::audiotime);
					p2pmsg->attach = parser_get_string(yayaParser, xP2PChatMsg::attach);
					p2pmsg->ext1 = parser_get_string(yayaParser, xP2PChatMsg::ext1);
					p2pmsg->thirduid = parser_get_string(yayaParser, xP2PChatMsg::uid);
					//packet = p2pmsg;

					ChatMsglist.push_back(p2pmsg);

					++index;
				}
				else if (this->source == CLOUDMSG_GROUP)
				{
					YaYaGroupChatNotify* groupmsg = new YaYaGroupChatNotify();

					groupmsg->groupid = parser_get_uint32(yayaParser, xGroupChatMsg::groupid);
					groupmsg->sendid = parser_get_uint32(yayaParser, xGroupChatMsg::sendid);
					groupmsg->sendnickname = parser_get_string(yayaParser, xGroupChatMsg::sendnickname);
					groupmsg->sendheadIconurl = parser_get_string(yayaParser, xGroupChatMsg::sendheadurl);
					groupmsg->groupicon = parser_get_string(yayaParser, xGroupChatMsg::groupicon);
					groupmsg->groupname = parser_get_string(yayaParser, xGroupChatMsg::groupname);
					groupmsg->time = parser_get_uint32(yayaParser, xGroupChatMsg::time);
					groupmsg->type = (e_chat_msgtype)parser_get_uint8(yayaParser, xGroupChatMsg::type);
					groupmsg->data = parser_get_string(yayaParser, xGroupChatMsg::data);
					groupmsg->audiotime = parser_get_uint32(yayaParser, xGroupChatMsg::audiotime);
					groupmsg->attach = parser_get_string(yayaParser, xGroupChatMsg::attach);
					groupmsg->ext1 = parser_get_string(yayaParser, xGroupChatMsg::ext1);
					ChatMsglist.push_back(groupmsg);
					 
					++index;
				}
			
			}

			//char UserID[12] = { 0 };
			//sprintf(UserID, "%d", this->id);
			//char TempID[12] = source.c_str();
			//if (this->source == UserID)
// 			if (this->source == CLOUDMSG_FRIEND)
// 			{
// 				YaYaP2PChatNotify* p2pmsg = new YaYaP2PChatNotify();
// 
// 				p2pmsg->userid = parser_get_uint32(yayaParser, xP2PChatMsg::userid);
// 				p2pmsg->name = parser_get_string(yayaParser, xP2PChatMsg::name);
// 				p2pmsg->signature = parser_get_string(yayaParser, xP2PChatMsg::signature);
// 				p2pmsg->headicon = parser_get_string(yayaParser, xP2PChatMsg::headurl);
// 				p2pmsg->sendtime = parser_get_uint32(yayaParser, xP2PChatMsg::sendtime);
// 				p2pmsg->type = (e_chat_msgtype)parser_get_uint8(yayaParser, xP2PChatMsg::type);
// 				p2pmsg->data = parser_get_string(yayaParser, xP2PChatMsg::data);
// 				p2pmsg->imageurl = parser_get_string(yayaParser, xP2PChatMsg::imageurl);
// 				p2pmsg->audiotime = parser_get_uint32(yayaParser, xP2PChatMsg::audiotime);
// 				p2pmsg->attach = parser_get_string(yayaParser, xP2PChatMsg::attach);
// 				p2pmsg->ext1 = parser_get_string(yayaParser, xP2PChatMsg::ext1);
// 
// 
// 
// 				//packet = p2pmsg;
// 			}
// 			else if (this->source == CLOUDMSG_GROUP)
// 			{
// 				YaYaGroupChatNotify* groupmsg = new YaYaGroupChatNotify();
// 
// 				groupmsg->groupid = parser_get_uint32(yayaParser, xGroupChatMsg::groupid);
// 				groupmsg->sendid = parser_get_uint32(yayaParser, xGroupChatMsg::sendid);
// 				groupmsg->groupicon = parser_get_string(yayaParser, xGroupChatMsg::groupicon);
// 				groupmsg->groupname = parser_get_string(yayaParser, xGroupChatMsg::groupname);
// 				groupmsg->time = parser_get_uint32(yayaParser, xGroupChatMsg::time);
// 				groupmsg->type = (e_chat_msgtype)parser_get_uint8(yayaParser, xGroupChatMsg::type);
// 				groupmsg->data = parser_get_string(yayaParser, xGroupChatMsg::data);
// 				groupmsg->audiotime = parser_get_uint32(yayaParser, xGroupChatMsg::audiotime);
// 
// 				//packet = groupmsg;
// 			}
// 			else
// 			{
// 				//CCLOG("not has this Notify logic:%s", this->source.c_str());
// 			}
		}
	};


	//云消息确认已读  IM_CLOUDMSG_READ_STATUS
	struct CloundMsgReadStatusRequest : YaYaRequestBase
	{
		CloundMsgReadStatusRequest()
		:YaYaRequestBase(IM_CLOUND, IM_CLOUDMSG_READ_STATUS)
		{

		}
		uint32  id;      //对应 CLOUDMSG_ID::110
		std::string	source;  //对应 CLOUDMSG_SOURCE::111

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_cstring(parser, x15007::source, source.c_str());
			parser_set_uint32(parser, x15007::id, id);
			return parser;
		}
	};

	//云消息确认已读回应  IM_CLOUDMSG_READ_RESP
	struct CloundMsgReadStatusbackRequest : YaYaRespondBase
	{
		uint32  result;      //
		std::string	msg;  //
		uint32  id;      //
		std::string	source;  //

		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x15009::result);
			msg = parser_get_string(parser, x15009::msg);
			source = parser_get_string(parser, x15009::source);
			id = parser_get_uint32(parser, x15009::id);
		}
	};


	//好友聊天-文本 IM_CHAT_FRIEND_TEXT_REQ
	struct FriendTextChatRequest :YaYaRequestBase
	{
		FriendTextChatRequest()
		:YaYaRequestBase(IM_CHAT, IM_CHAT_FRIEND_TEXT_REQ)
		{

		}

		uint32 userid; //好友ID
		std::string data; //消息内容
		std::string ext; //扩展字段
		std::string flag;

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_cstring(parser, x14000::data, data.c_str());
			parser_set_uint32(parser, x14000::userid, userid);
			parser_set_cstring(parser, x14000::ext, ext.c_str());
			parser_set_cstring(parser, x14000::flag, flag.c_str());
			return parser;
		}
	};

	//好友聊天-图像 IM_CHAT_FRIEND_IMAGE_REQ
	struct FriendImageChatRequest :YaYaRequestBase
	{
		FriendImageChatRequest()
		:YaYaRequestBase(IM_CHAT, IM_CHAT_FRIEND_IMAGE_REQ)
		{

		}
		uint32 userid; //好友ID
		std::string image; //图片路径
		std::string ext; //扩展字段
		std::string flag;

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_cstring(parser, x14001::image, image.c_str());
			parser_set_uint32(parser, x14001::userid, userid);
			parser_set_cstring(parser, x14001::ext, ext.c_str());
			parser_set_cstring(parser, x14001::flag, flag.c_str());
			return parser;
		}
	};

	//好友聊天 - 语音 IM_CHATI_FRIEND_AUDIO_REQ
	struct FriendVoiceChatRequest :YaYaRequestBase
	{
		FriendVoiceChatRequest()
		:YaYaRequestBase(IM_CHAT, IM_CHATI_FRIEND_AUDIO_REQ)
		{

		}

		uint32 userid; //好友ID
		std::string file; //语音文件路径
		uint32 time; //文件播放时长(秒)
		std::string txt; //附带文本(可选)
		std::string ext; //扩展字段
		std::string flag;

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_cstring(parser, x14002::file, file.c_str());
			parser_set_uint32(parser, x14002::userid, userid);
			parser_set_uint32(parser, x14002::time, time);
			parser_set_cstring(parser, x14002::txt, txt.c_str());
			parser_set_cstring(parser, x14002::ext, ext.c_str());
			parser_set_cstring(parser, x14002::flag, flag.c_str());
			return parser;
		}
	};


	//好友聊天通知 IM_CHAT_FRIEND_NOTIFY
	struct FriendChatNotify :YaYaRespondBase
	{
		uint32 userid; //好友ID
		std::string name; //好友名称
		std::string signature; //好友签名
		std::string headicon; //图像地址
		uint32 sendtime; //发送时间
		e_chat_msgtype  type;//类型 e_chat_msgtype
		std::string data; //若为文本类型，则是消息内容，若为音频，则是文件地址，若为图像，则是大图像地址
		std::string imageurl; //若为音频，则是小图像地址
		uint32 audiotime; //若为音频文件, 则是文件播放时长(秒)
		std::string attach; //若为音频文件，则是附加文本(没有附带文本时为空)
		std::string ext1; //扩展字段
		uint32 index;//消息ID
		std::string source; //消息源
		std::string thirduid; //第三方uid
		void decode(YV_PARSER parser)
		{
			userid = parser_get_uint32(parser, x14003::userid);
			name = parser_get_string(parser, x14003::name);
			signature = parser_get_string(parser, x14003::signature);
			headicon = parser_get_string(parser, x14003::headurl);
			sendtime = parser_get_uint32(parser, x14003::sendtime);
			type = (e_chat_msgtype)parser_get_uint8(parser, x14003::type);
			data = parser_get_string(parser, x14003::data);
			imageurl = parser_get_string(parser, x14003::imageurl);
			audiotime = parser_get_uint32(parser, x14003::audiotime);
			attach = parser_get_string(parser, x14003::attach);
			ext1 = parser_get_string(parser, x14003::ext1);
			//index = parser_get_uint32(parser, CLOUDMSG_ID);
			index = parser_get_uint32(parser, x14003::indexid);
			source = parser_get_string(parser, CLOUDMSG_SOURCE);
			thirduid = parser_get_string(parser, x14003::uid);
		}
	};
	/****************************频道开始***************************/
	//发送频道文字消息请求 IM_CHANNEL_TEXTMSG_REQ
	struct ChannelTextRequest :YaYaRequestBase
	{
		ChannelTextRequest()
		:YaYaRequestBase(IM_CHANNEL, IM_CHANNEL_TEXTMSG_REQ)
		{

		}

		std::string	textMsg; //发送内容
		std::string	wildCard; //通配符
		std::string	expand; //扩展字段
		std::string	       flag;     //消息标记(可不传)
		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_cstring(parser, x16002::textMsg, textMsg.c_str());
			parser_set_cstring(parser, x16002::wildCard, wildCard.c_str());
			parser_set_cstring(parser, x16002::expand, expand.c_str());
			parser_set_cstring(parser, x16002::flag, flag.c_str());
			return parser;
		}
	};

	//发送频道语音消息 IM_CHANNEL_VOICEMSG_REQ	
	struct ChannelVoiceRequest :YaYaRequestBase
	{
		ChannelVoiceRequest()
		:YaYaRequestBase(IM_CHANNEL, IM_CHANNEL_VOICEMSG_REQ)
		{

		}

		std::string			voiceFilePath;     //录音文件路径名
		uint32			voiceDurationTime; //录音时长  单位毫秒
		std::string			wildCard;          // 游戏通道字符串
		std::string          txt;               //附带文本(可选)，不能超过384个字符
		std::string			expand;            //扩展字段
		std::string	       flag;     //消息标记(可不传)
		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_cstring(parser, x16003::voiceFilePath, voiceFilePath.c_str());
			parser_set_cstring(parser, x16003::wildCard, wildCard.c_str());
			parser_set_cstring(parser, x16003::txt, txt.c_str());
			parser_set_cstring(parser, x16003::expand, expand.c_str());
			parser_set_uint32(parser, x16003::voiceDurationTime, voiceDurationTime);
			parser_set_cstring(parser, x16003::flag, flag.c_str());
			return parser;
		}
	};
	//频道发送结果通知 IM_CHANNEL_SENDMSG_RESP 
	struct ChannelMessageStateNotify :YaYaRespondBase
	{
		uint32 result;
		std::string	msg;
		uint32 type;
		std::string	wildCard;
		std::string	textMsg;  //文字消息
		std::string	url;      //语音URL
		uint32 voiceDurationTime;   //录音时长单位(秒)
		std::string	expand;   //透传字段
		bool  shield;		  //是否有敏感字， 1：存在，0不存在
		uint32 channel;       //游戏通道
		std::string	flag;     //消息标记(可不传)


		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x16010::result);
			msg = parser_get_string(parser, x16010::msg);
			type = parser_get_uint32(parser, x16010::type);
			wildCard = parser_get_string(parser, x16010::wildCard);
			textMsg = parser_get_string(parser, x16010::textMsg);
			url = parser_get_string(parser, x16010::url);
			voiceDurationTime = parser_get_uint32(parser, x16010::voiceDurationTime);
			expand = parser_get_string(parser, x16010::expand);
			shield = parser_get_uint8(parser, x16010::shield) == 0 ? false : true;
			channel = parser_get_uint32(parser, x16010::channel);
			flag = parser_get_string(parser, x16010::flag);

		}
	};

	//频道收到消息通知  IM_CHANNEL_MESSAGE_NOTIFY
	struct ChannelMessageNotify :YaYaRespondBase
	{
		uint32	user_id;//用户ID
		std::string	message_body; //消息
		std::string	nickname; //昵称
		std::string	ext1; //扩展1
		std::string	ext2; //扩展2
		uint8	channel; //游戏通道
		std::string	wildcard;//游戏通道字符串
		e_chat_msgtype	message_type;// type= 1 语音  type= 2 文本
		uint32  voiceDuration; //type= 1 语音时 该字段为语音时长
		std::string  attach;//语音消息的附带文本(可选)
		std::string  shield;//是否有敏感字， 1：存在，0不存在
		std::string thirduid;//第三方uid

		void decode(YV_PARSER parser)
		{
			user_id = parser_get_uint32(parser, x16004::user_id);
			message_body = parser_get_string(parser, x16004::message_body);
			nickname = parser_get_string(parser, x16004::nickname);
			ext1 = parser_get_string(parser, x16004::ext1);
			ext2 = parser_get_string(parser, x16004::ext2);

			channel = parser_get_uint8(parser, x16004::channel);
			wildcard = parser_get_string(parser, x16004::wildcard);

			message_type = (e_chat_msgtype)parser_get_uint32(parser, x16004::message_type);

			voiceDuration = parser_get_uint32(parser, x16004::voiceDuration);
			attach = parser_get_string(parser, x16004::attach);
			shield = parser_get_uint8(parser, x16004::shield) == 0 ? false : true;
			thirduid = parser_get_string(parser, x16004::uid);
		}
	};


	//	IM_CHANNEL_PUSH_MSG_NOTIFY////频道PUSH消息通知，可以使用例如系统消息的推送， 需要服务器配置
	struct ChannelPushMessageNotify :YaYaRespondBase
	{
		std::string	type; //消息类型
		std::string	data; //推送数据
		void decode(YV_PARSER parser)
		{
			type = parser_get_string(parser, x16013::type);
			data = parser_get_string(parser, x16013::data);
		}
	};
//
	//频道历史消息请求 IM_CHANNEL_HISTORY_MSG_REQ
	struct ChannelHistoryRequest :YaYaRequestBase
	{
		ChannelHistoryRequest()
		:YaYaRequestBase(IM_CHANNEL, IM_CHANNEL_HISTORY_MSG_REQ)
		{

		}

		uint32	index;				//消息索引	(当前最大索引号,索引为0请求最后count条记录)
		int	count; 				//请求条数	正数为index向后请求 负数为index向前请求 (时间排序)
		std::string	wildCard;           //通配符

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint32(parser, x16005::index, index);
			parser_set_integer(parser, x16005::count, count);
			parser_set_cstring(parser, x16005::wildcard, wildCard.c_str());

			return parser;
		}
	};

	////room消息列表
	struct YaYaChannelHistoryMsgInfo
	{
		uint32	index;			//消息索引
		std::string	ctime;			//消息时间 2015-02 10:50:13
		uint32	user_id;			//用户ID
		std::string	message_body;			//消息
		std::string	nickname;			//昵称
		std::string	ext1;			//扩展1
		std::string	ext2;			//扩展2
		uint8	channel;			//游戏通道
		std::string	wildcard;			//游戏通道字符串
		e_chat_msgtype	message_type; 			//type= 1 语音  type= 2 文本
		uint32  voiceDuration;			//type= 1 语音时 该字段为语音时长
		std::string  attach;			//语音消息的附带文本(可选)	
		std::string  thirduid; //第三方uid;
	};

	//频道历史消息返回 IM_CHANNEL_HISTORY_MSG_RESP
	struct ChannelHistoryNotify :YaYaRespondBase
	{
		std::vector<YaYaChannelHistoryMsgInfo> xHistoryMsg;

		void decode(YV_PARSER parser)
		{
			int index = 0;
			while (true)
			{
				if (parser_is_empty(parser, x16006::xHistoryMsg, index))
					return;

				YV_PARSER Object = yvpacket_get_parser_object(parser);
				parser_get_object(parser, x16006::xHistoryMsg, Object, index);

				YaYaChannelHistoryMsgInfo info;
				info.index = parser_get_uint32(Object, xHistoryMsgInfo::index);
				info.ctime = parser_get_string(Object, xHistoryMsgInfo::ctime);
				info.user_id = parser_get_uint32(Object, xHistoryMsgInfo::user_id);
				info.message_body = parser_get_string(Object, xHistoryMsgInfo::message_body);
				info.nickname = parser_get_string(Object, xHistoryMsgInfo::nickname);
				info.ext1 = parser_get_string(Object, xHistoryMsgInfo::ext1);
				info.ext2 = parser_get_string(Object, xHistoryMsgInfo::ext2);
				info.channel = parser_get_uint8(Object, xHistoryMsgInfo::channel);
				info.wildcard = parser_get_string(Object, xHistoryMsgInfo::wildcard);
				info.message_type = (e_chat_msgtype)parser_get_uint32(Object, xHistoryMsgInfo::message_type);
				info.voiceDuration = parser_get_uint32(Object, xHistoryMsgInfo::voiceDuration); 			//type= 1 语音  type= 2 文本
				info.attach = parser_get_string(Object, xHistoryMsgInfo::attach); 			//type= 1 语音时 该字段为语音时长
				info.thirduid = parser_get_string(Object, xHistoryMsgInfo::uid);
				xHistoryMsg.push_back(info);
				++index;
			}
		}
	};


	//频道修改
	struct ModChannelIdRequest :YaYaRequestBase
	{
		ModChannelIdRequest()
		:YaYaRequestBase(IM_CHANNEL, IM_CHANNEL_MODIFY_REQ)
		{

		}

		uint32	channel; ////通道（0-9）
		uint32 operate;  //0：移除，1：添加
		std::string	wildCard; //通配符
		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint32(parser, x16011::operate, operate);
			parser_set_cstring(parser, x16011::wildCard, wildCard.c_str());
			parser_set_uint32(parser, x16011::channel, channel);
			return parser;
		}
	};


	//登录 注:登录账号传入了通配符，会直接登录， 不需要再调此登录
	struct ChannelLoginRequest :YaYaRequestBase
	{
		ChannelLoginRequest()
		:YaYaRequestBase(IM_CHANNEL, IM_CHANNEL_LOGIN_REQ)
		{

		}
		std::string	pgameServiceID; ///游戏服务ID
		std::vector<std::string> wildCard; //通配符
		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_cstring(parser, x16007::pgameServiceID, pgameServiceID.c_str());
			for (std::vector<std::string>::iterator it = wildCard.begin(); it < wildCard.end(); ++it)
			{
				parser_set_cstring(parser, x11002::wildCard, it->c_str());
			}
			return parser;
		}
	};


	//频道修改返回
	struct ModChannelIdRespond :YaYaRespondBase
	{
		std::string	msg; //
		uint32 result;  
		std::vector<std::string>  wildCard;   //通配符
		//std::string wildCard[10];

		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x16012::result);
			msg = parser_get_string(parser, x16012::msg);
			//wildCard = parser_get_string(parser, x16012::wildCard);
// 			for (int i = 0; true; ++i)
// 			{
// 				if (parser_is_empty(parser, x16012::wildCard, i))
// 					break;
// 				wildCard[i] = parser_get_string(parser, x16012::wildCard, i);
// 			}
			int index = 0;
			while (true)
			{
				if (parser_is_empty(parser, x16012::wildCard, index))
					return;

				//YV_PARSER Object = yvpacket_get_parser_object(parser);
				//parser_get_object(parser, x16012::wildCard, Object, index);

				std::string  wildCardstr = parser_get_string(parser, x16012::wildCard, index);

				wildCard.push_back(wildCardstr);
				++index;
			}

		}
	};

	//频道登录返回  //IM_CHANNEL_LOGIN_RESP
	struct ChanngelLonginRespond :YaYaRespondBase
	{
		std::string	msg; //
		uint32 result;
		std::vector<std::string>  wildCard;   //通配符
		std::string announcement;//公告
		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x16008::result);
			msg = parser_get_string(parser, x16008::msg);
			//wildCard = parser_get_string(parser, x16008::wildCard);
			announcement = parser_get_string(parser, x16008::announcement);

			int index = 0;
			while (true)
			{
				if (parser_is_empty(parser, x16012::wildCard, index))
					return;

				std::string  wildCardstr = parser_get_string(parser, x16008::wildCard, index);
				wildCard.push_back(wildCardstr);
				++index;
			}
		}
	};

	// 设置频道发送消息时间间隔限制 //IM_CHANNEL_SET_SENDTIME_REQ
	struct SetChannelSendTime :YaYaRequestBase
	{
		uint32 times;
		SetChannelSendTime()
			:YaYaRequestBase(IM_CHANNEL, IM_CHANNEL_SET_SENDTIME_REQ)
		{

		}

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint32(parser, x16016::time, times);
			return parser;
		}
	};



	/****************************频道结束***************************/

	/****************************工具开始***************************/
	//网络状态通知IM_NET_STATE_NOTIFY
	struct NetWorkStateNotify :YaYaRespondBase
	{
		yv_net state;
		void decode(YV_PARSER parser)
		{
			state = (yv_net)parser_get_uint8(parser, x11016::state);
		}
	};

	//设置录音时长 IM_RECORD_SETINFO_REQ
	struct SetRecordRequest :YaYaRequestBase
	{
		uint32 times;
		uint8 volume;
		SetRecordRequest()
			:YaYaRequestBase(IM_TOOLS, IM_RECORD_SETINFO_REQ)
		{

		}

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint32(parser, x19014::times, times);
			parser_set_uint8(parser, x19014::volume, volume);
			return parser;
		}
	};

	//开始录音(最长60秒)  IM_RECORD_STRART_REQ	
	struct StartRecordRequest :YaYaRequestBase
	{
		std::string strFilePath;
		std::string  ext;
		StartRecordRequest()
			:YaYaRequestBase(IM_TOOLS, IM_RECORD_STRART_REQ)
		{

		}

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_cstring(parser, x19000::strfilepath, strFilePath.c_str());
			parser_set_cstring(parser, x19000::ext, ext.c_str());
			parser_set_uint8(parser, x19000::speech, 0);
			return parser;
		}
	};

	//结束录音(最长60秒)  IM_RECORD_STOP_REQ
	struct StopRecordRequest :YaYaRequestBase
	{
		StopRecordRequest()
		:YaYaRequestBase(IM_TOOLS, IM_RECORD_STOP_REQ)
		{
		}

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			return parser;
		}
	};

	//停止录音返回  回调返回录音文件路径名  IM_RECORD_STOP_RESP
	struct RecordStopNotify :YaYaRespondBase
	{
		RecordStopNotify(){ strfilepath = NULL; }
		~RecordStopNotify(){  }
		
		uint32	time; //录音时长
		YVFilePathPtr strfilepath; //录音保存文件路径名
		std::string ext;
		
		void decode(YV_PARSER parser)
		{
			time = parser_get_uint32(parser, x19002::time);
			std::string path = parser_get_string(parser, x19002::strfilepath);
			ext = parser_get_string(parser, x19002::ext);
			//strfilepath = YVFilePath::getLocalPath(path);
		}
	};

	//录音音量大小通知 IM_RECORD_VOLUME_NOTIFY
	struct RecordVoiceNotify
		:YaYaRespondBase
	{
		std::string ext;  //扩展标记
		uint8       volume;  //音量大小(0-100)
		void decode(YV_PARSER parser)
		{
			volume = parser_get_uint8(parser, x19015::volume);
			ext = parser_get_string(parser, x19015::ext);
		}
	};

	//播放录音请求	IM_RECORD_STARTPLAY_REQ	
	struct StartPlayVoiceRequest :YaYaRequestBase
	{
		StartPlayVoiceRequest()
		:YaYaRequestBase(IM_TOOLS, IM_RECORD_STARTPLAY_REQ)
		{
		}
		std::string	strUrl;      // 录音url	
		std::string	strfilepath;  //录音文件
		std::string ext;
		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_cstring(parser, x19003::strUrl, strUrl.c_str());
			parser_set_cstring(parser, x19003::strfilepath, strfilepath.c_str());
			parser_set_cstring(parser, x19003::ext, ext.c_str());
			return parser;
		}
	};

	//播放语音完成	IM_RECORD_FINISHPLAY_RESP
	struct StartPlayVoiceRespond :YaYaRespondBase
	{
		uint32    result; //播放完成为 0， 失败为1
		std::string    describe; //描述
		YVFilePathPtr filePath;

		std::string  ext;    
		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x19004::result);
			describe = parser_get_string(parser, x19004::describe);
			ext = parser_get_string(parser, x19004::ext);
		}
	};

	//停止播放语音  IM_RECORD_STOPPLAY_REQ
	struct StopPlayVoiceRequest :YaYaRequestBase
	{
		StopPlayVoiceRequest()
		:YaYaRequestBase(IM_TOOLS, IM_RECORD_STOPPLAY_REQ)
		{
		}

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			return parser;
		}
	};

	//语音识别设置 IM_SPEECH_SETLANGUAGE_REQ
	struct SpeechSetRequest :YaYaRequestBase
	{
		SpeechSetRequest()
		:YaYaRequestBase(IM_TOOLS, IM_SPEECH_SETLANGUAGE_REQ)
		{
		}
		yvimspeech_language language;
		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint8(parser, x19008::inlanguage, language);
			return parser;
		}
	};

	//开始语音识别 IM_SPEECH_START_REQ	
	struct SpeechStartRequest :YaYaRequestBase
	{
		SpeechStartRequest()
		:YaYaRequestBase(IM_TOOLS, IM_SPEECH_START_REQ)
		{
		}
		std::string strfilepath;
		std::string ext;
		yvspeech   type;
		std::string    url;
		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_cstring(parser, x19006::strfilepath, strfilepath.c_str());
			parser_set_cstring(parser, x19006::ext, ext.c_str());
			parser_set_uint8(parser, x19006::type, type);
			parser_set_cstring(parser, x19006::url, url.c_str());
			return parser;
		}
	};

	//停止语音识别回应 IM_SPEECH_STOP_RESP	
	struct SpeechStopRespond :YaYaRespondBase
	{
		uint32		err_id;   //0为成功
		std::string		err_msg;  //返回的错误描述
		std::string		result;   //结果
		std::string ext;

		YVFilePathPtr filePath;

		std::string url;    //识别时使用了上传功能，这个会返回url
		void decode(YV_PARSER parser)
		{
			err_id = parser_get_uint32(parser, x19009::err_id);
			err_msg = parser_get_string(parser, x19009::err_msg);
			result = parser_get_string(parser, x19009::result);
			ext = parser_get_string(parser, x19009::ext);
			url = parser_get_string(parser, x19009::url);
		}
	};

	//请求上传文件  IM_UPLOAD_FILE_REQ 
	struct UpLoadFileRequest :YaYaRequestBase
	{
		UpLoadFileRequest()
		:YaYaRequestBase(IM_TOOLS, IM_UPLOAD_FILE_REQ)
		{
		}
		std::string filename;
		std::string fileid;
		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_cstring(parser, x19010::filename, filename.c_str());
			parser_set_cstring(parser, x19010::fileid, fileid.c_str());
			return parser;
		}
	};

	//上传文件请求回应 IM_UPLOAD_FILE_RESP
	struct UpLoadFileRespond :YaYaRespondBase
	{
		uint32	result;
		std::string  msg;        //错误描述
		std::string  fileid;     //文件ID
		std::string  fileurl;    //返回文件地址
		uint32  percent;    //完成百分比

		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x19011::result);
			msg = parser_get_string(parser, x19011::msg);
			fileid = parser_get_string(parser, x19011::fileid);
			fileurl = parser_get_string(parser, x19011::fileurl);
			percent = parser_get_uint32(parser, x19011::percent);
		}
	};

	//请求下载文件  IM_DOWNLOAD_FILE_REQ 
	struct DownLoadFileRequest :YaYaRequestBase
	{
		DownLoadFileRequest()
		:YaYaRequestBase(IM_TOOLS, IM_DOWNLOAD_FILE_REQ)
		{
		}
		std::string url;
		std::string filename;
		std::string fileid;
		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_cstring(parser, x19012::url, url.c_str());
			parser_set_cstring(parser, x19012::filename, filename.c_str());
			parser_set_cstring(parser, x19012::fileid, fileid.c_str());
			return parser;
		}
	};

	//下载文件回应 IM_DOWNLOAD_FILE_RESP 
	struct DownLoadFileRespond :YaYaRespondBase
	{
		uint32	result;     //返回码 0：成功，其他失败
		std::string  msg;        //错误描述
		
		std::string  fileid;     //文件ID
		uint32  percent;    //完成百分比
		YVFilePathPtr  path;   //文件路径

		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x19013::result);
			msg = parser_get_string(parser, x19013::msg);
			std::string filename = parser_get_string(parser, x19013::filename);
			//path = YVFilePath::getLocalPath(filename);
			fileid = parser_get_string(parser, x19013::fileid);
			percent = parser_get_uint32(parser, x19013::percent);
		}
	};

	//设备号等操作IM_DEVICE_SETINFO
	struct SetDeviceInfoReqeust : YaYaRequestBase
	{
		SetDeviceInfoReqeust()
		:YaYaRequestBase(IM_LOGIN, IM_DEVICE_SETINFO)
		{
		}
		std::string imsi;
		std::string imei;
		std::string mac;
		std::string appVersion;
		std::string networkType;

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_cstring(parser, x11012::imsi, imsi.c_str());
			parser_set_cstring(parser, x11012::imei, imei.c_str());
			parser_set_cstring(parser, x11012::mac, mac.c_str());
			parser_set_cstring(parser, x11012::appVersion, appVersion.c_str());
			parser_set_cstring(parser, x11012::networkType, networkType.c_str());
			return parser;
		}
	};
	/****************************工具结束***************************/
//===============新加LBS
	/****************************LBS开始***************************/
#if 1
	//更新地理位置请求  IM_LBS_UPDATE_LOCATION_REQ
	struct UpdatelocationRequest :YaYaRequestBase
	{
		UpdatelocationRequest()
		:YaYaRequestBase(IM_LBS, IM_LBS_UPDATE_LOCATION_REQ)
		{
		}
		std::string attach;
		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_cstring(parser, x18000::attach, attach.c_str());
			return parser;
		}
	};

	//更新地理位置完成	IM_LBS_UPDATE_LOCATION_RESP
	struct UpdatelocationRespond :YaYaRespondBase
	{
		uint32    result;		//完成为 0， 失败为1
		std::string    msg; //描述

		std::string  ext;
		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x18001::result);
			msg = parser_get_string(parser, x18001::msg);
		}
	};
	//获取位置信息请求(包括更新位置)  IM_LBS_GET_LOCATION_REQ
	struct GetlocationRequest :YaYaRequestBase
	{
		GetlocationRequest()
		:YaYaRequestBase(IM_LBS, IM_LBS_GET_LOCATION_REQ)
		{
		}

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			return parser;
		}
	};

	//获取位置信息请求回应 IM_LBS_GET_LOCATION_RESP 
	struct GetlocationRespond :YaYaRespondBase
	{
		uint32	result;     //返回码 0：成功，其他失败
		std::string  msg;        //错误描述

		std::string  city;     //城市
		std::string  province;   //省份
		std::string  district;   //区，县
		std::string  detail;     //詊细地址
		std::string  longitude;     //经度
		std::string  latitude;     //纬度


		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x18003::result);
			msg = parser_get_string(parser, x18003::msg);

			//path = YVFilePath::getLocalPath(filename);
			city = parser_get_string(parser, x18003::city);
			province = parser_get_string(parser, x18003::province);
			district = parser_get_string(parser, x18003::district);
			detail = parser_get_string(parser, x18003::detail);
			longitude = parser_get_string(parser, x18003::longitude);
			latitude = parser_get_string(parser, x18003::latitude);
		}
	};

	//搜索（附近）用户(包括更新位置)  IM_LBS_SEARCH_AROUND_REQ
	struct SearchAroundRequest :YaYaRequestBase
	{
		SearchAroundRequest()
		:YaYaRequestBase(IM_LBS, IM_LBS_SEARCH_AROUND_REQ)
		{
		}

		uint32	range;     //搜索范围，默认值100000，单位：米 （可选）
		//std::string  msg;        //错误描述

		std::string  city;     ////所在城市,（可选）
		uint8	sex;     //性别:0 不限 1男 2女,保留（可选）
		uint32	time;     //在此时间内活跃，最大有效值为2880（60*24*2，两天）单位：分钟 (可选)
		uint32	pageIndex;  //当前页号，必填
		uint32	pageSize;    //分页长度，必填(pageSize < 32)
		std::string  ext;     ////扩展字段

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint32(parser, x18004::range, range);
			parser_set_cstring(parser, x18004::city, city.c_str());
			parser_set_uint8(parser, x18004::sex, sex);
			parser_set_uint32(parser, x18004::time, time);
			parser_set_uint32(parser, x18004::pageIndex, pageIndex);
			parser_set_uint32(parser, x18004::pageSize, pageSize);
			parser_set_cstring(parser, x18004::ext, ext.c_str());
			return parser;
		}
	};

	struct AroundUser
	{
		uint32 id; //云娃id
		std::string nickName; //用户昵称
		uint8 sex;
		std::string  city;     //城市
		std::string  headicon;   //头像地址
		uint32  distance;   //距离，单位：米
		std::string  lately;     //最近活跃时间
		std::string  longitude;     //经度
		std::string  latitude;     //纬度
		std::string Ext; //扩展字段
		std::string uid; //用户id
		std::string attach; //用户自定义字段
	};

	//搜索好友回应 IM_LBS_SEARCH_AROUND_RESP  
	struct SearchAroundRespond :YaYaRespondBase
	{
		uint32		result;
		std::string msg;
		std::vector<AroundUser> searchRetInfo;

		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x18005::result);
			msg = parser_get_string(parser, x18005::msg);
			int index = 0;
			while (true)
			{
				if (parser_is_empty(parser, x18005::user, index))
					return;

				YV_PARSER Object = yvpacket_get_parser_object(parser);
				parser_get_object(parser, x18005::user, Object, index);

				AroundUser user;
				user.id = parser_get_uint32(Object, xAroundUser::id);
				user.nickName = parser_get_string(Object, xAroundUser::nickname);
				user.sex = parser_get_uint8(Object, xAroundUser::sex);
				user.city = parser_get_string(Object, xAroundUser::city);
				user.headicon = parser_get_string(Object, xAroundUser::headicon);
				user.distance = parser_get_uint32(Object, xAroundUser::distance);
				user.lately = parser_get_string(Object, xAroundUser::lately);
				user.longitude = parser_get_string(Object, xAroundUser::longitude);
				user.latitude = parser_get_string(Object, xAroundUser::latitude);
				user.Ext = parser_get_string(Object, xAroundUser::ext);
				user.uid = parser_get_string(Object, xAroundUser::uid);
				user.attach = parser_get_string(Object, xAroundUser::attach);
				searchRetInfo.push_back(user);
				++index;
			}
		}
	};
	//隐藏地理位置请求  IM_LBS_SHARE_LOCATION_REQ
	struct LbsShareRequest :YaYaRequestBase
	{
		LbsShareRequest()
		:YaYaRequestBase(IM_LBS, IM_LBS_SHARE_LOCATION_REQ)
		{
		}

		uint8	hide;  //必填，0 分享 1 隐藏，默认为0

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint8(parser, x18006::hide, hide);
			return parser;
		}
	};

	//隐藏地理位置完成	IM_LBS_SHARE_LOCATION_RESP
	struct LbsShareRespond :YaYaRespondBase
	{
		uint32    result;		//完成为 0， 失败为1
		std::string    msg; //描述

		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x18007::result);
			msg = parser_get_string(parser, x18007::msg);
		}
	};

	//获取支持的（包括搜索、返回信息等）本地化语言列表请求  IM_LBS_GET_SUPPORT_LANG_REQ
	struct LbsGetSupportlangRequest :YaYaRequestBase
	{
		LbsGetSupportlangRequest()
		:YaYaRequestBase(IM_LBS, IM_LBS_GET_SUPPORT_LANG_REQ)
		{
		}

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			return parser;
		}
	};
	struct Language
	{
		std::string lang_code;      //语言编号, 如：zn-CN
		std::string lang_name;		//语言名称, 如：简体中文
	};
	//获取语言完成	IM_LBS_GET_SUPPORT_LANG_RESP
	struct LbsGetSupportlangRespond :YaYaRespondBase
	{
		uint32    result;		//完成为 0， 失败为1
		std::string    msg; //描述
		std::vector<Language> language;  //语言列表
		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x18009::result);
			msg = parser_get_string(parser, x18009::msg);

			int index = 0;
			while (true)
			{
				if (parser_is_empty(parser, x18009::language, index))
					return;

				YV_PARSER Object = yvpacket_get_parser_object(parser);
				parser_get_object(parser, x18009::language, Object, index);


				Language Language;

				Language.lang_code = parser_get_string(Object, xLanguage::lang_code);
				Language.lang_name = parser_get_string(Object, xLanguage::lang_name);
				index++;
			}
		}
	};

	//设置LBS本地化语言  IM_LBS_SET_LOCAL_LANG_REQ
	struct LbsSetLocalLangRequest :YaYaRequestBase
	{
		LbsSetLocalLangRequest()
		:YaYaRequestBase(IM_LBS, IM_LBS_SET_LOCAL_LANG_REQ)
		{
		}

		std::string lang_code;      //语言编号, 默认为zh-CN
		std::string lang_name;		//语言名称, 默认为CN

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_cstring(parser, x18010::lang_code, lang_code.c_str());
			parser_set_cstring(parser, x18010::country_code, lang_name.c_str());
			return parser;
		}
	};

	//设置LBS本地化语言完成	IM_LBS_SET_LOCAL_LANG_RESP
	struct LbsSetLocalLangRespond :YaYaRespondBase
	{
		uint32    result;		//完成为 0， 失败为1
		std::string    msg; //描述
		std::string    lang_code;  ////语言编号

		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x18011::result);
			msg = parser_get_string(parser, x18011::msg);
			lang_code = parser_get_string(parser, x18011::lang_code);
		}
	};

	//设置定位方式  IM_LBS_SET_LOCATING_TYPE_REQ
	struct LbsSetLocatingRequest :YaYaRequestBase
	{
		LbsSetLocatingRequest()
		:YaYaRequestBase(IM_LBS, IM_LBS_SET_LOCATING_TYPE_REQ)
		{
		}

		uint8 locate_gps;			 //可选，定位方式 GPS: 0 开 1 关， 默认为0
		uint8 locate_wifi;			 //可选，定位方式 WIFI:0 开 1 关， 默认为0
		uint8 locate_cell;			 //可选，定位方式 基站:0 开 1 关， 默认为0
		uint8 locate_network;		 //可选，定位方式 网络:0 开 1 关， 默认为0
		uint8 locate_bluetooth;      //暂不可用，定位方式 蓝牙

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint8(parser, x18012::locate_gps, locate_gps);
			parser_set_uint8(parser, x18012::locate_wifi, locate_wifi);
			parser_set_uint8(parser, x18012::locate_cell, locate_cell);
			parser_set_uint8(parser, x18012::locate_network, locate_network);
			parser_set_uint8(parser, x18012::locate_bluetooth, locate_bluetooth);
			return parser;
		}
	};

	//设置定位方式完成	IM_LBS_SET_LOCATING_TYPE_RESP
	struct LbsSetLocatingRespond :YaYaRespondBase
	{
		uint32    result;		//完成为 0， 失败为1
		std::string    msg; //描述

		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x18013::result);
			msg = parser_get_string(parser, x18013::msg);
		}
	};
#endif
	/****************************LBS结束***************************/

	/****************************群功能开始***************************/
#if 1

	//enum e_groupverify {
	//	gv_allow = 1,	//不需要验证
	//	//gv_answer	  =	2,	//答题验证 暂时不支持
	//	gv_audit = 3,	//管理员审核
	//	gv_not_allow = 4,	//群不允许加入
	//};
	

	struct  GroupUserInfo 
	{
		uint32 userId;//用户ID
		std::string nickname;//用户昵称
		std::string iconurl;//头像
		uint8 sex;//性别
		std::string alias;//名片
		uint8 role;//角色
		//uint8 level; //等级暂时用不到
		//uint32 grade;//积分暂时用不到
		uint32 lately_online;//最后一次上线时间
		uint8 online; //是否在线
		std::string thirduid;//第三方uid
	};


	struct  GroupItemInfo
	{
		uint32 groupid;//群ID
		uint32 ownerid;//拥有者ID
		uint8 verify; //群验证方式
		std::string groupname;

		std::string groupicon;//群头像
		uint32 numbercount;//总共人数
		uint32 currentnum;//加入人数
		std::string announcement;//群宣言

		//uint8 level;//user等级 暂时用不到
		uint8 msg_set;//群消息设置
		uint8 role;//我在群中的角色  gr_owners	= 2群所有者; 3群管理者;4群成员;10群游客
		GroupItemInfo()
		{
			msg_set = 1;
			role = 10;
		}
	};

	//修改资料通知  
	struct GroupUserMdy :YaYaRespondBase
	{
		uint32 groupid;//群id
		uint32 userId; //用户ID	
		std::string name;//群名称
		std::string icon;//群图标
		std::string announcement;//群公告
		uint8 verify; //验证方式
		std::string alias; //名片修改

		void decode(YV_PARSER parser)
		{
			groupid = 	parser_get_uint32(parser, x13001::groupid);
			userId = parser_get_uint32(parser, x13001::userId);
			name = parser_get_string(parser, x13001::name);
			icon = parser_get_string(parser, x13001::icon);
			announcement = parser_get_string(parser, x13001::announcement);
			verify = parser_get_uint8(parser, x13001::verify);
			alias = parser_get_string(parser, x13001::alias);
		}
	};


	//群用户列表 IM_GROUP_USERLIST_NOTIFY 
	struct GroupUserListNotify :YaYaRespondBase
	{
		uint32 groupid;		//群ID
		std::vector<GroupUserInfo*> GroupUserlist; //群用户列表

		void decode(YV_PARSER parser)
		{
			groupid = parser_get_uint32(parser, x13000::groupid);
			int index = 0;
			while (true)
			{
				if (parser_is_empty(parser, x13000::xGroupUser, index))
					return;

				YV_PARSER yayaParser = yvpacket_get_parser_object(parser);
				parser_get_object(parser, x13000::xGroupUser, yayaParser, index);

			
				GroupUserInfo* groupUserInfo = new GroupUserInfo();
				groupUserInfo->userId = parser_get_uint32(yayaParser, xGroupUser::userId);
				groupUserInfo->nickname = parser_get_string(yayaParser, xGroupUser::nickname);
				groupUserInfo->iconurl = parser_get_string(yayaParser, xGroupUser::iconurl);
				groupUserInfo->sex = parser_get_uint8(yayaParser, xGroupUser::sex);
				groupUserInfo->alias = parser_get_string(yayaParser, xGroupUser::alias);
				groupUserInfo->role = parser_get_uint32(yayaParser, xGroupUser::role);
			/*	groupUserInfo->level = parser_get_uint8(yayaParser, xGroupUser::level);
				groupUserInfo->grade = parser_get_uint32(yayaParser, xGroupUser::grade);*/
				groupUserInfo->lately_online = parser_get_uint32(yayaParser, xGroupUser::lately_online);
				groupUserInfo->online = parser_get_uint8(yayaParser, xGroupUser::online);
				groupUserInfo->thirduid = parser_get_string(yayaParser, xGroupUser::uid);
				GroupUserlist.push_back(groupUserInfo);
				++index;
				}
			}
	};


	//创建群  IM_GROUP_CREATE_REQ
	struct GroupCreateRequest :YaYaRequestBase
	{
		GroupCreateRequest()
		:YaYaRequestBase(IM_GROUPS, IM_GROUP_CREATE_REQ)
		{
		}
		uint8 verify;//群验证方式 e_groupverify
		std::string name;//群名称
		std::string iconUrl;//群头像

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint8(parser, x13002::verify, verify);
			parser_set_cstring(parser, x13002::name, name.c_str());
			parser_set_cstring(parser, x13002::iconUrl, iconUrl.c_str());
			return parser;
		}
	};



	//创建群回应 IM_GROUP_CREATE_RESP 
	struct GroupCreateRespond :YaYaRespondBase
	{
		uint32	result;     //返回码 0：成功，其他失败
		std::string  msg;   //错误描述
		uint32 groupid;		//群ID
		 
		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x13003::result);
			msg = parser_get_string(parser, x13003::msg);
			groupid = parser_get_uint32(parser, x13003::groupid);
		}
	};


	//搜索群  IM_GROUP_SEARCH_REQ
	struct GroupSearchRequest :YaYaRequestBase
	{
		GroupSearchRequest()
		:YaYaRequestBase(IM_GROUPS, IM_GROUP_SEARCH_REQ)
		{
		}
		uint32 groupid;//群ID
		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint32(parser, x13004::groupid, groupid);
			return parser;
		}
	};


	//搜索群回应 IM_GROUP_SEARCH_RESP 
	struct GroupSearchRespond :YaYaRespondBase
	{
		uint32	result;     //返回码 0：成功，其他失败
		std::string  msg;   //错误描述
		uint32 groupid;		//群ID
		uint8 verify; //群验证方式
		std::string name;//群名称
		std::string iconurl; //图标
		uint32 numbercount; //总共人数
		uint32 currentnum;//加入人数
		uint32 ownerid; //拥有者ID
		std::string announcement;//群宣言

		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x13005::result);
			msg = parser_get_string(parser, x13005::msg);
			groupid = parser_get_uint32(parser, x13005::groupid);
			verify = parser_get_uint8(parser, x13005::verify);
			name = parser_get_string(parser, x13005::name);
			iconurl = parser_get_string(parser, x13005::iconurl);
			numbercount = parser_get_uint32(parser, x13005::numbercount);
			currentnum = parser_get_uint32(parser, x13005::currentnum);
			ownerid = parser_get_uint32(parser, x13005::ownerid);
			announcement = parser_get_string(parser, x13005::announcement);
		}
	};


	//加入群  IM_GROUP_JOIN_REQ
	struct GroupJoinRequest :YaYaRequestBase
	{
		GroupJoinRequest()
		:YaYaRequestBase(IM_GROUPS, IM_GROUP_JOIN_REQ)
		{
		}
		uint32 groupid;//群ID
		std::string greet;//问候语
		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint32(parser, x13006::groupid, groupid);
			parser_set_cstring(parser, x13006::greet, greet.c_str());
			return parser;
		}
	};


	//加入群回应 IM_GROUP_JOIN_RESPON 
	struct GroupJoinRespond :YaYaRespondBase
	{
		uint32	result;     //返回码 0：成功，其他失败
		std::string  msg;   //错误描述
		uint32 groupid;		//群ID

		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x13036::result);
			msg = parser_get_string(parser, x13036::msg);
			groupid = parser_get_uint32(parser, x13036::groupid);
		}
	};


	//申请加群结果通知 IM_GROUP_JOIN_RESP 
	struct GroupJoinCallRespond :YaYaRespondBase
	{
		uint32 groupid;		//群ID
		uint32 userid; //用户(处理人)ID
		uint8 agree; //是否同意加入群  0, //拒绝    1, //同意
		std::string groupname; //群名称
		std::string greet;//问候语
		std::string iconurl;//用户头像地址

		void decode(YV_PARSER parser)
		{
			groupid = parser_get_uint32(parser, x13009::groupid);
			userid = parser_get_uint32(parser, x13009::userid);
			agree = parser_get_uint8(parser, x13009::agree);
			groupname = parser_get_string(parser, x13009::groupname);
			greet = parser_get_string(parser, x13009::greet);
			iconurl = parser_get_string(parser, x13009::iconurl);
		}
	};

	//加入群通知(群主/管理员接收) IM_GROUP_JOIN_NOTIFY 
	struct GroupJoinNotify :YaYaRespondBase
	{
		uint32 groupid;		//群ID
		uint32 userid; //用户ID
		std::string username; //用户名
		std::string groupname; //群名称
		std::string greet;//问候语
		std::string iconurl;//用户头像地址

		void decode(YV_PARSER parser)
		{
			groupid = parser_get_uint32(parser, x13007::groupid);
			userid = parser_get_uint32(parser, x13007::userid);
			username = parser_get_string(parser, x13007::username);
			groupname = parser_get_string(parser, x13007::groupname);
			greet = parser_get_string(parser, x13007::greet);
			iconurl = parser_get_string(parser, x13007::iconurl);
		}
	};


	//同意/拒绝加群  IM_GROUP_JOIN_ACCEPT
	struct GroupJoinAcceptRequest :YaYaRequestBase
	{
		GroupJoinAcceptRequest()
		:YaYaRequestBase(IM_GROUPS, IM_GROUP_JOIN_ACCEPT)
		{
		}
		uint32 groupid;//群id
		uint32 userid;//用户（申请者）ID
		uint8 agree;//是否同意加入群  0, //拒绝    1, //同意
		std::string greet;//拒绝原因
	
		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint32(parser, x13008::groupid, groupid);
			parser_set_uint32(parser, x13008::userid, userid);
			parser_set_uint8(parser, x13008::agree, agree);
			parser_set_cstring(parser, x13008::greet, greet.c_str());
			return parser;
		}
	};


	//同意/拒绝加群回应 IM_GROUP_JOIN_ACCEPT_RESP 
	struct GroupJoinAcceptRespond :YaYaRespondBase
	{
		uint32 result;		//
		std::string msg; //
		uint32 groupid;		//群ID
		uint32 userid; //用户（申请者）ID
		std::string reason; //原因
	
		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x13040::result);
			msg = parser_get_string(parser, x13040::msg);
			groupid = parser_get_uint32(parser, x13040::groupid);
			userid = parser_get_uint32(parser, x13040::userid);
			reason = parser_get_string(parser, x13040::reason);
		}
	};


	//退群  IM_GROUP_EXIT_REQ
	struct GroupExitRequest :YaYaRequestBase
	{
		GroupExitRequest()
		:YaYaRequestBase(IM_GROUPS, IM_GROUP_EXIT_REQ)
		{
		}
		uint32 groupid;//群id

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint32(parser, x13010::groupid, groupid);
			return parser;
		}
	};



	//退群响应 IM_GROUP_EXIT_RESP 
	struct GroupExitBack :YaYaRespondBase
	{
		uint32 result;		//结果信息
		std::string msg; //错误信息  
		uint32 groupid;		//群ID
		uint32 userid; //用户ID
	
		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x13011::result);
			msg = parser_get_string(parser, x13011::msg);
			groupid = parser_get_uint32(parser, x13011::groupid);
			userid = parser_get_uint32(parser, x13011::userid);
		}
	};


	//退群通知 IM_GROUP_EXIT_NOTIFY 
	struct GroupExitRespond :YaYaRespondBase
	{
		uint32 groupid;		//群ID
		uint32 userid; //用户ID

		void decode(YV_PARSER parser)
		{
			groupid = parser_get_uint32(parser, x13012::groupid);
			userid = parser_get_uint32(parser, x13012::userid);
		}
	};


	//修改群属性  IM_GROUP_MODIFY_REQ
	struct GroupModifyRequest :YaYaRequestBase
	{
		GroupModifyRequest()
		:YaYaRequestBase(IM_GROUPS, IM_GROUP_MODIFY_REQ)
		{
		}
		uint32 groupid;//群id
		std::string name;//群名称
		std::string icon;//群图标
		std::string announcement;//群公告
		uint8 verify; //验证方式
		uint8 msg_set; //群消息设置  
		std::string alias; //名片修改

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint32(parser, x13013::groupid, groupid);
			parser_set_cstring(parser, x13013::name, name.c_str());
			parser_set_cstring(parser, x13013::icon, icon.c_str());
			parser_set_cstring(parser, x13013::announcement, announcement.c_str());
			parser_set_uint8(parser, x13013::verify, verify);
			parser_set_uint8(parser, x13013::msg_set, msg_set);
			parser_set_cstring(parser, x13013::alias, alias.c_str());
			return parser;
		}
	};


	//修改群属性响应 IM_GROUP_MODIFY_RESP 
	struct GroupModifyRespond :YaYaRespondBase
	{
		uint32 result;		//结果信息
		std::string msg; //错误信息
		uint32 groupid;		//群ID
		std::string name; // 群名称
		std::string icon; //群图标
		std::string announcement;// 群公告
		uint8 verify; //验证方式 e_groupverify
		uint8	msg_set;//群消息设置  
		std::string alias; // 名片修改

	

		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x13014::result);
			msg = parser_get_string(parser, x13014::msg);
			groupid = parser_get_uint32(parser, x13014::groupid);
			name = parser_get_string(parser, x13014::name);
			icon = parser_get_string(parser, x13014::icon);
			announcement = parser_get_string(parser, x13014::announcement);
			verify = parser_get_uint8(parser, x13014::verify);
			msg_set = parser_get_uint8(parser, x13014::msg_set);
			alias = parser_get_string(parser, x13014::alias);
		}
	};


	//转移群主请求  IM_GROUP_SHIFTOWNER_REQ
	struct GroupShiftOwnerRequest :YaYaRequestBase
	{
		GroupShiftOwnerRequest()
		:YaYaRequestBase(IM_GROUPS, IM_GROUP_SHIFTOWNER_REQ)
		{
		}
		uint32 groupid;//群id
		uint32 userid;//用户ID

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint32(parser, x13015::groupid, groupid);
			parser_set_uint32(parser, x13015::userid, userid);
			return parser;
		}
	};


	//转移群主通知 IM_GROUP_SHIFTOWNER_NOTIFY 
	struct GroupShiftOwnerNotify :YaYaRespondBase
	{
		uint32 groupid;		//群ID
		uint32 userid;		//用户ID
		uint32 shiftid;		//转移对象

		void decode(YV_PARSER parser)
		{
			groupid = parser_get_uint32(parser, x13016::groupid);
			userid = parser_get_uint32(parser, x13016::userid);
			shiftid = parser_get_uint32(parser, x13016::shiftid);
		}
	};

	//转移群主响应 IM_GROUP_SHIFTOWNER_RESP 
	struct GroupShiftOwnerRespond :YaYaRespondBase
	{
		uint32 result;		//结果信息
		std::string msg;		//错误信息
		uint32 groupid;		//群ID
		uint32 userid;		//用户ID
		uint32 shiftid;		//转移对象

		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x13017::result);
			msg = parser_get_string(parser, x13017::msg);
			groupid = parser_get_uint32(parser, x13017::groupid);
			userid = parser_get_uint32(parser, x13017::userid);
			shiftid = parser_get_uint32(parser, x13017::shiftid);
		}
	};


	//踢除群成员  IM_GROUP_KICK_REQ
	struct GroupKickRequest :YaYaRequestBase
	{
		GroupKickRequest()
		:YaYaRequestBase(IM_GROUPS, IM_GROUP_KICK_REQ)
		{
		}
		uint32 groupid;//群id
		uint32 userid;//用户ID

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint32(parser, x13018::groupid, groupid);
			parser_set_uint32(parser, x13018::userid, userid);
			return parser;
		}
	};


	//踢除群成员通知 IM_KGROUP_KICK_NOTIFY 
	struct GroupKickNotify :YaYaRespondBase
	{
		uint32 groupid;		//群ID
		uint32 userid;		//用户ID
		uint32 kickid;		//被踢成员ID
		std::string groupname; //群名称

		void decode(YV_PARSER parser)
		{
			groupid = parser_get_uint32(parser, x13019::groupid);
			userid = parser_get_uint32(parser, x13019::userid);
			kickid = parser_get_uint32(parser, x13019::kickid); 
			groupname = parser_get_string(parser, x13019::groupname);
		}
	};

	//踢除群成员回调 IM_GROUP_KICK_RESP 
	struct GroupKickRespond :YaYaRespondBase
	{
		uint32 result;		//
		std::string msg; //错误信息
		uint32 groupid;		//群ID

		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x13020::result);
			msg = parser_get_string(parser, x13020::msg);
			groupid = parser_get_uint32(parser, x13020::groupid);
		}
	};


	//邀请好友入群  IM_GROUP_INVITE_REQ
	struct GroupInviteRequest :YaYaRequestBase
	{
		GroupInviteRequest()
		:YaYaRequestBase(IM_GROUPS, IM_GROUP_INVITE_REQ)
		{
		}
		uint32 groupid;//群id
		uint32 userid;//被邀请用户id
		std::string greet;//问候语

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint32(parser, x13021::groupid, groupid);
			parser_set_uint32(parser, x13021::userid, userid);
			parser_set_cstring(parser, x13021::greet, greet.c_str());
			return parser;
		}
	};

	//邀请好友入群回应 IM_GROUP_INVITE_RESPON 
	struct GroupInviteRespond :YaYaRespondBase
	{
		uint32 result;		//
		std::string msg; //错误信息
		uint32 groupid;		//群ID
		uint32 invitedid; //被邀请用户ID

		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x13041::result);
			msg = parser_get_string(parser, x13041::msg);
			groupid = parser_get_uint32(parser, x13041::groupid);
			invitedid = parser_get_uint32(parser, x13041::invitedid);
		}
	};


	//被邀请入群通知 IM_GROUP_INVITE_NOTIFY 
	struct GroupInviteNotify :YaYaRespondBase
	{
		uint32 groupid;		//群ID
		uint32 inviteid; //被邀请用户ID
		std::string invitename; //邀请用户名
		std::string greet; //问候语
		std::string groupname; //群名称
		std::string groupicon; //群图像地址

		void decode(YV_PARSER parser)
		{
			groupid = parser_get_uint32(parser, x13022::groupid);
			inviteid = parser_get_uint32(parser, x13022::inviteid);
			invitename = parser_get_string(parser, x13022::invitename);
			greet = parser_get_string(parser, x13022::greet);
			groupname = parser_get_string(parser, x13022::groupname);
			groupicon = parser_get_string(parser, x13022::groupicon);
		}
	};


	//被邀请者同意或拒绝群邀请  IM_GROUP_INVITE_ACCEPT
	struct GroupInviteAcceptRequest :YaYaRequestBase
	{
		GroupInviteAcceptRequest()
		:YaYaRequestBase(IM_GROUPS, IM_GROUP_INVITE_ACCEPT)
		{
		}
		uint32 groupid;//群id
		std::string invitename; //邀请用户名
		uint32 inviteid;	//邀请用户id
		uint32 agree;//是否同意入群 e_group_invite   0:拒绝 ;  1:同意
		std::string greet;//问候语

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint32(parser, x13023::groupid, groupid);
			parser_set_cstring(parser, x13023::invitename, invitename.c_str());
			parser_set_uint32(parser, x13023::inviteid, inviteid);
			parser_set_uint32(parser, x13023::agree, agree);
			parser_set_cstring(parser, x13023::greet, greet.c_str());
			return parser;
		}
	};


	//被邀请者同意或拒绝群邀请响应 IM_GROUP_INVITE_ACCEPT_RESP 
	struct GroupInviteAcceptRespond :YaYaRespondBase
	{
		uint32 result;		//
		std::string msg; //错误信息
		uint32 groupid;		//群ID
		uint32 inviteid; //被邀请用户ID

		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x13042::result);
			msg = parser_get_string(parser, x13042::msg);
			groupid = parser_get_uint32(parser, x13042::groupid);
			inviteid = parser_get_uint32(parser, x13042::inviteid);
		}
	};


	//被邀请者同意或拒绝群邀请通知 IM_GROUP_INVITE_RESP 
	struct GroupInviteAcceptNotify :YaYaRespondBase
	{
		uint32 groupid;		//群ID
		uint32 inviteid; //被邀请用户ID
		std::string groupname; //群名称
		uint8 agree;// 是否同意入群 e_group_invite
		std::string greet;//问候语

		void decode(YV_PARSER parser)
		{
			groupid = parser_get_uint32(parser, x13024::groupid);
			inviteid = parser_get_uint32(parser, x13024::inviteid);
			groupname = parser_get_string(parser, x13024::groupname);
			agree = parser_get_uint8(parser, x13024::agree);
			greet = parser_get_string(parser, x13024::greet);
		}
	};


	//设置群成员角色请求  IM_GROUP_SETROLE_REQ
	struct GroupSetRoleRequest :YaYaRequestBase
	{
		GroupSetRoleRequest()
		:YaYaRequestBase(IM_GROUPS, IM_GROUP_SETROLE_REQ)
		{
		}
		uint32 groupid;//群id
		uint32 userid;//被邀请用户id
		uint8 role;//用户角色 e_group_role

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint32(parser, x13025::groupid, groupid);
			parser_set_uint32(parser, x13025::userid, userid);
			parser_set_uint8(parser, x13025::role, role);
			return parser;
		}
	};

	//设置群成员角色返回 IM_GROUP_SETROLE_RESP 
	struct GroupSetRoleRespond :YaYaRespondBase
	{
		uint32 result;		//
		std::string msg; //错误信息
		uint32 groupid;		//群ID

		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x13026::result);
			msg = parser_get_string(parser, x13026::msg);
			groupid = parser_get_uint32(parser, x13026::groupid);
		}
	};


	//设置群成员角色通知 IM_GROUP_SETROLE_NOTIFY 
	struct GroupSetRoleNotify :YaYaRespondBase
	{
		uint32 groupid;		//群ID
		uint32 operid; //操作者ID
		uint32 byuserid; //被操作者ID
		uint32 role;// 修改后角色 e_group_role

		void decode(YV_PARSER parser)
		{
			groupid = parser_get_uint32(parser, x13027::groupid);
			operid = parser_get_uint32(parser, x13027::operid);
			byuserid = parser_get_uint32(parser, x13027::byuserid);
			role = parser_get_uint32(parser, x13027::role);
		}
	};


	//解散群请求  IM_GROUP_DISSOLVE_REQ
	struct GroupDissolveRequest :YaYaRequestBase
	{
		GroupDissolveRequest()
		:YaYaRequestBase(IM_GROUPS, IM_GROUP_DISSOLVE_REQ)
		{
		}
		uint32 groupid;//群id

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint32(parser, x13028::grouid, groupid);
			return parser;
		}
	};

	//解散群响应 IM_GROUP_DISSOLVE_RESP 
	struct GroupDissolveRespond :YaYaRespondBase
	{
		uint32 result;		//
		std::string msg; //错误信息
		uint32 groupid;		//群ID

		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x13029::result);
			msg = parser_get_string(parser, x13029::msg);
			groupid = parser_get_uint32(parser, x13029::grouid);
		}
	};

	//管理员修改他人名片  IM_GROUP_SETOTHER_REQ
	struct GroupSetOtherRequest :YaYaRequestBase
	{
		GroupSetOtherRequest()
		:YaYaRequestBase(IM_GROUPS, IM_GROUP_SETOTHER_REQ)
		{
		}
		uint32 groupid;//群id
		uint32 userid;//用户ID
		std::string alias; //用户名片
		

		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint32(parser, x13030::groupid, groupid);
			parser_set_uint32(parser, x13030::userid, userid);
			parser_set_cstring(parser, x13030::alias, alias.c_str());
			return parser;
		}
	};


	//修改他人名片通知 IM_GROUP_SETOTHER_NOTIFY 
	struct GroupSetOtherNotify:YaYaRespondBase
	{
		uint32 groupid; //群ID
		uint32 userid;//用户ID
		std::string alias;//用户名片

		void decode(YV_PARSER parser)
		{
			groupid = parser_get_uint32(parser, x13031::groupid);
			userid = parser_get_uint32(parser, x13031::userid);
			alias = parser_get_string(parser, x13031::alias);
		}
	};

	//修改他人名片返回 IM_GROUP_SETOTHER_RESP 
	struct GroupSetOtherRespond :YaYaRespondBase
	{
		uint32 result;		//结果信息     
		std::string msg; //错误信息
		uint32 groupid;		//群ID

		void decode(YV_PARSER parser)
		{
			result = parser_get_uint32(parser, x13032::result);
			msg = parser_get_string(parser, x13032::msg);
			groupid = parser_get_uint32(parser, x13032::groupid);
		}
	};


	//群属性通知(群列表) IM_GROUP_PROPERTY_NOTIFY 
	struct GroupPropertyNotify :YaYaRespondBase
	{
		uint32 groupid; //群ID
		std::string name;//群名称
		std::string icon;//群图标
		std::string announcement;//群公告
		//uint8 level;//用户等级
		uint8 verify;//验证方式
		uint32 number_limit;//人数限制
		uint32 owner;//群所有者
		uint8 msg_set;//群消息设置
		uint32 user_count;//当前用户数
		uint8 role;//我在群中的角色  gr_owners	= 2群所有者; 3群管理者;4群成员;10群游客

		void decode(YV_PARSER parser)
		{
			groupid = parser_get_uint32(parser, x13033::groupid);
			name = parser_get_string(parser, x13033::name);
			icon = parser_get_string(parser, x13033::icon);
			announcement = parser_get_string(parser, x13033::announcement);
			//level = parser_get_uint8(parser, x13033::level);
			verify = parser_get_uint8(parser, x13033::verify);
			number_limit = parser_get_uint32(parser, x13033::number_limit);
			owner = parser_get_uint32(parser, x13033::owner);
			msg_set = parser_get_uint8(parser, x13033::msg_set);
			user_count = parser_get_uint32(parser, x13033::user_count);
			role = parser_get_uint8(parser, x13033::role);
		}
	};


	//群成员上线 IM_GROUP_MEMBER_ONLINE 
	struct GroupMemberOnlineNotify :YaYaRespondBase
	{
		uint32 groupid; //群ID
		uint32 userid;//用户ID
		uint8 online;//用户是否在线 group_member_online

		void decode(YV_PARSER parser)
		{
			groupid = parser_get_uint32(parser, x13034::groupid);
			userid = parser_get_uint32(parser, x13034::userid);
			online = parser_get_uint8(parser, x13034::online);
		}
	};


	//新成员加入群 IM_GROUP_USERJOIN_NOTIFY 
	struct GroupNewUserJoinNotify :YaYaRespondBase
	{
		uint32 groupid; //群ID
		GroupUserInfo groupUserInfo;//用户信息

		void decode(YV_PARSER parser)
		{
			groupid = parser_get_uint32(parser, x13035::groupid);


			int index = 0;
			if (parser_is_empty(parser, x13035::xUser, index))
				return;
			YV_PARSER yayaParser = yvpacket_get_parser_object(parser);
			parser_get_object(parser, x13035::xUser, yayaParser, index);


			groupUserInfo.userId = parser_get_uint32(yayaParser, xGroupUser::userId);
			groupUserInfo.nickname = parser_get_string(yayaParser, xGroupUser::nickname);

			groupUserInfo.iconurl = parser_get_string(yayaParser, xGroupUser::iconurl);
			groupUserInfo.sex = parser_get_uint8(yayaParser, xGroupUser::sex);
			groupUserInfo.alias = parser_get_string(yayaParser, xGroupUser::alias);
			groupUserInfo.role = parser_get_uint32(yayaParser, xGroupUser::role);

			/*groupUserInfo.level = parser_get_uint8(yayaParser, xGroupUser::level);
			groupUserInfo.grade = parser_get_uint32(yayaParser, xGroupUser::grade);*/
			groupUserInfo.lately_online = parser_get_uint32(yayaParser, xGroupUser::lately_online);
			groupUserInfo.online = parser_get_uint8(yayaParser, xGroupUser::online);
			groupUserInfo.thirduid = parser_get_string(yayaParser, xGroupUser::uid);
			
		}
	};

	//群聊 - 文本  IM_CHAT_GROUP_TEXT_REQ
	struct GroupSendTextRequest :YaYaRequestBase
	{
		GroupSendTextRequest()
		:YaYaRequestBase(IM_CHAT, IM_CHAT_GROUP_TEXT_REQ)
		{
		}
		uint32 groupid;//群id
		std::string text; //
		std::string ext; //扩展字段
		std::string flag; //消息标记(可不传)


		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint32(parser, x14006::groupid, groupid);
			parser_set_cstring(parser, x14006::text, text.c_str());
			parser_set_cstring(parser, x14006::ext, ext.c_str());
			parser_set_cstring(parser, x14006::flag, flag.c_str());
			return parser;
		}
	};


	//群聊 -  图片  IM_CHAT_GROUP_IMAGE_REQ
	struct GroupSendImageRequest :YaYaRequestBase
	{
		GroupSendImageRequest()
		:YaYaRequestBase(IM_CHAT, IM_CHAT_GROUP_IMAGE_REQ)
		{
		}
		uint32 groupid;//群id
		std::string image; ////图像路径
		std::string ext; //扩展字段
		std::string flag; //消息标记(可不传)


		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint32(parser, x14007::groupid, groupid);
			parser_set_cstring(parser, x14007::image, image.c_str());
			parser_set_cstring(parser, x14007::ext, ext.c_str());
			parser_set_cstring(parser, x14007::flag, flag.c_str());
			return parser;
		}
	};


	//群聊 -  语音  IM_CHATA_GROUP_AUDIO_REQ
	struct GroupSendAutoRequest :YaYaRequestBase
	{
		GroupSendAutoRequest()
		:YaYaRequestBase(IM_CHAT, IM_CHATA_GROUP_AUDIO_REQ)
		{
		}
		uint32 groupid;//群id
		std::string file; ////音频文件路径
		uint32 time;//音频文件播放时长(秒)
		std::string txt; //附带文本(可选)
		std::string ext; //扩展字段
		std::string flag; //消息标记(可不传)


		YV_PARSER encode()
		{
			YV_PARSER parser = yvpacket_get_parser();
			parser_set_uint32(parser, x14008::groupid, groupid);
			parser_set_cstring(parser, x14008::file, file.c_str());
			parser_set_uint32(parser, x14008::time, time);
			parser_set_cstring(parser, x14008::txt, txt.c_str());
			parser_set_cstring(parser, x14008::ext, ext.c_str());
			parser_set_cstring(parser, x14008::flag, flag.c_str());
			return parser;
		}
	};

	//群聊天推送 IM_CHAT_GROUP_NOTIFY
	struct GroupChatNotify :YaYaRespondBase
	{
		uint32 groupid;		//群ID
		uint32 sendid; //发送者ID
		std::string sendnickname; //发送者昵称
		std::string sendheadurl; //发送者头像

		uint32 time;////发送时间
		std::string groupname; //群名称
		std::string groupicon; //群头像地址
		uint8 type;//消息类型 e_chat_msgtype

		std::string data; //若为文本类型，则是消息内容，若为音频，则是文件地址，若为图像，则是大图像地址
		std::string imageurl;//若为图片，则是小图像地址
		uint32 audiotime; //若为音频文件, 则为文件播放时长(秒)
		std::string  attach; //若为音频文件，则为附加文本(没有附带文本时为空)

		std::string ext1; //扩展字段

		uint32 index;//消息ID
		std::string source; //消息源

		void decode(YV_PARSER parser)
		{
			groupid = parser_get_uint32(parser, x14009::groupid);
			sendid = parser_get_uint32(parser, x14009::sendid);
			sendnickname = parser_get_string(parser, x14009::sendnickname);
			sendheadurl = parser_get_string(parser, x14009::sendheadurl);

			time = parser_get_uint32(parser, x14009::time);
			groupname = parser_get_string(parser, x14009::groupname);
			groupicon = parser_get_string(parser, x14009::groupicon);
			type = parser_get_uint8(parser, x14009::type);

			data = parser_get_string(parser, x14009::data);
			imageurl = parser_get_string(parser, x14009::imageurl);
			audiotime = parser_get_uint32(parser, x14009::audiotime);
			attach = parser_get_string(parser, x14009::attach);

			ext1 = parser_get_string(parser, x14009::ext1);
		//	index = parser_get_uint32(parser, CLOUDMSG_ID);
			index = parser_get_uint32(parser, x14009::indexid);
			source = parser_get_string(parser, CLOUDMSG_SOURCE);

		}
	};

	//群聊消息发送响应 IM_CHAT_GROUPMSG_RESP
	struct GroupChatMsgNotify :YaYaRespondBase
	{
		uint32 result; //
		std::string msg; //发送者头像
		uint32 groupid;		//群ID
		uint32 index; ///消息序号
		std::string flag;//消息标记

		void decode(YV_PARSER parser)
		{
			groupid = parser_get_uint32(parser, x14010::groupid);
			result = parser_get_uint32(parser, x14010::result);
			index = parser_get_uint32(parser, x14010::index);
			msg = parser_get_string(parser, x14010::msg);
			flag = parser_get_string(parser, x14010::flag);
		}
	};

#endif
	/****************************群功能结束***************************/

};
#endif