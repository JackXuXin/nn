/*********************************************************************************
*Copyright(C), 2015 YUNVA Company
*FileName:  RespondFactory.cpp
*Author:  Matt
*Version:  1.0.0
*Date:  2015-5-20
*Description:  好友聊天窗口
**********************************************************************************/

#include "FriendChatNode.h"
#include "ChatItem.h"
//#include "MainScene.h"
//#include "UserInfoNode.h"
//#include "MsgPopup.h
USING_NS_CC;
using namespace ui;
using namespace YVSDK;


bool FriendChatNode::init()
{
	if (!YVChatNode::init())
	{
		return false;
	}
	m_chatWithUid = -1;
    indexTemp = 0;
	uinfo = NULL;
    
    YVPlatform* platform = YVPlatform::getSingletonPtr();
    platform->addFriendChatStateListern(this);
    
    return true;
}


void FriendChatNode::onExit()
{
//	YVPlatform* p = YVPlatform::getSingletonPtr();
//	p->setChatNodeUid(0);
	Node::onExit();
}


FriendChatNode::~FriendChatNode()
{
    YVPlatform* platform = YVPlatform::getSingletonPtr();
    platform->delUpdateUserInfoListern(this);
    platform->delFriendChatListern(this);
    platform->delFriendHistoryChatListern(this);
    platform->delFriendChatStateListern(this);
    
    YVPlatform* p = YVPlatform::getSingletonPtr();
    p->setChatNodeUid(0);
}

void FriendChatNode::setChatUid(uint32 uid)
{
	m_chatWithUid = uid;

	YVPlatform* platform = YVPlatform::getSingletonPtr();


	platform->addUpdateUserInfoListern(this);
	platform->addFriendHistoryChatListern(this);

	uinfo = YVPlatform::getSingletonPtr()->getUInfoById(uid);
	if (uinfo != NULL)
	{
		YVPlatform::getSingletonPtr()->setChatNodeUid(uinfo->userid);
        platform->addFriendChatListern(this);
	}
	else
	{
		//setTitle("chat with a friend");
		platform->addFriendChatListern(this);
	}
    

	//根据缓存数据恢复聊天数据
	YVMessageListPtr msgList = platform->getFriendChatListById(uid);

	//没有数据，获取点历史消息
	if (msgList == NULL  || msgList->getMessageList().size() == 0)
	{
		//getBeforeMsg();
		return;
	}
	
	//从缓存里恢复数据
	auto msgs = msgList->getMessageList();

	for (auto it = msgs.rbegin(); it != msgs.rend(); ++it)
	{
		ChatItem* item = new ChatItem();
        item->init();
		YVMessagePtr mess = *it;
		item->setChatMessage(*it, true, true);
		if (mess->state == YVMessageStatusSendingFailed || mess->state == YVMessageStatusSending)
		{
			//item->showReSendButton(true);
		}
		//addContextItem(item, 0);
		//item->setChatNode(this);
	}

}

 void FriendChatNode::InitTempChatData(uint32 uid)
{
    YVPlatform* platform = YVPlatform::getSingletonPtr();
    //根据缓存数据恢复聊天数据
    YVMessageListPtr msgList = platform->getFriendChatListById(uid);
    
    if (msgList == NULL)
    {
        return;
    }
    
    //从缓存里恢复数据
    auto msgs = msgList->getMessageList();
    
   // for (auto it = msgs.rbegin(); it != msgs.rend(); ++it)
    for (auto it = msgs.rend()-1; it != msgs.rbegin()-1; --it)
    {
        
        YVMessagePtr msg = *it;
        ChatItem* item = NULL;
        
        item = new ChatItem();
        item->m_nPlayID = msg->id;
        item->setChatMessage(msg,true,true);
        
        //如果是声音
        //if (isAutoPlayVoice == false || msg->type != YVMessageTypeAudio) return;
        //if (msg->type != YVMessageTypeAudio) return;
        //排除自己的id
        //int uid = YVPlatform::getSingletonPtr()->getLoginUserInfo()->userid;
        //if (uid == msg->sendId) return;
        m_voiceList.insert(m_voiceList.begin(),item);//在最前面插入新元素。
   }
}

void FriendChatNode::sendText(std::string &strMsg)
{
	std::string text = strMsg;
	std::string ext = "hello, friend text";   //扩展字段
	if (text.length() == 0)
	{
		return;
	}
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	platform->sendFriendText(m_chatWithUid, text,ext);
	//存buff
	//ChatNode::sendText();

	//schedule(schedule_selector(FriendChatNode::delaytime), 5);
}



void FriendChatNode::sendVoice(YVFilePathPtr voicePath, float voiceTime)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	if (voicePath != NULL && voicePath->getLocalPath().empty() && voicePath->getUrlPath().empty())
	{
		//MsgPopup::getSingletonPtr()->setErroText("voicePath is null");
		return;
	}
	if (voiceTime > 0)
	{
		platform->sendFriendVoice(m_chatWithUid, voicePath, voiceTime, "hello,friend");
		YVChatNode::sendVoice(voicePath, voiceTime);
	}
	
}

void FriendChatNode::sendPic(std::string &picPath)
{
	/*CCLOG("sendimage Path:%s", picPath.c_str());
	FriendChatManager& friendChatManager = SDKCenter::getSingletonPtr()->getFriendChatManager();
	friendChatManager.sendPic(m_chatWithUid, picPath);
	ChatNode::sendPic(picPath);*/
}

void FriendChatNode::clickMoreButton()
{

//	if (m_chatWithUid < 0) return;
//	UserInfoNode* userInfoNode = UserInfoNode::create();
//	userInfoNode->setUid(m_chatWithUid);
//	MainScene* scene = (MainScene*)this->getScene();
//	if (scene != NULL)
//	{
//		scene->pushLayer(userInfoNode);
//	}
}

long long FriendChatNode::getHistoryIndex()
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMessageListPtr msgList = platform->getFriendChatListById(m_chatWithUid);
	long long index = 0;
	if (msgList != NULL  && msgList->getMessageList().size() != 0)
	{
		for (auto msg : msgList->getMessageList())
		{
			if (index == 0)
			{
				index = msg->index;
			}
			if (index > msg->index)
			{
				index = msg->index;
			}
		}
	}
	if (index == 1)
	{
		return -1;
	}
	return index - 1;
}

void FriendChatNode::getBeforeMsg()
{
    uint64 index = 0;
    YVPlatform* platform = YVPlatform::getSingletonPtr();
    YVMessageListPtr msgList = platform->getFriendChatListById(m_chatWithUid);
    if (msgList != NULL  && msgList->getMessageList().size() != 0)
    {
        YVMessagePtr msg;
        if(indexTemp == 0)
        {
            msg = msgList->getMessageList().back();
			indexTemp = msg->index;
			index = getHistoryIndex();
        } else
        {
			index = getHistoryIndex();
        }

        if (index <= 0)
            index = -1;
    }
    
    platform->getFriendChatHistoryData(m_chatWithUid, index);
}


void FriendChatNode::onFriendChatListern(YVSDK::YVMessagePtr msg)
{
	
	if (uinfo == NULL)    //没有在聊天界面
	{
		return;
	}
    
    YVPlatform* platform = YVPlatform::getSingletonPtr();
    uint32 ID =platform->getLoginUserInfo()->userid;
    
    CCLOG("recvID:%d,m_chatWithUid:%d",msg->recvId,m_chatWithUid);
    
    if (msg->recvId!=ID && msg->recvId!=m_chatWithUid)
    {
        return;
    }
    // && msg->type == YVMessageTypeAudio
    
	//MsgPopup::getSingletonPtr()->setErroText(msg->ext);
	
	if (ID != msg->sendId)
	{
		if (uinfo->userid != msg->sendId)   //  是在同一个好友界面
		{
			return;
		}
	}
    
	
	ChatItem* item = getItemByMsgEx(msg);
	if (item != NULL)
	{
		if (msg->state == YVMessageStatusCreated)
		{
			item->setWaitAnim(false);
			//item->showReSendButton(false);
			item->setChatMsg(msg);
			return;
		}
		if (msg->state == YVMessageStatusSendingFailed)
		{
			item->setWaitAnim(false);
			//item->showReSendButton(true);
		}
		return;
	}
    
    item = new ChatItem();
    item->m_nPlayID = msg->id;
	item->setChatMessage(msg,true,true,true);

	if (msg->state == YVMessageStatusSending)
	{
		//item->setWaitAnim(true);
	}

   //addContextItem(item);

	//发云确认消息
	platform->sendConfirmMsg(msg->index, msg->source);

	//如果是声音
	//if (isAutoPlayVoice == false || msg->type != YVMessageTypeAudio) return;
    //if (msg->type != YVMessageTypeAudio) return;
	//排除自己的id
	//int uid = YVPlatform::getSingletonPtr()->getLoginUserInfo()->userid;
	//if (uid == msg->sendId) return;
    m_voiceList.insert(m_voiceList.begin(),item);//在最前面插入新元素。
}

void FriendChatNode::onFriendChatStateListern(YVSDK::YVMessagePtr msg)
{
	if (msg->recvId != m_chatWithUid) return;
	//ChatItem* item = getItemByMsg(msg);
/*	if (item != NULL)
	{
		if (msg->state == YVMessageStatusCreated)
		{
			item->setWaitAnim(false);
			item->showReSendButton(false);
			item->setChatMsg(msg); 
			return;
		}
		if (msg->state == YVMessageStatusSendingFailed)
		{
			item->setWaitAnim(false);
			item->showReSendButton(true);
		}
		if (msg->state == YVMessageStatusSending)
		{
			item->setWaitAnim(false);
			item->showReSendButton(true);
		}
	}
	else{
		std::string sd = YVSDK::toString(msg->id);
		MsgPopup::getSingletonPtr()->setErroText(sd);
	}*/
}

void FriendChatNode::onFriendHistoryChatListern(YVSDK::YVMessageListPtr msgList)
{
	auto msgs = msgList->getMessageList();
	if (msgs.size() == 0)
	{
		return;
	}
/*	for (auto it = msgs.rbegin(); it != msgs.rend(); ++it)
	{
		ChatItem* item = ChatItem::create();
		item->setChatMessage(*it, false,true);
		addContextItem(item, 0);
		item->setChatNode(this);

		//如果是/声音,开启自动播放
		if (isAutoPlayVoice == true && (*it)->type == YVMessageTypeAudio)
		{
			uint32 uid = YVPlatform::getSingletonPtr()->getLoginUserInfo()->userid;
			if ((*it)->sendId != uid)
				m_voiceList->insertObject(item, m_voiceList->count());
		}
	}*/
}

void FriendChatNode::onUpdateUserInfoListern(YVSDK::YVUInfoPtr uinfo)
{
	if (uinfo->userid != m_chatWithUid) return;
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	platform->delUpdateUserInfoListern(this);
	//setTitle(uinfo->nickname);
}

void FriendChatNode::PlayVoice(uint64_t msgID, bool isBegin)
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

void FriendChatNode::PlayVoiceEx(std::string msgIDStr, bool isBegin)
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
