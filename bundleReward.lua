local BundleReward = class("BundleReward", cc.Node)

require "config"
require "myHelper"

function BundleReward:ctor(uiRoot)
	print("@@in bundle reward ctor")

	self.m_uiRoot = uiRoot
	self:enableNodeEvents()
	if self.onCreate then self:onCreate() end
end

function BundleReward:onCreate()
	print ("@@ in undle reward onCreate")
	-- 載入動畫sprite
	self.m_rewardCsbPath = "AnimationNode/UI_GetReward2.csb"
	self.m_rewardSprite	 = cc.CSLoader:createNode(self.m_rewardCsbPath)
	self.m_rewardAction	 = cc.CSLoader:createTimeline(self.m_rewardCsbPath)

	self.m_rewardSprite:setVisible(false)
	self.m_rewardSprite:runAction(self.m_rewardAction)
	self.m_uiRoot:addChild(self.m_rewardSprite)
	
	if self.seekAllNodes then self:seekAllNodes() end
end
-- 獲取該class 需要的節點
function BundleReward:seekAllNodes()
	print ("@@ in BundleReward seekAllNodes")
	-- 獎勵 UI 層節點
	self.m_uiLayout = seekNodeByName(self.m_rewardSprite, "UI")
	self.m_uiLayout:setTouchEnabled(false)
	self.m_uiLayout:addClickEventListener( -- 動畫顯示完後 點擊任意處離開
		function() 
			self.m_uiLayout:setTouchEnabled(false) 
			self.m_rewardSprite:setVisible(false)
		end)
	-- 十個道具的節點
	self.m_itemNodes = {}
	for idx = 1, 10 do
		local itemNode 		= seekNodeByName(self.m_rewardSprite, "Reward_"..tostring(idx))
		local itemSprite 	= seekNodeByName(itemNode, "Item")
		local itemValue 	= seekNodeByName(itemNode, "Value")
		print("@@ get items node in reward", itemNode, itemSprite, itemValue)

		table.insert(self.m_itemNodes, {Sprite = itemSprite, Value = itemValue, Node = itemNode})
	end
end
-- 執行title動畫
function BundleReward:playTitle(itemList)
	self.m_rewardAction:clearLastFrameCallFunc()
	self.m_rewardSprite:setVisible(true)
	
	self.m_rewardAction:play("Title", false)
	self.m_rewardAction:setLastFrameCallFunc(function() self:playGetItem(itemList) end)
end 
-- 執行獲取道具動畫
function BundleReward:playGetItem(itemList)
	self.m_rewardAction:clearLastFrameCallFunc()
	print ("@@ itemCount:", #itemList)
	dump (itemList, "@@ item list in play get item:")
	-- 設置道具圖片以及數量
	for idx = 1,#itemList do
		self.m_itemNodes[idx].Value:setString(itemList[idx].Value)
		self.m_itemNodes[idx].Sprite:setSpriteFrame(BundleMain.ItemList[tostring(itemList[idx].ItemId)]["FrameName"])
	end

	-- 顯示道具1~5 都有各自對應的美術動畫
	if (#itemList <= 5) then
		self.m_rewardAction:play("Get"..tostring(#itemList), false)
	else
		-- 依據道具數量將item 6~10 隱形或顯示
		for idx = 6, 10 do
			local isVisible = idx <= #itemList and true or false
			self.m_itemNodes[idx].Node:setVisible(isVisible)
		end
		self.m_rewardAction:play("Get10up", false)
	end

	dump (itemList, "@@ item content:")
	self.m_rewardAction:setLastFrameCallFunc(function() self.m_uiLayout:setTouchEnabled(true) end)
end

BundleMain.BundleReward = BundleReward