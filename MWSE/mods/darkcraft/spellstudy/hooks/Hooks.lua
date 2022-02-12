local ConfigHook = require("darkcraft.spellstudy.hooks.ConfigHook")
local InventoryHook = require("darkcraft.spellstudy.hooks.InventoryHook")
local RegistryHook = require("darkcraft.spellstudy.hooks.RegistryHook")
local SpellHooks = require("darkcraft.spellstudy.hooks.SpellHooks")

return {
    register = function(self)
        InventoryHook:register()
        RegistryHook:register()
        SpellHooks:register()
        ConfigHook:register()
    end
}