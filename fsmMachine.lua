cc.exports.FsmMachine = {}
 
function FsmMachine:New()
    self.__index = self
    local obj = setmetatable({}, self)
    obj.states = {}
    obj.curState = nil
    return obj
end
 
-- 新增狀態
function FsmMachine:AddState(baseState)
    self.states[baseState.stateName] = baseState
end
 
-- 初始化預設狀態
function FsmMachine:AddInitState(baseState)
    self.curState = baseState
end
 
-- 更新當前狀態
function FsmMachine:Update()
    self.curState:OnUpdate()
end
 
-- 切換狀態
function FsmMachine:Switch(stateName)
    print("@@ State switch to", stateName)
    if self.curState.stateName ~= stateName then
        self.curState:OnLeave()
        self.curState = self.states[stateName]
        self.curState:OnEnter()
    end
end