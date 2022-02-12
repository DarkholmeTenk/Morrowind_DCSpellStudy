local PlayerData = require("darkcraft.spellstudy.data.PlayerData")
local Ensure = require("darkcraft.spellstudy.util.Ensure")
local Context = require("darkcraft.dev.ui.util.Context")

local function getData()
    local data = PlayerData.get()
    Ensure.ensure(data, {
        tagKnowledge = {
            tags = {}
        }
    })
    return data.tagKnowledge
end

local cache = nil
local function getIt()
    if(cache == nil) then
        local d = getData()
        cache = {
            maxAmount = function(self)
                return 100
            end,

            getAmount = function(self, tagId)
                if(d.tags[tagId] == nil) then
                    return 0
                else
                    return d.tags[tagId]
                end
            end,

            set = function(self, tagId, amount)
                d.tags[tagId] = amount
            end,

            reduce = function(self, tagId, amount)
                local existing = self:getAmount(tagId)
                self:set(tagId, math.max(0, existing - amount))
            end,

            add = function(self, tagId, amount)
                local existing = self:getAmount(tagId)
                self:set(tagId, math.min(self:maxAmount(), existing + amount))
            end,

            listKnownTags = function(self)
                local tags = {}
                for tagId, amount in pairs(d.tags) do
                    table.insert(tags, tagId)
                end
                return tags
            end,

            getTags = function(self)
                return d.tags
            end
        }
    end
    return cache
end
local TagKnowledge = {
    get = function()
        return Context.useContext(getIt(), "TagKnowledge")
    end
}
return TagKnowledge