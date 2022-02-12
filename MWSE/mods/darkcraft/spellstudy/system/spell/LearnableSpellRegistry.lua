local SpellTagDataProvider = require("darkcraft.spellstudy.system.spell.SpellTagDataProvider")

local Loaders = {}

local SpellCache = nil
local LearnableSpellRegistry = {}
LearnableSpellRegistry = {
    init = function()
        mwse.log("Triggering learnable spell registry")
        event.trigger("SpellStudy-Register-LearnableSpells", LearnableSpellRegistry)
    end,

    registerLoader = function(loader)
        mwse.log("Registering spell loader - " .. loader.id)
        Loaders[loader.id] = loader
    end,

    getAllLearnableSpells = function()
        if(SpellCache == nil) then
            local spells = {}
            for _,loader in pairs(Loaders) do
                mwse.log("Loading spells from " .. loader.id)
                local loaderSpells = loader.getLearnableSpells()
                for i,v in pairs(loaderSpells) do
                    spells[i] = v
                    v.tags = SpellTagDataProvider.getTags(v.spell)
                    local totalCount = 0
                    for _, count in pairs(v.tags) do
                        totalCount = totalCount + count
                    end
                    v.totalTags = totalCount
                end
            end
            SpellCache = spells
        end
        local result = {}
        for spellId,value in pairs(SpellCache) do
            if(not tes3.player.object.spells:contains(spellId)) then
                result[spellId] = value
            end
        end
        return result
    end
}
return LearnableSpellRegistry