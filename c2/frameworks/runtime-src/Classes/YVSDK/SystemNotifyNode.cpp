#include "SystemNotifyNode.h"
#include "HclcData.h"
#include "CCLuaBridge.h"
#include "CCLuaEngine.h"

USING_NS_CC;
using namespace ui;
using namespace  YVSDK;

SystemNotifyNode::~SystemNotifyNode()
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	platform->delBegAddFriendListern(this);
	platform->delAddFriendRetListern(this);
}

bool SystemNotifyNode::init()
{
	if (!Node::init())
	{
		return false;
	}


	YVPlatform* platform = YVPlatform::getSingletonPtr();
	platform->addBegAddFriendListern(this);
	platform->addAddFriendRetListern(this);
	return true;
}



void SystemNotifyNode::onBegAddFriendListern(YVSDK::YVBegFriendNotifyPtr r)
{
    
    CCLOG("System-BegAddFrien-------");
    
    
    uint32 yvID = 0;
    string userID;
    string nickName;
    string iconUrl;
    
    yvID = r->uinfo->userid;
    userID = r->uinfo->thirdUid;
    nickName = r->uinfo->nickname;
    iconUrl = r->uinfo->header->getUrlPath();
    
    cocos2d::FileUtils *utils = cocos2d::FileUtils::getInstance();
    std::string fullPath = utils->fullPathForFilename("src/app/scenes/LobbyScene.lua");
    
    HclcData::sharedHD()->callLuaFunctionTwo(fullPath.c_str(), "applyFriendList", yvID, userID.c_str(), nickName.c_str(), iconUrl.c_str());
    

	 //去重操作
//	 auto items = m_dataView->getItems();
//	 for (auto it = items.begin(); it != items.end(); ++it)
//	 {
//		 NotfiyItemLayout* layeout = (NotfiyItemLayout*)(*it);
//		 if (layeout->getItemType() != BegAddFriendNotifyType) continue;
//		 if (layeout->getNotiyUid() == r->uinfo->userid) 
//			 //layeout->setNumButton(1);
//		return;
//	 }
//
//	 NotfiyItemLayout* layeout = NotfiyItemLayout::create();
//	 layeout->setNotifyData(r);
//	 layeout->setIsRead(false);
//	 m_dataView->pushBackCustomItem(layeout);
//	
//	 if (m_listNode)
//	 {
//		 layeout->setListNode(m_listNode);
//		 layeout->updateMessageNum();
//	 }
}

void SystemNotifyNode::onAddFriendRetListern(YVSDK::YVAddFriendRetPtr r)
{
    
     CCLOG("System-AddFriendRet-------");
    
    if (r->way == BegAddFriend)
    {
        bool isAgree = false;
        if(r->ret == BothAddFriend)
        {
            isAgree = true;
        }
        
        uint32 yvID = 0;
        string userID;
        string nickName;
        string iconUrl;
        
        yvID = r->uinfo->userid;
        userID = r->uinfo->thirdUid;
        nickName = r->uinfo->nickname;
        iconUrl = r->uinfo->header->getUrlPath();

        
        cocos2d::FileUtils *utils = cocos2d::FileUtils::getInstance();
        std::string fullPath = utils->fullPathForFilename("src/app/scenes/LobbyScene.lua");
        
        HclcData::sharedHD()->callLuaFunctionTwo(fullPath.c_str(), "replayApplyNotify", yvID, userID.c_str(), nickName.c_str(), iconUrl.c_str(), isAgree);

    }
    //	NotfiyItemLayout* layeout = NotfiyItemLayout::create();
//	layeout->setNotifyData(r);
//	m_dataView->pushBackCustomItem(layeout);
//	layeout->setIsRead(true);
//
//
//	if(m_listNode)
//	{
//		layeout->setListNode(m_listNode);
//		if (r->ret == BothAddFriend && r->way == BegAddFriend)
//		{
//			std::string  str = r->uinfo->nickname;
//			str.append("  is your friend now");
//			m_listNode->setSysItemText(str);
//		}
//	}
//	
//
//	//加好友成功或者拒绝，移除系统消息 
//	auto items = m_dataView->getItems();
//	for (auto it = items.begin(); it != items.end(); ++it)
//	{
//		NotfiyItemLayout* layeout = (NotfiyItemLayout*)(*it);
//		if (layeout->getItemType() != BegAddFriendNotifyType) continue;
//		if (layeout->getNotiyUid() != r->uinfo->userid) continue;
//
//		int index = m_dataView->getIndex(layeout);
//		m_dataView->removeItem(index);
//
//	//	MainScene* mianScene = (MainScene*)getScene();   //计数
//	//	mianScene->setupdatenum(-1);
//		layeout->setIsRead(true);
//		layeout->updateMessageNum();
//		break;
//	}
}

