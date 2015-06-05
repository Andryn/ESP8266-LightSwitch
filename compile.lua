file.remove("config.lc");
file.remove("GPIO.lc");
file.remove("wifi_lib.lc");
file.remove("httpd.lc");
file.remove("mqtt_lib.lc");

node.compile('config.lua');
node.compile('GPIO.lua');
node.compile('wifi_lib.lua');
node.compile('httpd.lua');
node.compile('mqtt_lib.lua');
