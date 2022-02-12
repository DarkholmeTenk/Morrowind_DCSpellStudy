local PlayerData = require("darkcraft.spellstudy.data.PlayerData")
local TheoryLevels = require("darkcraft.spellstudy.system.theory.TheoryLevels")
local TagKnowledge = require("darkcraft.spellstudy.data.TagKnowledge")
local Ensure = require("darkcraft.spellstudy.util.Ensure")
local Config = require("darkcraft.spellstudy.config.Config")
local Context = require("darkcraft.dev.ui.util.Context")
local debug = require("darkcraft.core.debug")

local function getData()
    local data = PlayerData.get()
    Ensure.ensure(data, {
        theoryData = {
            blankPaper = 0,
            inkAmount = 0,
            theories = {

            }
        }
    })
    return data.theoryData
end

local cache = nil
local function getThing()
    if(cache == nil) then
        local tagKnowledge = TagKnowledge.get()
        local d = getData()
        cache = {
            addPaper = function(self, amount)
                d.blankPaper = d.blankPaper + amount
            end,

            removePaper = function(self, amount)
                if(d.blankPaper > amount) then
                    d.blankPaper = d.blankPaper - amount
                    return true
                end
                return false
            end,

            getPaper = function(self)
                return d.blankPaper
            end,

            addInk = function(self, amount)
                d.inkAmount = math.min(d.inkAmount + amount, 100)
            end,

            removeInk = function(self, amount)
                d.inkAmount = math.max(d.inkAmount - amount, 0)
            end,

            getInk = function(self)
                return d.inkAmount
            end,

            getTheoriesAtLevel = function(self, level)
                local count = {}
                for tagId, levels in pairs(d.theories) do
                    if(levels[level] ~= nil and levels[level] > 0) then
                        count[tagId] = levels[level]
                    end
                end
                return count
            end,

            getTheories = function(self, tagId)
                if(d.theories[tagId] == nil) then
                    d.theories[tagId] = {}
                end
                local theories = d.theories[tagId]
                for _,v in pairs(TheoryLevels.levels) do
                    if(theories[v.id] == nil) then
                        theories[v.id] = 0
                    end
                end
                return theories
            end,

            getAllTheories = function(self)
                local result = {}
                for tagId, values in pairs(d.theories) do
                    local hasTheories = false
                    local tagResult = {}
                    for _, levelId in pairs(TheoryLevels.ids) do
                        table.insert(tagResult, values[levelId] or 0)
                        if(values[levelId] > 0) then hasTheories = true end
                    end
                    if(hasTheories) then
                        result[tagId] = tagResult
                    end
                end
                return result
            end,

            getTheoryAmount = function(self, tagId, levelId)
                return self:getTheories(tagId)[levelId]
            end,

            couldCraft = function(self, levelId)
                local levelData = TheoryLevels.byId[levelId]
                local errors = {}
                if(d.blankPaper < levelData.paperCost) then
                    table.insert(errors, "Not enough paper.")
                end
                if(d.inkAmount < levelData.inkCost) then
                    table.insert(errors, "Not enough ink.")
                end
                if(tes3.mobilePlayer.magicka.current < levelData.magickaCost) then
                    table.insert(errors, "Not enough Magicka.")
                end

                if(#errors == 0) then
                    return true, {}
                else
                    return false, errors
                end
            end,

            canCraft = function(self, tagId, levelId)
                local could, errors = self:couldCraft(levelId)
                local levelData = TheoryLevels.byId[levelId]
                if(tagKnowledge:getAmount(tagId) < levelData.knowledgeCost) then
                    table.insert(errors, "Not enough tag knowledge.")
                end

                if(#errors == 0) then
                    return true, ""
                else
                    return false, errors
                end
            end,

            craftTheory = function(self, tagId, levelId)
                local levelData = TheoryLevels.byId[levelId]
                if(self:canCraft(tagId, levelId)) then
                    self:removePaper(levelData.paperCost)
                    self:removeInk(levelData.inkCost)
                    tes3.modStatistic({reference = tes3.mobilePlayer, name = "magicka", current = -levelData.magickaCost})
                    tagKnowledge:reduce(tagId, levelData.knowledgeCost)
                    local theories = self:getTheories(tagId)
                    theories[levelId] = theories[levelId] + 1
                    if(not self:canCraft(tagId, levelId)) then
                        return true
                    end
                end
                return false
            end,

            useUp = function(self, level, theories, successfulCraft)
                local usedUp = 0
                local chance = 0
                debug(Config.get(), "CONFIG")
                if(successfulCraft) then
                    chance = Config.get().difficulty.theoryLossOnSuccessChance
                else
                    chance = Config.get().difficulty.theoryLossOnFailureChance
                end
                mwse.log("Using theories - " .. tostring(successfulCraft) .. " - " .. tostring(chance))
                for theoryId, count in pairs(theories) do
                    local theoryBlock = self:getTheories(theoryId)
                    local use = 0
                    for x=1,count do
                        if(math.random(0, 100) < chance) then
                            use = use + 1
                        end
                    end
                    theoryBlock[level] = math.max(theoryBlock[level] - use, 0)
                    usedUp = usedUp + use
                end
                return usedUp
            end
        }
    end
    return cache
end

local TheoryData = {
    get = function()
        return Context.useContext(getThing(), "TheoryData")
    end
}
return TheoryData