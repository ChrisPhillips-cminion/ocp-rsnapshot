






src_1=/usr/rsnapshot/rsnapshot.conf; target_1=backup
src_2=cminion@dns.phillips11.cf:/etc/bind/; target_2=dns
src_3=core@192.168.1.37:/home/core/backup/; target_3=ocp
src_4=dietpi@dashboard.phillips11.cf:/home/pi/; target_4=dashboard
src_5=root@drydock.phillips11.cf:/var/install*; target_5=drydock/install
src_6=root@drydock.phillips11.cf:/usr/local/bin; target_6=drydock/bin
src_7=root@drydock.phillips11.cf:/root/; target_7=drydock/root
src_8=root@drydock.phillips11.cf:/etc/letsencrypt; target_8=drydock/certs
src_9=cminion@homebridge.phillips11.cf:/var/lib/homebridge; target_9=homebridge
src_10=cminion@pihole.phillips11.cf:/etc/pihole/; target_10=pihole
src_11=cminion@blockbuster.phillips11.cf:/home/cminion/rdt; target_11=blockbuster


mkdir tmp
cd tmp
for i in {1..11} ; do
	srcNo=src_$i
	targetNo=target_$i
	sed -e s,SRC,${!srcNo},g ../cj.yaml | sed -e s,TARGETSLUG,$(echo ${!targetNo} | sed -e s/\\//-/g),g | sed -e s,TARGET,${!targetNo},g > $(echo ${!targetNo} | sed -e s/\\//-/g).yaml
done
cd ..

oc apply -f tmp
rm -rf tmp
