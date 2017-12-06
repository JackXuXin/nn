/*********************************************************************************
*Copyright(C), 2015 YUNVA Company
*FileName:  RespondFactory.cpp
*Author:  Matt
*Version:  1.0.0
*Date:  2015-5-8
*Description:  好友查找列表实现
**********************************************************************************/

#include "SearchListNode.h"
#include "HclcData.h"
#include "CCLuaBridge.h"
#include "CCLuaEngine.h"

USING_NS_CC;
using namespace ui;
using namespace YVSDK;

#define SearchStart 0
#define SearchNum   20

SearchListNode::~SearchListNode()
{
	//NetWorkingPopup::getSingletonPtr()->hide();
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	//platform->delRecommendFriendRetListern(this);
	platform->delSearchFriendRetListern(this);
}

bool SearchListNode::init()
{
	if (!Node::init())
	{
		return false;
	}

	//获取推荐好友
	//getRecomment();
	//this->addChild(m_rootNode);
	return true;
}

void  SearchListNode::searchFriendByNick(std::string nick)
{
	std::string keyword = nick;
	if (keyword.length() == 0)
	{
		return;
	}
	//获取查找好友
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	//platform->delRecommendFriendRetListern(this);
	platform->addSearchFriendRetListern(this);
	platform->searchFiend(keyword, SearchStart, SearchNum);

	//NetWorkingPopup::getSingletonPtr()->show(this->getScene());
}

void SearchListNode::getRecomment()
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	//platform->addRecommendFriendRetListern(this);
	platform->delSearchFriendRetListern(this);
	platform->recommendFriend(SearchStart, SearchNum);

	//NetWorkingPopup::getSingletonPtr()->show(this->getScene());
}


void SearchListNode::onSearchFriendRetListern(YVSDK::SearchFriendRespond* r)
{
	//NetWorkingPopup::getSingletonPtr()->hide();
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	platform->delSearchFriendRetListern(this);
    
    CCLOG("SearchFriendResult--------");
    
    bool ishas = false;
    uint32 yvID = 0;
    string userID;
    string nickName;
    string iconUrl;

    
    if (r->searchRetInfo.size()==0)
    {
        CCLOG("find no people!");
    }
    else
    {
        
        for (auto it = r->searchRetInfo.begin(); it != r->searchRetInfo.end(); ++it)
        {
            CCLOG("yvID:%d,uid:%s,nick:%s,icon:%s",(*it).yunvaId, (*it).userId.c_str(), (*it).nickName.c_str(), (*it).iconUrl.c_str());
            
            yvID = (*it).yunvaId;
            userID = (*it).userId;
            nickName = (*it).nickName;
            iconUrl = (*it).iconUrl;
            
            HclcData::sharedHD()->callLuaFunctionTwo("src/app/scenes/LobbyScene.lua", "SearchCallBack", yvID, userID.c_str(), nickName.c_str(), iconUrl.c_str());
        }
        
       // ishas = true;
        return;
        
//        ishas = true;
//        auto it = r->searchRetInfo.begin();
//        CCLOG("yvID:%d,uid:%s,nick:%s,icon:%s",(*it).yunvaId, (*it).userId.c_str(), (*it).nickName.c_str(), (*it).iconUrl.c_str());
//       // HclcData::sharedHD()->callLuaFunctionTwo(fullPath.c_str(), "findFriendList2", (*it).yunvaId, (*it).userId.c_str(), (*it).nickName.c_str(), (*it).iconUrl.c_str());
//        
//        yvID = (*it).yunvaId;
//        userID = (*it).userId;
//        nickName = (*it).nickName;
//        iconUrl = (*it).iconUrl;
    }
    
    
    HclcData::sharedHD()->callLuaFunctionTwo("src/app/scenes/LobbyScene.lua", "SearchCallBack", yvID, userID.c_str(), nickName.c_str(), iconUrl.c_str());
    
    
//    int callback = HclcData::sharedHD()->findCallback;
//    
//    if (callback != 0) {
//        using cocos2d::LuaBridge;
//        using cocos2d::LuaValue;
//        
//        LuaBridge::pushLuaFunctionById(callback);
//        cocos2d::LuaValueDict item;
//        if (ishas)
//        {
//             item["yvID"] = LuaValue::intValue(yvID);
//             item["userID"] = LuaValue::stringValue(userID);
//             item["nickName"] = LuaValue::stringValue(nickName);
//             item["iconUrl"] = LuaValue::stringValue(iconUrl);
//        }
//        
//        item["result"] = LuaValue::intValue(r->result);
//        LuaBridge::getStack()->pushLuaValueDict(item);
//        LuaBridge::getStack()->executeFunction(1);
//        LuaBridge::releaseLuaFunctionById(callback);
//        HclcData::sharedHD()->findCallback = 0;
//    }

    
    
//    for (auto it = r->searchRetInfo.begin(); it != r->searchRetInfo.end(); ++it)
//    {
//        
//        item->setUserInfo(&(*it));
//        Layout* layer = Layout::create();
//        layer->setContentSize(item->getContentSize());
//        layer->addChild(item);
//        m_dataListView->pushBackCustomItem(layer);
//    }
    
   
    
/*	m_dataListView->removeAllItems();
	//查找结果
	m_searchTip->setText("\xe6\x9f\xa5\xe6\x89\xbe\xe7\xbb\x93\xe6\x9e\x9c:");
	if (r->result != 0)
	{
		MsgPopup::getSingletonPtr()->setErroText(r->msg);
		//MsgPopup::getSingletonPtr()->show(this->getScene());
		//CCLOG("获取查找好友列表失败:%s", msg.c_str());
		return;
	}
	 */
}

void SearchListNode::onRecommendFriendRetListern(YVSDK::RecommendFriendRespond* r)
{
	//NetWorkingPopup::getSingletonPtr()->hide();
	//YVPlatform* platform = YVPlatform::getSingletonPtr();
	//platform->delRecommendFriendRetListern(this);
    
    CCLOG("RecommendFriend--------");

	//推荐好友
/*	m_searchTip->setText("\xe6\x8e\xa8\xe8\x8d\x90\xe5\xa5\xbd\xe5\x8f\x8b:");
	m_dataListView->removeAllItems();
	if (r->result != 0)
	{
		MsgPopup::getSingletonPtr()->setErroText(r->msg);
		//MsgPopup::getSingletonPtr()->show(this->getScene());
		//CCLOG("获取查找好友列表失败:%s", msg.c_str());
		return;
	}
	for (auto it = r->userInfos.begin(); it != r->userInfos.end(); ++it)
	{
		SearchListItem* item = (SearchListItem*)SearchListItem::create();
		item->setUserInfo(&(*it));
		Layout* layer = Layout::create();
		layer->setContentSize(item->getContentSize());
		layer->addChild(item);
		m_dataListView->pushBackCustomItem(layer);
	}*/
}
