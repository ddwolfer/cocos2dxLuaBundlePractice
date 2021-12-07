cc.exports.BaseState = {}
 
function BaseState:New(stateName)
    self.__index = self
    self.onEnterFun     = function() print("@@ default onEnter in baseState")  end
    self.OnUpdateFun    = function() print("@@ default OnUpdate in baseState") end
    self.OnLeaveFun     = function() print("@@ default OnLeave in baseState")  end

    local obj = setmetatable({}, self)
    obj.stateName = stateName
    return obj
end
 
-- 進入狀態
function BaseState:OnEnter()
    self.onEnterFun()
end
 
-- 更新狀態
function BaseState:OnUpdate()
    self.OnUpdateFun()
end
 
-- 離開狀態
function BaseState:OnLeave()
    self.OnLeaveFun()
end