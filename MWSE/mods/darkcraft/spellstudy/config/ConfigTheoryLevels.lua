local EasyMcm = require("easyMCM.EasyMCM")
local NumericTableVariable = require("darkcraft.spellstudy.config.NumericTableVariable")

return {
    register = function(template, table)
        local page = template:createSidebarPage({
            label = "Theory Levels",
            description = "Configure theory levels"
        })

        for _,theoryData in pairs(table) do
            local label = theoryData.name

            local category = page:createCategory({
                label = label,
                description = "Configure settings for the " .. label .. " theory level."
            })

            category:createTextField({
                label = "Paper Cost",
                variable = NumericTableVariable.build({
                    id = "paperCost",
                    table = theoryData
                }),
                description = "The amount of paper it costs to create a theory of this level.",
                numbersOnly = true
            })

            category:createTextField({
                label = "Ink Cost",
                variable = NumericTableVariable.build({
                    id = "inkCost",
                    table = theoryData
                }),
                description = "The amount of ink it costs to create a theory of this level.",
                numbersOnly = true
            })

            category:createTextField({
                label = "Magicka Cost",
                variable = NumericTableVariable.build({
                    id = "magickaCost",
                    table = theoryData
                }),
                description = "The amount of magicka it costs to create a theory of this level.",
                numbersOnly = true
            })

            category:createTextField({
                label = "Knowledge Cost",
                variable = NumericTableVariable.build({
                    id = "knowledgeCost",
                    table = theoryData
                }),
                description = "The amount of tag knowledge it costs to create a theory of this level.",
                numbersOnly = true
            })

            category:createTextField({
                label = "Spell Magicka Maximum",
                variable = NumericTableVariable.build({
                    id = "spellMagickaMax",
                    table = theoryData
                }),
                description = "Spells with a greater magicka cost than this will be counted as a higher level.",
                numbersOnly = true
            })
        end
    end
}