local mysql = require "resty.mysql"

local dao = {}
local opts = 
{
    host = "127.0.0.1",
    port = 3306,
    database = "test",
    user = "mysql",
    password = "",
    max_packet_size = 1024 * 1024 
}


local function clz(self)

    local ok, err = self:set_keepalive(100000, 100)
    if not ok then
        print("failed to set keepalive: ", err)
    end
    return ok, err
end


local function qry(self,cmd)

    res, err, errno, sqlstate =
        self:query(cmd)
    --if not res then
    print("query:" , err, ": ", errno, ": ", sqlstate, ".")
    --end

    return res
end


local function con()
    local db, err = mysql:new()

    if not db then
        print("failed to instantiate mysql: ", err)
        return
    end
    db:set_timeout(1000) -- 1 sec

    -- connect to mysql
    local ok, err, errno, sqlstate = db:connect(opts)
    if not ok then
        print("failed to connect: ", err, ": ", errno, " ", sqlstate)
        return
    end

    db.clz = clz
    db.qry = qry

    return db
end



dao.con = con
return dao
