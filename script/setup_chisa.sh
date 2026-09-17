#!/bin/sh

echo "=== Setup Chisa dimulai ==="

# --- DNS Resolver ---
echo "nameserver 8.8.8.8" > /etc/resolv.conf

# --- Install vsftpd ---
apk update
apk add vsftpd

# --- Buat 3 user pakai BusyBox adduser (selalu tersedia, tidak perlu install) ---
id alice >/dev/null 2>&1 || adduser -h /var/wired/data -s /sbin/nologin -D alice
id mika  >/dev/null 2>&1 || adduser -h /var/wired/data -s /sbin/nologin -D mika
id eiri  >/dev/null 2>&1 || adduser -h /var/wired/data -s /sbin/nologin -D eiri

# --- Buat folder shared ---
mkdir -p /var/wired/data
chown alice:alice /var/wired/data
chmod 755 /var/wired/data

# --- Config utama vsftpd ---
mkdir -p /etc/vsftpd/user_conf
cat > /etc/vsftpd/vsftpd.conf << 'CONF'
listen=YES
anonymous_enable=NO
local_enable=YES
write_enable=YES
chroot_local_user=YES
allow_writeable_chroot=YES
local_umask=022
seccomp_sandbox=NO
userlist_enable=YES
userlist_deny=YES
userlist_file=/etc/vsftpd/blocked_users
user_config_dir=/etc/vsftpd/user_conf
pasv_enable=YES
pasv_min_port=30000
pasv_max_port=30100
CONF

echo "eiri" > /etc/vsftpd/blocked_users

cat > /etc/vsftpd/user_conf/alice << 'CONF'
local_root=/var/wired/data
write_enable=YES
CONF

cat > /etc/vsftpd/user_conf/mika << 'CONF'
local_root=/var/wired/data
write_enable=NO
CONF

pgrep vsftpd > /dev/null || vsftpd /etc/vsftpd/vsftpd.conf 2>/dev/null &

echo "=== Setup Chisa selesai ==="