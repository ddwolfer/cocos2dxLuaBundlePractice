function cc.exports.seekNodeByName(node, name)
    local found = node:getChildByName(name)
    if found ~= nil then
        return found
    end
    local children = node:getChildren()
    for _, child in pairs(children) do
        found = seekNodeByName(child, name)
        if found ~=nil then
        return found
        end
    end
    return nil
end