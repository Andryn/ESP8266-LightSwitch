--Set OFF

--Load Config--
print("1 ", node.heap())
C= require("config")
C.loadcfg()
C=nil
package.loaded["config"]=nil
_G["config"]=nil
collectgarbage()
print("2 ", node.heap())

--Load GPIO--
G= require("GPIO")
G.initGPIO()
G.setMode(0)
ap=G.getConfigMode()
G.doGPIO()
--G=nil
collectgarbage()
print("3 ", node.heap())

--Load WIFI--
W=require("wifi_lib")
cfg.MAC=W.wifi(ap)
W=nil
package.loaded["wifi_lib"]=nil
_G["wifi_lib"]=nil
collectgarbage()
print("4 ", node.heap())

if ap==1 then
    print('Mode AP, do HTTP')
    --Load HTTPD--
    H=require("httpd")
    H.doHTTP()
    H=nil
    package.loaded["httpd"]=nil
    _G["httpd"]=nil
    collectgarbage()
    print("5 ", node.heap())
else
    print('Mode Sattion, wait MQTT')
    --Load Sensor--
    S=require("mqtt_lib")
    S.doSwichSend()
    collectgarbage()
    print("5 ", node.heap())
end

