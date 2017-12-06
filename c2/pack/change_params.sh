#!/bin/sh

echo "Change params begin"

echo "appID:$3"

if [ $1 = 1 ]; then
    sed -i '' 's/DEVELOPMENT = true/DEVELOPMENT = false/' ../src/config.lua
    sed -i '' 's/-- ip = "192.168.1.113"/ip = "192.168.1.113"/' ../src/config.lua
    sed -i '' 's/-- ip = "114.55.37.226"/ip = "114.55.37.226"/' ../src/config.lua
elif [ $1 = 2 ]; then
    sed -i '' 's/DEVELOPMENT = true/DEVELOPMENT = false/' ../src/config.lua
    sed -i '' 's/-- ip = "app.wangwang68.com"/ip = "app.wangwang68.com"/' ../src/config.lua
    sed -i '' 's/ip = "app.wangwang68.com"/-- ip = "app.wangwang68.com"/' ../src/config.lua
    sed -i '' 's/-- ip = "tt.wangwang68.com"/ip = "tt.wangwang68.com"/' ../src/config.lua
    sed -i '' 's/ip = "tt.wangwang68.com"/-- ip = "tt.wangwang68.com"/' ../src/config.lua
    sed -i '' 's/-- ip = "tt.gametea.me"/ip = "tt.gametea.me"/' ../src/config.lua
    #1801 服务器设置
    sed -i '' 's/-- ip = "app.gametea.me"/ip = "app.gametea.me"/' ../src/config.lua 
    sed -i '' 's/ip = "app.gametea.me"/-- ip = "app.gametea.me"/' ../src/config.lua
    sed -i '' 's/-- ip = "101.37.170.137"/ip = "101.37.170.137"/' ../src/config.lua
    sed -i '' 's/ip = "101.37.170.137"/-- ip = "101.37.170.137"/' ../src/config.lua 
    #1801 end
    sed -i '' 's/CONFIG_APP_CHANNEL = "35.."/CONFIG_APP_CHANNEL = "'$3'"/' ../src/config.lua
    sed -i '' 's/CONFIG_APP_CHANNEL = "18.."/CONFIG_APP_CHANNEL = "'$3'"/' ../src/config.lua
    sed -i '' 's/CONFIG_VERSION_ID = ".*"/CONFIG_VERSION_ID = "'$2'"/' ../src/config.lua
elif [ $1 = 3 ]; then
    sed -i '' 's/DEVELOPMENT = true/DEVELOPMENT = false/' ../src/config.lua
    sed -i '' 's/-- ip = "tt.wangwang68.com"/ip = "tt.wangwang68.com"/' ../src/config.lua
    sed -i '' 's/ip = "tt.wangwang68.com"/-- ip = "tt.wangwang68.com"/' ../src/config.lua
    sed -i '' 's/-- ip = "tt.gametea.me"/ip = "tt.gametea.me"/' ../src/config.lua
    sed -i '' 's/ip = "tt.gametea.me"/-- ip = "tt.gametea.me"/' ../src/config.lua
    sed -i '' 's/-- ip = "app.wangwang68.com"/ip = "app.wangwang68.com"/' ../src/config.lua
    sed -i '' 's/ip = "app.wangwang68.com"/-- ip = "app.wangwang68.com"/' ../src/config.lua
    sed -i '' 's/-- ip = "ky13.gametea.me"/ip = "ky13.gametea.me"/' ../src/config.lua
    sed -i '' 's/ip = "ky13.gametea.me"/-- ip = "ky13.gametea.me"/' ../src/config.lua
    sed -i '' 's/-- ip = "wwsx.gametea.me"/ip = "wwsx.gametea.me"/' ../src/config.lua
    sed -i '' 's/CONFIG_APP_CHANNEL = "35.."/CONFIG_APP_CHANNEL = "'$3'"/' ../src/config.lua
    sed -i '' 's/CONFIG_APP_CHANNEL = "18.."/CONFIG_APP_CHANNEL = "'$3'"/' ../src/config.lua
    sed -i '' 's/CONFIG_VERSION_ID = ".*"/CONFIG_VERSION_ID = "'$2'"/' ../src/config.lua
fi

echo "Change params end"

