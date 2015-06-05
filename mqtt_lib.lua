--==========================Module Part======================
local moduleName = ...
local M = {}
_G[moduleName] = M
--==========================Local parameters===========
local count = 0      -- Interations
local sc = 0         -- default secure mode
local prevmode = nil       --Prev mode swich
local connected = false  --Satate of connect
local publushed = false  --State of publish
local m = mqtt.Client(cfg.ID, 60, cfg.mqUser, cfg.mqPwd)

function publish()
    if wifi.sta.status() < 5 then 
        return
    end
    tmr.stop(3)
    count = count + 1 
    if count>10 then --Attempt count
        count=0 
    end
    if not connected then
        if count==1 then
            m:close()
            print ("Trying to connect to ".. cfg.mqHost .. ":" .. cfg.mqPort .." as " .. cfg.ID)
            m:connect( cfg.mqHost , cfg.mqPort, sc, function(conn)
                print("Connected to MQTT:" .. cfg.mqHost .. ":" .. cfg.mqPort .." as " .. cfg.ID )
                m:subscribe(cfg.mqT, 0, function(conn)
                    print("subscribe ON, topic",cfg.mqT) 
                end)
                connected = true
            end)
        end
        tmr.delay(100000)
        tmr.alarm(3, 1007, 1, function() publish() end)
        return
    end


    local md=G.getMode()
    if md ~= prevmode and not publushed then
        publushed = true
        count = 1
    end
    
    if count==1 and publushed then
        m:publish(cfg.mqT, md, 0, 0, function(conn)
            print("Send message:"..md.." to Topic:"..cfg.mqT)
            prevmode = md
            publushed = false
        end)
    end
    tmr.alarm(3, 1007, 1, function() publish() end)
    return
end

function M.doSwichSend()
    --m:lwt(cfg.mqT, -1, 0, 0)

    m:on("connect", function(con) 
        print ("connected") 
    end)     
    m:on("offline", function(con) 
        print ("offline") 
        count = 0
        connected = false
    end)
    m:on("message", function(conn, topic, data) 
        print("topic "..topic.." get message" )
        data=tonumber(data)
        print("prevmode:"..prevmode..", Data:"..data..", topic", topic)
        if data ~= nil and prevmode ~= data then
            G.setMode(data)
            prevmode = data
        end
    end)
    tmr.alarm(3, 1007, 1, function() publish() end)
end

return M
