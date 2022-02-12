local Config = require("darkcraft.spellstudy.config.Config")

local levels = Config.get().levels

local byId = {}
local ids = {}
local idNum = {}
local names = {}
for i,v in pairs(levels) do
    byId[v.id] = v
    table.insert(ids, v.id)
    idNum[v.id] = i
    table.insert(names, v.name)
end

return {
    levels = levels,
    byId = byId,
    ids = ids,
    idNum = idNum,
    names = names
}