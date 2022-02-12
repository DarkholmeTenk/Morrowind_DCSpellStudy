local debug = require("darkcraft.core.debug")

local function ensure(target, data)
    for i,v in pairs(data) do
        if(target[i] == nil) then
            mwse.log("Fixing " .. i)
            target[i] = v
        else
            if(type(v) == "table") then
                ensure(target[i], v)
            end
        end
    end
end

return {
    ensure = ensure
}