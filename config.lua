if cfg==nil then cfg={ID='',pIN=5,pOU1=1,pOU2=2,ON=0,OFF=1,SSID='',PWD=''} end
local loadcfg=function()
    local jn = require "cjson"
    if file.open("cfg.json","r")==nil then return end
    cfg = jn.decode(file.readline())
    file.close()
end
local savecfg=function()
    local jn = require "cjson"
    file.open("cfg.json","w+")
    file.writeline(jn.encode(cfg))
    file.close()
end
if cfg.update==1 then
    cfg.update=nil
    savecfg()
else
    loadcfg()
end
