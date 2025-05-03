local CStructer = {}
local ffi = require("ffi")

function CStructer._extract_validate_struct_type(struct_data)
    assert(type(struct_data) == "table", "Error: bad type for struct_data")
    local struct_type = struct_data[1].sdef
    for _, member in ipairs(struct_data) do
        assert(member.sdef == struct_type, "Error: unmatched name")
    end
    return struct_type
end

function CStructer._extract_validate_struct_size(struct_data)
    assert(type(struct_data) == "table", "Error: bad type for struct_data")
    local size = 0
    for _, member in ipairs(struct_data) do
        size = size + ffi.sizeof(member.type)
    end
    return size
end

function CStructer._extract_validate_struct_init(struct_data)
    local vals = {}
    for _, member in ipairs(struct_data) do
        table.insert(vals, member.init)
    end
    return vals
end

function CStructer._extract_validate_struct_mems(struct_data)
    assert(type(struct_data) == "table", "Error: bad type for struct_data")
    local members, indent = {}, "       "
    for _, member in ipairs(struct_data) do
        local m = string.format(indent .. "%s %s;", member.type, member.name)
        table.insert(members, m)
    end
    return table.concat(members, "\n")
end

return CStructer
