local base = require("darkcraft.dev.ui.renderer.base")
local TheoryLevels = require("darkcraft.spellstudy.system.theory.TheoryLevels")

return {
    LevelChooserButton = base.xml:extend([[
        <Button text="{name}" mouseClick="{mouseClick}" />
    ]], function(attributes, data)
        data.mouseClick = attributes.level.mouseClick
        local name = attributes.level.name
        if(attributes.selected == name) then
            data.name = "*" .. name
        else
            data.name = name
        end
    end),
    LevelChooser = base.xml:extend([[
        <Block autoWidth="true" autoHeight="true" flowDirection="top_to_bottom">
            <Label text="{selectedLabel}" />
            <ForEach from="{levels}" value="levelD" flowDirection="left_to_right" >
                <LevelChooserButton level="{levelD}" selected="{level}" />
            </ForEach>
        </Block>
    ]], function(attributes, data)
        local levels = {}
        data.selectedLabel = "Current: " .. TheoryLevels.byId[attributes.level].name
        for _,v in pairs(TheoryLevels.levels) do
            table.insert(levels, {
                name = v.name,
                mouseClick = function()
                    mwse.log("Setting level " .. v.id)
                    attributes.setLevel(v.id)
                end
            })
        end
        data.levels = levels
    end)
}