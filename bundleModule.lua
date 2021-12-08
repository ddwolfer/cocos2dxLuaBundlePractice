
local BundleModule = class("BundleModule", cc.Node)

require "bundlePageView"
require "bundleReward"
require("baseState")
require("fsmMachine")

function BundleModule:ctor()
	print("@@in BundleModule ctor")
	  -- 禮包背景
	self.m_uiRoot = nil
    self.m_uiRoot = cc.CSLoader:createNode("AnimationNode/UI_Bundle.csb")
    self.m_uiRoot:setPosition(CC_DESIGN_RESOLUTION.width/2, CC_DESIGN_RESOLUTION.height/2)

    self:addChild(self.m_uiRoot)
    self:enableNodeEvents()
    if self.onCreate then self:onCreate() end
    if self.hide then self:hide() end
end

function BundleModule:onCreate()
	print("@@in BundleModule onCreate")

    -- 購買動畫 
    self.m_BundleReward = BundleMain.BundleReward:create(self.m_uiRoot)
    self:addChild(self.m_BundleReward)    

    -- 禮包列表
    self.m_bundleList = nil
    self.m_pageViewId = 1

    -- loading 用的小圈圈
    self.m_loadingSprite = cc.Sprite:create("LoadingSpin.png")
    self.m_loadingSprite:setPosition(CC_DESIGN_RESOLUTION.width/2, CC_DESIGN_RESOLUTION.height/2)
    self.m_loadingSprite:runAction(cc.RepeatForever:create(cc.RotateBy:create(1,90)))
    self.m_loadingSprite:setVisible(true)
    self:addChild(self.m_loadingSprite, 10)

    if self.setStateMachine then self:setStateMachine() end
    if self.seekAllNodes then self:seekAllNodes() end
    
end

function BundleModule:seekAllNodes()
	print("@@in BundleModule seekAllNodes")
	-- 右側禮包畫面節點
	self.m_pageViewNode = seekNodeByName(self.m_uiRoot, "PageView")

	-- 左側按鈕欄位節點
    self.m_btnListViewNode = seekNodeByName(self.m_uiRoot, "BtnListView")

    -- 離開按鈕
    self.m_exitButton = seekNodeByName(self.m_uiRoot, "Exit")
    self.m_exitButton:addClickEventListener(
        function() 
            if (self.m_bundleStateMachine.curState.stateName == "showState") then
                self.m_bundleStateMachine:Switch("idleState") 
            end
        end)
end

function BundleModule:setStateMachine()
	print("@@in BundleModule setStateMachine")
    -- 狀態機
    self.m_bundleStateMachine = FsmMachine:New()
    --
	-- 初始(未顯示) 狀態
	--
    self.m_idleState = BaseState:New("idleState")
    self.m_idleState.onEnterFun = function()
        self:hide()
    end
    --
	-- 請求資料 狀態
	--
    self.m_askDataState = BaseState:New("askDataState")
        -- 進入後顯示背景 delay 2秒模擬接收資料
    self.m_askDataState.onEnterFun = function()
        print ("@@ into ask data state, wait 2 sec to get data ") 
        self:show()
        self.m_loadingSprite:setVisible(true)
        local delayGetData = cc.DelayTime:create(2)
        local afterGetData = cc.CallFunc:create(
            function()
                -- BundleMain.BundleList <- 模擬收到的JSON
                self.m_bundleList = BundleMain.BundleList
                self:setPageViewData()
                self:setButton()
                self.m_loadingSprite:setVisible(false)
                self.m_bundleStateMachine:Switch("showState")
            end)
        self:runAction(cc.Sequence:create(delayGetData, afterGetData))
    end

    --
	-- 顯示 狀態
    --
	self.m_showState = BaseState:New("showState")
        -- 如果還沒請求過資料則跳到askData State
    self.m_showState.onEnterFun = function()
        if (self.m_bundleList == nil) then
            self.m_bundleStateMachine:Switch("askDataState")
        end
        self:show()
        -- 從顯示第1個group的第1頁開始
        self.m_pageViewId = 1
        self.m_pageViewController:newPageView(BundleMain.BundleList[self.m_pageViewId])
        self.m_pageViewNode:setCurrentPageIndex(0)
    end
        -- 離開隱藏
    self.m_showState.onLeaveFun = function()
        self:hide()
    end
    --
    -- 加入State進入狀態機, 並設定初始State(初始狀態不會觸發onEnter)
    --
    self.m_bundleStateMachine:AddState(self.m_idleState)
    self.m_bundleStateMachine:AddState(self.m_askDataState)
    self.m_bundleStateMachine:AddState(self.m_showState)
    self.m_bundleStateMachine:AddInitState(BaseState:New("idleState"))
end

-- 設置右側禮包畫面
function BundleModule:setPageViewData()
	print("@@in BundleModule setPageViewData")
    self.m_pageViewController = BundleMain.PageView:create(
    	self.m_uiRoot, 
	    function() 
	        local getCurrPageIdx = seekNodeByName(self.m_uiRoot, "PageView"):getCurrentPageIndex()
	        local getItemList    = BundleMain.BundleList[self.m_pageViewId][getCurrPageIdx + 1].ItemList
	        self.m_BundleReward:playTitle(getItemList)
	    end)
    self.m_pageViewController:newPageView(self.m_bundleList[self.m_pageViewId])
    self:addChild(self.m_pageViewController)
end

-- 設置左側按鈕
function BundleModule:setButton()
	print("@@in BundleModule setButton")
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
                    self.m_pageViewController:newPageView(BundleMain.BundleList[self.m_pageViewId])
                end
            end
            )
        -- 加入listView
        btnLayout:addChild(btnSprite)
        self.m_btnListViewNode:addChild(btnLayout)
    end
end
-- 顯示
function BundleModule:show()
	print("@@in BundleModule show")
	self:setVisible(true)
end
-- 隱藏
function BundleModule:hide()
	print("@@in BundleModule hide")
	self:setVisible(false)
end

BundleMain.BundleModule = BundleModule
