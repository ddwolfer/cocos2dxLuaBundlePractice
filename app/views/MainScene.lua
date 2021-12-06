local MainScene = class("MainScene", cc.Node)
local fileUtils = cc.FileUtils:getInstance()

fileUtils:addSearchPath("src/")
fileUtils:addSearchPath("res/")

require "config"
require "myHelper"
require "json.getJsonList"
require "bundlePageView"
require "BundleReward"

-------------------
-- 禮包主畫面生成 --
-------------------
function MainScene:ctor()
    print("in mainScene ctor")
    -- 載入禮包背景
    self.m_uiRoot = nil
    self.m_uiRoot = cc.CSLoader:createNode("AnimationNode/UI_Bundle.csb")
    self.m_uiRoot:setPosition(CC_DESIGN_RESOLUTION.width/2, CC_DESIGN_RESOLUTION.height/2)
    if (self.m_uiRoot)
    then
        print("get uiRoot")
        self:addChild(self.m_uiRoot)
    else
        print("not found uiRoot")
        return
    end

    -- 生成購買動畫 
    self.BundleReward = BundleMain.BundleReward:create(self.m_uiRoot)
    self:addChild(self.BundleReward)

    -- 生成pageview內容 預設從第1個開始
    self.m_pageViewId = 1
    self.PageView = BundleMain.PageView:create(self.m_uiRoot, 
        function() 
            local getCurrPageIdx = seekNodeByName(self.m_uiRoot, "PageView"):getCurrentPageIndex()
            local getItemList    = BundleMain.BundleList[self.m_pageViewId][getCurrPageIdx + 1].ItemList
            self.BundleReward:playTitle(getItemList)
        end)
    self.PageView:newPageView(BundleMain.BundleList[self.m_pageViewId])
    self:addChild(self.PageView)

    -- 生成 ListView 內容
    -- 左側欄位節點
    self.m_btnListViewNode = self.m_uiRoot:getChildByName("BtnListView")
    -- 設置左側按鈕
    for key, buttonData in pairs(BundleMain.ButtonList) do
        -- 按鈕 Layout, Sprite, Node 獲取
        local btnLayout = ccui.Layout:create()
        local btnSprite = cc.CSLoader:createNode("AnimationNode/Button_Bundle.csb")
        local btnNode = seekNodeByName(btnSprite,"Button")
        -- 設定按鈕上文字
        btnNode:setTitleText(buttonData.GroupName)
        -- 設定Layout大小
        btnLayout:setContentSize(
            self.m_btnListViewNode:getContentSize()["width"], 
            btnNode:getContentSize()["height"] * 1.25
            )
        -- 設定按鈕位置
        btnSprite:setPosition(
            btnNode:getContentSize()["width"] / 2, 
            btnNode:getContentSize()["height"] / 2
            ) 
        -- 設定按鈕不要阻擋下層touch事件
        btnNode:setSwallowTouches(false)
        -- 設定按鈕callback
        btnNode:addClickEventListener(
            function() 
                -- 按下的按鈕與目前頁面不同時轉換PageView
                if (self.m_pageViewId ~= buttonData.GroupId)
                then
                    self.m_pageViewId = buttonData.GroupId
                    print ("@@ change to group ", self.m_pageViewId)
                    self.PageView:newPageView(BundleMain.BundleList[self.m_pageViewId])
                end
            end
            )
        -- 加入listView
        btnLayout:addChild(btnSprite)
        self.m_btnListViewNode:addChild(btnLayout)
    end
end

BundleMain.MainScene = MainScene