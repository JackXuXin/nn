#include "YVUInfoManager.h"
#include "YVSDK.h"
using namespace  YVSDK;

bool YVUInfoManager::init()
{
	YVPlatform* platform = YVPlatform::getSingletonPtr();
	platform->addUserSetInfonotifyListern(this);

	return true;
}

bool YVUInfoManager::destory()
{

	YVPlatform* platform = YVPlatform::getSingletonPtr();
	platform->delUserSetInfonotifyListern(this);
	return true;
}

YVUInfoPtr YVUInfoManager::getUInfoById(uint32 id)
{
	UInfoMap::iterator it  =  m_uinfos.find(id);
	if (it != m_uinfos.end())
	{
		return it->second;
	}
	return NULL;
}

void YVUInfoManager::onUserSetInfonotifyListern(YVSDK::UserSetInfoNotify* q)
{
	_YVUInfo* info = new _YVUInfo();
	info->userid = q->userid;
	info->nickname = q->nickname;
	info->thirdNickName = q->nickname;
	info->level = q->userlevel;
	info->vip = q->viplevel;
	info->sex = q->sex;
	info->ext = q->ext;
	updateUInfo(info);
}

void YVUInfoManager::updateUInfo(YVUInfoPtr info)
{

	UInfoMap::iterator it = m_uinfos.find(info->userid);
	if (it == m_uinfos.end())
	{
		m_uinfos.insert(std::make_pair(info->userid, info));
	}
	else
	{
		it->second = info;
	}
}

