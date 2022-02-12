local TagKnowledge = require("darkcraft.spellstudy.data.TagKnowledge")
local SpellTagDataProvider = require("darkcraft.spellstudy.system.spell.SpellTagDataProvider")

local amountPerHour = 10.0
local spellMult = 0.1

local function addTags(tagData, totalAmount)
    local knowledge = TagKnowledge.get()
    local count = 0
    for _,v in pairs(tagData) do
        count = count + v
    end
    local mult = totalAmount / count
    for tag, tagCount in pairs(tagData) do
        local amount = math.max(1, tagCount * mult)
        knowledge:add(tag, amount)
    end
end

return {


    study = function(tagData, hours)
        local hoursPassed = tes3.advanceTime({
            hours = hours,
            resting = false,
            updateEnvironment = true
        })
        addTags(tagData, hoursPassed * amountPerHour)
    end,

    onSpellCast = function(spell)
        local tags = SpellTagDataProvider.getTags(spell)
        addTags(tags, spellMult)
    end
}