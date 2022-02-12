local TagRegistry = require("darkcraft.spellstudy.system.tags.MagicTagRegistry")
local EffectTagRegistry = require("darkcraft.spellstudy.system.effect.EffectTagRegistry")
local LearnableSpellRegistry = require("darkcraft.spellstudy.system.spell.LearnableSpellRegistry")

local inited = false
local init = function()
    if(not inited) then
        mwse.log("SpellStudy - Initing registries")
        inited = true
        TagRegistry:init()
        EffectTagRegistry:init()
        LearnableSpellRegistry:init()
    end
end

local Registries = {
    init = init
}

return Registries