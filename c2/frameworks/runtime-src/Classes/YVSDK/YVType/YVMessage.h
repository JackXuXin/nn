﻿#ifndef _YVSDK_YVMESSAGE_H_
#define _YVSDK_YVMESSAGE_H_

#include <string>
#include <vector>
#include <map>
#include "YVDef.h"
#include "YVFilePath.h"
#include "YVUtils/YVUtil.h"

namespace YVSDK
{
	//消息类型
	enum YVMessageType
	{
		YVMessageTypeText,        ///文本消息
		YVMessageTypeImage,		 ///图片消息
		YVMessageTypeAudio,		 ///语音消息
	};

	//消息状态
	enum YVMessageStatus
	{
		YVMessageStatusCreated,      ///消息创建(默认状态)

		YVMessageStatusUnread,       ///消息未读
		YVMessageStatusRead,         ///消息已读

		YVMessageStatusSending,      ///消息发送中
		YVMessageStatusReSending,    ///消息重新发送中
		YVMessageStatusSendingFailed ///消息发送失败
	};

	//消息基类
	struct _YVMessage
	{
		_YVMessage(YVMessageType inType, YVMessageStatus instate);
		virtual ~_YVMessage();
		uint64 id;                //消息id(本地随机分配的，用于索引消息)
		uint32 index;             //服务器消息id，用于标识消息在服务器存储位置，用于拉取历史消息
		uint32 endId;			  //结束索引
		uint32 sendId;            //发送者id
		uint32 recvId;            //接收者id,  如果是频道消息，则此id为keystring的索引,如是群，则为群id
		YVMessageType type;       //消息类型
		YVMessageStatus state;    //消息状态
		uint32 sendTime;          //消息发送时间
		std::string source;       //来源(SYSTEM 系统消息 PUSH 推送消息 userId 好友消息)
		std::string	wildcard;     //游戏通道字符串
		std::string	ext;          //拓展字段
		uint8  playState;         //消息的播放状态 0：已播放， 1：未播放
		uint32 getTimeStamp(){ return sendTime; };
		

		bool operator <= (const _YVMessage&);
	};
	WISDOM_PTR(_YVMessage, YVMessagePtr);

	//文本消息
	struct _YVTextMessage
		:public _YVMessage
	{
		_YVTextMessage(std::string inText)
		:_YVMessage(YVMessageTypeText, YVMessageStatusCreated)
		{
			text.append(inText);
		}

		std::string  text;       //文本数据
	};
	WISDOM_PTR(_YVTextMessage, YVTextMessagePtr);

	//图片消息
	struct _YVImageMessage
		:public _YVMessage
	{
		_YVImageMessage()
		: _YVMessage(YVMessageTypeImage, YVMessageStatusCreated)
		{

		}
		YVFilePathPtr picPath;				//原图地址
		YVFilePathPtr littlePicPath;       //小图地址
	};
	WISDOM_PTR(_YVImageMessage, YVImageMessagePtr);

	//语音消息
	struct _YVVoiceMessage
		:public  _YVMessage
	{
		_YVVoiceMessage(std::string path, bool isUrl, uint32  invoiceTimes, std::string inattach)
		: _YVMessage(YVMessageTypeAudio, YVMessageStatusCreated)
		{

			if (isUrl)
			{
				voicePath = new _YVFilePath(NULL, path.c_str());
			}
			else
			{
				voicePath = new _YVFilePath(path.c_str(), NULL);
			}
		
			voiceTimes = invoiceTimes;
			attach.append(inattach);
		}

		_YVVoiceMessage(YVFilePathPtr   invoicePath, uint32  invoiceTimes, std::string inattach)
			: _YVMessage(YVMessageTypeAudio, YVMessageStatusCreated)
		{
			voicePath = invoicePath;
			voiceTimes = invoiceTimes;
			attach.append(inattach);
		}

		YVFilePathPtr   voicePath;       //语音文件路径 
		uint32      voiceTimes;          //时长
		std::string attach;              //附加文本
	};
	WISDOM_PTR(_YVVoiceMessage, YVVoiceMessagePtr);


	/////群消息结构begin////
	//群文本消息
	struct _YVGroupTextMessage
		:public _YVMessage
	{
		_YVGroupTextMessage(std::string inText,std::string inSendnickname,std::string inSendheadurl,std::string inGroupname,std::string inGroupicon)
		:_YVMessage(YVMessageTypeText, YVMessageStatusCreated)
		{
			text.append(inText);
			sendnickname.append(inSendnickname);
			sendheadurl.append(inSendheadurl);
			groupname.append(inGroupname);
			groupicon.append(inGroupicon);
		}

		std::string  text;       //文本数据
		std::string sendnickname; //发送者昵称
		std::string sendheadurl; //发送者头像
		std::string groupname; //群名称
		std::string groupicon; //群头像地址
	};
	WISDOM_PTR(_YVGroupTextMessage, YVGroupTextMessagePtr);

	//群图片消息
	struct _YVGroupImageMessage
		:public _YVMessage
	{
		_YVGroupImageMessage(std::string inSendnickname, std::string inSendheadurl, std::string inGroupname, std::string inGroupicon)
		: _YVMessage(YVMessageTypeImage, YVMessageStatusCreated)
		{
			sendnickname.append(inSendnickname);
			sendheadurl.append(inSendheadurl);
			groupname.append(inGroupname);
			groupicon.append(inGroupicon);
		}
		YVFilePathPtr picPath;				//原图地址
		YVFilePathPtr littlePicPath;       //小图地址
		std::string sendnickname; //发送者昵称
		std::string sendheadurl; //发送者头像
		std::string groupname; //群名称
		std::string groupicon; //群头像地址
	};
	WISDOM_PTR(_YVGroupImageMessage, YVGroupImageMessagePtr);

	//群语音消息
	struct _YVGroupVoiceMessage
		:public  _YVMessage
	{
		_YVGroupVoiceMessage(std::string path, bool isUrl, uint32  invoiceTimes, std::string inattach, 
		std::string inSendnickname, std::string inSendheadurl, std::string inGroupname, std::string inGroupicon)
		: _YVMessage(YVMessageTypeAudio, YVMessageStatusCreated)
		{

			if (isUrl)
			{
				voicePath = new _YVFilePath(NULL, path.c_str());
			}
			else
			{
				voicePath = new _YVFilePath(path.c_str(), NULL);
			}

			voiceTimes = invoiceTimes;
			attach.append(inattach);
			sendnickname.append(inSendnickname);
			sendheadurl.append(inSendheadurl);
			groupname.append(inGroupname);
			groupicon.append(inGroupicon);
		}

		_YVGroupVoiceMessage(YVFilePathPtr invoicePath, uint32  invoiceTimes, std::string inattach, 
			std::string inSendnickname, std::string inSendheadurl, std::string inGroupname, std::string inGroupicon)
			: _YVMessage(YVMessageTypeAudio, YVMessageStatusCreated)
		{
			voicePath = invoicePath;
			voiceTimes = invoiceTimes;
			attach.append(inattach);
			sendnickname.append(inSendnickname);
			sendheadurl.append(inSendheadurl);
			groupname.append(inGroupname);
			groupicon.append(inGroupicon);
		}

		YVFilePathPtr   voicePath;       //语音文件路径 
		uint32      voiceTimes;          //时长
		std::string attach;              //附加文本
		std::string sendnickname; //发送者昵称
		std::string sendheadurl; //发送者头像
		std::string groupname; //群名称
		std::string groupicon; //群头像地址
	};
	WISDOM_PTR(_YVGroupVoiceMessage, YVGroupVoiceMessagePtr);
	//////群消息结构end

	//消息列表
	class _YVMessageList
	{
	public:
		_YVMessageList();
		//设置消息列表上限
		void setMaxNum(uint32 maxNum);
		//清空消息列表
		void clear();
		//插入消息(按时间进行排序)
		void insertMessage(YVMessagePtr&, bool isBack);
		//获取消息列表
		std::vector<YVMessagePtr>& getMessageList();
		//获取聊天对像id,如果是频道，则为频道id,如果是群， 则为群id
		uint32 getChatWithID(){ return id; }
		//设置聊天对像id,如果是频道，则为频道id, 如果是群， 则为群id
		void setChatWithID(uint32 chatId){ id = chatId; }
		//通过消息id获取消息
		YVMessagePtr getMessageById(uint64 mssageID);
		//通过消息id删除某条消息
		void delMessageById(uint64 mssageID);
	private:
		uint32 id;                  //聊天对像id
		uint32 m_maxMessageNum;     //最大消息数量
		std::vector<YVMessagePtr> m_msssageList;  //消息内存缓存
	};

	//申明智能指针
	WISDOM_PTR(_YVMessageList, YVMessageListPtr);

	//以聊天对像为key（如果为频道，则为频道 id， 如是群， 则为群id），聊天消息列表为value的消息map类型
	typedef std::map<uint32, YVMessageListPtr> FriendChatMessageMap;
	typedef std::map<uint32, YVMessageListPtr> ChannelMessageMap;
	//云消息
	typedef std::map<uint32, YVMessageListPtr> NotifyMessageMap;
	typedef std::map<uint32, YVMessageListPtr> GroupMessageMap;//群
}
#endif