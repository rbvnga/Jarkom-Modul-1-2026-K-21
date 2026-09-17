# TERAPKAN DI SEMUA NODE
# Jalankan dulu DNS resolver
echo "nameserver 8.8.8.8" > /etc/resolv.conf

# Buat direktori autostart
mkdir -p /etc/local.d

# Buat script autostart DNS
cat > /etc/local.d/10-dns.start << 'EOF'
#!/bin/sh
echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF

chmod +x /etc/local.d/10-dns.start

apk add openrc
rc-update add local default

# verifikasi 
rc-update show | grep local
cat /etc/local.d/10-dns.start
cat /etc/resolv.conf