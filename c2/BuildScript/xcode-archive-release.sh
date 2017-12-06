#!/bin/sh
#

#出现过 can't find device 的错误，使用 rvm system 解决掉了

# source xcode-archive-release.sh 1 3551 4 2 1.0.0.6


if [ $# != 3 ]; then
    echo "错误：参数最少3个，第一个参数打包类型：1、adhoc  2、appstore
    第二个平台ID：3551
    第三个大版本号：如 输入5，build会设置成5"
    # 第四个服务器选项：1,内网（暂时没有）2，测试服，3，正式服
    # 第五个热更版本：如 1.0.0.1"

    exit 1
fi

declare -A appid_map=(["3551"]="wwcx" ["3550"]="wwyy")

appname=${appid_map[$2]}

apptype=adhoc
exportOptionsPlist="../../../BuildScript/adhocExportOptions.plist"
ipaOutPath=/Users/queyou/Desktop/测试包

if [ $1 = 1 ]; then

    apptype=adhoc
    exportOptionsPlist="../../../BuildScript/adhocExportOptions.plist"
    ipaOutPath=/Users/queyou/Desktop/测试包

elif [ $1 = 2 ]; then

    apptype=appstore
    exportOptionsPlist="../../../BuildScript/release_exportOptions.plist"
    ipaOutPath=/Users/queyou/Desktop/审核包

else
    echo "错误：第一个参数错误，只能是1、或者2！"
    exit 1
fi

# if [ "$4" != "" -a "$5" != "" ]; then

#     #修改配置参数
#     sh ../pack/change_params.sh $4 $5 $2

# fi

rvm use system

cd ../frameworks/runtime-src/wwcx_proj.ios_mac

plistPath=ios/Info.plist

if [[ $appname = "wwcx" ]]; then

	plistPath=ios/Info.plist

else

	plistPath=ios/$appname/Info.plist

fi

echo "plist---path:$plistPath"

/usr/libexec/PlistBuddy -c 'Set:CFBundleVersion '$3'' $plistPath

#"wwcx" 
archiveName=$appname      
workspaceName="client.xcodeproj"
scheme="client iOS "$appname  
configuration="release"
ipaPath="${PWD}/build/${archiveName}/${scheme}.ipa"
appleid="xxx"
applepassword="xxx"  

echo "开始打包－scheme:$scheme"
codeSignIdentity="iPhone Distribution: Hangzhou Wangwang Network Technology Co., Ltd. (P9C963J22V)"
#wwcx
appStoreProvisioningProfile="6d6e5071-0efe-4e37-b5d4-78682339692e"
#adhocProvisioningProfile="90d0ebc2-4119-4d9d-97cd-86f41451fe50"

osascript -e 'display notification "Release To '$apptype'"  with title "Running"'

#build clean
xcodebuild clean -configuration "$configuration" -alltargets
osascript -e 'display notification "Release To '$apptype'"  with title "Clean Complete!"'

#打包 archive
if [ $1 = 1 ]; then

	xcodebuild archive -project "$workspaceName" -scheme "$scheme" -configuration "$configuration" -archivePath $PWD/build/${archiveName}.xcarchive 

else

	xcodebuild archive -project "$workspaceName" -scheme "$scheme" -configuration "$configuration" -archivePath $PWD/build/${archiveName}.xcarchive CODE_SIGN_IDENTITY="$codeSignIdentity" PROVISIONING_PROFILE="$appStoreProvisioningProfile"

fi

osascript -e 'display notification "Release To '$apptype'" with title "Archive Complete!"'

# xcodebuild archive -workspace "$workspaceName" -scheme "$scheme" -configuration "$configuration" -archivePath $PWD/build/${archiveName}.xcarchive CODE_SIGN_IDENTITY="$codeSignIdentity" PROVISIONING_PROFILE="$appStoreProvisioningProfile"

#导出到ipa /Users/queyou/Desktop/测试包  $PWD/build/${archiveName}
xcodebuild -exportArchive -archivePath $PWD/build/${archiveName}.xcarchive -exportOptionsPlist "$exportOptionsPlist" -exportPath $ipaOutPath
osascript -e 'display notification "Release To '$apptype'" with title "Export Complete!"'

cd ../../../BuildScript

###################################
#发布到iTunesConnect
###################################
  
# altoolPath="/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support/altool"

# #validate
# "$altoolPath" --validate-app -f "$ipaPath" -u "$appleid" -p "$applepassword" -t ios --output-format xml
# osascript -e 'display notification "Release To AppStore" with title "Validate Complete!"'

# #upload
# "$altoolPath" --upload-app -f "$ipaPath" -u "$appleid" -p "$applepassword" -t ios --output-format xml
# osascript -e 'display notification "Release To AppStore" with title "Upload Complete!"'