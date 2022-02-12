local UiFramework = require("darkcraft.dev.ui.UiFramework")
local BaseComponents = require("darkcraft.spellstudy.menu.components.RenderGroups")
local TheoryComponents = require("darkcraft.spellstudy.menu.theory.TheoryComponents")

local TagKnowledge = require("darkcraft.spellstudy.data.TagKnowledge")
local TheoryData = require("darkcraft.spellstudy.data.TheoryData")

return {
    open = function()
        UiFramework.setup([[
                <Menu id="SpellStudy-Theories" text="Write Up Theories" dragFrame="true" minWidth="1000" minHeight="700" skipMenuMode="true">
                    <InkPaper />
                    <Block widthProportional="1.0" heightProportional="1.0" flowDirection="left_to_right">
                        <TheoryWritingBlock />
                        <KnownTheoryList />
                    </Block>
                    <TheoryDebugBlock />
                    <Button mouseClick="{SpellStudy-Theories#close}" text="Close" />
                </Menu>
            ]])
            .withRenderGroups({BaseComponents, TheoryComponents})
            .withoutData()
            .renderMenu()
    end
}