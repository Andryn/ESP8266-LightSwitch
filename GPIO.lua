local initGPIO = function ()
    gpio.mode(cfg.pOU1, gpio.OUTPUT)
    gpio.write(cfg.pOU1, cfg.OFF)
    gpio.mode(cfg.pIN, gpio.INPUT)
    gpio.write(cfg.pIN, cfg.OFF)
end
initGPIO()

chkRestore = function ()
    if gpio.read(cfg.pIN)==cfg.ON or cfg.SSID=='' then 
        return true
    end
    return false
end

doGPIO = function ()
    local ON,OFF=cfg.ON,cfg.OFF
    local pIN,pOU1,pOU2=cfg.pIN,cfg.pOU1,cfg.pOU2
    if gpio.read(pIN) == ON then
        local p1,p2 = gpio.read(pOU1),gpio.read(pOU2) 
        if p1 == OFF and p2 == OFF then
            gpio.write(pOU1, ON)
        elseif p1 == ON and p2 == OFF then
            gpio.write(pOU2, ON)
        elseif p1 == ON and p2 == ON then
            gpio.write(pOU1, OFF)
        else
            gpio.write(pOU2, OFF)
        end
        tmr.delay(500000)
        gpio.write(pIN, OFF)
    end
    tmr.alarm(0, 100, 0, doGPIO )
end
