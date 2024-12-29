#!/bin/bash
GREEN='\033[0;32m'
NC='\033[0m'
echo -n -e "${GREEN}Yeni IP adresini giriniz: ${NC}";
read IPv4;
config_file="/etc/netplan/config.yaml"
if [ -f "$config_file" ]; then
    echo -e "${GREEN}$config_file dosyası mevcut. Siliniyor...${NC}"
    rm -rf $config_file
else
    echo -e "${GREEN}$config_file dosyası bulunamadı. Yeni dosya oluşturulacak...${NC}"
fi
IFS='.' read -r -a ip_parts <<< "$IPv4"
gateway="${ip_parts[0]}.${ip_parts[1]}.${ip_parts[2]}.254"
cat <<EOF > $config_file
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      addresses: [$IPv4/24]
      gateway4: $gateway
      dhcp4: no
      nameservers:
        addresses: [1.1.1.1, 9.9.9.9]
EOF
netplan apply;
echo -e "${GREEN}Yeni IP adresi: $IPv4${NC}";
echo -e "${GREEN}Yeni yapılandırma başarıyla uygulandı.${NC}"
