cc.exports.BaseState = {}
 
function BaseState:New(stateName)
    self.__index = self
    local obj = setmetatable({}, self)
    obj.stateName = stateName
    return obj
end
 
-- 進入狀態
function BaseState:OnEnter()
    print("@@ default onEnter in baseState")
end
 
-- 更新狀態
function BaseState:OnUpdate()
    print("@@ default OnUpdate in baseState")
end
 
-- 離開狀態
function BaseState:OnLeave()
    print("@@ default OnLeave in baseState")
end