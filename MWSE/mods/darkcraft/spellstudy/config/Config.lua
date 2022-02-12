local EasyMcm = require("easyMCM.EasyMCM")
local DefaultConfig = require("darkcraft.spellstudy.config.DefaultConfigValues")
local Ensure = require("darkcraft.spellstudy.util.Ensure")
local debug = require("darkcraft.core.debug")

local ConfigDifficulty = require("darkcraft.spellstudy.config.ConfigDifficulty")
local ConfigTheoryLevels = require("darkcraft.spellstudy.config.ConfigTheoryLevels")


local ConfigPath = "darkcraft_spellstudy"
local ConfigValue = mwse.loadConfig(ConfigPath) or { }
Ensure.ensure(ConfigValue, table.deepCopy(DefaultConfig.getDefault()))

return {
    register = function()
        mwse.log("Setting up configs")
        debug(ConfigValue, "Config Value")

        local template = EasyMcm.createTemplate("Darkcraft - SpellStudy")
        template:saveOnClose(ConfigPath, ConfigValue)


        local mainpage = template:createSideBarPage {
            label = "Settings",
            description = "Configure main parts of the mod"
        }

        ConfigDifficulty.register(mainpage, ConfigValue.difficulty)
        ConfigTheoryLevels.register(template, ConfigValue.levels)

        EasyMcm.register(template)
    end,

    get = function() return ConfigValue end
}