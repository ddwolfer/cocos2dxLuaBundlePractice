local ViewController = class("PageView", cc.Node)

require "config"
require "myHelper"
require "bundleReward"
local BundleNormalView = require "bundleNormalView"

-- 建構式
function ViewController:ctor()
	print ("@@ in PageView ctor")

	self:enableNodeEvents()
	if self.onCreate then self:onCreate() end
end

-- 生成禮包頁面根部
function ViewController:createUIRootNode()
	local uiRoot = cc.CSLoader:createNode("AnimationNode/UI_Bundle.csb")
	uiRoot:setPosition(CC_DESIGN_RESOLUTION.width/2, CC_DESIGN_RESOLUTION.height/2)

	return uiRoot
end

-- 初始化
function ViewController:onCreate()
	print ("@@ in PageView onCreate")
	self.m_pageViewId = 1
	self.m_pageViewPool = {}
	self.m_bundleList = {}
	-- 禮包背景
	self.m_uiRoot = self:createUIRootNode()
    self:addChild(self.m_uiRoot)

    -- 購買動畫 
    self.m_BundleReward = BundleMain.BundleReward:create(self.m_uiRoot)
    self:addChild(self.m_BundleReward)   

    -- loading 用的小圈圈
    self.m_loadingSprite = cc.Sprite:create("LoadingSpin.png")
    self.m_loadingSprite:setPosition(CC_DESIGN_RESOLUTION.width/2, CC_DESIGN_RESOLUTION.height/2)
    self.m_loadingSprite:runAction(cc.RepeatForever:create(cc.RotateBy:create(1,90)))
    self.m_loadingSprite:setVisible(false)
    self:addChild(self.m_loadingSprite, 10)

    self:seekAllNodes()

	-- 購物按鈕功能
	self.m_buyBtnCallBack = function() 
		local getCurrPageIdx = self.m_pageViewNode:getCurrentPageIndex()
		local getItemList    = self.m_bundleList[self.m_pageViewId][getCurrPageIdx + 1].ItemList
		self.m_BundleReward:playTitle(getItemList)
	end	
end

-- 獲取該class 需要的節點
function ViewController:seekAllNodes()
	print ("@@ in PageView seekAllNodes")
	-- 右側禮包畫面節點
	self.m_pageViewNode = seekNodeByName(self.m_uiRoot, "PageView")

	-- 左側按鈕欄位節點
    self.m_btnListViewNode = seekNodeByName(self.m_uiRoot, "BtnListView")

    -- 關閉禮包按鈕
    self.m_exitBtn = seekNodeByName(self.m_uiRoot, "Exit")
    self.m_exitBtn:addClickEventListener(function() print("@@ default exit bundle message") end)
end

-- 新增PageViews內容
function ViewController:newPageView(bundleList)
	print ("@@ in PageView newPageView")
	-- 刪除舊有pageview畫面
	self.m_pageViewNode:removeAllPages()

	for idx, bundleData in pairs(bundleList) do
		print("@@ add",idx,"Page")
		-- 如果pool內沒有生成過再生成，有生成過的話直接從pool中取就好
		if (self.m_pageViewPool[bundleData.BundleId] == nil) then
			-- 生成與設定 page
			local newPage = BundleNormalView:create(bundleData)
			newPage:retain() -- 已在class中onExit()寫入release()
			newPage:setPagePosition(
				self.m_pageViewNode:getContentSize()["width"]/2, 
				self.m_pageViewNode:getContentSize()["height"]/2
				)
			newPage:setBundlePrice()
			newPage:setItemData()
			newPage:setBuyCallBack(self.m_buyBtnCallBack)

			self.m_pageViewPool[newPage.m_bundleData.BundleId] = newPage
		end
		self.m_pageViewNode:addPage(self.m_pageViewPool[bundleData.BundleId])
	end
	dump(self.m_pageViewPool,"@@ pool after ViewController:newPageView")

	self.m_pageViewNode:setCurrentPageIndex(0)
end
-- 設置離開事件
function ViewController:getExitBtnNode()
	print("@@ get exit button node")
	return self.m_exitBtn
end
-- 設置禮包列表
function ViewController:setBundleList(inputBundleList)
	print ("@@ ViewController setBundleList")
	self.m_bundleList = inputBundleList
end
-- 設置左側按鈕
function ViewController:setButton()
	print("@@in PageView setButton")
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
                    self:newPageView(self.m_bundleList[self.m_pageViewId])
                end
            end
            )
        -- 加入listView
        btnLayout:addChild(btnSprite)
        self.m_btnListViewNode:addChild(btnLayout)
    end
end
-- loading 畫面切換
function ViewController:showLoadingSprite()
	self.m_loadingSprite:setVisible(true)
end
function ViewController:hideLoadingSprite()
	self.m_loadingSprite:setVisible(false)
end

-- 解構式
function ViewController:onExit()
	print ("@@ in PageView exit")

	for key, node in pairs(self.m_pageViewPool) do
		node:release()
	end
	self:disableNodeEvents()
end

BundleMain.ViewController = ViewController
