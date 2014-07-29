local json = require "cjson"
local Reply = require "model.reply"
local Topic = require "model.topic"

local rid = tonumber(ngx.var.id) 
local respon = {}

if ngx.var.request_method == "GET" then 
    --read reply list
    if not rid then
        local tid = tonumber(ngx.var.arg_topic_id)
        print(tid)
        local r_list = Reply:read_list({topic_id=tid})
        if r_list then
            respon.data = {items = r_list}
            respon.data.kind = "reply"
            ngx.say(json.encode(respon))
        else
            respon.error = {code=404, message="Reply List Not Found"}
            ngx.say(json.encode(respon))
        end
        return
    end
    local t = Reply:read(rid)
    if next(t) == nil then
        respon.error = {
            code = 404,
            message = "Not Found"
        }
        ngx.say(json.encode(respon))
        return
    end 
    respon.data = {
        kind = "reply",
        items = t
    }
    ngx.say(json.encode(respon))
    return
end

if ngx.var.request_method == "DELETE" then
    local res = Reply:destroy(rid)
    local respon = {}
    if res then
        respon.data = {}
        respon.data.kind = "Reply"
        respon.data.message = "deleted"
        respon.data.id = rid
    end
    ngx.say(json.encode(respon))
    return
end

if ngx.var.request_method == "POST" then

    local args = ngx.req.get_post_args()
    local r = Reply.new()
    local tid = tonumber(args.topic_id)
    local respon = {}
    local now = os.time()
    
    --form vaild
    if tid == nil or args.content == nil then 
        respon.error = {}        
        respon.error.code = 400
        respon.error.message = "missing topic_id or content"
        ngx.say(json.encode(respon))
        return
    end

    local t = Topic:read(tid) 
    if t==nil or next(t)==nil then
        respon.error = {}
        respon.error.code = 404 respon.error.message = "topic not found by given topic id!"
        ngx.say(json.encode(respon))
        return
    end
    
    --not safe [floor] 
    --r.floor = t.reply_count.value + 1
    r.topic_id:set(tid) 
    r.content:set(args.content)
    r.created_at:set(now)
    r.updated_at:set(now)
    
    -- create reply
    local res = r:create()
    if not res then
        respon.error = {}
        respon.error.code = 500
        respon.error.message = "create faild"
        ngx.say(json.encode(respon))
        return 
    end 
    local rid = res.insert_id 
    --update topic
    if Topic:exe("update Topic,Reply set "..
            "Topic.reply_count=Topic.reply_count+1,"..
            "Topic.last_reply_date="..now..
            ",Reply.floor=Topic.reply_count"..
            " where Topic.id="..tid..
            " and Reply.id="..rid..";") then
            respon.data = {}
            respon.data.kind = "reply"
            respon.data.items = r:record()
    end
    respon.data = {kind="reply"}
    ngx.say(json.encode(respon))
    return
end

if ngx.var.request_method == "PUT" then
    local args = ngx.req.get_post_args()
    local d = {}
    local respon = {}
    d.id = rid 
    d.content = args.content
    --form check
    if not (d.id and d.content)  then
        respon.error = {}
        respon.error.code = 400
        respon.error.message = "no id give or nothing to update"
        ngx.say(json.encode(respon))
        return
    end    

    if Reply:update(d) then
        respon.data = {}
        respon.data.kind = "Reply"
        respon.data.id = d.id
    else 
        respon.error = {}
        respon.error.code = 500
        respon.error.message = "update faild"
    end 
    ngx.say(json.encode(respon))
    return
end


