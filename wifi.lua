--LED
for p = 6, 8 do
    pwm.setup(p,500,50)
    pwm.start(p)
end
local function led(r,g,b) 
    pwm.setduty(8,r) 
    pwm.setduty(6,g) 
    pwm.setduty(7,b) 
end

local wifi_ap=function()
    wifi.setmode(wifi.SOFTAP)
    local w = {ssid='ESP'}
    wifi.ap.config(w)
    cfg.MAC=wifi.ap.getmac()
    local lt=0
    tmr.stop(1)
    tmr.alarm(1,1000,1,function()
        if lt==0 then
            lt=1; led(512,512,512)
        else
            lt=0; led(0,0,0)
        end
    end)
    
end

local wifi_st=function()
    wifi.setmode(wifi.STATION)
    wifi.sta.config(cfg.SSID,cfg.PWD)
    wifi.sta.connect()
    cfg.MAC=wifi.sta.getmac()
    tmr.stop(1)
    tmr.alarm(1,1000,1,function()
        local s=wifi.sta.status()
        if s==0 or s==1 then led(0,0,512)
        elseif s==5 then led(0,512,0)
        else led(512,0,0) end
    end)
end

if restore then
    wifi_ap()
else
    wifi_st()
end
