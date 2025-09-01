#!/bin/bash
CONFIG_FILE="/etc/netplan/01-netcfg.yaml"

cat << 'EOF' | sudo tee /usr/bin/durum > /dev/null
#!/bin/bash
CONFIG_FILE="/etc/netplan/01-netcfg.yaml"

if [ -f "$CONFIG_FILE" ]; then
    GATEWAY=$(grep -E "gateway4:" "$CONFIG_FILE" | awk '{print $2}')
    if [ -n "$GATEWAY" ]; then
        echo "Mevcut Gateway: $GATEWAY"
    else
        echo "Gateway ayarlı değil."
    fi
else
    echo "$CONFIG_FILE bulunamadı."
fi
EOF

cat << 'EOF' | sudo tee /usr/bin/gateway > /dev/null
#!/bin/bash
CONFIG_FILE="/etc/netplan/01-netcfg.yaml"

if [ -f "$CONFIG_FILE" ]; then
    sed -i -E 's/^\s*gateway4:.*/gateway4: 194.116.229.1/' "$CONFIG_FILE"
    echo "Gateway 194.116.229.1 olarak ayarlandı."
    netplan apply
else
    echo "$CONFIG_FILE bulunamadı."
fi
EOF

cat << 'EOF' | sudo tee /usr/bin/anti > /dev/null
#!/bin/bash
CONFIG_FILE="/etc/netplan/01-netcfg.yaml"

if [ -f "$CONFIG_FILE" ]; then
    sed -i -E 's/^\s*gateway4:.*/gateway4: 194.116.229.254/' "$CONFIG_FILE"
    echo "Gateway 194.116.229.254 olarak ayarlandı."
    netplan apply
else
    echo "$CONFIG_FILE bulunamadı."
fi
EOF

sudo chmod +x /usr/bin/durum /usr/bin/gateway /usr/bin/anti
echo "Kurulum tamamlandı ✅";
echo "Komutlar hazır: durum | gateway | anti"
