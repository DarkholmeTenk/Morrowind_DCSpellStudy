local base = require("darkcraft.dev.ui.renderer.base")
local TheoryLevels = require("darkcraft.spellstudy.system.theory.TheoryLevels")
local Context = require("darkcraft.dev.ui.util.Context")
local TheoryData = require("darkcraft.spellstudy.data.TheoryData")
local TagKnowledge = require("darkcraft.spellstudy.data.TagKnowledge")
local debug = require("darkcraft.core.debug")

local function getCraftableTags(knowledge, level)
    local lData = TheoryLevels.byId[level]
    local tags = knowledge:getTags()
    local craftableTags = {}
    for tagId, amount in pairs(tags) do
        if(amount > lData.knowledgeCost) then
            table.insert(craftableTags, tagId)
        end
    end
    return craftableTags
end

return {
    CraftableTags = base.xml:extend([[
        <VerticalScrollPane widthProportional="1" heightProportional="1">
            <Label text="Cannot craft theories of this level" visible="{isError}" />
            <ForEach from="{errors}" value="error" flowDirection="top_to_bottom">
                <Label text="{error}" />
            </ForEach>
            <ForEach visible="{could}" from="{tags}" value="tagId" widthProportional="1" heightProportional="1" flowDirection="top_to_bottom">
                <TagTheories level="{level}" tagId="{tagId}"/>
            </ForEach>
        </VerticalScrollPane>
    ]], function(attributes, data)
        local level = attributes.level
        local could = false
        local errors = { }
        Context.useContextValues(data, TheoryData.get(), "CouldCraft", function(t)
            could, errors = t:couldCraft(level)
            debug(errors, "Errors")
            return {
                could = could,
                isError = not could,
                errors = errors
            }
        end)
        Context.useContextValues(data, TagKnowledge.get(), "Craftable", function(t)
            return {tags = getCraftableTags(t, level)}
        end)

    end),
    TheoryWritingBlock = base.xml:extend([[
        <Block width="500" fullHeight="true" flowColumn="true">
            <LevelChooser level="{level}" setLevel="{setLevel}" />
            <TheoryLevelCost level="{level}" />
            <CraftableTags level="{level}" />
        </Block>
    ]], function(attributes, data)
        data.level = data.level or "novice"
        data.setLevel = function(x) data.level = x end
    end)
}