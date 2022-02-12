local LearnableSpellRegistry = require("darkcraft.spellstudy.system.spell.LearnableSpellRegistry")
local Config = require("darkcraft.spellstudy.config.Config")
local TableHelper = require("darkcraft.dev.util.TableHelper")
local TheoryLevels = require("darkcraft.spellstudy.system.theory.TheoryLevels")
local TheoryData = require("darkcraft.spellstudy.data.TheoryData")
local debug = require("darkcraft.core.debug")

local function getTheoryAmount(spellTags, theories)
    local x = 0
    local y = 0
    local z = 0
    for theory, count in pairs(theories) do
        if(count >= 1 and spellTags[theory] == nil) then
            return nil, false
        end
        x = x + math.min(count, spellTags[theory])
    end
    for i,_ in pairs(spellTags) do
        if(theories[i] ~= nil and theories[i] > 0) then
            y = y + 1
        end
        z = z + 1
    end
    local isAllowed = (y / math.max(z, 1)) > (Config.get().difficulty.requiredTagTypes / 100.0)
    return x, isAllowed
end

local SpellCraft = {
    getLearnableSpells = function(self, level, theories)
        mwse.log("Getting learnable spells - " .. level )
        local levelId = TheoryLevels.idNum[level]
        local allSpells = LearnableSpellRegistry.getAllLearnableSpells()
        local filtered = {}
        for i, v in pairs(allSpells) do
            if(v.level <= levelId) then
                local theoryCount, hasTagTypes = getTheoryAmount(v.tags, theories)
                if(hasTagTypes and theoryCount ~= nil and theoryCount > 0) then
                    local baseChance = theoryCount / v.totalTags
                    local chance = math.min(1, baseChance + (Config.get().difficulty.craftChanceBonus * 0.01))
                    filtered[i] = {
                        data = v,
                        theoryAmount = theoryCount,
                        baseChance = baseChance,
                        chance = chance
                    }
                end
            end
        end
        return filtered
    end,

    learn = function(self, spellData)
        local randomChance = spellData.chance
        return {
            spellId = spellId,
            spell = spellData.data.spell,
            chance = randomChance,
            success = math.random() < randomChance
        }
    end,

    craft = function(self, level, theories)
        local learnable = self:getLearnableSpells(level, theories)
        local flatLearn = TableHelper.flattenKeys(learnable)
        if(#flatLearn == 0) then
            return {
                success = false,
                message = "No spells learnable with these theories and level"
            }
        end
        local spellId = TableHelper.randomPick(flatLearn)
        local learnResult = self:learn(learnable[spellId])
        local usedUp = TheoryData.get():useUp(level, theories, learnResult.success)
        local usedUpMessage = "Used up " .. usedUp .. " theories."
        if(learnResult.success) then
            tes3.addSpell({reference=tes3.player, spell=learnResult.spell})
            return {
                success = true,
                message = "Learned spell [" .. learnResult.spell.name .. "]. " .. usedUpMessage
            }
        else
            return {
                success = false,
                message = "Failed to learn a spell. " .. usedUpMessage
            }
        end
    end
}

return SpellCraft