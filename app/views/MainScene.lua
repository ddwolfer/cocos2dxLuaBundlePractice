local MainScene = class("MainScene", cc.Node)
local fileUtils = cc.FileUtils:getInstance()

fileUtils:addSearchPath("src/")
fileUtils:addSearchPath("res/")

require "config"
require "myHelper"
require "json.getJsonList"
require "bundlePageView"

function MainScene:ctor()
    print("in mainScene ctor")
    -- 加入禮包主要頁面
    self.uiRoot = nil
    self.uiRoot = cc.CSLoader:createNode("AnimationNode/UI_Bundle.csb")
    self.uiRoot:setPosition(CC_DESIGN_RESOLUTION.width/2, CC_DESIGN_RESOLUTION.height/2)
    if (self.uiRoot)
    then
        print("get uiRoot")
        self:addChild(self.uiRoot)
    else
        print("not found uiRoot")
        return
    end

    -- 加入左側Button listview
    local btnListViewNode = seekNodeByName(self.uiRoot, "BtnListView")

    for key, buttonData in pairs(BundleMain.ButtonList) do
        -- 按鈕 Layout, Sprite, Node 獲取
        local btnLayout = ccui.Layout:create()
        local btnSprite = cc.CSLoader:createNode("AnimationNode/Button_Bundle.csb")
        local btnNode = seekNodeByName(btnSprite,"Button")
        -- 設定按鈕上文字
        btnNode:setTitleText(buttonData.GroupName)
        -- 設定Layout大小
        btnLayout:setContentSize(
            btnListViewNode:getContentSize()["width"], 
            btnNode:getContentSize()["height"] * 1.25
            )
        -- 設定按鈕位置
        btnSprite:setPosition(
            btnNode:getContentSize()["width"] / 2, 
            btnNode:getContentSize()["height"] / 2
            ) 
        -- 設定按鈕callback
        btnNode:addClickEventListener(
            function() 
                -- 按下的按鈕與目前頁面不同時轉換
                if (BundleMain.PageViewId ~= buttonData.GroupId)
                then
                    BundleMain.PageViewId = buttonData.GroupId
                    local pageViewNode = seekNodeByName(self.uiRoot, "PageView")
                    BundleMain.PageView:newPageView(pageViewNode, BundleMain.BundleList[BundleMain.PageViewId])
                end
            end
            )
        -- 加入listView
        btnLayout:addChild(btnSprite)
        btnListViewNode:addChild(btnLayout)
    end

    -- 生成pageview內容 預設第1個開始
    BundleMain.PageViewId = 1
    local pageViewNode = seekNodeByName(self.uiRoot, "PageView")
    BundleMain.PageView:newPageView(pageViewNode, BundleMain.BundleList[BundleMain.PageViewId])

end



BundleMain.MainScene = MainScene
