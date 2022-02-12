local TheoryLevels = require("darkcraft.spellstudy.system.theory.TheoryLevels")

local function forEachSpellSeller(callback)
    for npc in tes3.iterateObjects(tes3.objectType.npc) do
        if(npc.id ~= "player" and npc.name ~= "") then
            if(npc.class.offersSpells or npc.aiConfig.offersSpells) then
                callback(npc)
            end
        end
    end
end

local levels = {
    30,
    60,
    90,
    120
}

local function calculateLevel(spell)
    for i,v in pairs(TheoryLevels.levels) do
        if(spell.magickaCost <= v.spellMagickaMax) then
            return i
        end
    end
    return #TheoryLevels.levels
end

local SellableSpellRegistry = {
    id = "SellableSpells",
    getLearnableSpells = function()
        local spells = {}
        forEachSpellSeller(function(seller)
            for spell in tes3.iterate(seller.spells.iterator) do
                spells[spell.id] = {
                    spell = spell,
                    level = calculateLevel(spell)
                }
            end
        end)
        return spells
    end
}

return SellableSpellRegistry