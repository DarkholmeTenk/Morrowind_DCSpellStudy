local DefaultConfigTheoryLevels = require("darkcraft.spellstudy.config.DefaultConfigTheoryLevels")

return {
    getDefault = function()
        return {
            difficulty = {
                craftChanceBonus = 0,
                theoryLossOnSuccessChance = 20,
                theoryLossOnFailureChance = 10,
                requiredTagTypes = 50
            },
            spells = {
                includeUnknownEffects = false
            },
            levels = DefaultConfigTheoryLevels
        }
    end
}