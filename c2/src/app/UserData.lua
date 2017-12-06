return
{
	Account = {
		init = function (self)
			self.account = nil
			self.password = nil
			self.secret = nil
			self.uid = nil
			self.recharge = nil
			self.channel = nil
			self.token = nil
			self.secret = nil
			self.tags = {}
	--modify by whb 161020
            self.app_channel = ""
    --end
		end,
	},
	Player = {
		init = function (self)
			self.uid = 0
			self.nickname = ""
			self.money = 0
			self.gold = ""
			self.bankgold = ""
			self.exp = 0
			self.vipexp = 0
			self.sex = 1	-- 1-female; 2-male
			self.imageid = ""
			self.isbinding = 0
			self.secondpwd = nil
			self.honor = 0
			self.supid = -1   --  -1没有绑定，-2顶级用户，其他 绑定的uid
	--modify by whb 161028
            self.viptype = 0
            self.vipdays = 0
            self.dynamicpwd = ""
            self.diamond = ""
            self.qq = ""
            self.weixin = ""
            self.isverified = false
    --end
    		self.noticeInfos = {}   --滚动的公告信息存储到这个表结构
    		self.noticeInfosEx = {}   --公告栏的公告信息存储到这个表结构
    		self.isStartPlayNotice = false --是否在该场景已经开始循环播放公告
		end
	},
	Room = {
		init = function (self)
			self.tableRule = { -- according to game.proto.SitdownReq.TableRule
				-- minwinrate = 0.01,
				-- maxfleerate = 99.9,
				-- minscore = 0,
				-- maxscore = 999999999,
				-- noblackman = true;
				-- nosameip = false;
				-- pwd = "123456";
			}
		end,
	},

	Goods = {
		init = function (self)
			self.list = {}
			self.channels = {}
		end,
	},

	clear = function(self) 
		self.Account:init()
		self.Player:init()
		self.Room:init()
		self.Goods:init()
	end
}