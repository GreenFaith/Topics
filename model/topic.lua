local Field = require "model.field"
local Base = require "model.base"
local dao = require "lib.dao"
local Topic = {table_name="Topic"}

setmetatable(Topic, {__index=Base})
function Topic.new(init)
    obj = {
        user_id = Field {_="number"},
        title = Field {_="string",  max=200},
        content = Field {_="string", max=2000},
        reply_count = Field {_="number"},
        created_at = Field {_="number"}, 
        updated_at = Field {_="number"}, 
        active = Field {_="number",default=1}, 
        last_reply_date = Field {_="number"}, 
        }     
    if init ~= nil then
        for k,v in pairs(init) do
           if k ~= "id" then obj[k]:set(v) end
        end
    end 
    return setmetatable(obj, {__index=Topic})            
end

function Topic.read_list( self, args )
    -- model method
    local db = dao:con()
    if not db then return end
    if not args.order then args.order = 'last_reply_date' end
    if not args.limit then args.limit = '15' end
    if not args.offset then args.offset = '0' end

    local  sql = "select id,title,user_id,created_at,updated_at,reply_count,last_reply_date from "..
        self.table_name.." order by "..args.order.." desc limit "..args.offset..","..args.limit..";"
    print(sql)
    local res = db:qry(sql)
    db:clz()
    return res
end

return Topic
