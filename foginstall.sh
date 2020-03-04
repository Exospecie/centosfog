# Updates your server to the latest available packages
yum update -y

# Sets your firewall up for multicast
for service in http https tftp ftp mysql nfs mountd rpc-bind proxy-dhcp samba; do firewall-cmd --permanent --zone=public --add-service=$service; 
done
echo "Open UDP port 49152 through 65532, the possible used ports for fog multicast" 
firewall-cmd --permanent --add-port=49152-65532/udp
echo "Allow IGMP traffic for multicast"
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -p igmp -j ACCEPT
systemctl restart firewalld.service
echo "Done."

# Adds firewall exceptions for DNS and DHCP. Comment out if you do not plan to use the FOG server for this.
for service in dhcp dns; do firewall-cmd --permanent --zone=public --add-service=$service; done
firewall-cmd --reload
echo Additional firewalld config done.

# Downloads the latest version of FOG and installs it via git. If you already have git installed, you can delete the first line.
yum install git -y
cd ~
mkdir git
cd git
git clone https://github.com/FOGProject/fogproject.git
cd fogproject/bin
./installfog.sh
echo "Now you should have fog installed."

