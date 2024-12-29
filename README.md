# RothTouchline

Scripts and Information about the Roth Touchline range of underfloor heating controllers.  

Data from the controller can be accessed using the web interface endpoints readVal.cgi and writeVal.cgi. e.g.  

Read  Value: http://xxx.xxx.xxx.xxx/readVal.cgi?variable  
Write Value: http://xxx.xxx.xxx.xxx/writwVal.cgi?variable=value  
  
IP address: xxx.xxx.xxx.xxx  
  
### Device Parameters  
  
| Variable                 | Values            | Description |  
| ---                      | ---               | --- | 
| CD.name                  |                   | Device name (only certain FW versions) |  
| CD.upass                 | 1234              | User interface password (default 1234) |  
| STELL-APP                | 1.42              | Internal Version number (RO) |  
| STELL-BL                 | 1.20              | Module version |  
| STM-BL                   | 1.20              | MOdule version |  
| hw.IP                    | xxx.xxx.xxx.xxx   | IP Address of Device |  
| hw.NM                    | 255.255.255.0     | Netmask of IP |  
| hw.Addr                  | 5C-AB-23-DF-FF-FA | MAC address of Interface |  
| hw.DNS1                  | dd1.dd1.dd1.dd1   | IP address of DNS entry #1 |  
| hw.DNS2                  | dd2.dd3.dd2.dd2   | IP address of DNS entry #2 |  
| hw.GW                    | zzz.zzz.zzz.zzz   | Default route |  
| hw.HostName              | ROTH-DFFFFA       | Hostname (default ROTH-last_6_digits_of_MAC |  
| totalNumberOfDevices     | 4                 | Number of thermostats attached, 4 indicates thermostats 0-3 |  
| numberOfSlaveControllers | 0                 | Number of slave controllers attach |  
| VPI.href                 | http://myroth.ininet.ch/remote/t_uniqueID/ | URL of remote access point, see uniqueID below |  
| VPI.state                | 99                | Remote access point status |  
| isMaster                 | 1                 | Is this a master or slave (push master button for this to work) |  
| Status                   | Server: Roth/1.0 (powered by SpiderControl TM), CGI=0|ILR=0, V.1.0, ILR2=0, V.2.00, ILR3=1, V.1.00 | Status of webserver components |  
|                          |                   |  
| R0.DateTime              | EPOCH datetime    | Date/time since 1970 e.g. 1703956882 or " Sat Dec 30 15:33:54 CET 2023", can be updated |  
| R0.ErrorCode             | 0                 | Current error |  
| R0.OPModeRegler          | 0                 | ??? |  
| R0.Safety                | 0                 | ??? |  
| R0.SystemStatus          | 0                 | System status, 0=off, 1=running |  
| R0.Taupunkt              | 0                 | ??? |  
| R0.WeekProgWarn          | 1                 | ??? |  
| R0.kurzID                | 69                | same as Gx.kurzID
| R0.numberOfPairedDevices | 4                | Number of paired devices, same as 'totalNumberOfDevices' |  
| R0.uniqueID              | 53FF710649895434 | Unique identifier, used to construct VPI.href | 


### Thermostat parameters  
These parameters can be updated using the writeVal.cgi?variable=value  

Gx indicates the thermostat index (0 to totalNumberofDevices-1)  

| Variable               | Values            | Description |  
| ---                    | ---               | --- | 
| Gx.name                | <Whatever>        | Name of thermostat, if set |  
| Gx.RaumTemp            | 2094              | Room temperature, 20.94 |  
| Gx.SollTemp            | 2000              | Room set temperature, 20.00 |  
| Gx.SollTempMaxVal      | 2600              | Max temperature allowed for SollTemp, 26.00 |  
| Gx.SollTempMinVal      | 1600              | Min temperature allowed for SollTemp, 16.00 |  
| Gx.TempSIUnit          | 0                 | Temperature scale, 0=C, 1=F |  
| Gx.WeekProgEna         | 1                 | Weekly mode enabled |  
| Gx.OPMode              | 0-2               | Operation Mode: 0=Normal, 1=Night, 2=Vacation |  
| Gx.OPModeEna           | 0-1               | Thermostat enabled (1) or disabled (0) |  
| Gx.kurzID              | 1                 | ??? Same for all thermostats |  
| Gx.ownerKurzID         | 69                | ??? Same for all thermostats |  
