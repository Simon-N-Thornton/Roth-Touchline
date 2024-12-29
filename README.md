# RothTouchline

Scripts and Information about the Roth Touchline range of underfloor heating controllers.

URL: http://xxx.xxx.xxx.xxx/readVal.cgi?variable  
IP                       :      192.168.5.19  

**Device Parameters**

| Variable               | Values            | Description                           |  
| ---                    | ---               | ---                                   | 
| CD.name                |                   | Device name (only certain FW versions |  
| CD.upass               | 1234              | User interface password (default 1234) |  
| STELL-APP              | 1.42              | Internal Version number (RO) |  
| STELL-BL               | 1.20              | Module version |  
| STM-BL                 | 1.20              | MOdule version |  
| hw.IP                  | 192.168.5.19      | IP Address of Device |  
| hw.NM                  | 255.255.255.0     | Netmask of IP |  
| hw.Addr                | 5C-C2-13-00-D8-18 | MAC address of Interface |  
| hw.DNS1                | 192.168.5.1       | IP address of DNS entry #1 |  
| hw.DNS2                | 192.168.5.44      | IP address of DNS entry #1 |  
| hw.GW                  | 192.168.5.5       | Default route |  
| hw.HostName            | ROTH-00D818       | Hostname (default ROTH-<last 4 digits of MAC) |  
| totalNumberOfDevices   | 4                 | Number of thermostats attached, 4 indicates thermostats 0-3 |  
| numberOfSlaveControllers | 0               | Number of slave controllers attach |  
| VPI.href               | http://myroth.ininet.ch/remote/t_<uniqueID>/ | URL of remote access point, see uniqueID below |  
| VPI.state              | 99                | Remote access point status |  
| isMaster               | 1                 | Is this a master or slave (push master button for this to work) |  
| Status                 | Server: Roth/1.0 (powered by SpiderControl TM), CGI=0|ILR=0, V.1.0, ILR2=0, V.2.00, ILR3=1, V.1.00 | Status of webserver components |  


** Thermostat parameters**

Gx indicates the thermostat index (0 to totalNumberofDevices-1)  

| Variable               | Values            | Description |  
| G0.name                | <Whatever>        | Name of thermostat, if set |  
G0.RaumTemp              :      20.94
G0.SollTemp              :      20.00
G0.SollTempMaxVal        :      22.00
G0.SollTempMinVal        :      20.00
G0.TempSIUnit            :      0
G0.WeekProgEna           :      1
G0.OPMode                :      0       Normal
G0.OPModeEna             :      1
G0.kurzID                :      1
G0.ownerKurzID           :      69
G1.name                  :      Living Room
G1.RaumTemp              :      20.21
G1.SollTemp              :      19.50
G1.SollTempMaxVal        :      30.00
G1.SollTempMinVal        :      05.00
G1.TempSIUnit            :      0
G1.WeekProgEna           :      1
G1.OPMode                :      0       Normal
G1.OPModeEna             :      1
G1.kurzID                :      2
G1.ownerKurzID           :      69
G2.name                  :      Hall
G2.RaumTemp              :      20.45
G2.SollTemp              :      20.00
G2.SollTempMaxVal        :      30.00
G2.SollTempMinVal        :      05.00
G2.TempSIUnit            :      0
G2.WeekProgEna           :      1
G2.OPMode                :      0       Normal
G2.OPModeEna             :      1
G2.kurzID                :      3
G2.ownerKurzID           :      69
G3.name                  :      Downstairs Bathroom
G3.RaumTemp              :      19.42
G3.SollTemp              :      18.00
G3.SollTempMaxVal        :      30.00
G3.SollTempMinVal        :      05.00
G3.TempSIUnit            :      0
G3.WeekProgEna           :      1
G3.OPMode                :      0       Normal
G3.OPModeEna             :      1
G3.kurzID                :      4
G3.ownerKurzID           :      69
R0.DateTime              :      Sat Dec 30 15:33:54 CET 2023
R0.ErrorCode             :      0
R0.OPModeRegler          :      0
R0.Safety                :      0
R0.SystemStatus          :      0
R0.Taupunkt              :      0
R0.WeekProgWarn          :      1
R0.kurzID                :      69
R0.numberOfPairedDevices :      4
R0.uniqueID              :      53FF71064989495318460287
