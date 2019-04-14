#!/bin/bash
#Title: Crowdsurfer
#Description: Crowd Density Detection
#Author: YellowCustardCreamPuff
#Date: 14-04-2019
#Version: Crowdsurfer v1.0


sudo rm /home/pi/Crowdsurfer/out/raw-01.csv; # replace location from line 5

xterm -hold -e sudo airodump-ng wlan1mon -w /home/pi/Crowdsurfer/out/raw -o csv & #set location to store csv file

# use bluetoothctl to scan bluetooth devices.


sleep 5;

function read {
	python - <<END

content = ""
bssid = []
station_MAC = []
i = 0
toWhich = 0
p = 0
devicenum = 0


with open('out/raw-01.csv', 'r') as airdump:
	content = airdump.read()


count = content.split("\n")

while i<len(count):
	carry = count[i].split(",")

	if carry[0] == "Station MAC":
		toWhich = 1;
	elif carry[0] == "\r" or carry[0] == "BSSID":
		pass
	else:
		if toWhich == 0:
			bssid.append(carry[0])
		else:
			station_MAC.append(carry[0])
	i = i+1

outputbssid = []
for x in bssid:
	if x not in outputbssid:
		outputbssid.append(x)

outputmac = []
for x in station_MAC:
	if x not in outputmac:
		outputmac.append(x)


print "\nDevices Nearby :"

v = len(outputmac)
while p < v:
	print outputmac[p]
	p = p + 1
	devicenum = devicenum + 1

print "Number of devices Present : ", devicenum

	#with open ('peoplepresent.txt', 'w') as people:
	
peoplenames = []
for f in station_MAC:
	if (f == '8C:1A:BF:5D:F6:DC'):
		peoplenames.append("John Doe")
	elif (f == '9C:DA:3E:E5:55:24'):
		peoplenames.append("Jane Doe")
	elif (f == 'DC:EF:CA:32:AD:9F'):
		peoplenames.append("Joseph Doe")
	


#attend()
with open ('peoplepresent.txt', 'w') as people:
	for item in peoplenames:
		people.write('%s\n' %item)




with open('numberofdevices.txt', 'w') as numberofdevices:
	numberofdevices.write(str(devicenum))
	
with open('devicemacs.txt', 'w') as f:
	for item in outputmac:
		f.write('%s\n' %item)

END
}


while true; do
	read
	sudo cp numberofdevices.txt /var/www/html
	sudo cp devicemacs.txt /var/www/html
	sudo cp peoplepresent.txt /var/www/html
	sleep 20;
done
