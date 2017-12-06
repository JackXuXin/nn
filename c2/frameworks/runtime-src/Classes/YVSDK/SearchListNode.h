#ifndef _SEARCHLISTNODE_H_
#define _SEARCHLISTNODE_H_
#include "cocos2d.h"
#include "../YVSDK/YVSDK.h"

struct YaYaRespondBase;
struct RecommendFriendRespond;

class SearchListNode
	:public cocos2d::Node,
	public YVSDK::YVListern::YVSearchFriendRetListern
	//public YVSDK::YVListern::YVRecommendFriendRetListern
{

public:
	virtual ~SearchListNode();
	virtual bool init();
	void onSearchFriendRetListern(YVSDK::SearchFriendRespond*);
	void onRecommendFriendRetListern(YVSDK::RecommendFriendRespond*);

	CREATE_FUNC(SearchListNode);
    void searchFriendByNick(std::string nick);

private:
	//获取推荐列表 
	void getRecomment();
	
};
    

#endif
