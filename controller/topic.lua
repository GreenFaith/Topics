local json = require "cjson"
local Topic = require "model.topic"

local tid = tonumber(ngx.var.id) 
local respon = {}

if ngx.var.request_method == "GET" then 
    -- read topic list
    if not tid then
        local offset = tonumber(ngx.var.arg_offset)
        print(offset)
        local t_list = Topic:read_list({order="created_at",offset=offset})
        if t_list then 
            respon.data = {items=t_list}
            respon.data.kind = "topic"
            ngx.say(json.encode(respon)) 
        else
            respon.error = {code=404,message="cannot read topic list!"}
            ngx.say(json.encode(respon))
        end
        return 
    end
    --read topic 
    t = Topic:read(tid)
    if next(t) == nil then
        respon.error = {
            code = 404,
            message = "Not Found"
        }
        ngx.say(json.encode(respon))
        return
    end 
    respon.data = {
        kind = "topics",
        items = t
    }
    ngx.say(json.encode(respon))
    return
end

if ngx.var.request_method == "DELETE" then
    local res = Topic:destroy(tid)
    local respon = {}
    if res then
        respon.data = {}
        respon.data.kind = "topic"
        respon.data.id = tid
    end
    ngx.say(json.encode(respon))
    return
end

if ngx.var.request_method == "POST" then

    local args = ngx.req.get_post_args()
    local t = Topic.new()
    local respon = {}
    local now = os.time()

    if  args.content == nil or args.title == nil then 
        respon.error = {}        
        respon.error.code = 400
        respon.error.message = "missing content or title"
        ngx.say(json.encode(respon))
        return
    end

    t.title:set(args.title)
    t.content:set(args.content)
    t.created_at:set(now)
    t.updated_at:set(now)

    if t:create() then
        respon.data = {}
        respon.data.kind = "topic"
        respon.data.items = t:record()
    else 
        respon.error = {}
        respon.error.code = 500
        respon.error.message = "create faild"
    end 
    ngx.say(json.encode(respon))
    return
end

if ngx.var.request_method == "PUT" then
    local args = ngx.req.get_post_args()
    local d = {}
    local respon = {}
    d.id = tid 
    d.content = args.content
    d.title = args.title
    --form check
    if not (d.id and (d.content or d.title )) then
        respon.error = {}
        respon.error.code = 400
        respon.error.message = "no id give or nothing to update"
        ngx.say(json.encode(respon))
        return
    end    

    if Topic:update(d) then
        respon.data = {}
        respon.data.kind = "topic"
        respon.data.id = d.id
    else 
        respon.error = {}
        respon.error.code = 500
        respon.error.message = "update faild"
    end 
    ngx.say(json.encode(respon))
    return
end

