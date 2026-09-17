# Install dan aktifkan layanan OpenSSH
apk add openssh
rc-update add sshd default
rc-service sshd start

# Buat akun administrator mika_admin
adduser -D mika_admin
echo "mika_admin:password123" | chpasswd

# Hardening: Matikan Password Authentication & Aktifkan Pubkey Auth
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# Apply konfigurasi
rc-service sshd restart

# Buat user mika_admin dan pindah ke akun tersebut
adduser -D mika_admin
su - mika_admin

# Generate pasangan kunci RSA 4096-bit
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""

# Salin Public Key ke node Knights
ssh-copy-id mika_admin@10.74.3.2

# Pengujian 1: Login tanpa password (Harus Sukses)
ssh mika_admin@10.74.3.2

# Pengujian 2: Uji Pembuktian Hardening Password Authentication (Harus Ditolak)
ssh -o PubkeyAuthentication=no mika_admin@10.74.3.2
