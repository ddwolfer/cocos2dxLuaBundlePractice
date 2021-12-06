local Page = {}

-- 設置道具圖片與數量
local function setItemData(itemNode, itemData)
	local itemPrice = seekNodeByName(itemNode, "Num")
	local itemSprite = seekNodeByName(itemNode, "Image")
	itemPrice:setString("X"..itemData.Value)
	itemSprite:setSpriteFrame(BundleMain.ItemList[tostring(itemData.ItemId)]["FrameName"])
end

function Page:new(pageViewNode, pageDataTable)
	-- 創新的 Layeout 與 新的頁面，
	local m_csbPath = BundleMain.BundleCsbPath[pageDataTable.BundleType]
    local m_panelLayout = ccui.Layout:create()
	local m_page = cc.CSLoader:createNode(m_csbPath)
	m_page:setPosition(pageViewNode:getContentSize()["width"]/2, pageViewNode:getContentSize()["height"]/2)

	-- 更改金錢
	local m_priceNode = seekNodeByName(m_page, "Price")
	m_priceNode:setString(pageDataTable.Price)
	print ("@@ change price to", pageDataTable.Price)

	--更改道具 & 道具數量
	for i=1,pageDataTable.ItemCount do
		print("@@ set item",i)
		local m_itemNode = seekNodeByName(m_page, "Item"..i)
		setItemData(m_itemNode, pageDataTable.ItemList[i])
	end

	m_panelLayout:addChild(m_page)
	return m_panelLayout
end

return Page