//
//  YVListenFun.c
//  client
//
//  Created by queyou on 16/12/19.
//
//

#include "YVChatNode.h"
#include "HclcData.h"
#import "CCLuaBridge.h"
#include "CCLuaEngine.h"

using namespace YVSDK;


YVChatNode::~YVChatNode()
{
    
    releaseVoiceList();
   
    YVPlatform* platform = YVPlatform::getSingletonPtr();
    platform->delStopRecordListern(this);
    
    cocos2d::Director::getInstance()->getScheduler()->unschedule(schedule_selector(YVChatNode::autoPlayeVoice), this);
    //停止播放语音
    platform->stopPlay();

    
}

void YVChatNode::releaseVoiceList()
{
    vector<ChatItem*>::iterator ite = m_voiceList.begin();
    while(ite!=m_voiceList.end())
    {
        CC_SAFE_DELETE(*ite);
        ite = m_voiceList.erase(ite);
    }
    
    m_voiceList.clear();
    
    vector<ChatItem*>::iterator iteTmp = m_tempVoiceList.begin();
    while(iteTmp!=m_tempVoiceList.end())
    {
        CC_SAFE_DELETE(*iteTmp);
        iteTmp = m_tempVoiceList.erase(iteTmp);
    }
    
    m_tempVoiceList.clear();

}

bool YVChatNode::init()
{
    
    m_isSendVoice = false;
    isFromStopBtn = false;
    isFromTouchAutoVoice = false;
    isRecordVoice = false;
    isAutoPlayVoice = true;
    TempAutoPlay = isAutoPlayVoice;
    
    m_voiceList.clear();
    m_tempVoiceList.clear();
    //m_isSpeenOn = true;
    
    isFriendChat = false;
    
    cocos2d::Director::getInstance()->getScheduler()->schedule(schedule_selector(YVChatNode::autoPlayeVoice), this, 0, false);
    
       
    //this->addChild(m_rootNode);
    return true;
}

void YVChatNode::recordingTimeUpdate(float dt)
{
    m_recordingTime -= dt;
    std::stringstream ss;
    std::string str;
    ss << (int)ceil(m_recordingTime);
    ss >> str;
    
    bool isBeStop = false;
    
    const float EPSINON = 0.000001;
    if (m_recordingTime <= EPSINON)
    {
        sendVoice(true);
        isBeStop = true;
    }
    else if (m_recordingTime < 0)
    {
        sendVoice(true);
        isBeStop = true;
    }
    
    if(isBeStop)
    {
        
         HclcData::sharedHD()->callLuaFunctionOne("src/app/scenes/LobbyScene.lua", "StopVoiceCallback",0,true);
        
         isBeStop = false;
          
//        int callback = HclcData::sharedHD()->sendVoiceCallback;
//        
//        if (callback != 0)
//        {
//            using cocos2d::LuaBridge;
//            using cocos2d::LuaValue;
//            
//            LuaBridge::pushLuaFunctionById(callback);
//            cocos2d::LuaValueDict item;
//            item["result"] = LuaValue::intValue(0);
//            item["isRecordVoice"] = LuaValue::booleanValue(false);
//            item["isStopRecord"] = LuaValue::booleanValue(true);
//            LuaBridge::getStack()->pushLuaValueDict(item);
//            LuaBridge::getStack()->executeFunction(1);
//            LuaBridge::releaseLuaFunctionById(callback);
//            HclcData::sharedHD()->sendVoiceCallback = 0;
//        }
    }
    
//    CCNode* record = m_recordSignNode->getChildByName("recording");
//    Text* text = (Text*)record->getChildByName("Text_1");
//    text->setFontName("font/fzlthjt.TTF");
//    text->setText(str);
}

void YVChatNode::sendVoice(bool isSend)
{
    //停止录音
    YVPlatform* platform = YVPlatform::getSingletonPtr();
    platform->addStopRecordListern(this);
    platform->stopRecord();
    m_isSendVoice = isSend;
}

void YVChatNode::EndVoice( std::string extStr )
{
    CCLOG("End Record");
    
    m_extStr = extStr;
    
    //判断底层是否已经 自动发送
   // if (m_recordSignNode->getParent() != NULL)
    {
        sendVoice(true);
        
    }
    //sendButton->setTitleText(WStrToUTF8(L"按住 说话"));
    //sendButton->setTitleText("\xe6\x8c\x89\xe4\xbd\x8f \xe8\xaf\xb4\xe8\xaf\x9d");
}

void YVChatNode::CancelVoice( void )
{
//    if (m_recordSignNode)
//    {
//        m_recordSignNode->stopAllActions();
//        m_recordSignNode->setVisible(false);
//    }
   // setRecordSignStat(false);
    sendVoice(false);
   // sendButton->setTitleText("\xe6\x8c\x89\xe4\xbd\x8f \xe8\xaf\xb4\xe8\xaf\x9d");
}

void YVChatNode::BeginVoice( void )
{
    CCLOG("start Record----111111");
    if (isRecordVoice == false)
    {
        //开始录音
        CCLOG("start Record-22222-");
        YVPlatform* platform = YVPlatform::getSingletonPtr();
        
        platform->stopPlay();    //录音时停止播放
        TempAutoPlay = isAutoPlayVoice;
        isAutoPlayVoice = false; //录音时停止播放
        //m_voiceList->removeAllObjects(); //录音时停止播放
        
        platform->startRecord();
        isRecordVoice = true;
        //setRecordSignStat(true);
        
        m_recordingTime = 59;
        cocos2d::Director::getInstance()->getScheduler()->schedule(schedule_selector(YVChatNode::recordingTimeUpdate), this, 0, false);
        
        //sendButton->setTitleText(WStrToUTF8(L"松开 结束"));
       // sendButton->setTitleText("\xe6\x9d\xbe\xe5\xbc\x80 \xe7\xbb\x93\xe6\x9d\x9f");
    }
}


void YVChatNode::onStopRecordListern(YVSDK::RecordStopNotify* r)
{
    
     CCLOG("onStopRecordListern----------111");
    //关闭记时器
    cocos2d::Director::getInstance()->getScheduler()->unschedule(schedule_selector(YVChatNode::recordingTimeUpdate), this);

//    if (m_recordSignNode)
//    {
//        m_recordSignNode->stopAllActions();
//        m_recordSignNode->setVisible(false);
//    }
//    
    //关闭回 调
    YVPlatform* platform = YVPlatform::getSingletonPtr();
    platform->delStopRecordListern(this);
    
    isAutoPlayVoice = TempAutoPlay;
    isRecordVoice = false;
    
    if (!m_isSendVoice)
    {
        return;
    }
    if ((59 - m_recordingTime) < 1.0f)
    {
        m_isSendVoice = false;
        //	MsgPopup::getSingletonPtr()->show(this->getScene());
        //录音时间太短了
        //MsgPopup::getSingletonPtr()->setErroText("\xe5\xbd\x95\xe9\x9f\xb3\xe6\x97\xb6\xe9\x97\xb4\xe5\xa4\xaa\xe7\x9f\xad\xe4\xba\x86");
        return;
    }
    
    CCLOG("onStopRecordListern----2222");
    
    m_recordingTime = r->time;
    YVFilePathPtr tem = r->strfilepath;
    sendVoice(tem, m_recordingTime);
    
}

ChatItem* YVChatNode::getItemByMsg(uint64_t msgID)
{
    std::vector<ChatItem*>::iterator it = m_voiceList.begin();
    
    while (it != m_voiceList.end())
    {
        if((*it)->getChatMessage()!=NULL && (*it)->getChatMessage()->id == msgID)
        {
            return *it;
        }
        
        it++;
    }
    
    return NULL;

}

ChatItem* YVChatNode::getItemByMsgEx(YVSDK::YVMessagePtr msg)
{
    
    cocos2d::FileUtils *utils = cocos2d::FileUtils::getInstance();
    const char* result = NULL;
    
    if(isFriendChat)
    {
        std::string fullPath = utils->fullPathForFilename("src/app/scenes/LobbyScene.lua");
        
        result = HclcData::sharedHD()->callLuaFunctionOne(fullPath.c_str(), "getIsfriendItem",msg->id);
    }
    else
    {
        std::string fullPath = utils->fullPathForFilename("src/app/Common/util.lua");
        
        result = HclcData::sharedHD()->callLuaFunctionOne(fullPath.c_str(), "getIsHasItem",msg->id);
    }
    
    if (result != NULL && strcmp(result,"0") == 0)
    {
        
        return NULL;
        
    }

    std::vector<ChatItem*>::iterator it = m_voiceList.begin();
    
    while (it != m_voiceList.end())
    {
        if((*it)->getChatMessage()!=NULL && (*it)->getChatMessage()->id == msg->id)
        {
            return *it;
        }
        
        it++;
    }
    
//    Vector<Widget*>& items = m_chatListView->getItems();
//    for (Vector<Widget*>::reverse_iterator it = items.rbegin();
//         it != items.rend(); ++it)
//    {
//        Layout* layout = (Layout*)(*it);
//        if (layout == NULL) continue;
//        ChatItem* item = (ChatItem*)(layout->getUserData());
//        if (item != NULL)
//        {
//            YVSDK::YVMessagePtr msgt = item->getChatMessage();
//            if (msgt != NULL && msgt->id == msg->id)
//            {
//                return item;
//            }
//        }
//        else
//        {
//            //return (ChatItem*);
//        }
//        
//    }
    return NULL;
}

void YVChatNode::setisvoiceAutoplay(bool flag)
{
    isAutoPlayVoice = flag;
}

void YVChatNode::addContextItem(ChatItem* item)
{
//    Layout* layout = Layout::create();
//    layout->setContentSize(item->getContentSize());
//    layout->ignoreAnchorPointForPosition(false);
//    layout->setAnchorPoint(Vec2(0, 0));
//    
//    //item->ignoreAnchorPointForPosition(false);
//    if (item->getContentSize().height > 124)
//    {
//        item->setPositionY(item->getPositionY() + item->getContentSize().height - 124);
//    }
//    layout->addChild(item);
//    layout->setUserData(item);
//    //	ChatItem* tem = (ChatItem*)layout->getUserData();
//    item->setChatNode(this);
//    //	Director::getInstance()->getScheduler()->
//    //		unscheduleSelector(schedule_selector(ChatNode::updateScroll), this);
//    bool ishasitem = false;
//    Vector<Widget*>& items = m_chatListView->getItems();
//    int itemCount = 0;
//    itemCount = items.size();
//    for (Vector<Widget*>::reverse_iterator it = items.rbegin();
//         it != items.rend(); ++it)
//    {
//        ChatItem* itema = (ChatItem*)(*it);
//        if (itema)
//        {
//            ishasitem = true;
//            break;
//        }
//    }
//    if (ishasitem)
//    {
//        m_chatListView->pushBackCustomItem(layout);
//    }
//    else{
//        m_chatListView->insertCustomItem(layout, 0);
//    }
//    if (itemCount > 2)
//    {
//        m_chatListView->scrollToBottom(0.01f, false);
//    }
//    
//    m_chatListView->refreshView();

}

//void ChatNode::addContextItem(ChatItem* item, int index)
//{
//    Layout* layout = Layout::create();
//    item->ignoreAnchorPointForPosition(false);
//    layout->setContentSize(item->getContentSize());
//    layout->setAnchorPoint(Vec2(0, 0));
//    layout->addChild(item);
//    layout->setUserData(item);
//    if (item->getContentSize().height > 124)
//    {
//        item->setPositionY(item->getPositionY() + item->getContentSize().height - 124);
//    }
//
//    if (m_chatListView){
//        m_chatListView->insertCustomItem(layout, index);
//        Vector<Widget*>& items = m_chatListView->getItems();
//        if (items.size() > 2)
//        {
//            m_chatListView->scrollToBottom(0.01f, false);
//        }
//        
//        m_chatListView->refreshView();
//    }
//    
//    
//}

void YVChatNode::setFrindChat(bool isFriend)
{
    isFriendChat = isFriend;
}

void YVChatNode::autoPlayeVoice(float dt)
{
    int size = (int)m_voiceList.size();
    
    if (isFriendChat || isAutoPlayVoice == false || size == 0) return;
    
    ChatItem* item = (ChatItem*)m_voiceList.front();
    if (item == NULL) return;
    
//    Vector<Widget*>& items = m_chatListView->getItems();
//    for (Vector<Widget*>::reverse_iterator it = items.rbegin();
//         it != items.rend(); ++it)
//    {
//        ChatItem* itema = (ChatItem*)(*it);
//        if (item == NULL) continue;;
//        if (!itema->IsautoplayVoid())
//        {
//            return;
//        }
//    }
    HclcData::sharedHD()->m_nCurPlayID = item->m_msg->id;
    if (item->isHasPlay() || item->m_msg->type != YVMessageTypeAudio)
    {
       // m_voiceList->removeLastObject(true);
        return;
    }
    
    YVPlatform* platform = YVPlatform::getSingletonPtr();
    if (platform->isPlaying() == false)
    {
        item->playVoice();
        item->SethasPlay();
        //m_voiceList->removeLastObject(true);
    }
}

void YVChatNode::setParent(cocos2d::Node* parent)
{
    //CheckBox* autoPlayeCheckBox = (CheckBox*)m_rootNode->getChildByName("CheckBox");
   // autoPlayeCheckBox->setBright(isAutoPlayVoice);
    
    Node::setParent(parent);


}

void YVChatNode::removeFromParent()
{
    Node::removeFromParent();
}
