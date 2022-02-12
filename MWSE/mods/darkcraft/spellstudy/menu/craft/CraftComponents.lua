local base = require("darkcraft.dev.ui.renderer.base")
local TheoryLevels = require("darkcraft.spellstudy.system.theory.TheoryLevels")
local SpellCraft = require("darkcraft.spellstudy.system.spell.SpellCraft")
local TheoryData = require("darkcraft.spellstudy.data.TheoryData")
local Context = require("darkcraft.dev.ui.util.Context")
local debug = require("darkcraft.core.debug")

return {
    TheoryChooser = base.xml:extend([[
        <Block widthProportional="1" autoHeight="true" flowDirection="top_to_bottom">
            <TagLabel tag="{tagId}" />
            <Block widthProportional="1" autoHeight="true" flowDirection="left_to_right>
                <Slider widthProportional="1" jump="{jump}" max="{max}" PartScrollBar_changed="{onChange}" />
                <Label text="{label}" />
            </Block>
        </Block>
    ]], function(attributes,data)
        local theory = attributes.theory
        data.tagId = theory.id
        data.value = theory.current
        data.max = theory.max
        data.jump = math.min(theory.max, 4)
        local onChange = theory.set
        data.onChange = function(a, e, q, v)
            local newValue = a.widget.current
            mwse.log("Changing")
            onChange(newValue)
            mwse.log("Changed " .. newValue)
            e.source:forwardEvent(e)
        end
        data.label = tostring(theory.current) .. " / " .. tostring(theory.max)
    end),
    TheoryListChooser = base.xml:extend([[
        <VerticalScrollPane widthProportional="1" heightProportional="1">
            <ForEach from="{theories}" value="theoryInfo" widthProportional="1" heightProportional="1" flowDirection="top_to_bottom">
                <TheoryChooser theory="{theoryInfo}" />
            </ForEach>
        </VerticalScrollPane>
    ]], function(attributes, data)
        local updateChosen = attributes.updateChosen
        Context.useContextValue(data, TheoryData.get(), "theories", function(theoryData)
            local theories = theoryData:getTheoriesAtLevel(attributes.level)
            local theoryInfos = {}
            for tagId, max in pairs(theories) do
                local current = attributes.chosen[tagId] or 0
                local set = function(v) updateChosen(tagId, v) end
                table.insert(theoryInfos, {
                    id = tagId,
                    max = max,
                    current = current,
                    set = set
                })
            end
            return theoryInfos
        end)
    end),
    CraftingBlock = base.xml:extend([[
        <Block widthProportional="1" heightProportional="1" flowDirection="top_to_bottom">
            <Label text="{numSpellsLabel}" />
            <Label text="{craftLabel}" />
            <VerticalScrollPane heightProportional="1" widthProportional="1">
                <Label text="Logs:" />
                <ForEach from="{logs}" value="logLine" heightProportional="1" widthProportional="1" flowDirection="top_to_bottom">
                    <Label text="{logLine}" />
                </ForEach>
            </VerticalScrollPane>
            <Button mouseClick="{craft}" text="Craft" />
        </Block>
    ]], function(attributes, data)
        local chosen = attributes.chosen
        local level = attributes.level
        local preCraftInfo = SpellCraft:getLearnableSpells(level, chosen)
        local num = 0
        local chance = 0
        for _,v in pairs(preCraftInfo) do
            num = num + 1
            chance = chance + v.chance
        end
        chance = chance / math.max(1,num)

        data.numSpellsLabel = "Craftable spells: " .. tostring(num)
        data.craftLabel = "Success chance: " .. tostring(math.floor(chance * 1000) / 10)
        data.logs = data.logs or {}
        data.craft = function()
            mwse.log("Attempting to craft")
            local result = SpellCraft:craft(level, chosen)
            local message = result.message
            table.insert(data.logs, message)
            mwse.log("Messages " .. message)
            debug(data.logs, "Logs")
            data.logs = data.logs
        end
    end)
}