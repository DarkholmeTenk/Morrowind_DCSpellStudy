local EffectTagRegistry = require("darkcraft.spellstudy.system.effect.EffectTagRegistry")

local function addTag(tags, tagId, num)
    if(tagId == nil) then return end
    if(tags[tagId] == nil) then
        tags[tagId] = num
    else
        tags[tagId] = tags[tagId] + num
    end
end

return {
    getTags = function(spell)
        local tags = {}
        for _,v in pairs(spell.effects) do
            if(v ~= nil and v.id ~= -1) then
                local tagData = EffectTagRegistry.getTags(v.id)
                if(tagData ~= nil) then
                    addTag(tags, tagData.schoolTag, 1)
                    for t, _ in pairs(tagData.extraTags) do
                        addTag(tags, t, 1)
                    end
                end
            end
        end
        return tags
    end,

    getLevel = function(spell)

    end
}