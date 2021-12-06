local BundleList = {}
local ItemList = {}
local ButtonList = {}
local fileUtils = cc.FileUtils:getInstance()

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

-- 獲取所有道具列表
local itemListJsonStr = fileUtils:getStringFromFile("json/ItemList.json")
local ItemList = json.decode(itemListJsonStr)

-- 左側 ListView 的按鈕列表
local ButtonList = {
    {  
        GroupId = 1,
        GroupName = "一般禮包"
    },
    {
        GroupId = 2,
        GroupName = "每日禮包"
    },
    {
        GroupId = 3,
        GroupName = "豪華禮包"
    }
}

-- page的屬性，影響要用哪一個美術圖顯示
local BundleType = {
    BUNDLE_NORMAL = 1,
    BUNDLE_DAILY = 2,
    BUNDLE_BIG = 3,
}

--BundleType.Bundle3
-- pageType對應的美術圖位置
local BundleCsbPath = {
    [BundleType.BUNDLE_NORMAL] = "AnimationNode/Bundle1.csb",
    [BundleType.BUNDLE_DAILY] = "AnimationNode/Bundle2.csb",
    [BundleType.BUNDLE_BIG] = "AnimationNode/Bundle3.csb"
}

BundleMain.BundleList = BundleList
BundleMain.ItemList = ItemList
BundleMain.ButtonList = ButtonList
BundleMain.BundleType = BundleType
BundleMain.BundleCsbPath = BundleCsbPath