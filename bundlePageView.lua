local PageView = class("MainScene", cc.Node) 
local NewPage = {}

require "config"
require "myHelper"
NewPage[BundleMain.BundleType.BUNDLE_NORMAL] 	= require "bundlePageTypeNormal"
NewPage[BundleMain.BundleType.BUNDLE_DAILY] 	= require "bundlePageTypeNormal"
NewPage[BundleMain.BundleType.BUNDLE_BIG] 		= require "bundlePageTypeNormal"

function PageView:ctor()
	print("@@ in pageview ctor")
end
-- 設置道具圖片與數量
local function setItemData(itemNode, itemData)
	local itemPrice = seekNodeByName(itemNode, "Num")
	local itemSprite = seekNodeByName(itemNode, "Image")
	itemPrice:setString("X"..itemData.Value)
	itemSprite:setSpriteFrame(BundleMain.ItemList[tostring(itemData.ItemId)]["FrameName"])
end
-- 新增Page進PageView
function PageView:addPage(pageViewNode, pageTable)
	-- 依據 json 內設定好的禮包 type 決定要選擇哪個csb生成
	print ("@@ BundleMain.BundleType.BUNDLE_NORMAL :", BundleMain.BundleType.BUNDLE_NORMAL)
	print ("@@ pageTable.BundleType :", pageTable.BundleType)
	local panelLayout = NewPage[pageTable.BundleType]:new(pageViewNode, pageTable)
	-- if (pageTable.BundleType == BundleMain.BundleType.BUNDLE_NORMAL) then 		-- 普通禮包
	-- 	panelLayout = NewPage[pageTable.BundleType]:new(pageViewNode, pageTable)
	-- elseif (pageTable.BundleType == BundleMain.BundleType.BUNDLE_DAILY) then	-- 每日禮包
	-- 	panelLayout = NewPage[pageTable.BundleType]:new(pageViewNode, pageTable)
	-- elseif (pageTable.BundleType == BundleMain.BundleType.BUNDLE_BIG) then     -- 豪華大禮包
	-- 	panelLayout = NewPage[pageTable.BundleType]:new(pageViewNode, pageTable)
	-- end
	-- 加進 PageView 節點
	pageViewNode:addPage(panelLayout)


	-- -- 依據道具數量決定要用哪個csb
	-- local m_csbPath = "AnimationNode/Bundle"
	-- -- 
	-- if (pageTable.ItemCount == 3) then
	-- 	m_csbPath = m_csbPath.."1.csb"
	-- elseif (pageTable.ItemCount == 4) then
	-- 	m_csbPath = m_csbPath.."2.csb"
	-- elseif (pageTable.ItemCount == 6) then
	-- 	m_csbPath = m_csbPath.."3.csb"
	-- end
	-- print("@@ Path:", m_csbPath, "pageTable.ItemCount:",pageTable.ItemCount)
	-- -- 創新的 Layeout 與 新的頁面，
 --    local panelLayout = ccui.Layout:create()
	-- local page = cc.CSLoader:createNode(m_csbPath)
	-- page:setPosition(pageViewNode:getContentSize()["width"]/2, pageViewNode:getContentSize()["height"]/2)
	
	-- -- 更改金錢
	-- local priceNode = seekNodeByName(page, "Price")
	-- priceNode:setString(pageTable.Price)
	-- print ("@@ change price to", pageTable.Price)

	-- --更改道具 & 道具數量
	-- for i=1,pageTable.ItemCount do
	-- 	print("@@ set item",i)
	-- 	local itemNode = seekNodeByName(page, "Item"..i)
	-- 	setItemData(itemNode, pageTable.ItemList[i])
	-- end

	-- -- 加進 PageView 節點
	-- panelLayout:addChild(page)
	-- pageViewNode:addPage(panelLayout)
end
-- 新增(更新)新的PageView
function PageView:newPageView(pageViewNode, bundleList)
	-- 刪除舊有pageview畫面 / 如果新增頁面時沒用 addPage 而用 addChild 的話，removeAll不會報錯，但是會有意外發生
	pageViewNode:removeAllPages()
	-- 去 list 看有幾頁要加
	for idx, pageTable in pairs(bundleList) do
		print("@@ create new panel", idx)
		print("@@ itemCOunt:",pageTable.ItemCount)
        self:addPage(pageViewNode, pageTable)
	end
	-- 生成完pageview後從第一頁(0)開始
	pageViewNode:setCurrentPageIndex(0)
end

BundleMain.PageView = PageView