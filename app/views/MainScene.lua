local MainScene = class("MainScene", cc.Node)
local fileUtils = cc.FileUtils:getInstance()

fileUtils:addSearchPath("src/")
fileUtils:addSearchPath("res/")

require "config"
require "myHelper"
require "json.getJsonList"
require "bundleModule"
-- require "FsmMachine"
-- require "baseState"

function MainScene:ctor()
    print("in mainScene ctor")
    
    self:enableNodeEvents()
    if self.onCreate then self:onCreate() end
end

function MainScene:onCreate()
    self.m_bundle = BundleMain.BundleModule:create()
    

end

BundleMain.MainScene = MainScene