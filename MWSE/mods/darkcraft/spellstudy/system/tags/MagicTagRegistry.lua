local Flip = require("darkcraft.dev.util.Flip")
local SchoolIdMap = require("tes3.magicSchool")
local DefaultTags = require("darkcraft.spellstudy.system.tags.DefaultTags")

local tags = {}

local SchoolMap = Flip.flip(SchoolIdMap)

local MagicTagRegistry = {}
MagicTagRegistry = {
    init = function(self)
        for _,v in pairs(DefaultTags) do
            mwse.log("Registering default tag " .. v.id)
            self.registerTag(v)
        end
        event.trigger("SpellStudy-Register-Tag", self)
    end,

    getSchoolTag = function(schoolId)
        local name = SchoolMap[schoolId]
        if(name ~= nil) then
            return "school-" .. SchoolMap[schoolId]
        else
            return "dummy"
        end
    end,

    getDummyTag = function()
        return MagicTagRegistry.getTag("dummy")
    end,

    getTag = function(tagId)
        return tags[tagId]
    end,

    listTags = function()
        local arr = {}
        for _,v in pairs(tags) do
            table.insert(arr, v)
        end
        return arr
    end,

    registerTag = function(tag)
        mwse.log("Registering tag [" .. tag.id .. "]")
        tags[tag.id] = tag
    end
}
return MagicTagRegistry