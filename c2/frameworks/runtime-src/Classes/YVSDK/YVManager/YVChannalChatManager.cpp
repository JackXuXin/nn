/*********************************************************************************
*Copyright(C), 2015 YUNVA Company
*FileName:  RespondFactory.cpp
*Author:  Matt
*Version:  1.0.0
*Date:  2015-5-8
*Description:  频道聊天实现类
**********************************************************************************/

#include "YVChannalChatManager.h"
#include "YVUtils/YVMsgDispatcher.h"
#include "YVSDK.h"

//#include "cocos2d.h"

#include <assert.h>
#include <time.h>

using namespace YVSDK;

bool YVChannalChatManager::init()
{
	m_historyCache = new _YVMessageList();
	m_sendMsgCache = new _YVMessageList();
	YVMsgDispatcher*  msgDispatcher = YVPlatform::getSingletonPtr()->getMsgDispatcher();

	//频道消息通知//
	msgDispatcher->registerMsg(IM_CHANNEL_MESSAGE_NOTIFY, this,
		&YVChannalChatManager::channelMessageNotifyCallback);
	
	//频道历史消息通知//
	msgDispatcher->registerMsg(IM_CHANNEL_HISTORY_MSG_RESP, this, 
		&YVChannalChatManager::channelMessageHistoryCallback);

	//消息发送状态通知//
	msgDispatcher->registerMsg(IM_CHANNEL_SENDMSG_RESP, this,
		&YVChannalChatManager::channelMessageStateCallback);

	//频道登录返回
	msgDispatcher->registerMsg(IM_CHANNEL_LOGIN_RESP, this,
		&YVChannalChatManager::ChannalloginBack);

	//频道修改返回
	msgDispatcher->registerMsg(IM_CHANNEL_MODIFY_RESP, this,
		&YVChannalChatManager::ModChannelIdBack);

	//频道push消息返回
	msgDispatcher->registerMsg(IM_CHANNEL_PUSH_MSG_NOTIFY, this,
		&YVChannalChatManager::ChannelPushMessageNotifyCallback);
	
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	platform->addFinishSpeechListern(this);

	m_chatNodeUid = 0;
	m_isInChatChannel = false;
	
	return true;
}

bool YVChannalChatManager::destory()
{
	YVMsgDispatcher*  msgDispatcher = YVPlatform::getSingletonPtr()->getMsgDispatcher();

	msgDispatcher->unregisterMsg(IM_CHANNEL_MESSAGE_NOTIFY, this);

	msgDispatcher->unregisterMsg(IM_CHANNEL_HISTORY_MSG_RESP, this);

	msgDispatcher->unregisterMsg(IM_CHANNEL_SENDMSG_RESP, this);

	msgDispatcher->unregisterMsg(IM_CHANNEL_LOGIN_RESP, this);

	msgDispatcher->unregisterMsg(IM_CHANNEL_MODIFY_RESP, this);

	msgDispatcher->unregisterMsg(IM_CHANNEL_PUSH_MSG_NOTIFY, this);
	

	YVPlatform* platform = YVPlatform::getSingletonPtr();
	platform->delFinishSpeechListern(this);

	m_historyCache->clear();
	m_sendMsgCache->clear();

	return true;
}

void YVChannalChatManager::setNewMessageCount(int count)
{
	this->newMessagesCount = count;
}
int YVChannalChatManager::getNewMessageCount()
{
	return newMessagesCount;
}

void YVChannalChatManager::setIsInChatChannel(bool isIn)
{
	m_isInChatChannel = isIn;
}
bool YVChannalChatManager::getIsInChatChannel()
{
	return m_isInChatChannel;
}

void YVChannalChatManager::setNewMessageChatChannel(bool isIn)
{
	m_newMessageFromChatChannel = isIn;
}
bool YVChannalChatManager::getNewMessageChatChannel()
{
	return m_newMessageFromChatChannel;
}

void YVChannalChatManager::setChatNodeUid(uint64 uid)
{
	m_chatNodeUid = uid;
}
uint64 YVChannalChatManager::getChatNodeUid()
{
	return m_chatNodeUid;
}


//频道push消息
void YVChannalChatManager::ChannelPushMessageNotifyCallback(YaYaRespondBase* respond)
{
	ChannelPushMessageNotify* r = static_cast<ChannelPushMessageNotify*>(respond);
	if (r == NULL)
	{
		return;
	}
	callChannelPushChatListern(r);
}
void YVChannalChatManager::channelMessageNotifyCallback(YaYaRespondBase* respond)
{
	ChannelMessageNotify* r = static_cast<ChannelMessageNotify*>(respond);
	if (r == NULL)
	{
		return;
	}
	if (r->wildcard.empty())
	{
		return;
	}
	int ChannelId = getChannelIdByKey(r->wildcard);
 //	assert(ChannelId >= 0);    //协议异常//
	//YVPlatform* platform1 = YVPlatform::getSingletonPtr();
	//assert(!platform1->channelKey[1].empty());
	//assert(!r->wildcard.empty());
	if (ChannelId < 0)
	{
		return;

	}
	
	//文本消息//
	YVMessagePtr msg = NULL;
	if (r->message_type == chat_msgtype_text)
	{
		msg = new _YVTextMessage(r->message_body);
	}
	else if (r->message_type == chat_msgtype_audio)
	{
		msg = new _YVVoiceMessage(r->message_body, true, r->voiceDuration, r->attach);
	}

	msg->recvId = getChannelIdByKey(r->wildcard);
	msg->sendId = r->user_id;
	msg->wildcard = r->wildcard;
	msg->sendTime = time(0);
	msg->ext = r->ext1;
	msg->playState = 1;
	
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVUInfoPtr uinfo = platform->getUInfoById(msg->sendId);
	if (uinfo == NULL)
	{
		_YVUInfo* _info = new _YVUInfo;
		_info->userid = r->user_id;
		_info->nickname = r->nickname;
		_info->thirdUid = r->thirduid;

		//info->header = YVPlatform::getSingletonPtr()->getYVPathByUrl(r->headicon);
		uinfo = _info;
	}
	else
	{
		uinfo->nickname = r->nickname;
		
	}
	platform->updateUInfo(uinfo);
	insertMsg(ChannelId, msg,true, true);
}

//////////////////////////////


time_t StringToDatetime(const std::string &str)
{
	struct tm tm_;
	int year, month, day, hour, minute, second;
	sscanf(str.c_str(), "%d-%d-%d %d:%d:%d", &year, &month, &day, &hour, &minute, &second);
	tm_.tm_year = year - 1900;
	tm_.tm_mon = month - 1;
	tm_.tm_mday = day;
	tm_.tm_hour = hour;
	tm_.tm_min = minute;
	tm_.tm_sec = second;
	tm_.tm_isdst = 0;

	time_t t_ = mktime(&tm_); //已经减了8个时区  
	return t_; //秒时间  
}
/////////////////


void YVChannalChatManager::channelMessageHistoryCallback(YaYaRespondBase* respond)
{
	ChannelHistoryNotify* r = static_cast<ChannelHistoryNotify*>(respond);

	std::vector<YaYaChannelHistoryMsgInfo>& xHistoryMsg = r->xHistoryMsg;

	m_historyCache->clear();
	YVPlatform* platform = YVPlatform::getSingletonPtr();

	for (std::vector<YaYaChannelHistoryMsgInfo>::iterator it = xHistoryMsg.begin();
		it != xHistoryMsg.end(); ++it)
	{
		YaYaChannelHistoryMsgInfo& info = *it;
		int id = getChannelIdByKey(info.wildcard);
	///	assert(id >= 0);    //协议异常//
		if (id < 0)
		{
			continue;
		}
		m_historyCache->setChatWithID(id);
	
		//文本消息//
		YVMessagePtr msg = NULL;
		if (info.message_type == chat_msgtype_text)
		{
			msg = new _YVTextMessage(info.message_body);
		}
		else if (info.message_type == chat_msgtype_audio)
		{
			msg = new _YVVoiceMessage(info.message_body, true, info.voiceDuration, info.attach);
		}
		msg->recvId = getChannelIdByKey(info.wildcard);
		msg->sendId = info.user_id;
		msg->playState = 1;
		msg->index = info.index;
		//msg->sendTime = atoi((info.ctime).c_str());


		//char timestr[20];
		//memset(timestr, 0, 20);
		//uint32 lb = data->sendTime;
		std::string  sttm = info.ctime;
		time_t t = StringToDatetime(sttm);
		msg->sendTime = t;
		//struct tm *ttime = localtime(&t);
		//strftime(timestr, 20, "%Y-%m-%d %H:%M:%S", ttime);
		msg->wildcard = info.wildcard;
		msg->ext = info.ext1;

		//msg->attach = info.attach;

		
		YVUInfoPtr uinfo = platform->getUInfoById(msg->sendId);
		if (uinfo == NULL)
		{
			_YVUInfo* _uinfo = new _YVUInfo;
			_uinfo->userid = msg->sendId;
			_uinfo->nickname.append(info.nickname);
			_uinfo->thirdUid = info.thirduid;
			uinfo = _uinfo;
			platform->updateUInfo(uinfo);
		}

		m_historyCache->insertMessage(msg, false);
	}
	//调用历史消息回调//
	callChannelHistoryChatListern(m_historyCache);
}

void YVChannalChatManager::channelMessageStateCallback(YaYaRespondBase* respond)
{
 	ChannelMessageStateNotify* r = static_cast<ChannelMessageStateNotify*>(respond);
	uint64 id = 0;
	if (r){
		id = toNumber(r->flag);
	}
	else
	{
		return;
	}
	YVMessagePtr msg = m_sendMsgCache->getMessageById(id);
	if (msg == NULL) return;
	if (r && r->type == 2)
	{
		YVTextMessagePtr textmsg = msg;
		textmsg->text = r->textMsg;
	}
	else if (r && r->type == 1)
	{
		YVVoiceMessagePtr textmsg = msg;
		textmsg->attach = r->textMsg;
	}

	msg->state = r->result == 0 ? YVMessageStatusCreated : YVMessageStatusSendingFailed;
	callChannelChatStateListern(msg);
	if (msg->state != YVMessageStatusSendingFailed)
	m_sendMsgCache->delMessageById(id);
}

bool YVChannalChatManager::sendChannalText(int channelKeyId, const std::string & text, const std::string & ext)
{
	if (text.length() == 0)
	{
		return false;
	}
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher*  msgDispatcher = platform->getMsgDispatcher();
	//消息存入缓存//
	YVMessagePtr msg = new _YVTextMessage(text);
	msg->recvId = channelKeyId;
	msg->sendId = platform->getLoginUserInfo()->userid;
	msg->state = YVMessageStatusSending;
	msg->sendTime = time(0);
	msg->wildcard = getChannelKeyById(channelKeyId);
	msg->ext = ext;
	//缓存消息
	insertMsg(channelKeyId, msg, true);
	//放至消息发送列表里
	if (m_sendMsgCache->getMessageById(msg->id) == NULL)
		m_sendMsgCache->insertMessage(msg, true);
	
	//SendMsgCache(channelKeyId,msg);
	if (!platform->GetNetState())
	{
		msg->state = YVMessageStatusSendingFailed;
		callChannelChatStateListern(msg);
	}

// 	int size = m_sendMsgCache->getMessageList().size();
// 	if (m_sendMsgCache->getMessageList().size() != 0)
// 	{
// 		std::vector<YVMessagePtr>::iterator it = m_sendMsgCache->getMessageList().crend();
// 		YVMessagePtr Cache = *(m_sendMsgCache->getMessageList().cend());
// 		if (Cache->state != YVMessageStatusSendingFailed)
// 		{
// 			insertMsg(channelKeyId, msg);
// 			//放至消息发送列表里
// 			m_sendMsgCache->insertMessage(msg);
// 		}
// 	} 
// 	else
// 	{
// 		insertMsg(channelKeyId, msg);
// 		//放至消息发送列表里
// 		m_sendMsgCache->insertMessage(msg);
// 	}

	//构造消息
	ChannelTextRequest q;
	q.textMsg = text;
	q.wildCard.append(getChannelKeyById(channelKeyId));//根据频道号获取相应的通配符
	q.flag.append(toString(msg->id));
	q.expand= ext;
	
	//发送消息//
	return msgDispatcher->send(&q);
}

bool YVChannalChatManager::SendMsgChannalText(int channelKeyId, uint64 id, const std::string & text, const std::string & ext)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher*  msgDispatcher = platform->getMsgDispatcher();

	//构造消息
	ChannelTextRequest q;
	q.textMsg = text;
	q.wildCard.append(getChannelKeyById(channelKeyId));
	q.flag.append(toString(id));

	q.expand= ext;

	//发送消息//
	return msgDispatcher->send(&q);
}

bool YVChannalChatManager::SendMsgChannalVoice(int channelKeyId, uint64 id, const std::string & text, YVFilePathPtr voicePath,
	uint32 voiceTime, const std::string & ext)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher*  msgDispatcher = platform->getMsgDispatcher();
	//发送前需要识别语音
	if (platform->speechWhenSend)
	{
		return platform->speechVoice(voicePath);
	}
	else
	{
		//构造消息
		ChannelVoiceRequest q;
		q.txt = text;
		q.voiceDurationTime = voiceTime;
		q.wildCard.append(getChannelKeyById(channelKeyId));
		q.voiceFilePath = voicePath->getLocalPath();
		//q.txt = text;
		q.flag.append(toString(id));
		q.expand = ext;

		//发送消息//
		return msgDispatcher->send(&q);
	}
}

void YVChannalChatManager::SendMsgCache(int channelKeyId,YVMessagePtr msg)
{
	if (m_sendMsgCache->getMessageList().size() != 0)
	{
		std::vector<YVMessagePtr>& sendingmsgs = m_sendMsgCache->getMessageList();
		std::vector<YVMessagePtr>::iterator it = sendingmsgs.begin();
		YVMessagePtr Cache = *it;
		if (Cache->state == YVMessageStatusSendingFailed)
		{
			insertMsg(channelKeyId, msg,true, false);
			//放至消息发送列表里
			m_sendMsgCache->delMessageById(Cache->id);
			m_sendMsgCache->insertMessage(msg, true);
		}
		else
		{
			insertMsg(channelKeyId, msg, true);
			//放至消息发送列表里
			m_sendMsgCache->insertMessage(msg, true);
		}
	}
	else
	{
		insertMsg(channelKeyId, msg, true);
		//放至消息发送列表里
		m_sendMsgCache->insertMessage(msg, true);
	}
}

void YVChannalChatManager::insertMsg(int channelKeyId, YVMessagePtr msg, bool isInsertBack,bool isCallChannelChatListern)
{
	ChannelMessageMap::iterator it = m_channelMssages.find(channelKeyId);
	if (it == m_channelMssages.end())
	{
		YVPlatform* platform = YVPlatform::getSingletonPtr();
		YVMessageListPtr messageList = new _YVMessageList();
		messageList->setMaxNum(platform->channelChatCacheNum);
		messageList->setChatWithID((uint32)channelKeyId);
		m_channelMssages.insert(std::make_pair((uint32)channelKeyId, messageList));
		it = m_channelMssages.find((uint32)channelKeyId);
	}
	it->second->insertMessage(msg, isInsertBack);
	//调用消息回调//
	if (isCallChannelChatListern)
	{
		callChannelChatListern(msg);
	}
}

//录音发送//
bool YVChannalChatManager::sendChannalVoice(int channelKeyId, YVFilePathPtr voicePath,
	uint32 voiceTime, const std::string & ext)
{
	if (!(voicePath->getState() == OnlyLocalState
		|| voicePath->getState() == BothExistState))
	{
		return false;
	}
	expand = "";
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher*  msgDispatcher = platform->getMsgDispatcher();
	
	//消息存入缓存//
	YVMessagePtr msg = new _YVVoiceMessage(voicePath, voiceTime, "");
	msg->recvId = channelKeyId;
	msg->sendId = platform->getLoginUserInfo()->userid;
	msg->state = YVMessageStatusSending;
	msg->sendTime = time(0);
	msg->wildcard = getChannelKeyById(channelKeyId);
	msg->ext = ext;
	//缓存消息
	insertMsg(channelKeyId, msg, true);
	//放至消息发送列表里
	if (m_sendMsgCache->getMessageById(msg->id) == NULL)
	m_sendMsgCache->insertMessage(msg, true);


	if (!platform->GetNetState())
	{
		msg->state = YVMessageStatusSendingFailed;
		callChannelChatStateListern(msg);
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
		ChannelVoiceRequest q;
		q.txt = "";
		q.voiceDurationTime = voiceTime;
		q.wildCard.append(getChannelKeyById(channelKeyId));
		q.voiceFilePath = voicePath->getLocalPath();
		//q.txt = text;
		q.flag.append(toString(msg->id));
		q.expand = ext;

		//发送消息//
		return msgDispatcher->send(&q);
	}
}

bool YVChannalChatManager::getChannalHistoryData(int channelKeyId, int index)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();

	//获取一屏的数量历史消息的数量// 
	uint32  count = platform->channelHistoryChatNum;
	m_historyCache->clear();
	m_historyCache->setMaxNum(count);

	ChannelHistoryRequest q;
	q.count = 0 - count;
	q.index = index;
	q.wildCard.append(getChannelKeyById(channelKeyId));

	YVMsgDispatcher*  msgDispatcher = YVPlatform::getSingletonPtr()->getMsgDispatcher();
	return msgDispatcher->send(&q);
}

std::string& YVChannalChatManager::getChannelKeyById(int id)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();

	assert(id <  platform->channelKey.size() && id >= 0);
	return  platform->channelKey.at(id);
}

void YVChannalChatManager::setChannelKey(int id,const std::string & key)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();

	platform->channelKey.push_back(key);
	//platform->channelKey.insert(std::make_pair((uint32)id, key));
}

int  YVChannalChatManager::getChannelIdByKey(const std::string & key)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	int id = 0;
	for (std::vector<std::string>::iterator it = platform->channelKey.begin();
		it != platform->channelKey.end(); ++it)
	{
		if (*it == key)
		{
			return id;
		}
		++id;
	}
	return -1;
}

YVMessageListPtr YVChannalChatManager::getCacheChannalChatData(int channelKeyId)
{
	ChannelMessageMap::iterator it = m_channelMssages.find(channelKeyId);
	if (it == m_channelMssages.end())
	{
		return NULL;
	}
	return (it->second);
}

void YVChannalChatManager::onFinishSpeechListern(SpeechStopRespond* r)
{
	if (r == NULL) return;
	std::vector<YVMessagePtr>& sendingmsgs = m_sendMsgCache->getMessageList();
	for (std::vector<YVMessagePtr>::iterator it = sendingmsgs.begin();
		it != sendingmsgs.end(); ++it)
	{
		YVMessagePtr msg = *it;
		if (msg->type != YVMessageTypeAudio) continue;
		YVVoiceMessagePtr voiceMsg = msg;
		if (voiceMsg->voicePath != r->filePath) continue;
		voiceMsg->attach.clear();
		if (r->err_id == 0)
			voiceMsg->attach.append(r->result);
		else
			voiceMsg->attach.append("\xe8\xaf\x86\xe5\x88\xab\xe5\xa4\xb1\xe8\xb4\xa5\xef\xbc\x81");

		ChannelVoiceRequest q;
		//q.txt = "";
		q.voiceDurationTime = voiceMsg->voiceTimes;
		q.wildCard.append(getChannelKeyById(voiceMsg->recvId));
		//q.voiceFilePath = r->filePath->getLocalPath();
		q.voiceFilePath = r->url;
		q.txt = r->result;
		q.flag.append(toString(msg->id));
		q.expand = expand;

		//CCLOG("---%s", r->result);

		//发送消息//
		YVPlatform* platform = YVPlatform::getSingletonPtr();
		YVMsgDispatcher*  msgDispatcher = platform->getMsgDispatcher();
		msgDispatcher->send(&q);
	}
}

bool YVChannalChatManager::ModchannalId(bool operate, int channelKey, const std::string & wildCard)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher* msgDispatcher = platform->getMsgDispatcher();

	ModChannelIdRequest r;
	r.operate = operate;
	r.wildCard.append(wildCard);
	r.channel = channelKey;
	//setChannelKey(channelKey,wildCard);

	return msgDispatcher->send(&r);
}

bool YVChannalChatManager::setChannelSendTime(uint32 time)
{
	SetChannelSendTime r;
	r.times = time;
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher* msgDispatcher = platform->getMsgDispatcher();
	return msgDispatcher->send(&r);
}

////登录 注:登录账号传入了通配符，会直接登录， 不需要再调此登录  IM_CHANNEL_LOGIN_REQ
//struct ChannelLoginRequest :YaYaRequestBase   
bool YVChannalChatManager::channelLoginRequest()
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	ChannelLoginRequest q;
	q.pgameServiceID = platform->serverid;
	q.wildCard = platform->channelKey;

	YVMsgDispatcher* msgDispatcher = platform->getMsgDispatcher();
	return msgDispatcher->send(&q);
}

//频道登录返回  在收到此回调成功后才做频道切换
void YVChannalChatManager::ChannalloginBack(YaYaRespondBase* respond)
{ 
	ChanngelLonginRespond* r = static_cast<ChanngelLonginRespond*>(respond);
	if (r->result == 0)
	{
		
	}
	else
	{
		ChannelLoginRequest();
	}
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	platform->setRecordTime(60, 1);
	//platform->setChannelSendTime(10);

	callChannalloginListern(r);
}

//频道修改返回  
void YVChannalChatManager::ModChannelIdBack(YaYaRespondBase* respond)
{
	ModChannelIdRespond* r = static_cast<ModChannelIdRespond*>(respond);
	if (r->result == 0)
	{

	}
	YVPlatform::getSingletonPtr()->channelKey = r->wildCard;
	callModChannelIdListern(r);
}
