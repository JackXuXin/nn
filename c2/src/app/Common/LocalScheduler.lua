local scheduler = require("framework.scheduler")


local LocalScheduler = {}


function LocalScheduler.new()
	local localScheduler = {}
	local handlers = {}

	function localScheduler.scheduleUpdate(listener)
		local handle = scheduler.scheduleUpdateGlobal(listener)
		table.insert(handlers, handle)
	    return handle
	end

	function localScheduler.schedule(listener, interval)
		local handle = scheduler.scheduleGlobal(listener, interval)
		table.insert(handlers, handle)
		return handle
	end

	function localScheduler.unschedule(handle)
	    scheduler.unscheduleGlobal(handle)
	    for i, v in pairs(handlers) do 
	    	if v == handle then
	    		table.remove(handlers, i)
	    		break
	    	end
	    end
	end

	function localScheduler.performWithDelay(listener, time)
		local handle = nil
		handle = scheduler.performWithDelayGlobal(function()
			for k, v in pairs(handlers) do
				if v == handle then
					handlers[k] = nil
					listener()
					-- print("handle:", tostring(handle), "released! remain:".. table.nums(handlers))
					return
				end
			end
			print("error!!! have no handle:", tostring(handle))
		end, time)
		table.insert(handlers, handle)
		return handle
	end

	function localScheduler.clear()
		for _, v in pairs(handlers) do
			if v then 
				scheduler.unscheduleGlobal(v)
			end
		end
		handlers = {}
	end

	print("new local scheduler...")
	return localScheduler
end


return LocalScheduler