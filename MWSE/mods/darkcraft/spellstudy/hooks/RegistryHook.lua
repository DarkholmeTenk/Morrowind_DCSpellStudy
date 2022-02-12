local Registries = require("darkcraft.spellstudy.system.Registries")
local JsonRegistryHelper = require("darkcraft.spellstudy.system.JsonRegistryHelper")
local SellableSpellRegistry = require("darkcraft.spellstudy.system.spell.SellableSpellRegistry")

local jsonPrefix = "mods\\darkcraft\\spellstudy\\json\\"

return {
    registerJson = function()
        JsonRegistryHelper.registerJsonTagLoader(jsonPrefix .. "tags\\Vanilla")
        JsonRegistryHelper.registerJsonTagLoader(jsonPrefix .. "tags\\MagickaExpanded")

        JsonRegistryHelper.registerJsonEffectTagLoader(jsonPrefix .. "effects\\Vanilla-Alteration")
        JsonRegistryHelper.registerJsonEffectTagLoader(jsonPrefix .. "effects\\Vanilla-Conjuration")
        JsonRegistryHelper.registerJsonEffectTagLoader(jsonPrefix .. "effects\\Vanilla-Destruction")
        JsonRegistryHelper.registerJsonEffectTagLoader(jsonPrefix .. "effects\\Vanilla-Illusion")
        JsonRegistryHelper.registerJsonEffectTagLoader(jsonPrefix .. "effects\\Vanilla-Mysticism")
        JsonRegistryHelper.registerJsonEffectTagLoader(jsonPrefix .. "effects\\Vanilla-Restorationz")

        JsonRegistryHelper.registerJsonEffectTagLoader(jsonPrefix .. "effects\\MagickaExpanded")
    end,

    register = function(self)
        self.registerJson()
        event.register("SpellStudy-Register-LearnableSpells", function(e) e.registerLoader(SellableSpellRegistry)  end)
        event.register("initialized", Registries.init)
    end
}