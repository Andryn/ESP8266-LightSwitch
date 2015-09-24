--==========================Module Part======================
local moduleName = ...
local M = {}
_G[moduleName] = M
--==========================Local parameters===========
local count = 0      -- Interations
local sc = 0         -- default secure mode
local prevmode = nil       --Prev mode swich
local connected = false  --Satate of connect
local republish = 0    --=0 if need of republish
local m = mqtt.Client(cfg.ID, 60, cfg.mqUser, cfg.mqPwd)

function publish()
    if wifi.sta.status() < 5 then 
        return
    end
    tmr.stop(3)
    count = count + 1 
    if count > 10 then --Attempt count
        count=0
        if republish > 0 and republish < 6 then --republish data for each 60s 
            republish = republish + 1
        else
            republish = 0
        end
        --print ("republish = ".. republish)
    end
    if not connected then
        if count==1 then
            m:close()
            print ("Trying to connect to ".. cfg.mqHost .. ":" .. cfg.mqPort .." as " .. cfg.ID)
            m:connect( cfg.mqHost , cfg.mqPort, sc, function(conn)
                print("Connected to MQTT:" .. cfg.mqHost .. ":" .. cfg.mqPort .." as " .. cfg.ID )
                m:subscribe(cfg.mqT.."cmd", 0, function(conn)
                    print("subscribe ON, topic",cfg.mqT.."cmd") 
                end)
                connected = true
            end)
        end
        tmr.delay(100000)
        tmr.alarm(3, 1007, 1, function() publish() end)
        return
    end


    local md=G.getMode()
    if md ~= prevmode then
        republish = 0
        count = 1
    end
    
    if count==1 and republish==0 then
        m:publish(cfg.mqT.."state", md, 0, 0, function(conn)
            print("Send message:"..md.." to Topic:"..cfg.mqT.."state")
            prevmode = md
            republish = 1
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
            republish = 0
        end
    end)
    tmr.alarm(3, 1007, 1, function() publish() end)
end

return M
