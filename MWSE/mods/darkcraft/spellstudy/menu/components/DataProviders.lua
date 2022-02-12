local base = require("darkcraft.dev.ui.renderer.base")
local TagKnowledge = require("darkcraft.spellstudy.data.TagKnowledge")

return {
    KnownTags = base.provider:extend(function(attributes, data)
        
    end),
    DebugBlock = base.xml:extend([[
        <Conditional enabled="{isDebug}" autoWidth="true" autoHeight="true" >
            <Children children="{children}" />
        </Conditional>
    ]], function(attributes, data, parentData)
        for i,v in pairs(parentData) do
            if(v ~= nil and data[i] == nil) then
                data[i] = v
            end
        end
        data.isDebug = SS_DEBUG or false
    end)
}