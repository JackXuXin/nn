/*********************************************************************************
*Copyright(C), 2015 YUNVA Company
*FileName:  RespondFactory.cpp
*Author:  Matt
*Version:  1.0.0
*Date:  2015-5-8
*Description:  好友列表 UI实现
**********************************************************************************/

#include "FriendListNode.h"
//#include "FriendListItem.h"
//#include "MainScene.h"
#include "SearchListNode.h"
//#include "NetWorkingPopup.h"
#include "../YVSDK/YVSDK.h"
#include "HclcData.h"
#include "CCLuaBridge.h"
#include "CCLuaEngine.h"

USING_NS_CC;
using namespace ui;
using namespace YVSDK;

FriendListNode::~FriendListNode()
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	platform->delDelFriendListern(this);
	platform->delAddFriendListern(this);
	platform->delUpdateUserInfoListern(this);
	platform->delUserSetInfonotifyListern(this);
    platform->delFriendListListern(this);
}

bool FriendListNode::init()
{
	if (!Node::init())
	{
		return false;
	}
    
	//从内存恢复黑名单信息
	YVPlatform* platform = YVPlatform::getSingletonPtr();
//	auto allFriendInfo = platform->getAllFriendInfo();
//	for (auto it = allFriendInfo.begin(); it != allFriendInfo.end(); ++it)
//	{
//		addFriend(it->second);	
//	}
	//this->addChild(m_rootNode);
	
	platform->addDelFriendListern(this);
	platform->addAddFriendListern(this);
	platform->addUpdateUserInfoListern(this);
	platform->addUserSetInfonotifyListern(this);
    platform->addFriendListListern(this);


	return true;
}



void FriendListNode::delFriend(YVUInfoPtr info)
{
    CCLOG("delFriend-------");
//   Layout* layer = (Layout*)m_dataView->getChildByTag(info->userid);
//   if (layer == NULL)
//   {
//	   return;
//   }
//   int index = m_dataView->getIndex(layer);
//   m_dataView->removeItem(index);
//   m_dataView->refreshView();
//
//   NetWorkingPopup::getSingletonPtr()->hide();
}

void FriendListNode::updateFriend(YVUInfoPtr info)
{
    if(info == NULL || info->header == NULL)
    {
        return;
    }
    
    uint32 yvID = info->userid;
    std::string userID = info->thirdUid;
    std::string nickName = info->nickname;
    std::string iconUrl = info->header->getUrlPath();
    int online = info->online;
    
    bool isOnline = false;
    
    if(online>0)
    {
        isOnline = true;
    }
    
    YVPlatform* p = YVPlatform::getSingletonPtr();
    YVUInfoPtr tempinfo = p->getFriendInfo(info->userid);
    if (tempinfo != NULL)
    {
        CCLOG("updateFriend-------");
        HclcData::sharedHD()->callLuaFunctionTwo("src/app/scenes/LobbyScene.lua", "FriendList", yvID, userID.c_str(), nickName.c_str(), iconUrl.c_str(), false, isOnline, true);
        if (info->nickname.empty() || userID.empty())
        {
            p->getUserInfoSync(info->userid);
        }
    }
}
void FriendListNode::onNearsNotifyListern(RecentListNotify* r)
{
	
}


void FriendListNode::onAddFriendListern(YVUInfoPtr info)
{
    if(info == NULL)
    {
        return;
    }
    
    uint32 yvID = info->userid;
    std::string userID = info->thirdUid;
    std::string nickName = info->nickname;
    std::string iconUrl = info->header->getUrlPath();
    int online = info->online;
    
    bool isOnline = false;
    
    if(online>0)
    {
        isOnline = true;
    }
    
    CCLOG("addFriend-------");
    
    HclcData::sharedHD()->callLuaFunctionTwo("src/app/scenes/LobbyScene.lua", "FriendList", yvID, userID.c_str(), nickName.c_str(), iconUrl.c_str(), true, isOnline, false);
}

void FriendListNode::onDelFriendListern(YVUInfoPtr info)
{
    if(info == NULL)
    {
        return;
    }
    
//    HclcData::sharedHD()->callLuaFunctionTwo("src/app/scenes/LobbyScene.lua", "SureDeleteFriend", info->userid, info->thirdUid.c_str(), info->nickname.c_str(), info->header->getUrlPath().c_str());
    
	delFriend(info);
	YVPlatform::getSingletonPtr()->DelRecent(info->userid);
}

void FriendListNode::onUpdateUserInfoListern(YVUInfoPtr info)
{
    if(info == NULL)
    {
        return;
    }
     CCLOG("UpdateUserInfo-------");
	 updateFriend(info);
}


void FriendListNode::onFriendListListern(YVSDK::FriendListNotify* friendInfo)
{
    
    CCLOG("addFriendList-------");
    
    YVPlatform* p = YVPlatform::getSingletonPtr();
    
    for (std::vector<YaYaUserInfo*>::iterator it = friendInfo->userInfos.begin();
         it != friendInfo->userInfos.end(); ++it)
    {
        uint32 yvID = (*it)->userid;
        std::string userID = (*it)->thirduid;
        std::string nickName = (*it)->nickname;
        std::string iconUrl = (*it)->iconurl;
        
        p->getUserInfoSync(yvID);
        
        int online = (*it)->online;
        bool isOnline = false;
        if(online>0)
        {
            isOnline = true;
        }
        
        HclcData::sharedHD()->callLuaFunctionTwo("src/app/scenes/LobbyScene.lua", "FriendList", yvID, userID.c_str(), nickName.c_str(), iconUrl.c_str(), false, isOnline, false);
    }

}

void FriendListNode::onUserSetInfonotifyListern(YVSDK::UserSetInfoNotify* q)
{
    if(q == NULL)
    {
        return;
    }
    
    CCLOG("UserSetInfonotify-------");
    
	_YVUInfo* info = new _YVUInfo();
	info->userid = q->userid;
	info->nickname = q->nickname;
	info->thirdNickName = q->nickname;
	info->level = q->userlevel;
	info->vip = q->viplevel;
	info->sex = q->sex;
	info->ext = q->ext;
	YVPlatform* p = YVPlatform::getSingletonPtr();
	YVUInfoPtr tempinfo = p->getFriendInfo(q->userid);
	if (tempinfo != NULL)
		info->online = tempinfo->online;
	updateFriend(info);
}

