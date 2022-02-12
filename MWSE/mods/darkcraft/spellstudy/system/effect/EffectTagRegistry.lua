local TagRegistry = require("darkcraft.spellstudy.system.tags.MagicTagRegistry")
local effectTags = {}

return {
    init = function(self)
        event.trigger("SpellStudy-Register-EffectTag", self)
    end,

    getTags = function(effectId)
        if(effectTags[effectId] == nil) then
            local effect = tes3.getMagicEffect(effectId)
            if(effect ~= nil) then
                effectTags[effectId] = {
                    schoolTag = TagRegistry.getSchoolTag(effect.school),
                    extraTags = {}
                }
            end
        end
        return effectTags[effectId]
    end,

    registerEffectTag = function(self, effectId, tagId)
        local tags = self.getTags(effectId)
        if(tags ~= nil) then
            tags.extraTags[tagId] = true
        end
    end
}