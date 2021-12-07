local PageView = class("PageView", cc.Node)

require "config"
require "myHelper"
local BundleNormalView = require "bundleNormalView"

-- 建構式
function PageView:ctor(uiRoot, buyButtonCallBack)
	print ("@@ in PageView ctor")

	self.m_uiRoot = uiRoot
	self.m_buyButtonCallBack = buyButtonCallBack
	self:enableNodeEvents()
	if self.onCreate then self:onCreate() end
end

-- 初始化
function PageView:onCreate()
	print ("@@ in PageView onCreate")
	self.m_pageViewPool = {}

	if self.seekAllNodes then self:seekAllNodes() end
end

-- 獲取該class 需要的節點
function PageView:seekAllNodes()
	print ("@@ in PageView seekAllNodes")
	self.m_pageViewNode = seekNodeByName(self.m_uiRoot, "PageView")
end

-- 新增PageViews內容
function PageView:newPageView(bundleList)
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
			newPage:setBuyCallBack(self.m_buyButtonCallBack)

			self.m_pageViewPool[newPage.m_bundleData.BundleId] = newPage
		end
		self.m_pageViewNode:addPage(self.m_pageViewPool[bundleData.BundleId])
	end
	dump(self.m_pageViewPool,"@@ pool after PageView:newPageView")

	self.m_pageViewNode:setCurrentPageIndex(0)
end

-- 解構式
function PageView:onExit()
	print ("@@ in PageView exit")

	for key, node in pairs(self.m_pageViewPool) do
		node:release()
	end
	self:disableNodeEvents()
end

BundleMain.PageView = PageView
