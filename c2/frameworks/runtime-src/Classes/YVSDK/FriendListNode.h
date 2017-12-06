#ifndef _FRIENDLISTNODE_H__
#define _FRIENDLISTNODE_H__

#include "cocos2d.h"
#include "../YVSDK/YVSDK.h"

//struct YaYaUserInfo;

class FriendListNode
	:public cocos2d::Node,
	public YVSDK::YVListern::YVAddFriendListern,
	public YVSDK::YVListern::YVDelFriendListern,
	public YVSDK::YVListern::YVUpdateUserInfoListern,
	public YVSDK::YVListern::YVUserSetInfonotifyListern,
	public YVSDK::YVListern::YVNearsNotifyListern,
    public YVSDK::YVListern::YVFriendListListern
{
public:

	virtual ~FriendListNode();
	virtual bool init();

	void onAddFriendListern(YVSDK::YVUInfoPtr);
	void onDelFriendListern(YVSDK::YVUInfoPtr);
	void onUpdateUserInfoListern(YVSDK::YVUInfoPtr);
	//void onFriendListListern(YVSDK::FriendListNotify);
	void onUserSetInfonotifyListern(YVSDK::UserSetInfoNotify* q);
	void onNearsNotifyListern(YVSDK::RecentListNotify*);
    void onFriendListListern(YVSDK::FriendListNotify*);
    

private:
	virtual void delFriend(YVSDK::YVUInfoPtr);
	virtual void updateFriend(YVSDK::YVUInfoPtr);

	cocos2d::Node* m_rootNode;

};

#endif

