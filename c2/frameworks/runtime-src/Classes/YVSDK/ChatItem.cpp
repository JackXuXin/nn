/*********************************************************************************
*Copyright(C), 2015 YUNVA Company
*FileName:  RespondFactory.cpp
*Author:  Matt
*Version:  1.0.0
*Date:  2015-5-15
*Description:  一条消息的item显示UI
**********************************************************************************/

#include "ChatItem.h"
#include <stdlib.h>
#include "HclcData.h"
//#include "MainScene.h"
//#include "FriendChatNode.h"
//#include "MsgPopup.h"

USING_NS_CC;
using namespace ui;
using namespace YVSDK;

bool m_IsautoplayVoid;
unsigned long tempvoiceID;
unsigned long voiceID;

ChatItem::ChatItem()
{
    if(init() == false)
    {
        CCLOG("ChatItem Init error");
    }
}

ChatItem::~ChatItem()
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	platform->delDownLoadFileListern(this);
	platform->delFinishPlayListern(this);
	platform->delUpdateUserInfoListern(this);
    
    cocos2d::Director::getInstance()->getScheduler()->unschedule(schedule_selector(ChatItem::delaytime),this);
    cocos2d::Director::getInstance()->getScheduler()->unschedule(schedule_selector(ChatItem::MutUpdate), this);

}

bool ChatItem::init()
{
	if (!Node::init())
	{
		return false;
	}
	isGroupItem = false;
	m_isShowWaitAnim = false;
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	platform->addFinishPlayListern(this);
    
    m_bIsHasPlay = false;

	m_isVoiceMssage = false;
	downloadNum = 0;
	m_rootNode = NULL;
	m_voicePath = NULL;
	m_headIocnPath = NULL;
	m_IsautoplayVoid = true;
	tempvoiceID = -1;
	m_Message = NULL;
	//tempvoiceID = m_voicePath->getPathId();
	m_Playover = false;
	friendchatflag = true;
	userinfo = NULL;

    
	return true;
}


void ChatItem::setChatMsg(YVMessagePtr msg)
{
	YVVoiceMessagePtr Vomsg = msg;
//	if (m_isVoiceMssage){
//		showMessageVoiceText(Vomsg->attach);
//	}
	if (msg->type == YVMessageTypeText)
	{

		YVTextMessagePtr textmsg = msg;
	
		initTextMessage(textmsg->text);
	}
	
}

void ChatItem::setChatMessage(YVMessagePtr msg,bool flag,bool chatflag, bool isNew)
{
 	m_msg = msg;

	if (isSendMessage(msg))
	{
		m_isSendItem = true;
	}
	else
	{
		m_isSendItem = false;
	}
    
    YVPlatform* platform = YVPlatform::getSingletonPtr();
    
    std::string nick = platform->getLoginUserInfo()->nickname;
    std::string thirdUid = platform->getLoginUserInfo()->thirdUid;
    YVFilePathPtr head = platform->getLoginUserInfo()->header;
    std::string iconImage = head->getUrlPath();
    
    CCLOG("TUid:%s,urlPath:%s",thirdUid.c_str(), iconImage.c_str());
    
    int timeNum = 0;
    
    bool ishasVoice = false;
    std::string msgTest;
    
    switch (msg->type)
    {
        case YVMessageTypeText:
        {
            YVTextMessagePtr message = msg;
            msgTest = message->text;
           // initTextMessage(message->text);
            break;
        }
        case YVMessageTypeImage:
        {
            YVImageMessagePtr message = msg;
            initPicMessage(message);
            break;
        }
        case YVMessageTypeAudio:
        {
            YVVoiceMessagePtr message = msg;
            
            timeNum = ceil(message->voiceTimes / 1000.0f);
            
            initVoiceMessage(message, flag);
            
             YVFilePathPtr voicePath = message->voicePath;
             if (voicePath != NULL && (voicePath->getState() == BothExistState || voicePath->getState() == OnlyLocalState) )
             {
                 ishasVoice = true;
             }
             else
             {
                 YVPlatform* platform = YVPlatform::getSingletonPtr();
                 platform->addDownLoadFileListern(this);
                 platform->downLoadFile(voicePath);
             
                 ishasVoice = false;
                 //开启菊花特效// 下载提示
                 setWaitAnim(true);
             
             }
             m_voicePath = voicePath;
            
            break;
        }
            
    }
    
    if(msgTest.length()==0)
    {
        msgTest = "en";
    }
    
    if (chatflag)
    {
        
        HclcData::sharedHD()->callLuaFunctionEx("src/app/scenes/LobbyScene.lua", "setFriendChatMessage", msg, m_isSendItem, isNew, nick.c_str(), timeNum, thirdUid.c_str(), iconImage.c_str(), ishasVoice, flag, msgTest.c_str());
    }
    else
    {
  
        HclcData::sharedHD()->callLuaFunctionEx("src/app/Common/util.lua", "setChatMessage", msg, m_isSendItem, chatflag, m_extNickStr.c_str(), timeNum, thirdUid.c_str(), iconImage.c_str(), ishasVoice, flag, msgTest.c_str());
    }
    
	friendchatflag = chatflag;
	//this->setContentSize(m_rootNode->getContentSize());
	//this->addChild(m_rootNode);

	initMessageHeader(msg);
	//initMessageContent(msg, flag);
}


YVSDK::YVMessagePtr ChatItem::getChatMessage()
{ 
	return m_msg; 
}

bool  ChatItem::isSendMessage(YVMessagePtr base)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	if (platform->getLoginUserInfo()->userid == base->sendId)
		return true;
	
	return false;
}

void ChatItem::initMessageHeader(YVMessagePtr message)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	userinfo = platform->getUInfoById(message->sendId);
	if (userinfo == NULL)
	{
		
		platform->addUpdateUserInfoListern(this);
		platform->getUserInfoSync(message->sendId);
		return;
	}
	//setUserInfo(userinfo);
//	Text* messageTimeLayer = (Text*)m_rootNode->getChildByName("TimeLabel");
//
//	uint32 uid = platform->getLoginUserInfo()->userid;
//	Text* nickNameNameLayer = (Text*)m_rootNode->getChildByName("NickName");
//	if (message->sendId == uid)
//	{
//		float distances = nickNameNameLayer->getPositionX() - nickNameNameLayer->getContentSize().width;
//		if (distances < messageTimeLayer->getPositionX())
//		{
//			messageTimeLayer->setPositionX(messageTimeLayer->getPositionX() - (messageTimeLayer->getPositionX() - distances) - 10);
//		}
//	}
//	else
//	{
//		float distances = nickNameNameLayer->getPositionX() + nickNameNameLayer->getContentSize().width;
//		if (distances > messageTimeLayer->getPositionX())
//		{
//			messageTimeLayer->ignoreAnchorPointForPosition(false);
//			messageTimeLayer->setAnchorPoint(Vec2(0, messageTimeLayer->getAnchorPoint().y));
//			messageTimeLayer->setPositionX(messageTimeLayer->getPositionX() + distances - messageTimeLayer->getPositionX() + 10);
//		}
//	}
//	char timestr[9];
//	memset(timestr, 0, 9);
//	time_t t = message->getTimeStamp();
//	struct tm *ttime = localtime(&t);
//	strftime(timestr, 9, "%H:%M:%S", ttime);
//	messageTimeLayer->setString(timestr);


}


void ChatItem::initMessageContent(YVMessagePtr message,bool flag)
{
	switch (message->type)
	{
	case YVMessageTypeText:
	{
							  YVTextMessagePtr msg = message;
							  initTextMessage(msg->text);
							  break;
	}
	case YVMessageTypeImage:
	{
							   YVImageMessagePtr msg = message;
							   initPicMessage(msg);
							   break;
	}
	case YVMessageTypeAudio:
	{
							   YVVoiceMessagePtr msg = message;
							   initVoiceMessage(msg, flag);
							   break;
	}
	}
}

void ChatItem::initTextMessage(std::string&  te)
{
//	Color3B  WHITE{ 0xFF, 0xFF, 0xFF };
//	Text* messageLayer = (Text*)m_rootNode->getChildByName("MessageLabel");
//	messageLayer->setText("");
//		
//	RichText* richText = RichText::create();
//	richText->ignoreContentAdaptWithSize(false);
//	richText->setContentSize(CCSizeMake(360, 100));
//	richText->ignoreAnchorPointForPosition(false);
//
//	//获取消息内容
//
//	std::string text = te;
//	//获取表情信息
//	std::string kong = "\n";
//	char buff[20] = { 0 };
//	std::string strBuff;
//	int i = 0;
//	for (int index = 0; index < text.length();)
//	{
//		char* cursor = (char*)text.c_str() + index;
//
//		if (*cursor != '/')
//		{
//			++index;
//			strBuff.push_back(*cursor);
//			continue;
//		}
//
//		FaceDataMap* face = ChatNode::getFaceData();
//		RichElement* r = NULL;
//		for (FaceDataMap::iterator it = face->begin(); it != face->end(); ++it)
//		{
//			int len = strlen(it->second->tag.c_str());  
//			memset(buff, 0, 5);
//			if (index + len > text.length()) continue;  
//			memcpy(buff, cursor, len);
//			if (strcmp(buff, it->second->tag.c_str()) != 0) continue;
//			CCSprite* img = CCSprite::createWithSpriteFrameName(it->second->file.c_str());
//			r = RichElementCustomNode::create(++i, WHITE, 255, img);
//			index = index + len;
//			break;		
//		}
//		//确定是表情后
//		if (r != NULL)
//		{
//			if (strBuff.length() != 0)
//			{
//				RichElementText* re1 = RichElementText::create(++i, WHITE, 255, strBuff.c_str(), "font/fzlthjt.TTF", 20);
//				//把表情前的文本数据加入
//				richText->pushBackElement(re1);
//				strBuff.clear();
//			}
//			//再加入表情数据//
//			richText->pushBackElement(r);
//		}
//		else
//		{
//			strBuff.push_back(*cursor);
//			++index;
//		}
//	}
//
//	//残留的数据
//	if (strBuff.length() != 0)
//	{
// 		for (int i = 0; i < strBuff.length(); i++)
// 		{
//			RichElementText* re1 = RichElementText::create(0, WHITE, 255, strBuff.c_str(), "font/fzlthjt.TTF", 20);
//			richText->pushBackElement(re1);
//			strBuff.clear();
//		}
//	}
//
//	//文字滚动，超出范围后从新开始
//
//	//if (text.length()>50)
//	//schedule(schedule_selector(ChatItem::rollText));
//
//	m_richText = richText;
//	ImageView* img_message = (ImageView*)m_rootNode->getChildByName("img_message");
//	float oldtenSizeHeight = this->getContentSize().height;
//	float oldHeight = oldtenSizeHeight - img_message->getPositionY();
//	
//	richText->formatText();
//	richText->ignoreAnchorPointForPosition(false);
//	img_message->setScale9Enabled(true);
//	float  wwrich = richText->getContentSize().width;
//	img_message->setContentSize(CCSizeMake(richText->getVirtualRendererSize().width + 40, richText->getVirtualRendererSize().height + 40));
//
//	richText->setAnchorPoint(Vec2(0, 0));
//	richText->setPosition(ccp(20, 20));
//	img_message->addChild(richText);
//	if (m_isVoiceMssage){
//		uint32 times = 0;
//		if (m_Message!=NULL){
//			times = m_Message->voiceTimes;
//		}
//		if (times > 5)
//		{
//			this->setContentSize(CCSizeMake(this->getContentSize().width, oldtenSizeHeight + 50));
//		}
//
//		if (times > 20)
//		{
//			this->setContentSize(CCSizeMake(this->getContentSize().width, oldtenSizeHeight + 70));
//		}
//
//	}else
//	{
//		if (oldHeight + img_message->getContentSize().height > oldtenSizeHeight)
//		{
//			this->setContentSize(CCSizeMake(this->getContentSize().width, oldHeight + img_message->getContentSize().height));
//		}
//	}

}


void ChatItem::initVoiceMessage(YVVoiceMessagePtr message,bool flag)
{
	m_isVoiceMssage = true;
	m_Message = message;
//	Text* messageLayer = (Text*)m_rootNode->getChildByName("MessageLabel");
//	messageLayer->setVisible(true);
//	messageLayer->setText("");
	

	//替图
//	Button* voiceButton = (Button*)m_rootNode->getChildByName("VoiceButton");
//	
//	Point an = messageLayer->getAnchorPoint();
//	Point pos = messageLayer->getPosition();
//	voiceButton->setAnchorPoint(an);
//	voiceButton->setPosition(messageLayer->getPosition());
//	
//	voiceButton->setVisible(true);
//	voiceButton->setTouchEnabled(false);

	

//	if (hongdiang == NULL)
//	{
//		hongdiang = Sprite::create("dot04.png");
//		CCSize buttonSize = voiceButton->getContentSize();
//		hongdiang->setPosition(CCPointMake((buttonSize.width + 20), (buttonSize.height / 2)));
//		hongdiang->setScale(0.5);
//
//		voiceButton->addChild(hongdiang);
//		if (isSendMessage(message) || flag || (!message->playState))
//			hongdiang->setVisible(false);
//	}
//
//
//	if (m_playerRoot == NULL) {
//		return;
//	}
//	m_playerRoot->setName("playerRoot");


//	m_voiceText = message->attach;
//	ImageView* img = (ImageView*)m_rootNode->getChildByName("img_message");
//	if (isSendMessage(message))
//	{
//		
//		img->setPositionX(img->getPositionX() - voiceButton->getContentSize().width - 40);
//	}
//	else
//	{
//		img->setPositionX(img->getPositionX() + voiceButton->getContentSize().width + 60);
//	}
//
//
//	showMessageVoiceText(m_voiceText);
	
/*	YVFilePathPtr voicePath = message->voicePath;
	if (voicePath != NULL && (voicePath->getState() == BothExistState || voicePath->getState() == OnlyLocalState) )
	{
		voiceButton->setTouchEnabled(true);
		voiceButton->addTouchEventListener(this, SEL_TouchEvent(&ChatItem::voiceButtonClickCallBack));
	}
	else
	{
		YVPlatform* platform = YVPlatform::getSingletonPtr();
		platform->addDownLoadFileListern(this);
		platform->downLoadFile(voicePath);

		//开启菊花特效//
		setWaitAnim(true);

	}
	m_voicePath = voicePath; */
}

void ChatItem::initPicMessage(YVImageMessagePtr message)
{
	////替图
	//Text* messageLayer = (Text*)m_rootNode->getChildByName("MessageLabel");
	//messageLayer->setText("");
	////替图
	//Button* pigButton = (Button*)m_rootNode->getChildByName("PicButton");
	//pigButton->setVisible(true);

	//PathUtil& picPath = message->getLittlePicPath();
	//if (!picPath.isUrl())
	//{
	//	m_dataLocalPath = picPath.getPath();
	//	pigButton->loadTextureNormal(m_dataLocalPath);
	//	pigButton->loadTexturePressed(m_dataLocalPath);
	//	pigButton->setAnchorPoint(messageLayer->getAnchorPoint());
	//	pigButton->setPosition(messageLayer->getPosition());
	//}
	//else
	//{
	//	HttpManager& httpManager = SDKCenter::getSingletonPtr()->getHttpManager();
	//	m_dataLocalPath = httpManager.getData(picPath.getPath());

	//	if (m_dataLocalPath == "")
	//	{
	//		if (signal_downLoadOverIt.empty())
	//		{
	//			signal_downLoadOverIt = httpManager.signal_httpDownLoadOver.connect(sigc::mem_fun(this, &ChatItem::httpDownLoadOver));
	//		}
	//		downloadNum++;
	//		m_dataUrlPath = picPath.getPath();
	//	}
	//}
	//resize();
}

void ChatItem::onDownLoadFileListern(YVSDK::YVFilePathPtr path) 
{

	if (path->getState() == DownLoadErroSate)
	{
		CCLOG("download Error:%s", path->getLocalPath().c_str());
		return;
	}

	if (m_voicePath != NULL && m_voicePath->getPathId() == path->getPathId())
	{
        if (m_msg != NULL)
        {
            
            if(friendchatflag)
            {
                HclcData::sharedHD()->callLuaFunctionOne("src/app/scenes/LobbyScene.lua", "SetShowFriendVoiceBtn",m_msg->id);
            }
            else
            {
                HclcData::sharedHD()->callLuaFunctionOne("src/app/Common/util.lua", "SetShowVoiceBtn",m_msg->id);
            }
        
        }
        
        setWaitAnim(false);
       
//		Button* voiceButton = (Button*)m_rootNode->getChildByName("VoiceButton");
//		if (voiceButton != NULL && voiceButton->isVisible())
//		{
//			voiceButton->setTouchEnabled(true);
//			voiceButton->addTouchEventListener(this, SEL_TouchEvent(&ChatItem::voiceButtonClickCallBack));
//
//			//关闭菊花特效
//			setWaitAnim(false);
//		}
//
//		Button* pigButton = (Button*)m_rootNode->getChildByName("PicButton");
//		if (pigButton != NULL && pigButton->isVisible())
//		{
//			pigButton->loadTextureNormal(path->getLocalPath());
//			resize();
//		}
	}
}

void ChatItem::onUpdateUserInfoListern(YVSDK::YVUInfoPtr info)
{
	if (userinfo != NULL && userinfo->userid == info->userid)
	{
		YVPlatform* platform = YVPlatform::getSingletonPtr();
		platform->delUpdateUserInfoListern(this);
		//setUserInfo(userinfo);
	}
}

void ChatItem::onFinishPlayListern(YVSDK::StartPlayVoiceRespond* r)
{
    
    CCLOG("onFinishPlayListern--");
    
    if(friendchatflag && HclcData::sharedHD()->m_nCurPlayID != m_msg->id)
    {
        return;
    }
//    if (m_msg->recvId!= m_chatWithUid)
//    {
//        return;
//    }
    
    CCLOG("msgID:%llu",m_msg->id);

    if(friendchatflag)
    {
        HclcData::sharedHD()->callLuaFunctionOne("src/app/scenes/LobbyScene.lua", "StopFriendPlayAction",m_msg->id);
    }
    else
    {
        HclcData::sharedHD()->callLuaFunctionOne("src/app/Common/util.lua", "StopPlayAction",m_msg->id);
    }

}


void ChatItem::PlayVoiceBegin( uint64_t playID )
{
    YVPlatform* platform = YVPlatform::getSingletonPtr();
    
    m_nPlayID = playID;
    
    if (platform->isPlaying())
    {
        tempvoiceID = platform->PlayingId();
        isplaying = true;
    }
    else
    {
        isplaying = false;
    }
    
    platform->stopPlay();

    m_IsautoplayVoid = false;
    cocos2d::Director::getInstance()->getScheduler()->unschedule(schedule_selector(ChatItem::MutUpdate), this);

}

void ChatItem::PlayVoiceEnd( uint64_t playID )
{
    voiceID = m_voicePath->getPathId();
    
    m_nPlayID = playID;
    
    if (voiceID != tempvoiceID)
    {
        tempvoiceID = voiceID;
        playVoice();
        m_IsautoplayVoid = false;
        YVVoiceMessagePtr timemsg = m_msg;
        float time = timemsg->voiceTimes/1000;
        
        cocos2d::Director::getInstance()->getScheduler()->schedule(schedule_selector(ChatItem::MutUpdate), this, time, false);
    }
    else
    {
        tempvoiceID = -1;
        m_IsautoplayVoid = true;
    }
}

void ChatItem::setautoplayvoid(bool autoplay)
{
	m_Playover = autoplay;
}

bool ChatItem::getautoplayvoid()
{
	return m_Playover;
}

void ChatItem::MutUpdate(float dt)
{
	tempvoiceID = -1;
	m_IsautoplayVoid = true;

    cocos2d::Director::getInstance()->getScheduler()->unschedule(schedule_selector(ChatItem::MutUpdate), this);
}

bool ChatItem::IsautoplayVoid()
{
	return m_IsautoplayVoid;
}


void ChatItem::playVoice()
{
	
	YVPlatform* platform = YVPlatform::getSingletonPtr();

	if(!platform->playRecord(m_voicePath)) 
	{
		return;
	}
    
    bool isSend = isSendMessage(m_msg);
    
    if(friendchatflag)
    {
        HclcData::sharedHD()->callLuaFunctionOne("src/app/scenes/LobbyScene.lua", "ShowFriendPlayAction",m_msg->id,isSend);
    }
    else
    {

        HclcData::sharedHD()->callLuaFunctionOne("src/app/Common/util.lua", "ShowPlayAction",m_msg->id,isSend);
    }
}

void ChatItem::setWaitAnim(bool isShow)
{
	if (isShow == m_isShowWaitAnim)
	{
		return;
	}
	m_isShowWaitAnim = isShow;

    bool isSend = isSendMessage(m_msg);

	if (isShow)
	{
		//下载时候的效果
        if(friendchatflag)
        {
             HclcData::sharedHD()->callLuaFunctionOne("src/app/scenes/LobbyScene.lua", "OpenFriendWaitAnim",m_msg->id, isSend);
        }
        else
        {
             HclcData::sharedHD()->callLuaFunctionOne("src/app/Common/util.lua", "OpenWaitAnim",m_msg->id, isSend);
        }

        cocos2d::Director::getInstance()->getScheduler()->schedule(schedule_selector(ChatItem::delaytime), this, 30, false);
	}
	else
	{
		cocos2d::Director::getInstance()->getScheduler()->unschedule(schedule_selector(ChatItem::delaytime),this);
        if(friendchatflag)
        {
            HclcData::sharedHD()->callLuaFunctionOne("src/app/scenes/LobbyScene.lua", "CloseFriendWaitAnim",m_msg->id, isSend);
        }
        else
        {
            HclcData::sharedHD()->callLuaFunctionOne("src/app/Common/util.lua", "CloseWaitAnim",m_msg->id, isSend);
        }

	}

}

void ChatItem::delaytime(float ft)
{
	setWaitAnim(false);
	//showReSendButton(true);
}

YVSDK::YVUInfoPtr ChatItem::getuserinfo()
{
	return userinfo;
}

