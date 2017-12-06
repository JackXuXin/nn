LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
$(call import-add-path,$(LOCAL_PATH)/../..)

LOCAL_MODULE := cocos2dlua_shared

LOCAL_MODULE_FILENAME := libcocos2dlua
LOCAL_SHARED_LIBRARIES += libYvImSdk

LOCAL_SRC_FILES := hellolua/main.cpp \
../../../../../Classes/VisibleRect.cpp \
../../../../../Classes/AppDelegate.cpp \
../../../../../Classes/HclcData.cpp \
../../../../../Classes/YVSDK/ChannalChatNode.cpp   \
../../../../../Classes/YVSDK/ChatItem.cpp   \
../../../../../Classes/YVSDK/YVChatNode.cpp   \
../../../../../Classes/YVSDK/FriendChatNode.cpp   \
../../../../../Classes/YVSDK/FriendListNode.cpp   \
../../../../../Classes/YVSDK/YVListenFun.cpp   \
../../../../../Classes/YVSDK/SearchListNode.cpp   \
../../../../../Classes/YVSDK/SystemNotifyNode.cpp   \
../../../../../Classes/YVSDK/YVPlatform.cpp   \
../../../../../Classes/YVSDK/YVManager/YVChannalChatManager.cpp   \
../../../../../Classes/YVSDK/YVManager/YVConfigManager.cpp   \
../../../../../Classes/YVSDK/YVManager/YVContactManager.cpp   \
../../../../../Classes/YVSDK/YVManager/YVFileManager.cpp   \
../../../../../Classes/YVSDK/YVManager/YVFriendChatManager.cpp   \
../../../../../Classes/YVSDK/YVManager/YVPlayerManager.cpp   \
../../../../../Classes/YVSDK/YVManager/YVToolManager.cpp   \
../../../../../Classes/YVSDK/YVManager/YVUInfoManager.cpp   \
../../../../../Classes/YVSDK/YVManager/YVGroupUserManage.cpp   \
../../../../../Classes/YVSDK/YVManager/YVLbsManager.cpp   \
../../../../../Classes/YVSDK/YVType/YVFilePath.cpp   \
../../../../../Classes/YVSDK/YVType/YVMessage.cpp   \
../../../../../Classes/YVSDK/YVType/YVUInfo.cpp   \
../../../../../Classes/YVSDK/YVUtils/YVMsgDispatcher.cpp   \
../../../../../Classes/YVSDK/YVUtils/YVRespondFactory.cpp   \
../../../../../Classes/YVSDK/YVUtils/YVString.cpp   \

# #anysdk
# LOCAL_SRC_FILES += \
# ../../../../../Classes/anysdkbindings.cpp \
# ../../../../../Classes/anysdk_manual_bindings.cpp

LOCAL_C_INCLUDES := \
$(LOCAL_PATH)/../../../../../Classes/runtime \
$(LOCAL_PATH)/../../../../../Classes \
$(LOCAL_PATH)/../../../../../Classes/YVSDK \
$(COCOS2DX_ROOT)/external \
$(COCOS2DX_ROOT)/external/protobuf-lite/src \
$(COCOS2DX_ROOT)/quick/lib/quick-src \
$(COCOS2DX_ROOT)/quick/lib/quick-src/extra

# #anysdk
# LOCAL_C_INCLUDES +=	\
# $(LOCAL_PATH)/../protocols/android \
# $(LOCAL_PATH)/../protocols/include

#anysdk
# LOCAL_WHOLE_STATIC_LIBRARIES += PluginProtocolStatic

LOCAL_STATIC_LIBRARIES := cocos2d_lua_static
LOCAL_STATIC_LIBRARIES += lua_extensions_static
LOCAL_STATIC_LIBRARIES += extra_static

include $(BUILD_SHARED_LIBRARY)

$(call import-module,scripting/lua-bindings/proj.android)

$(call import-module, quick-src/lua_extensions)
$(call import-module, quick-src/extra)

#anysdk
# $(call import-module,protocols/android)

$(call import-module, IM_SDK)

