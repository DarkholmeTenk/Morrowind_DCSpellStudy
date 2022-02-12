local UiFramework = require("darkcraft.dev.ui.UiFramework")
local BaseComponents = require("darkcraft.spellstudy.menu.components.RenderGroups")
local CraftRenderGroups = require("darkcraft.spellstudy.menu.craft.CraftComponents")
local TheoryData = require("darkcraft.spellstudy.data.TheoryData")

local CraftXml = [[
    <Menu id="SpellStudy-Craft" text="Craft Spells" dragFrame="true" minWidth="1100" minHeight="600" skipMenuMode="true" autoWidth="false" autoHeight="false">
        <LevelChooser level="{level}" setLevel="{setLevel}" />
        <Block widthProportional="1" heightProportional="1" flowDirection="left_to_right">
            <TheoryListChooser theoryData="{theoryData}" level="{level}" chosen="{chosen}" updateChosen="{updateChosen}" />
            <CraftingBlock chosen="{chosen}" level="{level}" />
        </Block>
        <Button mouseClick="{SpellStudy-Craft#close}" text="Close" />
    </Menu>
]]

return {
    open = function()
        local tdata = TheoryData.get()
        local data = UiFramework.wrapData({
            level = "novice",
            chosen = {},
            theoryData = tdata
        })
        data.setLevel = function(l)
            data.level = l
            data.chosen = {}
        end
        data.updateChosen = function(t, v)
            mwse.log("Updating " .. t .. " to " .. v)
            if(v > 0) then
                data.chosen[t] = v
            else
                data.chosen[t] = nil
            end
            data.chosen = data.chosen
        end
        data.fixChosen = function()
            for tagId, count in pairs(data.chosen) do
                local max = tdata:getTheoryAmount(tagId, data.level)
                if(count > max) then
                    data.chosen[tagId] = max
                end
            end
        end

        UiFramework.setup(CraftXml)
            .withRenderGroups({ BaseComponents, CraftRenderGroups })
            .withData(data)
            .renderMenu()
    end
}