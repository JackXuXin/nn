//
//  YVListenFun.c
//  client
//
//  Created by queyou on 16/12/19.
//
//

#include "cocos2d.h"
#include "YVListenFun.h"
#include "HclcData.h"
#include "CCLuaBridge.h"
#include "CCLuaEngine.h"



using namespace YVSDK;


YVListenFun::~YVListenFun()
{
    YVPlayerManager* platform = YVPlatform::getSingletonPtr();
    platform->delCPLoginListern(this);
//    platform->delYYLoginListern(this);
    
    releaseAllNode();
    
}


void YVListenFun::releaseAllNode()
{
    CC_SAFE_DELETE(pSearchListNode);
    CC_SAFE_DELETE(pFriendListNode);
    CC_SAFE_DELETE(pSystemNotifyNode);
    CC_SAFE_DELETE(pChannalNode);
    
    vector<FriendChatNode*>::iterator ite = m_friendChatList.begin();
    while(ite!=m_friendChatList.end())
    {
        CC_SAFE_DELETE(*ite);
        ite = m_friendChatList.erase(ite);
    }
    
    m_friendChatList.clear();
}

FriendChatNode* YVListenFun::getFriendChatNode(uint32 nYvID)
{
    std::vector<FriendChatNode*>::iterator it = m_friendChatList.begin();
    
    while (it != m_friendChatList.end())
    {
        if((*it)->getFriendChatUid() == nYvID)
        {
            return *it;
        }
        
        it++;
    }
    
    return NULL;
}

void YVListenFun::openFriendChat(uint32 nYvID)
{
    
    FriendChatNode* pfriendChatNode = new FriendChatNode();
    
    pfriendChatNode->init();
    pfriendChatNode->setChatUid(nYvID);
    pfriendChatNode->setFrindChat(true);
    
    m_friendChatList.insert(m_friendChatList.begin(),pfriendChatNode);
    
}


void YVListenFun::onCPLoginListern(CPLoginResponce* r )
{
    bool isLoginOk = true;
    
    if (r->result != 0)
    {
        CCLOG("longin error");
        
        isLoginOk = false;
    }
    
    if(isLoginOk)
    {
        if(pSearchListNode == NULL)
        {
            pSearchListNode = new SearchListNode();
            pSearchListNode->init();
        }
        
        if(pFriendListNode == NULL)
        {
            pFriendListNode = new FriendListNode();
            pFriendListNode->init();
        }
        
        if(pSystemNotifyNode == NULL)
        {
            pSystemNotifyNode = new SystemNotifyNode();
            pSystemNotifyNode->init();
        }
        
        if(pChannalNode == NULL)
        {
            pChannalNode = new ChannalChatNode();
            pChannalNode->init();
        }
       
        CCLOG("uid :%d", r->userid);
        CCLOG("nickname :%s", r->nickName.c_str());
        
        CCLOG("longin ok!");

    }
    else
    {
         CCLOG("longin failed!");
    }
    
    HclcData::sharedHD()->callLuaFunctionOne("src/app/scenes/LobbyScene.lua", "loginYvCallback",r->result);
    
//     int callback = HclcData::sharedHD()->loginYvSysCallback;
//    if (callback != 0) {
//        using cocos2d::LuaBridge;
//        using cocos2d::LuaValue;
//        
//        LuaBridge::pushLuaFunctionById(callback);
//        cocos2d::LuaValueDict item;
//        item["result"] = LuaValue::intValue(r->result);
//        LuaBridge::getStack()->pushLuaValueDict(item);
//        LuaBridge::getStack()->executeFunction(1);
//        LuaBridge::releaseLuaFunctionById(callback);
//        HclcData::sharedHD()->loginYvSysCallback = 0;
//    }

}
