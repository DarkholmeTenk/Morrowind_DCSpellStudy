local Study = require("darkcraft.spellstudy.system.learn.Study")

return {
    spellCast = function(event)
        mwse.log("Spell cast")
        if(e.caster == tes3.player) then
            Study.onSpellCast(e.source)
        end
    end,

    register = function(self)
        event.register("spellCasted", self.spellCast)
    end
}