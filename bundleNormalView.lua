local BundleBaseView = require "bundleBaseView"

local BundleNormalView = class("BundleNormalView", BundleBaseView)
-- 設定金額
function BundleNormalView:setBundlePrice(...)
	if (#{...} == 1) then
		local inputPrice = {...}
		self.m_bundleData.Price = inputPrice[1]
	end
	self.m_priceNode:setString(self.m_bundleData.Price)
end
-- 設定物品圖片跟數量
function BundleNormalView:setItemData(...)
	if (#{...} == 1) then
		local inputItemData = {...}
		self.m_bundleData = inputItemData[1]
	end
	for idx=1,self.m_bundleData.ItemCount do
		local itemNode = seekNodeByName(self.m_itemListNode, "Item"..idx)
		local itemPrice = seekNodeByName(itemNode, "Num")
		local itemSprite = seekNodeByName(itemNode, "Image")
		itemPrice:setString("X"..self.m_bundleData.ItemList[idx].Value)
		itemSprite:setSpriteFrame(
			BundleMain.ItemList[tostring(self.m_bundleData.ItemList[idx].ItemId)]["FrameName"]
			)
	end
end


return BundleNormalView