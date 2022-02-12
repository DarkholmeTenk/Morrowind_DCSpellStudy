local TagParts = require("darkcraft.spellstudy.menu.components.TagParts")
local DataProviders = require("darkcraft.spellstudy.menu.components.DataProviders")
local TheoryLevelComponents = require("darkcraft.spellstudy.menu.components.TheoryLevelComponents")
local Merge = require("darkcraft.dev.util.Merge")

return Merge.merge({
    TagParts,
    DataProviders,
    TheoryLevelComponents
})
