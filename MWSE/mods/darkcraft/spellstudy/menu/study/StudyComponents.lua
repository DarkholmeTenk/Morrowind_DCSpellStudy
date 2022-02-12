local base = require("darkcraft.dev.ui.renderer.base")
local SpellTagDataProvider = require("darkcraft.spellstudy.system.spell.SpellTagDataProvider")
local Study = require("darkcraft.spellstudy.system.learn.Study")
local TagKnowledge = require("darkcraft.spellstudy.data.TagKnowledge")
local Context = require("darkcraft.dev.ui.util.Context")

return {
    SpellStudyComponent = base.xml:extend([[
            <Block widthProportional="1" heightProportional="1" flowDirection="top_to_bottom">
                <Label text="{spellName}" />
                <VerticalScrollPane widthProportional="1" heightProportional="1">
                    <Label text="Spell Tags:" />
                    <ForEach from="{tags}" key="tagId" value="count" flowDirection="top_to_bottom" widthProportional="1.0" heightProportional="1.0">
                        <TagKnowledge tagId="{tagId}" count="{count}" />
                    </ForEach>
                </VerticalScrollPane>
                <Block widthProportional="1" autoHeight="true" flowDirection="left_to_right">
                    <StudyButton tagData="{tags}" hours="1" />
                    <StudyButton tagData="{tags}" hours="3" />
                    <StudyButton tagData="{tags}" hours="6" />
                    <StudyButton tagData="{tags}" hours="12" />
                </Block>
            </Block>
        ]], function(attributes, data)
        local spell = attributes.spell
        data.tags = SpellTagDataProvider.getTags(spell)
        data.spellName = spell.name
    end),
    StudyButton = base.xml:extend([[
        <Button text="{label}" mouseClick="{click}" />
    ]], function(attributes, data)
        local h = tonumber(attributes.hours)
        data.label = "Study " .. h .. "h"
        data.click = function()
            Study.study(attributes.tagData, h)
        end
    end),
    KnownTagList = base.xml:extend([[
        <Block widthProportional="1" heightProportional="1" flowDirection="top_to_bottom" >
            <Label text="Tag knowledge:" />
            <VerticalScrollPane widthProportional="1" heightProportional="1">
                <ForEach from="{tags}" value="tagId" flowDirection="top_to_bottom" widthProportional="1.0" heightProportional="1.0">
                    <TagKnowledge tagId="{tagId}" />
                </ForEach>
            </VerticalScrollPane>
        </Block>
    ]], function(attributes, data)
        Context.useContextValue(data, TagKnowledge.get(), "tags",
                function(t) return t:listKnownTags()  end
        )
    end)
}