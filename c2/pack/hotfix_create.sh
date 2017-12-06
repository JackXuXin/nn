#!/bin/sh
path=$(cd "$(dirname "$0")"; pwd)
cd $path

# args1:打包类型:1、内网  2、测试服服务器  3、游戏服务器
# args2:版本号

if [ $# != 2 ]; then
    echo "错误：参数必须是2个，第一个参数type：1、内网  2、测试服服务器  3、游戏服务器;\n第二个参数是新的版本，版本号必须比前一个版本大！"
    exit 1
fi

#appid="3551"
ip="139.196.172.48"

curVer="测试服"

if [ $1 = 1 ]; then
    ip="139.196.172.48"
    curVer="内网测试"
elif [ $1 = 2 ]; then
    ip="tt.gametea.me"
    curVer="测试服"
elif [ $1 = 3 ]; then
    ip="wwsx.gametea.me"
    curVer="正式服"
else
    echo "错误：第一个参数错误，只能是1、2或者3！"
    exit 1
fi

dirRoot=../../../hottest
curDic=pack

#declare -A appid_map=(["3551"]="wwcx" ["3550"]="wwyy" ["3552"]="wwzj" ["1801"]="wwjl")
#["3554"]="wwkxm" ["3553"]="wwsx" ["3552"]="wwzj"
declare -A appid_map=(["3553"]="wwsx")

for key in ${!appid_map[@]}
do
    appid=$key
    appname=${appid_map[$key]}

    appRoot=../../$appname

    echo "开始打包－－渠道号-$appid--渠道名-$appname "

	#删除旧的目录文件
    rm -rf $dirRoot/$appname

	echo "delete：old res,src,version-finish!"

	#修改配置参数
	sh change_params.sh $1 $2 $appid

	if [ ! -d "'$dirRoot'/'$appname'" ]; then
     	mkdir $dirRoot/$appname
	fi

	if [ ! -d "'$dirRoot'/'$appname'/files" ]; then
     	mkdir $dirRoot/$appname/files
	fi

	#拷贝资源文件
	cp -R ../src $dirRoot/$appname/files/
	#cp -R ../res $dirRoot/$appname/files/

	if [ $appname != "wwkxm" ]; then

		appRoot=../../$appname
		curDic=../wwkxm/pack

		rsync -aP --exclude-from=$appRoot/tools/exclude.list ../res $dirRoot/$appname/files/

		echo "not wwkxm---!"

		rm -rf $dirRoot/$appname/files/res/Platform_Src
		cp -R $appRoot/res/Platform_Src $dirRoot/$appname/files/res
        #如果是金陵茶苑的包，要替换掉头像
		# if [ $appname = "wwjl" ]; then

		# 	rm -rf $dirRoot/$appname/files/res/Image/Common/Avatar
		# 	cp -R $appRoot/res/Avatar $dirRoot/$appname/files/res/Image/Common

		# fi

	else

		appRoot=..
		curDic=pack

		rsync -aP --exclude-from=$appRoot/tools/exclude.list ../res $dirRoot/$appname/files/
	fi

	#如果是正式服包就备份下资源
	if [ $1 = 3 ]; then

		rm -rf $appRoot/backups
		if [ ! -d "'$appRoot'/backups" ]; then
		     mkdir $appRoot/backups
		fi

		echo "copy backups src,res to $appname/backups!"
		cp -R $dirRoot/$appname/files/res $appRoot/backups/
		cp -R $dirRoot/$appname/files/src $appRoot/backups/

		nowtime=$(date +%Y%m%d%H%M%S)

		pageName=$nowtime"_"$appname"_"$curVer"_"$2

		if [ ! -d "'$appRoot'/backzip" ]; then
		     mkdir $appRoot/backzip
		fi

        #压缩备份资源
		cd $appRoot

		echo "zip $appname/backups to backzip/$pageName!"

	    zip -q -r backzip/$pageName.zip backups

	    cd $curDic
	fi

	cp -R ../version $dirRoot/$appname/

	echo "copy src ,res, version-finish!"

	#加密lua
    sh crypt_src.sh $appname $dirRoot

    if [ $appname != "wwkxm" ]; then

	    #生成热更新文件
	    if [ $1 = 2 ]; then
	    	echo "test----ip------!"
	    	python hotfixt.py $2 $ip $appid $appname $dirRoot
	    else
	    	python hotfix.py $2 $ip $appid $appname $dirRoot
	    fi
		
	else
		 #生成热更新文件
		python hotfixk.py $2 $ip $appid $appname $dirRoot
	fi

	#  #生成热更新文件
	# python hotfix.py $2 $ip $appid $appname $dirRoot

	pageName=$appname"_"$curVer"_"$2

	echo $pageName

	cd $dirRoot

	zip -q -r $pageName.zip $appname

	cd ../wangwang/wwkxm/pack

done
