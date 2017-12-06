/*********************************************************************************
*Copyright(C), 2015 YUNVA Company
*FileName:  RespondFactory.cpp
*Author:  Matt
*Version:  1.0.0
*Date:  2015-5-20
*Description: 频道聊天界面
**********************************************************************************/

#include "ChannalChatNode.h"
#include <string>
#include "ChatItem.h"
//#include "LoginScene.h"
//#include "MsgPopup.h"
#include "HclcData.h"

USING_NS_CC;
using namespace ui;
using namespace YVSDK;

ChannalChatNode::~ChannalChatNode()
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	platform->delChannelChatListern(this);
	platform->delChannelHistoryChatListern(this);
	platform->delChannelChatStateListern(this);
	platform->delChannalloginListern(this);
	platform->delRecordVoiceListern(this);
}

void ChannalChatNode::setParent(cocos2d::Node* parent)
{
	YVChatNode::setParent(parent);
}

void ChannalChatNode::removeFromParent()
{
	YVChatNode::removeFromParent();
}

void ChannalChatNode::onEnter()
{
	Node::onEnter();
	YVPlatform* p = YVPlatform::getSingletonPtr();
	p->setIsInChatChannel(true);
	p->setNewMessageChatChannel(false);
	UserDefault::getInstance()->setBoolForKey("hasNewMessageInChatChannel", false);
}

void ChannalChatNode::onExit()
{
	Node::onExit();
	YVPlatform* p = YVPlatform::getSingletonPtr();
	p->setIsInChatChannel(false);
}

bool ChannalChatNode::init()
{
	if (!YVChatNode::init())
	{
		return false;
	}
    
    m_curChannalIndex = 0;

//	Button* picButton = (Button*)m_textInputNode->getChildByName("PicButton");
//	picButton->setTouchEnabled(false);
//	picButton->setVisible(false);
//
//	m_moreButton->setTouchEnabled(false);
//	m_moreButton->setVisible(false);
    
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	platform->addChannelChatListern(this);
	platform->addChannelHistoryChatListern(this);
	platform->addChannelChatStateListern(this);
	platform->addChannalloginListern(this);
	platform->addRecordVoiceListern(this);

	//数据初使化
//	bool isInitData = false;
//	YVMessageListPtr msgList = platform->getCacheChannalChatData(0);
//	if (msgList != NULL)
//	{
//		std::vector<YVMessagePtr>&  msgs = msgList->getMessageList();
//		for (auto it = msgs.begin(); it != msgs.end(); ++it)
//		{
//			onChannelChatListern(*it);
//		}
//		isInitData = true;
//	}
//
//	 m_voiceList.clear();
//    
//	if (!isInitData)
//	{
//		getChannalHistoryD();
//
//	}
    
    YVPlatform * p = YVPlatform::getSingletonPtr();
    
    p->setIsInChatChannel(true);
    p->setNewMessageChatChannel(false);
    UserDefault::getInstance()->setBoolForKey("hasNewMessageInChatChannel", false);

//	bool bnewMessage = UserDefault::getInstance()->getBoolForKey("hasNewMessageInChatChannel", false);
//	p->setNewMessageChatChannel(bnewMessage);
    

    return true;
}
void ChannalChatNode::getChannalHistoryD()
{
	Director::getInstance()->getScheduler()->
		schedule(schedule_selector(ChannalChatNode::getChannalHistory), this, 0.01, 0.5, 0.0f, false);
}


void ChannalChatNode::getChannalHistory(float dt)
{

	Director::getInstance()->getScheduler()->
		unschedule(schedule_selector(ChannalChatNode::getChannalHistory), this);
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	platform->getChannalHistoryData(0, 0);
}

void ChannalChatNode::sendText()
{ 
//	std::string text = m_textField->getStringValue();
//	std::string ext = "忠忠";
//	if (text.length() == 0)
//	{
//		return;
//	}
//	YVPlatform* platform = YVPlatform::getSingletonPtr();
//#if 0
//	for (int i = 0; i < 5; i++)
//	{
//		platform->sendChannalText(0, text, ext);
//	}
//#endif
//	text.append(platform->getChannelKeyById(0));
//	platform->sendChannalText(0, text, ext);
//
//	YVChatNode::sendText();
}

//录音发送
void ChannalChatNode::sendVoice(YVSDK::YVFilePathPtr voicePath, float voiceTime)
{
	YVPlatform* platform= YVPlatform::getSingletonPtr();
	if (voicePath != NULL && voicePath->getLocalPath().empty() && voicePath->getUrlPath().empty())
	{
        CCLOG("voicePath is null");
		//MsgPopup::getSingletonPtr()->setErroText("voicePath is null");
		return;
	}
	if (voiceTime > 0)
	{
        platform->sendChannalVoice(m_curChannalIndex, voicePath, voiceTime, m_extStr);
       // platform->sendChannalVoice(0, voicePath, voiceTime, "");
		YVChatNode::sendVoice(voicePath, voiceTime);
	}

}
void ChannalChatNode::onChannelChatListern(YVSDK::YVMessagePtr msg)
{
    
    CCLOG("receive:message--keystring = %ud-----wildcard = %s----",msg->recvId,msg->wildcard.c_str());
    if(m_curChannalIndex != msg->recvId or m_curChannalStr.compare(msg->wildcard) != 0)
    {
        CCLOG("keystring is not equal or wildcard is not equal--");
        return;
    }
    
	/*YVSDK::YVVoiceMessagePtr yvm = msg;
	MsgPopup::getSingletonPtr()->setErroText(yvm->attach);*/
	YVPlatform* p = YVPlatform::getSingletonPtr();
	if (p->getIsInChatChannel() == false)
	{
		p->setNewMessageChatChannel(true);
		UserDefault::getInstance()->setBoolForKey("hasNewMessageInChatChannel", true);
	}
	else
	{
		p->setNewMessageChatChannel(false);
		UserDefault::getInstance()->setBoolForKey("hasNewMessageInChatChannel", false);
	}
    
    ChatItem* item = getItemByMsgEx(msg);

    if (item == NULL)
    {
        item = new ChatItem();
        item->m_extNickStr = msg->ext;
        item->setChatMessage(msg, true, false);
//			item->setTimevisible(false);
      //  item->setChatNode(this);
        if (msg->state == YVMessageStatusSending)
        {
            //item->setWaitAnim(true);
        }
//	    addContextItem(item);
        //如果是声音,开启自动播放
        if (msg->type != YVMessageTypeAudio) return;
//			uint32 uid = YVPlatform::getSingletonPtr()->getLoginUserInfo()->userid;
//
//			if (msg->sendId == uid) return;
//            
        m_voiceList.insert(m_voiceList.begin(),item);//在最前面插入新元素。
//
    }
    else
    {
        if (msg->state == YVMessageStatusSending)
        {
        
             item->setWaitAnim(true);
             //item->showReSendButton(false);
             //item->setChatMsg(msg);
        }

        if (msg->state == YVMessageStatusSendingFailed)
        {
              CCLOG("SendingFailed------------");
            // item->showReSendButton(true);
        }
    }

}

void ChannalChatNode::onChannelHistoryChatListern(YVSDK::YVMessageListPtr msgList)
{
     CCLOG("receive:ChannelHistorymessage-----------");
//	if (msgList->getChatWithID() != 0) return;
//
//    CCLOG("receive:ChannelHistory--succ-----------");
//	std::vector<YVMessagePtr>&  msgs = msgList->getMessageList();
	//MsgPopup::getSingletonPtr()->setErroText(msgs[0]->ext);
	
//	for (auto it = msgs.rbegin(); it != msgs.rend(); ++it)
//	{
//		ChatItem* item = ChatItem::create();
//		item->setChatMessage(*it,false,false);
//		item->setTimevisible(false);
//		addContextItem(item, 0);
//		item->setChatNode(this);
//
//		
//		//如果是/声音,开启自动播放
//		if (isAutoPlayVoice == true && (*it)->type == YVMessageTypeAudio)
//		{
//			uint32 uid = YVPlatform::getSingletonPtr()->getLoginUserInfo()->userid;
//			if ((*it)->sendId != uid)
//			m_voiceList->insertObject(item, m_voiceList->count());
//		}
//	}
}

void ChannalChatNode::onChannelChatStateListern(YVSDK::YVMessagePtr msg)
{
    
    CCLOG("onChannelChatStateListern-----------");
	ChatItem* item = getItemByMsgEx(msg);
	//YVMessageListPtr m_sendMsgCache = new _YVMessageList();
	if (item != NULL)
	{
        
		if (msg->state == YVMessageStatusCreated)
		{	
			item->setWaitAnim(false);
//			item->showReSendButton(false);
			item->setChatMsg(msg);
			return;
		}
		if (msg->state == YVMessageStatusSendingFailed)
		{
            CCLOG("SendingFailed----------");
			item->setWaitAnim(false);
//			item->showReSendButton(true);
		}
	}
}

void ChannalChatNode::PlayVoice(uint64_t msgID, bool isBegin)
{
    ChatItem* item = getItemByMsg(msgID);
    
    if(item == NULL)
    {
        CCLOG("ChatITem is NULL");
        return;
    }
    
    if(isBegin)
    {
        item->PlayVoiceBegin(msgID);
    }
    else
    {
        item->PlayVoiceEnd(msgID);
    }
}

void ChannalChatNode::PlayVoiceEx(std::string msgIDStr, bool isBegin)
{
    
    std::stringstream strValue;
    
    strValue << msgIDStr.c_str();
    
    uint64_t  msgID = 0;
    
    strValue >> msgID;

    
    ChatItem* item = getItemByMsg(msgID);
    
    if(item == NULL)
    {
        CCLOG("ChatITem is NULL");
        return;
    }
    
    if(isBegin)
    {
        item->PlayVoiceBegin(msgID);
    }
    else
    {
        item->PlayVoiceEnd(msgID);
    }
}

void ChannalChatNode::onModChannelIdListern(YVSDK::ModChannelIdRespond* r)
{
    int a = 5;
}

void ChannalChatNode::onChannalloginListern(YVSDK::ChanngelLonginRespond* r)
{
	CCLOG("onChannalloginListern-----------");
	if (r->result)
	{
		CCLOG("onChannalloginListern:error-----------");
	}
    
//    YVPlatform* platform = YVPlatform::getSingletonPtr();
//    
//    std::string channestr = m_curChannalStr;
//    
//    platform->ModchannalId(true, 0, channestr);
//    // index = platform->getChannelId(channestr);
//    
//    m_curChannalIndex = 1;
    
}

void ChannalChatNode::onRecordVoiceListern(YVSDK::RecordVoiceNotify* r)
{
	CCLOG("======================count = %d", r->volume);
}
