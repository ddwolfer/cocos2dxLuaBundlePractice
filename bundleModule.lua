
local BundleModule = class("BundleModule")

require "bundleViewController"
require "Commder.lua"
require("baseState")
require("fsmMachine")

function BundleModule:ctor(MainScene)
	print("@@in BundleModule ctor")

    self.m_mainScene = MainScene
    self.m_viewController = BundleMain.ViewController:create()
    self.m_viewController:setVisible(false)
    self.m_mainScene:addChild(self.m_viewController)

    if self.onCreate then self:onCreate() end
end

function BundleModule:onCreate()
	print("@@in BundleModule onCreate")
    -- 禮包列表
    self.m_bundleList = nil
    self:setStateMachine()
    -- 設定退出按鈕動作
    self.m_viewController:getExitBtnNode():addClickEventListener(function() self:hide() end)
    -- Commder
    self.m_commder = BundleMain.BundleCommder:create()

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
        print("@@ in idle onEnter, invisible the ui")
        self.m_viewController:setVisible(false)
    end
    --
	-- 請求資料 狀態
	--
    self.m_askDataState = BaseState:New("askDataState")
        -- 進入後顯示背景 delay 2秒模擬接收資料
    self.m_askDataState.onEnterFun = function()
        print ("@@ into ask data state, wait 2 sec to get data ") 
        self.m_viewController:showLoadingSprite()
        self:askBundleData()
    end
    --
	-- 顯示 狀態
    --
	self.m_showState = BaseState:New("showState")
        -- 如果還沒請求過資料則跳到askData State
    self.m_showState.onEnterFun = function()
        print("@@ in show state on Enter, if didn't load any bundle yet, goto askData state")
        self.m_viewController:setVisible(true)
        if (self.m_bundleList == nil) then
            self.m_bundleStateMachine:Switch("askDataState")
        else
            -- 從顯示第1個group的第1頁開始
            self.m_viewController:newPageView(self.m_bundleList[1])
        end
    end
        -- 離開隱藏
    self.m_showState.onLeaveFun = function()
        print("@@ in show state on Leave, invisible the ui")
        self.m_viewController:setVisible(false)
    end
    --
    -- 加入State進入狀態機, 並設定初始State(初始狀態不會觸發onEnter)
    --
    self.m_bundleStateMachine:AddState(self.m_idleState)
    self.m_bundleStateMachine:AddState(self.m_askDataState)
    self.m_bundleStateMachine:AddState(self.m_showState)
    self.m_bundleStateMachine:AddInitState(BaseState:New("idleState"))
end


-- 請求資料
function BundleModule:askBundleData()
    local receiveDataCallback = function(data) self:receiveBundleData(data) end
    self.m_commder:startGetDataScheduler(receiveDataCallback)

end
-- 接收資料
function BundleModule:receiveBundleData(getList)
    self.m_bundleList = getList
    self.m_viewController:setBundleList(getList)
    self.m_viewController:setButton()
    self.m_viewController:hideLoadingSprite()
    if (self.m_bundleStateMachine.curState.stateName == "askDataState") then
        self:show()
    end
end

-- 顯示
function BundleModule:show()
	print("@@in BundleModule show (change state to show)")
	self.m_bundleStateMachine:Switch("showState")
end
-- 隱藏
function BundleModule:hide()
	print("@@in BundleModule hide (change state to idle)")
	self.m_bundleStateMachine:Switch("idleState")
end

BundleMain.BundleModule = BundleModule
