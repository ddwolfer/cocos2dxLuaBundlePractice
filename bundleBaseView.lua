local BundleBaseView = class("BundleBaseView", ccui.Layout)
-- 初始化 基本頁面
function BundleBaseView:ctor(bundleData, pagePosistion)
	print ("@@ in BundleBaseView ctor")

	self.m_bundleData = bundleData
	self:enableNodeEvents()
	if self.onCreate then self:onCreate(pagePosistion) end
end
-- 設定位置及Sprite
function BundleBaseView:onCreate(pagePosistion)
	print ("@@ in BundleBaseView onCreate")
	-- 依據type去決定要用哪一個csb檔案
	self.m_bundleCsbPath = BundleMain.BundleCsbPath[self.m_bundleData.BundleType]
	-- 頁面的Sprite
	self.m_page = cc.CSLoader:createNode(tostring(self.m_bundleCsbPath))
	self.m_page:setPosition(pagePosistion["x"], pagePosistion["y"])
	self:addChild(self.m_page)
	-- 購買按鈕的callBack function
	self.m_clickCallBack = function() print("@@ default cllback") end

	if self.seekAllNodes then self:seekAllNodes() end
end
-- 取得金錢節點跟物品節點
function BundleBaseView:seekAllNodes()
	print ("@@ in BundleBaseView seekAllNodes")
	self.m_priceNode = seekNodeByName(self.m_page, "Price")
	self.m_itemListNode = seekNodeByName(self.m_page, "Item")
	self.m_rewardButton = seekNodeByName(seekNodeByName(self.m_page, "GetButton"), "Button")
	self.m_rewardButton:addClickEventListener(self.m_clickCallBack)
end
-- 設定購買按鈕callBack
function BundleBaseView:setBuyCallBack(buyCallBack)
	self.m_clickCallBack = buyCallBack
	self.m_rewardButton:addClickEventListener(self.m_clickCallBack)
end

return BundleBaseView
