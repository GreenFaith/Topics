local Field = {}
local mt = {__call = function (t, args) return t.new(args) end }
setmetatable(Field, mt)

function Field.new(args)
    local type_str, default, min, max = 
        args._, args.default, args.min, args.max
    if not type_str then return end
    if type_str == "number" then
        --int(11)
        if not min then min = -2147483648 end
        if not max then max = 2147483647 end
        if not default then default = 0 end
    end 
    
    if type_str == "string" then
        if not min then min = 0 end
        if not max then max = 15 end
        if not default then default = "null" end
    end 

    obj = {
            t = type_str, 
            value = nil,
            default = default,
            min = min,
            max = max 
            }

    obj =  setmetatable(obj, {__index=Field,})
    return obj
end

function Field.set(self, v)
    --check type
    if self.t ~= type(v) then
        return nil
    end
    --check size 
    if self.t == "number" and (v > self.max or v < self.min) then
        return nil       
    end
    
    if self.t == "string" and ( v:len() > self.max or v:len() < self.min) then
        return nil
    end 
    self.value = v
    return self.value
end    

return Field    
