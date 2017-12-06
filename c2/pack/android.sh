#!/bin/sh
#

if [[ $# < 2 ]]; then
    echo "错误：参数2个，第一个参数游戏名：如：旺旺慈溪游戏
    第二个平台ID：3551
    第三个服务器选项：1,内网（暂时没有）2，测试服，3，正式服
    第四个热更版本：如 1.0.0.1"

    exit 1
fi

if [ "$3" != "" -a "$4" != "" ]; then

    #修改配置参数
    sh change_params.sh $3 $4 $2

fi

rootDir=../frameworks/runtime-src/wwkxm_proj.android_studio/client/src/main

echo "正在删掉旧的src,res,version"
rm -rf $rootDir/assets/src
rm -rf $rootDir/assets/res
rm -rf $rootDir/assets/version

declare -A appid_map=(["3553"]="wwsx" ["3554"]="wwkxm")
declare -A Packname_map=(["3553"]="com.tencent.tmgp.shaoxing" ["3554"]="com.tencent.tmgp.kxmqp")

appname=${appid_map[$2]}
packName=${Packname_map[$2]}
packStr=${packName##*.}

echo "正在拷贝$appname-的src,res,version"

if [[ $appname = "wwkxm" ]]; then

    #如果参数修改参数不为空，拷贝res目录资源到assets
    if [ "$3" != "" -a "$4" != "" ]; then

        cp -R ../src ../res ../version $rootDir/assets/

    else

        cp -R ../res_to_pack/src ../res_to_pack/res ../res_to_pack/version $rootDir/assets/

    fi

	if [ -d "../android_res/res" ]; then

        echo "android_res/res文件夹存在"
        rm -rf $rootDir/res
        cp -R ../android_res/res $rootDir
        cp -R ../android_res/AndroidManifest.xml $rootDir
     	
	fi

else

     if [ "$3" != "" -a "$4" != "" ]; then

        cp -R ../src ../../$appname/res_to_pack/res ../../$appname/res_to_pack/version $rootDir/assets/

    else

        cp -R ../../$appname/res_to_pack/src ../../$appname/res_to_pack/res ../../$appname/res_to_pack/version $rootDir/assets/

    fi

	if [ -d "../../$appname/android_res/res" ]; then

        echo "$appname/android_res/res文件夹存在"
        rm -rf $rootDir/res
        cp -R ../../$appname/android_res/res $rootDir
        cp -R ../../$appname/android_res/AndroidManifest.xml $rootDir
     	
	fi

fi

echo "正在替换包名为:$packName"

gradle -PpackageName=$packName showName

appRoot=wwkxm_proj.android_studio

echo "正在修改游戏名－－－"
php modifyName.php $1 $rootDir

reName=$rootDir/java/com/tencent/tmgp

echo "正在修改文件夹名-$packStr"
mv $reName/* $reName/$packStr

cd ../frameworks/runtime-src/$appRoot

echo "开始打包－－渠道号-$2--渠道名-$appname "

# clean build
# sh gradlew clean

# # # build signed apk
# sh gradlew assembletencentConfigRelease

# nowtime=$(date +%Y%m%d-%H%M%S)

# echo "打包完成－渠道名-$appname-完成时间：$nowtime"

# # copy to desktop
# cp client/build/outputs/apk/client-tencentConfig-release.apk ~/Desktop/apk/$appname-client.apk

cd ../../../pack
