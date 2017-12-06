﻿#ifndef _YVSDK_YVCONFIGURE_H_
#define _YVSDK_YVCONFIGURE_H_
#include <map>
#include <vector>
#include "YVType/YVType.h"
#include "YVManager/YVManager.h"
#include "YVUtils/YVMsgDispatcher.h"

namespace YVSDK
{
	//配置类开
	enum  ConfigType
	{
							  //配置说明       是否可选     类型      数量
		ConfigAppid,          //AppId配置      必须      int型      一个
		ConfigChannelKey,     //频道标识       可选     文本型     0至多个
		ConfigTempPath,       //呀呀缓存存放的位置
		ConfigIsTest,		  //是否是测试环境
		ConfigIsOverSea,	  //是否是海外版本
		ConfigServerId,		  //游戏大区ID号
		ConfigReadstatus,	  //消息是否需要确认

		ConfigFriendChatCacheNum,     //好友聊天内存缓存数量; 
		ConfigFriendHistoryChatNum,   //每次拉好友聊天历史信息数量;

		ConfigChannelChatCacheNum,     //好友聊天内存缓存数量; 
		ConfigChannelHistoryChatNum,   //每次拉好友聊天历史信息数量;

		ConfigGroupCacheNum,				//内存缓存的群消息数量
		ConfigGroupHistoryChatNum,		//每次拉取的群的历史消息数量

		ConfigSpeechWhenSend,   //语音消息是否先识别出文本后再发送
	};

	class YVConfigManager
	{
		friend class YVMsgDispatcher;
		friend class YVPlayerManager;
		friend class YVChannalChatManager;
		friend class YVFriendChatManager;
		friend class YVFileManager;
		friend class YVGroupUserManager;
		friend class _YVFilePath;

		public:
			YVConfigManager();
			void  setConfig(ConfigType type, ...);
			uint32 getGroupCacheNum();
		private:
			uint32 appid;                         //appid
			std::vector<std::string> channelKey;  //频道key
			std::string tempPath;				  //云娃产生的缓存文件地址
			bool isTest;						  //是开启测试环境
			bool isOverSea;						  //是开启海外版本
			bool readstatus;					  //消息是否需要已经标识
			std::string serverid;				  //服务器频道id
			
			uint32 friendChatCacheNum;             //内存缓存的好友消息数量 
			uint32 channelChatCacheNum;            //内存缓存的频道消息数量

			uint32	groupCacheNum;					//内存缓存的群消息数量
			uint32	groupHistoryChatNum; 			//每次拉取的群的历史消息数量

			uint32 friendHistoryChatNum;           //每次拉取的好友历史消息数量     最大值为15
			uint32 channelHistoryChatNum;          //每次拉取的频道的历史消息数量   最大值为15

			uint32 isClearErroMsg;                 //发送失败的消息，重新发送，是否清除错误的消息
			bool speechWhenSend;
	};
}
#endif