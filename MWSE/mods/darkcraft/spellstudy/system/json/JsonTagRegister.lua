local debug = require("darkcraft.core.debug")

local function validateTag(v)
    return true
end

return {
    register = function(file, registry)
        local data = json.loadfile(file)
        if(data ~= nil and type(data) == "table" and #data > 0) then
            for _,v in pairs(data) do
                if(validateTag(v)) then
                    registry.registerTag(v)
                end
            end
        else
            debug(data, "Failed JSON Data: " .. file)
        end
    end
}