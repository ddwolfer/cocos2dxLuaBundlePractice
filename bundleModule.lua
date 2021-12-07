--bundelModule.lua
local BundleModule = class{"BundleModule", cc.Node}

local fileUtils = cc.FileUtils:getInstance()

fileUtils:addSearchPath("src/")
fileUtils:addSearchPath("res/")

require "config"
require "myHelper"
require "json.getJsonList"
require "bundlePageView"
require "bundleReward"
require("baseState")
require("fsmMachine")



function BundleModule:ctor()
	print("@@in BundleModule ctor")
	   
    if self.onCreate then self:onCreate() end
end

function BundleModule:onCreate()
	print("@@in BundleModule onCreate")

	-- 禮包背景
    self.m_uiRoot = cc.CSLoader:createNode("AnimationNode/UI_Bundle.csb")
    self.m_uiRoot:setPosition(CC_DESIGN_RESOLUTION.width/2, CC_DESIGN_RESOLUTION.height/2)
    self:addChild(self.m_uiRoot)

    -- 購買動畫 
    self.m_BundleReward = BundleMain.BundleReward:create(self.m_uiRoot)
    self:addChild(self.m_BundleReward)    

    -- 禮包列表
    self.m_bundleList = {}
    self.m_pageViewId = 1

    if self.seekAllNodes then self:seekAllNodes() end
    if self.setStateMachine then self:setStateMachine() end
end

function BundleModule:seekAllNodes()

	-- 右側禮包畫面節點
	self.m_pageViewNode = seekNodeByName(self.m_uiRoot, "PageView")

	-- 左側按鈕欄位節點
    self.m_btnListViewNode = seekNodeByName(self.m_uiRoot, "BtnListView")
end

function BundleModule:setStateMachine()
	-- 初始(未顯示) 狀態
	self.m_idleState = baseState:New("self.m_idleState")
	

	-- 請求資料 狀態
	self.m_askDataState = baseState:New("self.m_askDataState")
	
	-- 顯示 狀態
	self.m_showState = baseState:New("self.m_showState")
	
	-- 狀態機
    self.m_bundleStateMachine = FsmMachine:New()
    self.m_bundleStateMachine:AddState(self.m_idleState)
    self.m_bundleStateMachine:AddState(self.m_askDataState)
    self.m_bundleStateMachine:AddState(self.m_showState)
    self.m_bundleStateMachine:AddInitState(self.m_idleState)
end

-- 設置右側禮包畫面
function setPageViewData()
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

function BundleModule:show()
	print("@@in BundleModule show")
	self:setVisible(true)
end

function BundleModule:hide()
	print("@@in BundleModule hide")
	self:setVisible(false)
end

BundleMain.BundleModule = BundleModule
