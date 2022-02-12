local PlayerData = {
    get = function()
        if(tes3.player.data.SpellStudy == nil) then
            tes3.player.data.SpellStudy = {}
        end
        return tes3.player.data.SpellStudy
    end
}

return PlayerData