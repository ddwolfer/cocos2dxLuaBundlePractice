cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")
BundleMain = {} 
require "config"
require "cocos.init"
require "app.views.MainScene"

local function main()
    print("[myinfo] main start")
    local startScene = cc.Scene:create()
    local director = cc.Director:getInstance()
    
    director:setDisplayStats(true)
    director:runWithScene(startScene)
    startScene:addChild(BundleMain.MainScene:create())

end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
