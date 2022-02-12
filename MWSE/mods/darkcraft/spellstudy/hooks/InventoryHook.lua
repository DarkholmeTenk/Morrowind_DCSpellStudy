local Registries = require("darkcraft.spellstudy.system.Registries")
local InventoryBlock = require("darkcraft.spellstudy.menu.inventory.InventoryBlock")

local MenuMagicId = tes3ui.registerID("MenuMagic")
local MenuMagicSpells = tes3ui.registerID("MagicMenu_spells_list")
local MenuSpecialBlock = tes3ui.registerID("MagicMenu_SpellStudyBlock")

local function setup(e)
    Registries.init()
    local block = e:findChild(MenuSpecialBlock)
    if(block == nil) then
        local spellsElement = e:findChild(MenuMagicSpells)
        if(spellsElement ~= nil) then
            block = spellsElement.parent:createBlock({ id = MenuSpecialBlock })
        else
            return
        end
    end
    mwse.log("ASD")
    block:destroyChildren()
    block.widthProportional = 1.0
    block.autoHeight = true
    InventoryBlock.render(block)
end

local InventoryHook = {
    activate = function(e)
        setup(e.element)
    end,

    enter = function()
        local menu = tes3ui.findMenu(MenuMagicId)
        if(menu ~= nil) then
            setup(menu)
        end
    end,

    register = function(self)
        event.register("uiActivated", self.activate, { filter = "MenuMagic" })

        event.register("menuEnter", self.enter, { filter = "MenuInventory" })
        event.register("menuEnter", self.enter, { filter = "MenuMagic" })
        event.register("menuEnter", self.enter, { filter = "MenuMap" })
        event.register("menuEnter", self.enter, { filter = "MenuStat" })
    end
}
return InventoryHook