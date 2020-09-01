./waf configure --board IMF405 --bootloader
./waf clean
./waf bootloader
dfu-util -a 0 --dfuse-address 0x08000000 -D build/IMF405/bin/AP_Bootloader.bin -R
