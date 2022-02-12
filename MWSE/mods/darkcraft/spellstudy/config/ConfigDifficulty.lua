local EasyMcm = require("easyMCM.EasyMCM")

return {
    register = function(mainPage, tableValue)
        local difficultyCategory = mainPage:createCategory {
            label = "Difficulty",
            description = "Configure options relating to the difficulty of the mod"
        }
        difficultyCategory:createSlider {
            label = "Theory loss on successful craft",
            description = "The chance of a theory being used up on a successful spellcraft",
            variable = EasyMcm.createTableVariable {
                id="theoryLossOnSuccessChance",
                table = tableValue
            }
        }
        difficultyCategory:createSlider {
            label = "Theory loss on failed craft",
            description = "The chance of a theory being used up on a failed spellcraft",
            variable = EasyMcm.createTableVariable {
                id="theoryLossOnFailureChance",
                table = tableValue
            }
        }
        difficultyCategory:createSlider {
            label = "Crafting chance bonus",
            description = "A flat bonus added to any spell crafting chance",
            variable = EasyMcm.createTableVariable {
                id="craftChanceBonus",
                table = tableValue
            }
        }
        difficultyCategory:createSlider {
            label = "Required tag type percentage",
            description = "The percentage of tag types that are required to have any chance of crafting a spell",
            variable = EasyMcm.createTableVariable {
                id="requiredTagTypes",
                table = tableValue
            }
        }
    end
}