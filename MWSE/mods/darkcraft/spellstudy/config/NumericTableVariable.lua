local EasyMcm = require("easyMCM.EasyMCM")

return {
    build = function(args)
        local table = args.table
        local id = args.id
        local newArgs = {
            get = function(self)
                local val = table[id]
                mwse.log("Calling get - " .. tostring(val))
                return val
            end,

            set = function(self, newVal)
                local x = tonumber(newVal)
                if(x ~= nil) then
                    table[id] = x
                end
            end
        }
        for i,v in pairs(args) do
            if(i ~= "table" and i ~= "id") then
                newArgs[i] = v
            end
        end
        return EasyMcm.createVariable(newArgs)
    end
}