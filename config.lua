--==Module Part==
local moduleName = ...
local M = {}
_G[moduleName] = M
--==Default config==--
if cfg==nil then 
    cfg = {}
    cfg.ID=""
    cfg.pIN=5
    cfg.pOU1=1
    cfg.pOU2=2
    cfg.ON=0
    cfg.OFF=1
    cfg.SSID=""
    cfg.PWD=""
    cfg.mqHost=""
    cfg.mqPort=1883
    cfg.mqUser=""
    cfg.mqPwd=""    
    cfg.mqT=""
end

function M.loadcfg()
    local jn = require "cjson"
    if file.open("cfg.json","r")==nil then return end
    cfg = jn.decode(file.readline())
    file.close()
end
function M.savecfg()
    cfg.MAC=nil
    local jn = require "cjson"
    file.open("cfg.json","w+")
    file.writeline(jn.encode(cfg))
    file.flush()
    file.close()
end

return M

