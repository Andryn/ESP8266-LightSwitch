function connect (conn, data)
    conn:on ('receive',
        function (cn, req_data)
            local method, url, vars
            _, _, method, url, vars = string.find(req_data, "([A-Z]+) /([^?]*)%??(.*) HTTP")
            local f
            if url~='' and url~='set' and url~='get' then
                cn:send("HTTP/1.1 404 file not found\r\n\r\n")
                cn:close()
                return
            end
            if restore then
                f='setup.htm'
                if url=='set' then
                    vars="&"..vars.."&"
                    for i,v in pairs(cfg) do 
                        if string.find(vars, "&"..i.."=") then
                            cfg[i]=string.match(vars, ".-&"..i.."=(.-)&.-")
                        end
                    end
                    cfg.update=1
                    dofile('config.lua')
                    if string.find(vars, "&RST=1&") then node.restart() end
                    f='redirect.htm'
                end
            else
                f='index.htm'
                if url=='set' then
                    vars="&"..vars.."&"
                    if string.find(vars, "&pVL1=") then
                        local pVL1=string.match(vars, ".-&pVL1=(.-)&.-")
                        gpio.write(cfg.pOU1, pVL1)
                    end
                    if string.find(vars, "&pVL2=") then
                        local pVL2=string.match(vars, ".-&pVL2=(.-)&.-")
                        gpio.write(cfg.pOU2, pVL2)
                    end
                    f='redirect.htm'
                elseif url=='get' then
                    local j={}
                    j.ID=cfg.ID;j.pOU1=gpio.read(cfg.pOU1);j.pOU2=gpio.read(cfg.pOU2)
                    local jn = require "cjson"
                    cn:send("HTTP/1.1 200 OK\r\n\r\n"..jn.encode(j))
                    cn:close()
                    return
                end
            end
            file.open(f,"r")
            while true do
                local ln=file.readline()
                if ln == nil then break end
                for i,v in pairs(cfg) do 
                    ln = string.gsub(ln, '$'..i, v)
                end
                cn:send(ln)
            end
            file.close()
            cn:close()
        end)
end
