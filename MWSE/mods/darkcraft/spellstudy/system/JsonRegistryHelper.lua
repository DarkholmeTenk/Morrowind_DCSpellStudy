local JsonTagRegister = require("darkcraft.spellstudy.system.json.JsonTagRegister")
local JsonEffectTagRegister = require("darkcraft.spellstudy.system.json.JsonEffectTagRegister")


local JsonRegistryHelper = {
    registerJsonTagLoader = function(jsonLocation)
        event.register("SpellStudy-Register-Tag", function(registry)
            mwse.log("Loading tags from JSON [" .. jsonLocation .. "]")
            JsonTagRegister.register(jsonLocation, registry)
        end)
    end,

    registerJsonEffectTagLoader = function(jsonLocation)
        event.register("SpellStudy-Register-EffectTag", function(registry)
            mwse.log("Loading effect tags from JSON [" .. jsonLocation .. "]")
            JsonEffectTagRegister.register(jsonLocation, registry)
        end)
    end
}

return JsonRegistryHelper