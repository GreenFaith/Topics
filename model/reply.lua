Base = require "model.base"
Field = require "model.field"
local dao = require "lib.dao"

local Reply = {table_name="Reply"}
setmetatable(Reply, {__index=Base})
function Reply.new()
    local obj = {}
    obj = {
        user_id = Field {_="number"},
        topic_id = Field {_="number"}, 
        content = Field {_="string",max=2000},
        floor = Field {_="number"},
        created_at = Field {_="number"},
        updated_at = Field {_="number"},
        active = Field {_="number",default=1},
        }
    return setmetatable(obj, {__index=Reply})
end

function Reply.read_list( self, args )
    -- model method
    local db = dao:con()
    if not (db and args.topic_id) then return end
    if not args.order then args.order = 'floor' end
    if not args.limit then args.limit = '30' end
    if not args.offset then args.offset = '0' end

    local  sql = "select * from "..
        self.table_name.." where topic_id="..args.topic_id..
        " order by "..args.order.." desc limit "..args.offset..","..args.limit..";"
    print(sql)
    local res = db:qry(sql)
    db:clz()
    return res
end

return Reply

