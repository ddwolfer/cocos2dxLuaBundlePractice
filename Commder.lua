local BundleCommder = class("BundleCommder")

function BundleCommder:ctor()
	
end

function BundleCommder:startGetDataScheduler(callBack)
	print("@@ start get data scheduler")
    local scheduler = cc.Director:getInstance():getScheduler()
    self.m_getBundleDataSchedule = scheduler:scheduleScriptFunc( function()
    	print("@@ in scheduler")
    	local fileUtils = cc.FileUtils:getInstance()
    	local BundleList = {}
    	-- 獲取所有禮包的列表
		local bundleListJsonStr = fileUtils:getStringFromFile("json/BundleList.json")
		local bundleListJsonTable = json.decode(bundleListJsonStr)
		dump(bundleListJsonTable, "@@bundleList json content:")
		-- 將列表內的所有禮包json放進Table
		for idx, jsonFileName in pairs(bundleListJsonTable) do
		    local bundlePageJsonStr = fileUtils:getStringFromFile("json/"..jsonFileName)
		    local bundlePagejsonTable = json.decode(bundlePageJsonStr)
		    local bundleGroup = bundlePagejsonTable.GroupId
		    -- Group: 同一個ListView按鈕底下
		    if (BundleList[bundleGroup] == nil)
		    then
		        BundleList[bundleGroup] = {}
		    end
		    table.insert(BundleList[bundleGroup], bundlePagejsonTable)
		end

		BundleMain.BundleList = BundleList
    	callBack(BundleMain.BundleList)
    	self:stopGetDataScheduler()
    end, 2, false)
end 

function BundleCommder:stopGetDataScheduler()
    local scheduler = cc.Director:getInstance():getScheduler()
    if self.m_getBundleDataSchedule then 
        scheduler:unscheduleScriptEntry(self.m_getBundleDataSchedule)
        self.m_getBundleDataSchedule = nil 
    else
    	print("@@ get bundle list schedule is not exist")
    end
end 

-- function BundleCommder:getSchedule()
-- 	return BundleCommder.m_getBundleDataSchedule
-- end

BundleMain.BundleCommder = BundleCommder