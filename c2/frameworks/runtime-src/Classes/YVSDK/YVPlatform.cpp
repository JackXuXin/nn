/*********************************************************************************
*Copyright(C), 2015 YUNVA Company
*FileName:  RespondFactory.cpp
*Author:  Matt
*Version:  1.0.0
*Date:  2015-5-7
*Description:  云娃SDK入口实现
**********************************************************************************/
#include "YVPlatform.h"
#include "YVUtils/YVMsgDispatcher.h"
#include "YVManager/YVManager.h"

using namespace YVSDK;
YVPlatform* YVPlatform::s_YVPlatformPtr = NULL;

YVPlatform* YVPlatform::getSingletonPtr()
{
	if (s_YVPlatformPtr == NULL)
	{
		s_YVPlatformPtr = new YVPlatform();
	}
	return s_YVPlatformPtr;
}

YVPlayerManager* YVPlatform::getPlayerManager()
{
     return s_YVPlatformPtr;
}


YVPlatform::YVPlatform()
{
	_isInit = false;
	m_msgDispatcher = new YVMsgDispatcher();
}


YVMsgDispatcher* YVPlatform::getMsgDispatcher()
{
	return m_msgDispatcher;
}

void YVPlatform::updateSdk(float dt)
{
	m_msgDispatcher->dispatchMsg(dt);
}

bool YVPlatform::modifyUserInfo(std::string nickname, const std::string & iconUrl, const std::string & level, const std::string & vip, uint8 sex, const std::string & ext)
{
    bool isModify = false;
    isModify = setUserInfoRequest(nickname, iconUrl, level, vip, sex, ext);

    return isModify;
}

bool YVPlatform::init()
{
	if (_isInit) return true;
	YVUInfoManager::init();
	YVPlayerManager::init();
	YVContactManager::init();
	YVChannalChatManager::init();
	YVToolManager::init();
	YVFriendChatManager::init();

#ifdef _YVSDK_USE_LBS_
	YVLbsManager::init();
#endif

#ifdef _YVSDK_USE_GROUP_
	YVGroupUserManager::init();
#endif
	_isInit = true;
	bool isinitSuc = false;
	if (m_msgDispatcher)
		isinitSuc = m_msgDispatcher->initSDK();
	
	return isinitSuc;
}

bool YVPlatform::destory()
{
	if (!_isInit) return true;
	YVUInfoManager::destory();
	YVPlayerManager::destory();
	YVContactManager::destory();
	YVChannalChatManager::destory();
	YVToolManager::destory();
	YVFriendChatManager::destory();

#ifdef _YVSDK_USE_LBS_
	YVLbsManager::destory();
#endif

#ifdef _YVSDK_USE_GROUP_
	YVGroupUserManager::destory();
#endif
	
	//通用版SDK功能释放
	m_msgDispatcher->releseSDK();
	_isInit = false;
	return false;
}
