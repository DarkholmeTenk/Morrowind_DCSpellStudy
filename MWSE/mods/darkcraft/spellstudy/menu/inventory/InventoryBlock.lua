local UiFramework = require("darkcraft.dev.ui.UiFramework")
local StudyMenu = require("darkcraft.spellstudy.menu.study.StudyMenu")
local TheoryMenu = require("darkcraft.spellstudy.menu.theory.TheoryMenu")
local CraftMenu = require("darkcraft.spellstudy.menu.craft.CraftMenu")

local xml = [[
    <Block widthProportional="1.0" autoHeight="true" flowDirection="left_to_right" >
        <Button mouseClick="{study}" text="Study" />
        <Button mouseClick="{theory}" text="Theories" />
        <Button mouseClick="{craft}" text="Craft" />
    </Block>
]]

local function study()
    StudyMenu.open()
end

local function theory()
    TheoryMenu.open()
end

local function craft()
    CraftMenu.open()
end

mwse.log("AFK")

return {
    render = function(block)
        UiFramework.setup(xml)
            .withSimpleData {
                study = study,
                theory = theory,
                craft = craft
            }
            .renderIn(block)
    end
}