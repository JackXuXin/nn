#ifndef _SYSTEMNOTIFYNODE_H__
#define _SYSTEMNOTIFYNODE_H__

#include "cocos2d.h"
#include "YVSDK.h"

class NotifyListNode;
class NotfiyItemLayout;
class SystemNotifyNode
	:public cocos2d::Node
	, public YVSDK::YVListern::YVBegAddFriendListern,
	public YVSDK::YVListern::YVAddFriendRetListern
{
public:
	virtual ~SystemNotifyNode();
	virtual bool init();

	void onBegAddFriendListern(YVSDK::YVBegFriendNotifyPtr);
	void onAddFriendRetListern(YVSDK::YVAddFriendRetPtr);
	

private:

};

#endif
