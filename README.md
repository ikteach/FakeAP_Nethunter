# FakeAP_Nethunter #
Made by me Ikteach & Dr. Ismail saad

This eviltwin script let you run fake access point portal with verification of any given handshake on vritually created wlan1 using Kali Nethunter
If you want to Deauth orignal network into Attack to disconnect all connected with network then you only need 1 external adapter.


## How to Usage ##

1.nano /etc/apache2/sites-enabled/000-default.conf

copy everything inside conf.txt and paste it inside default.conf like this given image

![Screenshot_20241118-105842_NetHunter_Terminal](https://github.com/user-attachments/assets/04756c79-7b68-40a1-812a-e0992d694d30)

2.run this command:
rm -rf /var/www/html/*

then

copy all portal files from inside portal folder to /var/www/html

3. run this command: 
a2enmod rewrite 

then 
run : sudo service apache2 start 

***important*** : before moving forward make sure portal is working fine by navagating to 127.0.0.1 in web browser .. if it show forbidden you need to manage permission with chmod commands

4. copy target handshake inside our main folder and rename it to evil.cap

5. run this command :

aircrack-ng evil.cap
 
you will get your target bssid copy it .. 
then 
nano passapi.py  
replace it in the 5th line 

7.python3 passapi.py

8. deauth your target network with external adapter and make sure adapter is recognised as wlan2

9.nano hostapd.conf and change network name tenda to your target network name

8.if you wanna share internet from internal wifi use fakeap.sh .. if you wanna share mobile internet use 4g script .. make sure to edit path files inside the script depending on your files locations then you can run the script

you can use any portal you want with the script .. if its flask portal make sure to host it on 10.0.0.1 and port 80

want to thanks @dr_ismail_saad to Check all codes and test it 
want to thanks @yesimxev for internet sharing rules

and thanks @Justxd22 for handshake
verification methods and portals you can check his repo here

https://github.com/Justxd22/Eviltwin-Huawei_XD
