﻿/*********************************************************************************
*Copyright(C), 2015 YUNVA Company
*FileName:  RespondFactory.cpp
*Author:  元谷
*Version:  1.0.0
*Date:  2015-5-5
*Description:  用户管理类
**********************************************************************************/

#include "YVPlayerManager.h"
#include "YVSDK.h"
#include <assert.h>

using namespace YVSDK;

bool YVPlayerManager::init()
{
	m_loginUserInfo = NULL;
	YVMsgDispatcher*  msgDispatcher = YVPlatform::getSingletonPtr()->getMsgDispatcher();
	
	msgDispatcher->registerMsg(IM_LOGIN_RESP, this, &YVPlayerManager::loginResponceCallback);
	msgDispatcher->registerMsg(IM_THIRD_LOGIN_RESP, this, &YVPlayerManager::cpLoginResponce);
	msgDispatcher->registerMsg(IM_GET_THIRDBINDINFO_RESP, this, &YVPlayerManager::GetCpuUserinfoResponce);

	return true;
}

bool YVPlayerManager::destory()
{
	YVMsgDispatcher*  msgDispatcher = YVPlatform::getSingletonPtr()->getMsgDispatcher();

	msgDispatcher->unregisterMsg(IM_LOGIN_RESP, this);
	msgDispatcher->unregisterMsg(IM_THIRD_LOGIN_RESP, this);
	msgDispatcher->unregisterMsg(IM_GET_THIRDBINDINFO_RESP, this);

	return true;
}





bool YVPlayerManager::cpLogin(const std::string& uidStr, const std::string & nameStr, const std::string& level,const std::string& vip
	, uint8 sex, const std::string& iconUrl, const std::string& ext)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher* msgDispatcher = platform->getMsgDispatcher();

	char ttStr[1000] = { 0 };
	
	const char* ttFormat = "{\"uid\":\"%s\",\"nickname\":\"%s\",\"iconUrl\":\"%s\",\"level\":\"%s\",\"vip\":\"%s\",\"sex\":\"%d\",\"ext\":\"%s\"}";
	sprintf(ttStr, ttFormat, uidStr.c_str(), nameStr.c_str(), iconUrl.c_str(), level.c_str(), vip.c_str(), sex, ext.c_str());

	CPLoginRequest r;
	//cp登录凭证，json字符串，可包含uid（必须）、nickname、iconUrl、level、vip、ext、sex字段
	r.tt.append(ttStr);
	r.wildCard = platform->channelKey;
	r.readstatus = platform->readstatus;
	r.pgameServiceID.append(platform->serverid);

	return msgDispatcher->send(&r);
}

bool YVPlayerManager::yyLogin(int userId, const std::string& passWord)
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher* msgDispatcher = platform->getMsgDispatcher();

	LoginRequest r;
	r.userid = userId;
	r.pwd = passWord;
	r.wildCard = platform->channelKey;
	r.readstatus = platform->readstatus;
	r.pgameServiceID.append(platform->serverid);

	return msgDispatcher->send(&r);
}

void YVPlayerManager::loginResponceCallback(YaYaRespondBase* respond)
{
	LoginResponse* r = static_cast<LoginResponse*>(respond);
	if (r->result == 0)
	{
		m_loginUserInfo = new _YVUInfo();
		m_loginUserInfo->header = YVPlatform::getSingletonPtr()->getYVPathByUrl(r->iconurl);
		m_loginUserInfo->nickname.append(r->nickname);
		m_loginUserInfo->userid = r->userId;
	}
	callYYLoginListern(r);
}

void YVPlayerManager::cpLoginResponce(YaYaRespondBase* respond)
{
	CPLoginResponce* r = static_cast<CPLoginResponce*>(respond);
	if (r->result == 0)
	{
		m_loginUserInfo = new _YVUInfo(); 
		m_loginUserInfo->header = YVPlatform::getSingletonPtr()->getYVPathByUrl(r->iconUrl);
		m_loginUserInfo->nickname.append(r->nickName);
		m_loginUserInfo->userid = r->userid;
		m_loginUserInfo->thirdUid = r->thirdUserId;
 		m_loginUserInfo->thirdNickName = r->nickName;
		m_loginUserInfo->level = r->level;
		m_loginUserInfo->vip = r->vip;
		m_loginUserInfo->sex = r->sex;
		m_loginUserInfo->ext = r->ext;

		
		//将用户数据更新到好友信息缓存中;
		YVPlatform* platform = YVPlatform::getSingletonPtr();
		platform->updateUInfo(m_loginUserInfo);
	}
	callCPLoginListern(r);
}

const YVUInfoPtr YVPlayerManager::getLoginUserInfo()
{
	return m_loginUserInfo;
}
void YVPlayerManager::modifyNickName(const std::string& nickname, const std::string& level, const std::string& vip, const std::string& headicon, uint8 sex, const std::string& ext)
{
	m_loginUserInfo->nickname = nickname;
	m_loginUserInfo->thirdNickName = nickname;
	m_loginUserInfo->level = level;
	if (!headicon.empty())
	{
		m_loginUserInfo->header = YVPlatform::getSingletonPtr()->getYVPathByUrl(headicon);
	}
	m_loginUserInfo->sex = sex;
	m_loginUserInfo->vip = vip;
	m_loginUserInfo->ext = ext;
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	platform->updateUInfo(m_loginUserInfo);
}

bool YVPlayerManager::cpLogout()
{
	printf("request cp logout.");

	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher* msgDispatcher = platform->getMsgDispatcher();

	CPLogoutRequest r;

	return msgDispatcher->send(&r);
}

bool YVPlayerManager::GetCpuUserinfo(uint32 appid, const std::string& uid)
{

	YVPlatform* platform = YVPlatform::getSingletonPtr();
	YVMsgDispatcher* msgDispatcher = platform->getMsgDispatcher();

	GetCpmsgRequest q;
	q.Uid = uid;
	q.appid = appid;

	return msgDispatcher->send(&q);
}

void YVPlayerManager::GetCpuUserinfoResponce(YaYaRespondBase* respond)
{
	//调回来接口  可以取回ID
	GetCpmsgRepond* r = static_cast<GetCpmsgRepond*>(respond);
	if (r->result == 0)
	{

	}
	callGetCpuUserListern(r);
}