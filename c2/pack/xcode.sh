#!/bin/sh

cd ../frameworks/runtime-src/proj.ios_mac
rm -rf build/

# clean build
xcodebuild clean

# build app
xcodebuild -target "client iOS" -configuration "release" -sdk iphoneos

# build ipa
xcrun -sdk iphoneos PackageApplication -v "build/release-iphoneos/client iOS.app" -o "`pwd`/build/client.ipa"

# copy to desktop
cp build/client.ipa ~/Desktop/
