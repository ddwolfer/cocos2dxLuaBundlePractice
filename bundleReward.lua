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

	self.m_rewardCsbPath = "AnimationNode/UI_GetReward2.csb"
	self.m_rewardSprite	 = cc.CSLoader:createNode(self.m_rewardCsbPath)
	self.m_rewardAction	 = cc.CSLoader:createTimeline(self.m_rewardCsbPath)

	self.m_rewardSprite:setVisible(false)
	self.m_rewardSprite:runAction(self.m_rewardAction)
	self.m_uiRoot:addChild(self.m_rewardSprite)
end

function BundleReward:playTitle(itemList)
	self.m_rewardAction:clearLastFrameCallFunc()
	self.m_rewardSprite:setVisible(true)
	
	self.m_rewardAction:play("Title", false)
	self.m_rewardAction:setLastFrameCallFunc(function() self:playGetItem(itemList) end)
end 

function BundleReward:playGetItem(itemList)
	self.m_rewardAction:clearLastFrameCallFunc()
	print ("@@ itemCount:", #itemList)

	if (#itemList == 1) then
		self.m_rewardAction:play("Get1", false)
	elseif(#itemList == 2) then
		self.m_rewardAction:play("Get2", false)
	elseif(#itemList == 3) then
		self.m_rewardAction:play("Get3", false)
	elseif(#itemList == 4) then
		self.m_rewardAction:play("Get4", false)
	elseif(#itemList == 5) then
		self.m_rewardAction:play("Get5", false)
	else
		self.m_rewardAction:play("Get10up", false)
	end

	dump (itemList, "@@ item content:")
	self.m_rewardAction:setLastFrameCallFunc(function() self.m_rewardSprite:setVisible(false) end)
end


-- cc.Sequence:create(不用nil)
-- cc.CallFunc:create(hander, value)
-- hander : 执行的回调函数
-- value  : 传递给回调函数的可选参数，必须为一个table
BundleMain.BundleReward = BundleReward