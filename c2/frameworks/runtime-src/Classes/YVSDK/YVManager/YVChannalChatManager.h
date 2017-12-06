#ifndef _CHANNALCHATMANAGER_H_
#define _CHANNALCHATMANAGER_H_

#include <vector>
#include "YVListern/YVListern.h"
#include "YVType/YVType.h"

namespace YVSDK
{
#define CHANNALLINITMSGNUM 10

	struct YaYaRespondBase;

	class YVChannalChatManager
		:public YVListern::YVFinishSpeechListern
	{
	public:
		bool init();
		bool destory();

		void setNewMessageCount(int count);
		int getNewMessageCount();

		void setIsInChatChannel(bool isIn);
		bool getIsInChatChannel();

		void setNewMessageChatChannel(bool isIn);
		bool getNewMessageChatChannel();

		void setChatNodeUid(uint64 uid);
		uint64 getChatNodeUid();
		
		//发送文本消息
		bool sendChannalText(int channelKeyId, const std::string & text, const std::string & ext);
		
		//发送语音消息
		bool sendChannalVoice(int channelKeyId, YVFilePathPtr voicePath,
			uint32 voiceTime, const std::string & ext);

		//获取历史消息   //channelKeyId 频道ID   index索引， 坐0开始, 频道没有离线，只有历史消息
		bool getChannalHistoryData(int channelKeyId, int index);

		//获取内存中的数据。
		YVMessageListPtr getCacheChannalChatData(int channelKeyId);
		
		//缓存数据重发
		void SendMsgCache(int channelKeyId,YVMessagePtr msg);

		bool SendMsgChannalVoice(int channelKeyId, uint64 id, const std::string & text, YVFilePathPtr voicePath,
			uint32 voiceTime, const std::string & ext);
		bool SendMsgChannalText(int channelKeyId, uint64 id, const std::string & text, const std::string & ext);
		//频道修改
		bool ModchannalId(bool operate, int channelKey, const std::string & wildCard);


		//登录 注:登录账号传入了通配符，会直接登录， 不需要再调此登录  IM_CHANNEL_LOGIN_REQ
		bool channelLoginRequest();

		//频道登录返回
		void ChannalloginBack(YaYaRespondBase*);
		//频道修改返回
		void ModChannelIdBack(YaYaRespondBase*);

		bool setChannelSendTime(uint32 time);

		void channelMessageNotifyCallback(YaYaRespondBase*);
		void channelMessageHistoryCallback(YaYaRespondBase*);
		void channelMessageStateCallback(YaYaRespondBase*);

		//频道推送信息回调, 此信息需服务器配置信息
		void ChannelPushMessageNotifyCallback(YaYaRespondBase* respond);
		std::string& getChannelKeyById(int id);
		
		InitListern(ChannelHistoryChat, YVMessageListPtr);
		InitListern(ChannelChat, YVMessagePtr);
		InitListern(ChannelChatState, YVMessagePtr);
		InitListern(Channallogin, ChanngelLonginRespond*);
		InitListern(ModChannelId, ModChannelIdRespond*);
		InitListern(ChannelPushChat, ChannelPushMessageNotify*);
		
	protected:
		//结束识别接口
		void onFinishSpeechListern(SpeechStopRespond*); 
		
		std::string expand;
		int  getChannelIdByKey(const std::string & key);
		void setChannelKey(int id, const std::string & key);
		void insertMsg(int channelKeyId, YVMessagePtr, bool isInsertBack, bool isCallChannelChatListern = true);
		int newMessagesCount;
		uint64 m_chatNodeUid;
		
		ChannelMessageMap m_channelMssages;           //频道消息备份
		YVMessageListPtr m_historyCache;            //频道历史消息缓存
		YVMessageListPtr m_sendMsgCache;            //发送中的消息备份

	private:
		bool m_isInChatChannel;
		bool m_newMessageFromChatChannel;
	};
}
#endif