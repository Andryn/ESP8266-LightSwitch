--==Module Part==
local moduleName = ...
local M = {}
_G[moduleName] = M
--===============
local swmode
local function setSwich()
    local pOU1,pOU2=cfg.pOU1,cfg.pOU2
    if swmode == 0 then
        gpio.write(pOU1, cfg.OFF)
        gpio.write(pOU2, cfg.OFF)
    elseif swmode == 1 then
        gpio.write(pOU1, cfg.ON)
        gpio.write(pOU2, cfg.OFF)
    elseif swmode == 2 then
        gpio.write(pOU1, cfg.OFF)
        gpio.write(pOU2, cfg.ON)
    elseif swmode == 3 then
        gpio.write(pOU1, cfg.ON)
        gpio.write(pOU2, cfg.ON)
    end
end

function M.initGPIO()
    gpio.mode(cfg.pOU1, gpio.OUTPUT)
    gpio.mode(cfg.pOU2, gpio.OUTPUT)
    gpio.mode(cfg.pIN, gpio.INPUT)
    gpio.write(cfg.pIN, gpio.HIGH)
end

function M.getConfigMode()
    --print("gpio.read",gpio.read(cfg.pIN))
    if gpio.read(cfg.pIN)==gpio.LOW or cfg.SSID=='' then 
        return 1
    end
    return 0
end

function doSwich()
    if gpio.read(cfg.pIN) == gpio.LOW then
        if swmode == 0 then
            swmode = 1
        elseif swmode == 1 then
            swmode = 3
        elseif swmode == 3 then
            swmode = 2
        else
            swmode=0
        end
        setSwich()
        tmr.delay(500000)
        gpio.write(cfg.pIN, gpio.HIGH)
    end
    tmr.alarm(0, 100, 0, function() doSwich() end)
end

function M.doGPIO()
    tmr.alarm(0, 100, 0, function() doSwich() end)
end
function M.setMode(mode)
    swmode=mode
    setSwich()
end
function M.getMode()
    return swmode
end

return M
