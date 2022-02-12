local base = require("darkcraft.dev.ui.renderer.base")
local TagKnowledge = require("darkcraft.spellstudy.data.TagKnowledge")
local TagRegistry = require("darkcraft.spellstudy.system.tags.MagicTagRegistry")
local Context = require("darkcraft.dev.ui.util.Context")

local DEFAULT_ICON = "icons\\dc\\magic_base.dds"

return {
    TagGetter = base.provider:extend(function(attributes, data, current)
        local tag = attributes.tag
        if(type(tag) == "string") then
            tag = TagRegistry.getTag(tag)
        end
        if(tag == nil) then
            tag = TagRegistry.getDummyTag()
        end
        data.tagData = tag
        data.icon = tag.icon or DEFAULT_ICON
        data.name = tag.name or "Unnamed Tag"
        data.desc = tag.desc or "No Description"
    end),
    TagIconView = base.pure(base.xml:extend([[<Image path="{icon}" width="32" height="32" />]])),
    TagIconView2 = base.pure(base.xml:extend([[
        <Block width="32" height="32">
            <Image path="{icon}" visible="{useIcon}" width="32" height="32" />
            <Image path="icons\dc\magic_base.dds" width="32" height="32"  >
                <Block full="true" childAlignY="0.5" childAlignX="0.5">
                    <Label text="{labelText}" font="2" visible="{useLabel}" fullAuto="true" color="0,0,0" />
                </Block>
            </Image>
        </Block>
    ]], function(attributes, data)
        data.labelText = string.sub(attributes.name, 1, 1)
        if(attributes.icon == "" or attributes.icon == DEFAULT_ICON) then
            data.useIcon = false
            data.useLabel = true
        else
            data.useIcon = true
            data.useLabel = false
        end
    end)),
    TagIcon = base.xml:extend([[
        <TagGetter tag="{tag}">
            <Image path="{icon}" width="32" height="32" />
        </TagGetter>
    ]]),
    TagLabel = base.pure(base.xml:extend([[
        <TagGetter tag="{tag}">
            <Block autoWidth="true" autoHeight="true" flowDirection="left_to_right" childAlignY="0.5">
                <TagIconView icon="{icon}" name="{name}" />
                <Label text="{name}" borderLeft="7"/>
            </Block>
        </TagGetter>
    ]])),
    TagKnowledge = base.xml:extend([[
        <Block widthProportional="1" autoHeight="true" flowDirection="top_to_bottom">
            <TagLabel tag="{tagId}" />
            <FillBar current="{currentKnowledge}" max="{maxKnowledge}" />
            <TagTooltip tag="{tagId}" />
        </Block>
    ]], function(attributes, data)
        data.tagId = attributes.tagId
        Context.useContextValues(data, TagKnowledge.get(), "tagKnowledge" .. attributes.tagId, function(t)
            return {
                maxKnowledge = t:maxAmount(),
                currentKnowledge = t:getAmount(attributes.tagId)
            }
        end)
    end),
    TagTooltip = base.pure(base.xml:extend([[
        <TagGetter tag="{tag}" >
            <TooltipMenu>
                <Block autoWidth="true" autoHeight="true" flowDirection="top_to_bottom">
                    <TagLabel tag="{tag}" />
                    <Label text="{desc}" />
                </Block>
            </TooltipMenu>
        </TagGetter>
    ]]))
}