local base = require("darkcraft.dev.ui.renderer.base")
local TheoryData =require("darkcraft.spellstudy.data.TheoryData")
local TheoryLevels = require("darkcraft.spellstudy.system.theory.TheoryLevels")

return {
    TheoryLevelCost = base.xml:extend([[
        <ForEach from="{costs}" value="cost" fullWidth="true" flowRow="true">
            <Label text="{cost}" fullWidth="true"/>
        </ForEach>
    ]], function(attributes, data)
        local level = attributes.level
        local levelData = TheoryLevels.byId[level]
        data.costs = {
            "Paper: " .. tostring(levelData.paperCost),
            "Ink: " .. tostring(levelData.inkCost),
            "Magicka: " .. tostring(levelData.magickaCost),
            "Knowledge: " .. tostring(levelData.knowledgeCost)
        }
    end),
    TagTheories = base.xml:extend([[
        <Block widthProportional="1" autoHeight="true" flowDirection="top_to_bottom">
            <TagKnowledge tagId="{tagId}" />
            <Button text="Craft" mouseClick="{craft}" />
        </Block>
    ]], function(attributes, data)
        local level = attributes.level
        data.craft = function()
            mwse.log("Craft attempt")
            TheoryData.get():craftTheory(attributes.tagId, level)
        end
    end)
}