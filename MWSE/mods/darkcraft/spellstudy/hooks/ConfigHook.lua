local Config = require("darkcraft.spellstudy.config.Config")

return {
    ready = function()
        Config.register()
    end,

    register = function(self)
        event.register("modConfigReady", self.ready)
    end
}