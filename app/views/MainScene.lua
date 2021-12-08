local MainScene = class("MainScene", cc.Node)
local fileUtils = cc.FileUtils:getInstance()

fileUtils:addSearchPath("src/")
fileUtils:addSearchPath("res/")

require "config"
require "myHelper"
require "Define.lua"
-- require "json.getJsonList"
require "bundleModule"

function MainScene:ctor()
    print("in mainScene ctor")
    
    self:enableNodeEvents()
    if self.onCreate then self:onCreate() end
end

function MainScene:onCreate()
    -- 獲取所有道具列表
    local itemListJsonStr = fileUtils:getStringFromFile("json/ItemList.json")
    BundleMain.ItemList = json.decode(itemListJsonStr)

    -- 禮包
    self.m_bundle = BundleMain.BundleModule:create(self)

    -- 可以打開禮包的按鈕
    self.m_openBundleButton = cc.CSLoader:createNode("AnimationNode/Button_Bundle.csb")
    self.m_openBundleButton:setPosition(CC_DESIGN_RESOLUTION.width/2, CC_DESIGN_RESOLUTION.height/2)
    self.m_openButtonNode = seekNodeByName(self.m_openBundleButton, "Button")
    self.m_openButtonNode:addClickEventListener( function() self.m_bundle:show() end)  -- 切換至show狀態
    self.m_openButtonNode:setTitleText("打開禮包")
    self:addChild(self.m_openBundleButton, -1)
    
end

BundleMain.MainScene = MainScene