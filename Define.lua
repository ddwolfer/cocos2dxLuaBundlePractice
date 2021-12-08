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

-- pageType對應的美術圖位置
local BundleCsbPath = {
    [BundleType.BUNDLE_NORMAL] = "AnimationNode/Bundle1.csb",
    [BundleType.BUNDLE_DAILY] = "AnimationNode/Bundle2.csb",
    [BundleType.BUNDLE_BIG] = "AnimationNode/Bundle3.csb"
}

-- 禮包狀態機的狀態
local BundleStateType = {
    IDLE_STATE = 1,
    ASKDATA_STATE = 2,
    SHOW_STATE = 3
}

BundleMain.ButtonList = ButtonList
BundleMain.BundleType = BundleType
BundleMain.BundleCsbPath = BundleCsbPath
BundleMain.BundleStateType = BundleStateType