local base = require("darkcraft.dev.ui.renderer.base")
local TheoryData = require("darkcraft.spellstudy.data.TheoryData")

return {
    TheoryDebugBlock = base.xml:extend([[
        <DebugBlock>
            <Button mouseClick="{addPaper}" text="Add Paper" />
            <Button mouseClick="{addInk}" text="Add Ink" />
        </DebugBlock>
    ]], function(attributes, data)
        local theoryData = TheoryData.get()
        data.addPaper = function()
            theoryData:addPaper(5)
        end

        data.addInk = function()
            theoryData:addInk(5)
        end
    end)
}