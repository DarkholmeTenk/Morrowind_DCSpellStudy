local Merge = require("darkcraft.dev.util.Merge")
local base = require("darkcraft.dev.ui.renderer.base")
local Context = require("darkcraft.dev.ui.util.Context")
local TheoryData = require("darkcraft.spellstudy.data.TheoryData")
local TheoryLevelParts = require("darkcraft.spellstudy.menu.theory.TheoryLevelParts")
local TheoryTagParts = require("darkcraft.spellstudy.menu.theory.TheoryTagParts")
local TheoryDebugParts = require("darkcraft.spellstudy.menu.theory.TheoryDebugParts")
local TheoryLevels = require("darkcraft.spellstudy.system.theory.TheoryLevels")

return Merge.merge({
    TheoryLevelParts,
    TheoryTagParts,
    TheoryDebugParts,
    {
        TheoryField = base.xml:extend([[
            <Block autoRow="true">
                <Label minWidth="100" text="{fieldName}" />
                <Label text="{value}" />
            </Block>
        ]], function(attributes, data)
            data.fieldName = attributes.fieldName
            data.value = attributes.value
        end),
        InkPaper = base.xml:extend([[
            <Block autoColumn="true">
                <TheoryField fieldName="Paper" value="{paper}" />
                <TheoryField fieldName="Ink" value="{ink}" />
            </Block>
        ]], function(attributes, data)
            Context.useContextValues(data, TheoryData.get(), "InkPaper", function(t)
                return {
                    paper = t:getPaper(),
                    ink = t:getInk()
                }
            end)
        end),
        KnownTheory = base.xml:extend([[
            <Block autoColumn="true">
                <TagLabel tag="{tag}" />
                <ForEach autoRow="true" from="{amounts}" value="amount">
                    <Label minWidth="85" maxWidth="85" text="{amount}" />
                </ForEach>
            </Block>
        ]]),
        KnownTheoryList = base.xml:extend([[
            <Block bigColumn="true">
                <Label text="Crafted Theories:" />
                <VerticalScrollPane full="true">
                    <ForEach from="{levels}" value="label" autoRow="true">
                        <Label text="{label}" minWidth="85" maxWidth="85"/>
                    </ForEach>
                    <ForEach from="{tags}" key="tag" value="amounts" flowColumn="true">
                        <KnownTheory tag="{tag}" amounts="{amounts}" />
                    </ForEach>
                </VerticalScrollPane>
            </Block>
        ]], function(attributes, data)
            data.levels = TheoryLevels.names
            Context.useContextValue(data, TheoryData.get(), "tags", function(theoryData)
                return theoryData:getAllTheories()
            end)
        end)
    }
})