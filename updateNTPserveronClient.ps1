stop-service w32time
w32tm /unregister
w32tm /register
start-service w32time
w32tm /config /manualpeerlist:"10.1.63.252,0x8 10.11.0.251,0x8 10.11.0.252,0x8 10.1.63.251,0x8" /syncfromflags:manual /update
w32tm /config /reliable:yes
restart-service w32time
w32tm /resync
w32tm /query /source