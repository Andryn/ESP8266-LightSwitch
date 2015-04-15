file.remove("config.lc");
file.remove("GPIO.lc");
file.remove("wifi.lc");
file.remove("httpd.lc");

node.compile('config.lua')
node.compile('GPIO.lua')
node.compile('wifi.lua')
node.compile('httpd.lua')
