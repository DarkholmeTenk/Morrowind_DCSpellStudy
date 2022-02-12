local EffectMap = require("tes3.effect")

local function validateTag(v)
    if(v.effectId == nil) then return false end
    local effectId = v.effectId
    if(type(effectId) == "string") then
        if(EffectMap[effectId] ~= nil) then
            v.effectId = EffectMap[effectId]
        else
            mwse.log("No effect found for " .. effectId)
            return false
        end
    end
    return true
end

return {
    register = function(file, registry)
        local data = json.loadfile(file)
        if(data == nil or #data == 0) then
            mwse.log("Error loading json file - " .. file)
        end
        if(data ~= nil and type(data) == "table") then
            for _,v in pairs(data) do
                if(validateTag(v)) then
                    local effectId = v.effectId
                    for _,tagId in pairs(v.tags) do
                        registry:registerEffectTag(effectId, tagId)
                    end
                end
            end
        end
    end
}