# Jarkom-Modul-1-2026-K-21

| Nama                          | NRP        |
| ----------------------------- | ---------- |
| Revalinda Bunga Nayla Laksono | 5027251011 |
| Najla Tufailah                | 5027251078 |

# 1 2 - Membangun The Wired

**Membuat 3 Switch/Gateway dimana, kelima entitas ini di konfigurasi sebagai client di GNS3, lalu mengkonfigurasi router lain agar daoat tersembung ke internet publik NAT/DHCP pada interface eth0**

- Switch 1 menuju Alice dan Mika <br>
- Switch 2 menuju Chisa <br>
- Switch 3 menuju Knights dan Eiri <br>

<img width="1864" height="1402" alt="image" src="https://github.com/user-attachments/assets/e8639d4e-0fd6-428b-ac60-5742fabf3c76" />
- Router 1 pusat dengan 3 interface (eth1, eth2, eth3) menuju 3 switch berbeda
- Switch1 → Alice & Mika (2 client)
- Switch2 → Chisa (1 client)
- Switch3 → Knights & Eiri (2 client)
- NAT1 terhubung ke Router lewat eth0, ini untuk akses ke internet publik

### Konfigurasi Router

```
auto eth0
iface eth0 inet dhcp
       up sysctl -w net.ipv4.ip_forward=1
       up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
auto eth1
iface eth1 inet static
    address 10.74.1.1
    netmask 255.255.255.0

auto eth2
iface eth2 inet static
    address 10.74.2.1
    netmask 255.255.255.0

auto eth3
iface eth3 inet static
    address 10.74.3.1
    netmask 255.255.255.0
```

Node Router, yang mengatur 4 interface jaringan sekaligus: 1 interface ke arah internet (dengan NAT), dan 3 interface sebagai gateway ke masing-masing segmen/switch.

- `auto eth0` → interface eth0 otomatis diaktifkan saat sistem boot/network service jalan.
- `iface eth0 inet dhcp` → interface ini pakai DHCP (dapat IP otomatis dari luar).
- `netmask 255.255.255.0` → subnet mask-nya (sama dengan /24).
- `up sysctl -w net.ipv4.ip_forward=1`
  Perintah `up` berarti dijalankan setelah interface ini aktif. `sysctl -w net.ipv4.ip_forward=1` mengaktifkan IP forwarding di kernel Linux. Hal ini membuat Router bisa meneruskan paket dari satu interface ke interface lain (tanpa ini, Linux akan berperilaku seperti host biasa yang cuma menerima/mengirim paket untuk dirinya sendiri, bukan meneruskan punya orang lain)
- `up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE`
  Menambahkan (`-A`) rule ke tabel NAT, bagian `POSTROUTING` (diterapkan pada paket yang keluar), untuk interface eth0 (`-o eth0`), dengan aksi `MASQUERADE` yang berarti semua paket yang keluar lewat eth0 akan "disamarkan" memakai IP publik eth0, supaya client-client di segmen internal bisa mengakses internet meskipun IP mereka privat
- `iface eth1 inet static` → interface ini pakai IP statis (ditentukan manual, bukan DHCP).
- `address 10.74.x.x` -> Menunjukkan IP router pada segmen tersebut sekaligus berfungsi sebagai gateway bagi semua client yang ada di switch yang terhubung. <br>
  Garis Besar:

1. eth0 → ke arah internet/NAT (dinamis, DHCP) <br>
2. eth1 → gateway segmen 1 (statis, 10.10.1.1) <br>
3. eth2 → gateway segmen 2 (statis, 10.10.2.1) <BR>

### Konfigurasi Client Alice

```bash
auto eth0
iface eth0 inet static
    address 10.74.1.2
    netmask 255.255.255.0
    gateway 10.74.1.1
```

### Konfigurasi Client Mika

```bash
auto eth0
iface eth0 inet static
    address 10.74.1.3
    netmask 255.255.255.0
    gateway 10.74.1.1
```

### Konfigurasi Client Chisa

```bash
auto eth0
iface eth0 inet static
    address 10.74.2.2
    netmask 255.255.255.0
    gateway 10.74.2.1
```

### Konfigurasi Client Knights

```bash
auto eth0
iface eth0 inet static
    address 10.74.3.2
    netmask 255.255.255.0
    gateway 10.74.3.1
```

### Konfigurasi Client Eiri

```bash
auto eth0
iface eth0 inet static
    address 10.74.3.3
    netmask 255.255.255.0
    gateway 10.74.3.1
```

**Pemetaan IP per client**
| Client | IP Address | Gateway | Segmen (Terhubung ke) |
|----------|----------|----------|----------|
| Alice | 10.74.1.2 | 10.74.1.1 | Switch 1 (eth1 Router) |
| Mika | 10.74.1.3 | 10.74.1.1 | Switch 1 (eth1 Router) |
| Chisa | 10.74.2.2 | 10.74.2.1 | Switch 2 (eth2 Router) |
| knights | 10.74.3.2 | 10.74.3.1 | Switch 3 (eth3 Router) |
| Eiri | 10.74.3.3 | 10.74.3.1 | Switch 3 (eth3 Router) |

# 3

**Memastikan seluruh entitas (client) di bawah Switch 1, Switch 2, Switch 3 dapat saling terhubung dan berkomunikasi satu sama lain**

## Alice ke Client Lain

<img width="700" height="500" alt="image" src="https://github.com/user-attachments/assets/151db998-8dc9-4dc9-9fbb-7d0fb40f115b" />

## Mika ke Client Lain

<img width="700" height="500" alt="image" src="https://github.com/user-attachments/assets/71d002bc-71e9-4e5f-a932-aecec0ebd295" />

## Chisa ke Client Lain

<img width="700" height="500" alt="image" src="https://github.com/user-attachments/assets/f73315af-8c8b-4e59-9fee-823dce1afe1b" />

## Knights ke Client Lain

<img width="700" height="500" alt="image" src="https://github.com/user-attachments/assets/6244fd34-0fe7-48d7-aa3b-151faf427a4e" />

## Eiri ke Client Lain

<img width="700" height="500" alt="image" src="https://github.com/user-attachments/assets/08767df8-5f4b-4628-be4c-854d999635af" />

# 4

**Mengkonfigurasikan firewall/ipables (NAT Masquerade) dan DNS Resolver agar setiap client dapat terhubung secara mendiri**

### 4.1 Set DNS resolver

```sh
echo "nameserver 8.8.8.8" > /etc/resolv.conf
```

Perintah ini menulis alamat DNS publik Google (`8.8.8.8`) ke file konfigurasi resolver sistem, sehingga node dapat mulai menerjemahkan nama domain.

### 4.2 Buat direktori autostart

```sh
mkdir -p /etc/local.d
```

### 4.3 Buat script autostart DNS

```sh
cat > /etc/local.d/10-dns.start << 'EOF'
#!/bin/sh
echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF

chmod +x /etc/local.d/10-dns.start
```

Menuliskan ulang konfigurasi DNS secara otomatis setiap kali sistem melakukan boot, sehingga konfigurasi tidak hilang saat node di-restart.

### 4.4 Daftarkan service `local` ke runlevel default

```sh
rc-update add local default
```

OpenRC (init system Alpine) akan menjalankan seluruh script di dalam `/etc/local.d/` setiap boot hanya jika service `local` sudah terdaftar pada runlevel `default`.

### 4.5 Verifikasi konfigurasi

```sh
rc-update show | grep local
cat /etc/local.d/10-dns.start
cat /etc/resolv.conf
```
<img width="1674" height="766" alt="Screenshot 2026-09-17 170058" src="https://github.com/user-attachments/assets/20b6c010-07f3-469f-bc87-518a5f138a0b" />
<img width="1632" height="614" alt="Screenshot 2026-09-17 171205" src="https://github.com/user-attachments/assets/f9dfa156-fbef-4993-a17e-09192a57210e" />
<img width="1632" height="614" alt="Screenshot 2026-09-17 171205" src="https://github.com/user-attachments/assets/943fea8d-7f44-49a4-903e-8a82bc9ff166" />
<img width="778" height="328" alt="Screenshot 2026-09-17 171414" src="https://github.com/user-attachments/assets/a690abf7-1f0b-4ed9-8766-373d9b8c803c" />
<img width="780" height="306" alt="Screenshot 2026-09-17 172053" src="https://github.com/user-attachments/assets/e36ff034-ab21-4915-95b3-5ca40f6e84b9" />



# 5

**Memastikan seluruh konfigurasi jaringan, dengan membuat script verivikasi**
<img width="1076" height="948" alt="image" src="https://github.com/user-attachments/assets/c613b72a-a4f2-4991-be27-4114a5025385" />
Untuk memastikan konfigurasi jaringan tersebut dibuat script dalam node Router yang berisi
```
#!/bin/bash
echo "=== Ringkasan Interface ==="
ip -br a
echo ""
echo "=== Status Tabel NAT ==="
iptables -t nat -L -v -n
```


# 6

**Menyaring paket yang berprotokol DNS atau ICMP melalui Wireshark pada interface node Mika**
### 6.1 Mendownload traffic generator
# Mendownload zip di dalam drive
```
wget --no-check-certificate \
  "https://drive.google.com/uc?export=download&id=1G9zIi20ofbOgfffor-i-e7QKU3Ihe42W" \
  -O traffic_protocol7.zip
```
### 6.2 Me-unzip dan jalankan traffic generator
```
# unzip 
unzip traffic_protocol7.zip

# Mengatur Eksekusi 
chmod +x traffic_protocol7.sh

# Menjalankan traffic untuk di analisis
./traffic_protocol7.sh
```

### 6.3 Ketika Paket dikirimkan 
<img width="1347" height="1365" alt="WhatsApp Image 2026-09-17 at 22 22 54" src="https://github.com/user-attachments/assets/4cc48cd7-9b42-4cb6-8b8f-5b8915134f0e" />

<img width="909" height="575" alt="Tangkapan Layar 2026-09-20 pukul 17 48 49" src="https://github.com/user-attachments/assets/d51940a3-eaa3-408c-a8b1-b13a9648aaf3" />

<img width="925" height="579" alt="Tangkapan Layar 2026-09-20 pukul 17 49 08" src="https://github.com/user-attachments/assets/6f851d2e-d4d7-479b-b2f8-8c456fe2c72c" />



# 7

**Chisa mendirikan FTP Server dengan shared folder /var/wired/data
dan menerapkan beberapa kebijakan akses tertentu pada user Alice, Mika, Eiri**

### 7.1 Konfigurasi
Untuk memudahkan konfigurasi dibuat script yang berisi: 
```
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
```
### 7.2 Konfigurasi utama vsftpd
```
listen=YES              → vsftpd jalan sebagai standalone daemon
anonymous_enable=NO     → login anonim DIMATIKAN, harus pakai akun
local_enable=YES        → izinkan login pakai akun user lokal Linux
write_enable=YES        → izinkan operasi tulis (default global)
chroot_local_user=YES   → user di-"kurung" di dalam home dir-nya, gak bisa keluar ke filesystem lain
allow_writeable_chroot=YES → izinkan chroot walau home dir writable (biasanya vsftpd nolak demi security, ini di-override)
local_umask=022         → permission default file yang di-upload
seccomp_sandbox=NO      → matikan sandbox seccomp (sering perlu di container/Alpine biar gak error)
userlist_enable=YES     → aktifkan fitur whitelist/blacklist user
userlist_deny=YES       → mode userlist_file jadi BLACKLIST (user yang ada di file DITOLAK)
userlist_file=/etc/vsftpd/blocked_users → lokasi file blacklist
user_config_dir=/etc/vsftpd/user_conf   → folder berisi config KHUSUS per-user (override config global)
pasv_enable=YES + pasv_min/max_port     → mode Passive FTP, port data 30000-30100
```
### 7.3 Pembuktian

```
ftpput -u alice -p alice123 10.74.2.2 signal_alice.txt signal_alice.txt
```
<img width="860" height="204" alt="Screenshot 2026-09-18 000109" src="https://github.com/user-attachments/assets/6fb71b0e-a12d-4f7a-91f1-f7c20ea8c0ce" />

# 8

**Menganalisis sesi Wireshark ketika Knights mengupload file ke FTP server Chisa**
### 8.1 Mendownload file yang diberikan untuk di upload
```
# Jalankan dari Console Knights
wget --no-check-certificate \
  "https://drive.google.com/uc?export=download&id=1lFepK4wFmx55PnRki3NsHW-ivudSR0vg" \
  -O knights_report.zip

unzip knights_report.zip
```

### 8.2 Mengupload file dari Knights ke Chisa
```
ftpput -u alice -p alice123 10.74.2.2 knights_report.txt knights_report.txt
```
### 8.3 Analisis WireShark
<img width="2486" height="1486" alt="Screenshot 2026-09-15 192713" src="https://github.com/user-attachments/assets/66b788a0-e00b-4fb1-8f32-2a0a26504039" />
| Baris | Isi |
|---|---|
| No. 20 | Request: STOR knights_report.txt ✓ ini perintah upload-nya |
| No. 27 | Response: 226 Transfer complete. ✓ ini kode sukses-nya |
| No. 16 | Response: 229 Entering Extended Passive Mode (\|\|\|30051\|) ← ini yang beda |

## Kenapa yang muncul 229, bukan 227?

Client kamu (BusyBox ftpput) pakai perintah EPSV (Extended Passive Mode), bukan PASV biasa — bisa dilihat di baris No. 15: Request: EPSV. EPSV itu versi modern/extended dari PASV, fungsinya sama persis (menegosiasikan port data), cuma formatnya beda dan responsnya pakai kode 229, bukan 227.

## Bedanya di format penulisan port:

- PASV (227) → format (h1,h2,h3,h4,p1,p2), port dihitung manual: (p1×256)+p2
- EPSV (229) → format lebih simpel: (\|\|\|port\|) — port-nya langsung tertulis, tidak perlu dihitung

Jadi dari baris kamu:

229 Entering Extended Passive Mode (\|\|\|30051\|)

Port data-nya langsung = 30051, tidak perlu rumus apa-apa lagi.

## Kesimpulan untuk laporan kamu

Ketiganya sudah lengkap ada di capture:

- Perintah STOR: STOR knights_report.txt (paket No. 20)
- Kode status sukses: 226 Transfer complete. (paket No. 27)
- Port data yang dinegosiasikan: 30051, dari respons 229 Entering Extended Passive Mode (\|\|\|30051\|)

# 9
**Mika akses file yang diberikan dari FTP Server Chisa dan mengunduhnya dan buktikan pembatasan read-only mika**
# 9.1 Mencoba Upload
```
ftpput -u mika -p mika123 10.74.2.2 percobaan_mika.txt percobaan_mika.txt
```
Hasilnya: 
<img width="1578" height="84" alt="Screenshot 2026-09-17 233806" src="https://github.com/user-attachments/assets/3c6b77a8-3737-4d2f-b828-a61b8a9064ef" />




Analisis Wireshark
<img width="2880" height="1800" alt="Screenshot 2026-09-15 202520" src="https://github.com/user-attachments/assets/f69b46a7-b7d5-49e0-a57c-050ff6f5cd36" />

# 9.2 Chisa Mendownload file yang diberikan 
```
wget --no-check-certificate \
  "https://drive.google.com/uc?export=download&id=1tKZu0rcti4t-fXX4jtXDSKDBWzsawfoN" \
  -O protocol7_manifesto.zip

unzip protocol7_manifesto.zip

```
# 9.3 Mencoba Akses

```
# mencoba akses
ftpget -u mika -p mika123 10.74.2.2 protocol7_manifesto.txt protocol7_manifesto.txt

# cek verivikasi
ls -la protocol7_manifesto.txt
```
Hasilnya
<img width="1764" height="120" alt="Screenshot 2026-09-15 202708" src="https://github.com/user-attachments/assets/85dbb9b4-bfef-4cf2-a69e-8f8d2447a7a9" />

```
cat protocol7_manifesto.txt
```
Hasilnya
<img width="2880" height="1800" alt="Screenshot 2026-09-15 202811" src="https://github.com/user-attachments/assets/f918f1f7-6178-4de5-9a3f-a88c12e6b7c0" />

Analisis Wiresharak
<img width="2880" height="1800" alt="Screenshot 2026-09-15 203039" src="https://github.com/user-attachments/assets/7f28b495-8868-41c7-a257-293e92f60bbb" />

# 10

**Mencatat nilai ICMP Type dan Code untuk Echo Request vs Echo Reply, serta analisis packet loss dan RTT (min/avg/max) ketika Knights mengirimkan ping ke node Chisa**

### 10.1 Mengirim Paket
```
ping -c 77 -s 128 -i 0.3 10.74.2.2
```
### 10.2 Analisis Wireshark Chisa 
<img width="2880" height="1800" alt="Screenshot 2026-09-15 205043" src="https://github.com/user-attachments/assets/c312130e-f6bb-4651-8f79-f65ce396abe2" />
### 10.2.1 Analisis Wireshark Chisa - filtering
<img width="2880" height="1800" alt="Screenshot 2026-09-15 205446" src="https://github.com/user-attachments/assets/2e3d24d3-11df-466d-9438-a09bd7c594d5" />
### 10.3 Analisis Wireshark Knights
<img width="2880" height="1800" alt="Screenshot 2026-09-15 205255" src="https://github.com/user-attachments/assets/5c681df8-28a2-4a43-9535-bd73eec30b48" />
### 10.2.1 Analisis Wireshark Knights - filtering
<img width="2880" height="1800" alt="Screenshot 2026-09-15 205513" src="https://github.com/user-attachments/assets/7ca5b975-7704-45d3-94f5-05d94a96042c" />
<img width="2880" height="1712" alt="Screenshot 2026-09-15 205956" src="https://github.com/user-attachments/assets/c96adb60-bd60-4a94-9c3b-c652be422c31" />


# 11

**Membuktikan kelemahan protokol telnet dengan membuat akun baru pada layanan telnetd di node Chisa, lalu menunjukkan kredensial plain text**

- Membuat akun Phantom_user dan men-setting password nya wired_ghost

```
adduser phantom_user
passwd phantom_user
```

- Menyalakan telnetd

```
telnetd -l /bin/login &
netstat -tulnp | grep 23
```

- Login dari akun Eiri dengan memasukkan username: Phantom_user dan password: wired_ghost
<img width="716" height="650" alt="image" src="https://github.com/user-attachments/assets/de28de68-61ab-4de0-8814-5a856107963a" />
<img width="1398" height="382" alt="image" src="https://github.com/user-attachments/assets/261844da-6000-460b-82c3-3194703af16b" />

- Analisis Wireshark - Filter: telnet
  <img width="2880" height="1700" alt="Screenshot 2026-09-15 212629" src="https://github.com/user-attachments/assets/d40c3c74-4e6b-4c94-bb2c-beb24df5d9a7" />
- Analisis Wireshark - TCP Stream
  <img width="2536" height="1214" alt="Screenshot 2026-09-15 213208" src="https://github.com/user-attachments/assets/11dfad55-cea8-4318-8c08-d10e27be3cc1" />
  <img width="2880" height="1800" alt="Screenshot 2026-09-15 213059" src="https://github.com/user-attachments/assets/f296c21c-6987-44a7-99ed-3c7178ced695" />
  <img width="2880" height="1800" alt="Screenshot 2026-09-15 213142" src="https://github.com/user-attachments/assets/338a6347-abd2-4664-8b3b-18d9044e5d4e" />

# 12

**Melakukan pemindaian port dari node Alice ke node Knights menggunakan Netcat (nc) untuk memeriksa beberapa port yaitu**

- port 22 (SSH) dalam keadaan terbuka
- port 80 (HTTP) dalam keadaan terbuka
- Port (rahasia) 7777 dalam keadaan tertutup

<img width="1600" height="1041" alt="WhatsApp Image 2026-09-16 at 11 24 05" src="https://github.com/user-attachments/assets/b1c0da49-e0e8-4796-a843-e8eda6379ebf" />


# 13
Pada nomor ini, mengonfigurasi layanan OpenSSH pada node Knights,memasang autentikasi berbasis publik key untuk user mika_admin dari node mika, menerapkan ssh hardening dengan memastikan passworauthentication

Node Knights (SSH Server):
- apk add openssh && rc-service sshd start
- adduser -D mika_admin
  
Node Mika(SSH Client):
- adduser -D mika_admin && su - mika_admin
- ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
- ssh-copy-id mika_admin@10.74.3.2

Hardening di Node Knights (/etc/ssh/sshd_config):
-PubkeyAuthentication yes
- PasswordAuthentication no
- Restart SSH: rc-service sshd restart

Pada nomor ini, analisis dilakukan terhadap file capture wired_tls_decrypt.pcapng dengan mengimpor file Pre-Master-Secret keyslogfile.txt pada konfigurasi TLS Wireshark untuk mendekripsi lalu lintas data yang disembunyikan oleh Eiri.
# 13.1 
<img width="1600" height="929" alt="WhatsApp Image 2026-09-16 at 13 56 41" src="https://github.com/user-attachments/assets/c17b85a7-e330-4393-b3eb-26e7e6701c31" />


# 14

**Eiri melancarakan serangan bruce-force terhadap form login web Alice. Analisis file `wired_bruteforce.pcapng` untuk menidentifikasi bebrapa hal dan memvalidasi temuan tersebut pada socket server**

### 14.1. Memeriksa Ip Victim dan IP Attacker melalui Tab Statistics → Conversations → tab IPv4

<img width="2856" height="1312" alt="image" src="https://github.com/user-attachments/assets/76cef8d2-70f1-49f6-a20f-0eb4f45def0a" />
Pada Tab ini diketahui ip server (Alice) = 172.26.7.100 — IP ini muncul sebagai "Address B" di semua baris, artinya dia yang menerima koneksi dari 5 IP berbeda. Sedangkan Penyerang (Eiri) = 172.26.7.50
- 104 packets, 23 kB, data ini jauh lebih besar dari baris lain yang cuma 1-2 packets/~88-230 bytes
Ini pola khas brute force dimana ratusan percobaan login berturut-turut ke server yang sama menghasilkan traffic jauh lebih besar dibanding koneksi normal <br>

### 14.2 Mencari Port yang diserang melalui Tab Statistics → Conversations → tab TCP

<img width="2850" height="1702" alt="image" src="https://github.com/user-attachments/assets/5f65e6ff-c248-416a-9fcc-7390f9a588f7" /> <br>

### 14.3 LAIN ADMIN-HTTPSTREAM

<img width="2880" height="1706" alt="image" src="https://github.com/user-attachments/assets/75ad14d1-3736-473a-ab8a-7e949639ad4a" />
<img width="2856" height="1704" alt="image" src="https://github.com/user-attachments/assets/58ea5c28-d120-41f2-ba21-e3a61d1a3131" />

**Hal hal yang ditemukan** <br>

- Ip Penyerang : 172.26.7.50
- Ip Target : 172.26.7.100
- Password `lain_admin` : wired_pr0tocol_7
- Software & versi web server : Apache 2.6.62 + PHP/8.3.14

### 14.4 Cek Validasi di console Client (Alice)

```
nc 10.4.89.246 3401
```

<img width="1626" height="864" alt="image" src="https://github.com/user-attachments/assets/bb33e32d-95dc-4a86-ab0c-dc39d3e75e51" />

# 15

**Eiri telah memasang perangkat berbahaya pad anode Alice. Identifikasi Vendor ID dan Product ID perangkat USB, alamat nomor device USB, Serta pesan rahasia dari keystroke yang didapatkan**

### 15.1 Menggunakan filter `usb.idVendor and usb.idProduct` pada wireShark <br>

Filter ini menemukan satu paket dengan info **"GET DESCRIPTOR Response DEVICE"** (Frame 2). Paket ini dikirim oleh device (`1794.0.0`) ke host sebagai respons atas permintaan deskriptor USB saat proses enumerasi.
<img width="1510" height="1534" alt="Screenshot 2026-09-17 001130" src="https://github.com/user-attachments/assets/9954b390-f0f7-434d-a14f-90089d55c7a6" /> <br>
Pada panel detail, di-expand bagian **DEVICE DESCRIPTOR**, ditemukan:

```
idVendor:  Logitech, Inc. (0x046d)
idProduct: Keyboard K120 (0xc31c)
```

Setiap perangkat USB memiliki deskriptor device yang dikirim ke host saat pertama kali disambungkan (proses enumerasi). Deskriptor ini berisi metadata perangkat, termasuk Vendor ID (identitas pabrikan) dan Product ID (identitas model produk). Wireshark secara otomatis mencocokkan kedua ID ini dengan database USB-IF sehingga langsung menampilkan nama pabrikan dan nama produknya. <br>

### 15.2 Identifikasi Alamat Device USB

Untuk mencari address permanen yang di-assign ke keyboard (bukan address sementara `0` yang dipakai saat proses enumerasi awal), dilakukan dua langkah verifikasi:

**a. Melalui kolom Source pada paket interrupt (data keystroke):**

```
usb.capdata
```

Paket-paket hasil filter menunjukkan kolom **Source** berformat `bus.device.endpoint`, contoh:

```
Source: 2.7.1
```

Dari format ini:

- Bus = 2
- **Device address = 7**
- Endpoint = 1
  Saat device USB pertama kali terhubung, ia sementara menggunakan address `0` selama proses enumerasi (pertukaran deskriptor). Setelah host mengenali device melalui deskriptor tersebut, host mengirim permintaan `SET_ADDRESS` untuk menetapkan address permanen . <br>

### 15.3 Ekstraksi Data Keystroke (HID Report)

Filter untuk mengisolasi seluruh paket yang membawa data keystroke:

```
usb.capdata
```

Filter ini mengembalikan 60 dari 85 total paket dalam capture. Untuk mengekstrak seluruh payload byte HID

```
"C:\Program Files\Wireshark\tshark.exe" -r "C:\Users\User\OneDrive\Documents\soal15_wired_usb_hid.pcap" -Y "usb.capdata" -T fields -e frame.number -e usb.capdata
```

Hasil Output : <br>

```
26      02001a0000000000
27      0000000000000000
28      00000c0000000000
29      0000000000000000
30      0000150000000000
31      0000000000000000
32      0000080000000000
33      0000000000000000
34      0000070000000000
35      0000000000000000
36      02002d0000000000
37      0000000000000000
38      0200130000000000
39      0000000000000000
40      0000150000000000
41      0000000000000000
42      0000120000000000
43      0000000000000000
44      0000170000000000
45      0000000000000000
46      0000120000000000
47      0000000000000000
48      0000060000000000
49      0000000000000000
50      0000120000000000
51      0000000000000000
52      00000f0000000000
53      0000000000000000
54      02002d0000000000
55      0000000000000000
56      0000240000000000
57      0000000000000000
58      02002d0000000000
59      0000000000000000
60      00000c0000000000
61      0000000000000000
62      0000160000000000
63      0000000000000000
64      02002d0000000000
65      0000000000000000
66      0000040000000000
67      0000000000000000
68      00000f0000000000
69      0000000000000000
70      00000c0000000000
71      0000000000000000
72      0000190000000000
73      0000000000000000
74      0000080000000000
75      0000000000000000
76      02002d0000000000
77      0000000000000000
78      00001f0000000000
79      0000000000000000
80      0000270000000000
81      0000000000000000
82      00001f0000000000
83      0000000000000000
84      0000230000000000
85      0000000000000000
```

Setiap baris hasil ekstraksi merepresentasikan satu HID Report sepanjang 8 byte dengan format:

```
[byte0: modifier][byte1: reserved][byte2: key1]...[byte7: key6]
```

Baris dengan nilai `0000000000000000` menandakan event **key-release** (tidak ada tombol tertekan) dan diabaikan dalam proses decoding. Baris dengan isi pada byte ketiga (index 2) menandakan tombol yang sedang ditekan (key-press).

### 15.4 Decoding Keystroke menjadi Teks

Setiap byte key-code dicocokkan dengan tabel **HID Usage ID Keyboard/Keypad Page**:

| Kode Hex | Karakter              | Kode Hex  | Karakter            |
| -------- | --------------------- | --------- | ------------------- |
| 0x04     | a                     | 0x13      | p                   |
| 0x06     | c                     | 0x15      | r                   |
| 0x07     | d                     | 0x16      | s                   |
| 0x08     | e                     | 0x17      | t                   |
| 0x0C     | i                     | 0x19      | v                   |
| 0x0F     | l                     | 0x1A      | w                   |
| 0x12     | o                     | 0x1F–0x27 | 2, 3, ... 0 (angka) |
| 0x2D     | - / \_ (dengan Shift) |           |                     |

Modifier byte `0x02` menandakan **Left Shift** ditekan bersamaan — mengubah huruf menjadi kapital dan mengubah tombol `0x2D` (`-`) menjadi karakter `_`.

Hasil decoding baris per baris (frame 26–85):

| Frame | Modifier | Key Code | Karakter |
| ----- | -------- | -------- | -------- |
| 26    | 02       | 1a       | W        |
| 28    | 00       | 0c       | i        |
| 30    | 00       | 15       | r        |
| 32    | 00       | 08       | e        |
| 34    | 00       | 07       | d        |
| 36    | 02       | 2d       | \_       |
| 38    | 02       | 13       | P        |
| 40    | 00       | 15       | r        |
| 42    | 00       | 12       | o        |
| 44    | 00       | 17       | t        |
| 46    | 00       | 12       | o        |
| 48    | 00       | 06       | c        |
| 50    | 00       | 12       | o        |
| 52    | 00       | 0f       | l        |
| 54    | 02       | 2d       | \_       |
| 56    | 00       | 24       | 7        |
| 58    | 02       | 2d       | \_       |
| 60    | 00       | 0c       | i        |
| 62    | 00       | 16       | s        |
| 64    | 02       | 2d       | \_       |
| 66    | 00       | 04       | a        |
| 68    | 00       | 0f       | l        |
| 70    | 00       | 0c       | i        |
| 72    | 00       | 19       | v        |
| 74    | 00       | 08       | e        |
| 76    | 02       | 2d       | \_       |
| 78    | 00       | 1f       | 2        |
| 80    | 00       | 27       | 0        |
| 82    | 00       | 1f       | 2        |
| 84    | 00       | 23       | 6        |

### 15.5 Validasi Temuan ke Socket Server

```bash
nc 10.4.89.246 3402
```

<img width="1688" height="866" alt="Screenshot 2026-09-17 003945" src="https://github.com/user-attachments/assets/6acecd8a-72bd-4d88-9840-57dcde51a845" />

# 16

**Eiri telah memasang malware di server. Analisis lalu lintas FTP untuk mengidentifikasi alamat IP server FTP penyerang, banner software FTP, kredensial login penyerang, serta ukuran (bytes) dari file malware knights_payload.exe yang diunduh**

### 16.1 Mencari Kredensial login penyerang

Hal ini dapat dicari dengan memfilter Wireshark dengan `ftp.request.command == "USER" or ftp.request.command == "PASS"` . Filter ini akan mengisolasi hanya paket-paket request login FTP dari seluruh trafik campuran di file capture ini.

<img width="1638" height="542" alt="image" src="https://github.com/user-attachments/assets/eaa9699d-344b-428e-8c7d-d524e2d23971" />

### 16.2 Mencari IP FTP Server (Destination)

filter `ftp.request.command == "RETR"` akan menemukan command download file yang spesifik menyasar file malware knights_payload.exe.

<img width="2880" height="1800" alt="image" src="https://github.com/user-attachments/assets/42c95936-cbf7-4305-b671-c4cd7d30ec43" />

<img width="1222" height="1354" alt="image" src="https://github.com/user-attachments/assets/76a6d265-273b-411e-ab8e-3d1543a620c4" />

Informasi yang diperoleh
| Temuan | Nilai |
|----------|----------|
| IP FTP Sever | 198.51.100.7 |
| Banner Software | Wired FTP Server (vsftpd 3.0.5) |
| Ukuran file knights_payload.exe | 524288 bytes |
| Kredensial Penyerang | Username: knights_agent — Password: N4v1_s3cur3_2026 |

### 16.3 Validasi Temuan

<img width="1694" height="864" alt="image" src="https://github.com/user-attachments/assets/2c8b1604-dae0-4f9a-afba-39a2a1c4a87f" />

# 17

Pada nomor 17 ini, analisis dilakukan terhadap file capture wired_http_c2.pcap menggunakan Wireshark untuk mengidentifikasi aktivitas pengunduhan payload berbahaya oleh Eiri pada sistem Alice.

Dengan mengaplikasikan display filter `http.request || http.response`, ditemukan aktivitas pengunduhan file malware pada paket No. 30 (permintaan GET) dan No. 31 (respons HTTP):
<img width="1470" height="956" alt="Tangkapan Layar 2026-09-17 pukul 14 18 05" src="https://github.com/user-attachments/assets/f2d09f41-3075-4078-8a4b-78c43f152ce7" />

- Nama Domain (Host): Berdasarkan baris Host: pada header HTTP Request paket No. 30,
  nama domain tempat malware diunduh adalah wired-update.net.
- Alamat IP Server Penyerang: Pada kolom Destination IP paket No. 30, lokasi server penyerang berada pada IP 203.0.113.42.
- Nama File Executable Malware: Berdasarkan Request URI pada paket No. 30, nama file executable yang diunduh adalah navi_agent.exe.
- Kode Status HTTP: Pada paket No. 31, server penyerang mengembalikan kode status 200 (200 OK), yang menandakan file malware berhasil diunduh ke sistem target.

Seluruh temuan parameter tersebut kemudian diinputkan dan divalidasi ke socket server menggunakan perintah nc [IP_Group] 3404 dan dinyatakan berhasil/valid.
<img width="1470" height="956" alt="Tangkapan Layar 2026-09-17 pukul 14 08 51" src="https://github.com/user-attachments/assets/51e66af9-f749-4614-97ea-65cf9112b2eb" />

# 18

Pada nomor ini, analisis dilakukan terhadap file captur `e wired_smb_transfer.pcapng` menggunakan Wireshark untuk mengidentifikasi aktivitas penanaman file malware menggunakan protokol file sharing SMB oleh Eiri.

<img width="1129" height="420" alt="Tangkapan Layar 2026-09-17 pukul 14 35 18" src="https://github.com/user-attachments/assets/5145199d-b13e-4bd1-8162-b3838bb5fa00" />

Dengan menerapkan display filter smb2, ditemukan aktivitas pemindahan file pada paket No. 16 (Create Request) dan No. 20 (Write Request):

- Nama Protokol Jaringan: Protokol yang dieksploitasi adalah SMB2 (Server Message Block version 2).
- IP Pengirim & Penerima: Paket dikirim dari IP penyerang 10.7.3.100 menuju IP korban 10.7.1.50.
- Folder Tujuan Penyimpanan: Berdasarkan path file pada paket Create Request, file diletakkan pada direktori System32 (melalui share folder ADMIN$).
- Nama File Executable Malware: File executable yang ditransfer adalah wired_trojan_payload.exe.

Seluruh temuan parameter tersebut telah diinputkan dan divalidasi ke socket server melalui perintah nc [IP_Group] 3405 dan terverifikasi berhasil/valid.

<img width="605" height="374" alt="Tangkapan Layar 2026-09-17 pukul 14 34 57" src="https://github.com/user-attachments/assets/006fff49-6988-45fb-af3c-266918d1a75f" />

# 19

Pada nomor ini, analisis dilakukan terhadap file capture `wired_smtp_threat.pcap` menggunakan Wireshark untuk mengidentifikasi ancaman email pemerasan via protokol SMTP tanpa enkripsi oleh Eiri.
<img width="1470" height="956" alt="Tangkapan Layar 2026-09-17 pukul 15 10 19" src="https://github.com/user-attachments/assets/3beb0a73-6b16-40ba-aecd-a4158031f1e2" />

Dengan memeriksa detail Internet Message Format dan isi Line-based text data pada paket No. 86, diperoleh seluruh parameter ancaman sebagai berikut:

- Alamat Email Korban: Email target penyerangan adalah victim@protocol7.co.jp
- Password Korban: Password milik korban yang diklaim telah bocor oleh penyerang adalah pr0tocol_7_user.
- Jenis Malware: Perangkat korban diinfeksi menggunakan jenis malware ransomware.
- Batas Waktu: Penyerang memberikan tenggat waktu pembayaran tebusan selama 3 hari (72 jam).
- MailClientID: Identitas client pengirim email yang tercantum pada pesan adalah 7719980706

  Seluruh temuan parameter tersebut telah diinputkan dan divalidasi ke socket server melalui perintah nc [IP_Group] 3406 dan terverifikasi berhasil/valid.
  <img width="1470" height="956" alt="Tangkapan Layar 2026-09-17 pukul 15 10 11" src="https://github.com/user-attachments/assets/04307c5e-aca2-431c-a4bd-a7d2d25021c7" />

# 20

Pada nomor ini, analisis dilakukan terhadap file capture `wired_tls_decrypt.pcapng` dengan mengimpor file Pre-Master-Secret keyslogfile.txt pada konfigurasi TLS Wireshark untuk mendekripsi lalu lintas data yang disembunyikan oleh Eiri.

<img width="1470" height="956" alt="Tangkapan Layar 2026-09-17 pukul 15 39 10" src="https://github.com/user-attachments/assets/b3d1fe45-0f51-46f1-a067-ce9cc9191c33" />

Setelah proses dekripsi berhasil, diperoleh detail parameter sebagai berikut:

- Versi Protokol TLS: Protokol TLS yang dinegosiasikan adalah TLSv1.2.
- Nama Domain (SNI): Server Name Indication yang diakses oleh client adalah example.com.
- Alamat IP Server HTTPS: Lokasi IP server penyerang berada pada 93.184.216.34.
- User-Agent: String User-Agent yang digunakan oleh client adalah curl/7.62.0.
- HTTP Request Method & Path: Metode permintaan yang digunakan adalah HEAD dengan lokasi path /.
  Seluruh temuan parameter tersebut telah diinputkan dan divalidasi ke socket server melalui perintah nc [IP_Group] 3407 dan terverifikasi berhasil/valid.

<img width="1470" height="956" alt="Tangkapan Layar 2026-09-17 pukul 15 33 54" src="https://github.com/user-attachments/assets/4053a924-e6df-4de3-8257-bc4f9f972a41" />
