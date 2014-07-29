-- function for common model
local dao = require "lib.dao"
local Base = {}

function Base.repr(self, args)
    local not_nil, colums, values = args.not_nil, args.colums, args.values
    local target = {}

    for k,v in pairs(self) do
        if type(v) == "table" then  -- for each Field

            if v.value == nil and not_nil ~= true then
                 v.value = v.default
            end

            if v.value ~= nil then            
                target[k]=v.value
            end
        end
    end
    
    --String(target) 
    local res, str  
    for k,v in pairs(target) do
        if colums == true and values == true then
            str =  k .. "=" .. "\'"..v .."\'"
        elseif colums == true then
            str = k 
        else
            str = "\'"..v.."\'"
        end
        if res == nil then 
            res = str 
        else 
            res = str .. "," ..  res
        end 
    end
    return res
end

function Base.colums(self)
    return self:repr{not_nil=false, colums=true} 
end

function Base.values(self)
    return self:repr{not_nil=false, values=true}
end

function Base.toString(self)
    return self:repr{not_nil=true, colums=true, values=true}
end


function Base.record(self)
    local target = {}
    for k,v in pairs(self) do
        if type(v) == "table" then  -- for each Field

            if v.value == nil then
                 v.value = v.default
            end

            if v.value ~= nil then            
                target[k]=v.value
            end
        end
    end
    return target
end


function Base.create(self)
    --model instance method
    local db = dao:con()  
    if db == nil then return end
    local sql = "INSERT INTO "..self.table_name.." ("
                        .. self:colums() ..    
                        ") VALUES ("
                        .. self:values() ..
                        ");" 
    print(sql)
    local ok = db:qry(sql)
    db:clz()
    return ok
end

function Base.update(self, new_data)
    --model instance method
    local db = dao:con()  
    if db == nil then return end
    if new_data.id == nil then
        print("no id for update")
        return false
    end
    --model.new(o)
    local t = self.new(new_data)

    local sql = "update "..self.table_name.." set " ..
                t:toString() .. 
                " where id=".. new_data.id ..
                " limit 1;"
    print(sql)
    local res = db:qry(sql)
    db:clz()
    return res
end

function Base.read(self, id)
    -- model method
    local db = dao:con()  
    if db == nil then return end
    local res = db:qry("select * from "..self.table_name.. " where id =" .. id .. " limit 1")
    db:clz()
    return res
end



function Base.destroy(self,id)
    -- model method
    local db = dao:con()  
    if db == nil then return end
    local res = db:qry("update "..self.table_name.." set active=0 where id=".. id .. " limit 1" )
    db:clz()
    return res
end

function Base.exe(self, sql)
    print(sql)
    local db = dao:con()
    if db == nil then return end 
    local res = db:query(sql)
    db:clz()
    return res
end

return Base
