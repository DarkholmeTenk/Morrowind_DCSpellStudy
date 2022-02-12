local UiFramework = require("darkcraft.dev.ui.UiFramework")
local BaseComponents = require("darkcraft.spellstudy.menu.components.RenderGroups")
local StudyRenderGroups = require("darkcraft.spellstudy.menu.study.StudyComponents")
local TagKnowledge = require("darkcraft.spellstudy.data.TagKnowledge")
local Config = require("darkcraft.spellstudy.config.Config")
local debug = require("darkcraft.core.debug")

local StudyXml = [[
    <Menu id="SpellStudy-Study" text="Study Current Spell" dragFrame="true" minWidth="800" minHeight="700" skipMenuMode="true">
        <Block bigRow="true" >
            <SpellStudyComponent spell="{spell}" />
            <KnownTagList />
        </Block>
        <Button mouseClick="{SpellStudy-Study#close}" text="Close" />
    </Menu>
]]

return {
    open = function()
        debug(Config.get())
        local data = UiFramework.wrapData({
            spell = tes3.mobilePlayer.currentSpell
        })
        UiFramework.setup(StudyXml)
            .withRenderGroups({ BaseComponents, StudyRenderGroups })
            .withData(data)
            .renderMenu()
    end
}