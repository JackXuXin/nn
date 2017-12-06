//
//  YVListenFun.h
//  client
//
//  Created by queyou on 16/12/19.
//
//

#ifndef YVListenFun_h
#define YVListenFun_h

#include <stdio.h>

#include "../YVSDK/YVSDK.h"

#include "SearchListNode.h"
#include "FriendListNode.h"
#include "SystemNotifyNode.h"
#include "FriendChatNode.h"
#include "ChannalChatNode.h"

using namespace YVSDK;


class YVListenFun : public YVListern::YVCPLoginListern
{
public:
    
    ~YVListenFun();
    
    void onCPLoginListern(CPLoginResponce* r );
    
    SearchListNode* getSearchListNode() { return pSearchListNode; };
    FriendListNode* getFriendListNode() { return pFriendListNode; };
    ChannalChatNode* getChannalNode() { return pChannalNode; };
    
    void openFriendChat(uint32 nYvID);
    void releaseAllNode();
    
    FriendChatNode* getFriendChatNode(uint32 nYvID);
    

private:
    
    SearchListNode* pSearchListNode;
    FriendListNode* pFriendListNode;
    SystemNotifyNode *pSystemNotifyNode;
    ChannalChatNode* pChannalNode;
    //FriendChatNode* pfriendChatNode;
    
    std::vector<FriendChatNode*> m_friendChatList;
};


#endif /* YVListenFun_h */
