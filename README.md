# ESP8266-LightSwitch
2-channel ESP8266 based lightswitch for <a href="http://tronixlabs.com/wireless/esp8266/esp8266-esp-12-full-evaluation-board/">ESP8266 ESP-12 Full Evaluation Board</a>.
Work on <a href="https://github.com/nodemcu/nodemcu-firmware/releases/tag/0.9.6-dev_20150406">NodeMCU 0.9.6</a>

## Hardware
<table>
    <tr>
      <th>NodeMCU IO index</th>
      <th>ESP-12 GPIO</th>
      <th>Connection</th>
    </tr>
    <tr>
        <td>1</td>
        <td>GPIO4</td>
        <td>Output 1</td>
    </tr>
    <tr>
        <td>2</td>
        <td>GPIO5</td>
        <td>Output 2</td>
    </tr>
    <tr>
        <td>5</td>
        <td>GPIO14</td>
        <td>Input</td>
    </tr>
    <tr>
        <td>6</td>
        <td>GPIO12</td>
        <td>RGB 4-pin LED wifi indicator, green</td>
    </tr>
    <tr>
        <td>7</td>
        <td>GPIO13</td>
        <td>RGB 4-pin LED wifi indicator, blue</td>
    </tr>
    <tr>
        <td>8</td>
        <td>GPIO15</td>
        <td>RGB 4-pin LED wifi indicator, red</td>
    </tr>
</table>
## Use
http://192.168.4.1/ - Initial manual setup (you need connect to open AP which ssid='ESP')<br/>
http://[IP_adders]/ - Manual get and set state<br/>
http://[IP_adders]/get - Get state in json<br/>
http://[IP_adders]/set?pVL1=0&pVL1=0 - Set "ON" for all switchers<br/>
