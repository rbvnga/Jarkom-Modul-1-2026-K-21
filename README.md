# Jarkom-Modul-1-2026-K-21

| Nama | NRP | 
|----------|----------|
| Revalinda Bunga Nayla Laksono  | 5027251011  | 
| Najla Tufailah  | 5027251078  | 

# 1 2 - Membangun The Wired
**Membuat 3 Switch/Gateway dimana, kelima entitas ini di konfigurasi sebagai client di GNS3, lalu mengkonfigurasi router lain agar daoat tersembung ke internet publik NAT/DHCP pada interface eth0**
- Switch 1 menuju Alice dan Mika
- Switch 2 menuju Chisa
- Switch 3 menuju Knights dan Eiri

<img width="1864" height="1402" alt="image" src="https://github.com/user-attachments/assets/e8639d4e-0fd6-428b-ac60-5742fabf3c76" />
- Router 1 pusat dengan 3 interface (eth1, eth2, eth3) menuju 3 switch berbeda
- Switch1 → Alice & Mika (2 client)
- Switch2 → Chisa (1 client, FTP server nantinya)
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
| Alice  | 10.74.1.2  | 10.74.1.1 | Switch 1 (eth1 Router) |
| Mika  | 10.74.1.3  | 10.74.1.1 | Switch 1 (eth1 Router) | 
| Chisa  | 10.74.2.2  | 10.74.2.1 | Switch 2 (eth2 Router) | 
| knights  | 10.74.3.2  | 10.74.3.1 | Switch 3 (eth3 Router) | 
| Eiri  | 10.74.3.3  | 10.74.3.1 | Switch 3 (eth3 Router) | 


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
# 5 
**Memastikan seluruh kondigurasi jaringan, dengan membuat script verivikasi**
# 6 
**Menyaring paket yang berprotokol DNS atau ICMP melalui Wireshark pada interface node Mika**
# 7 
**Chisa mendirikan FTP Server dengan shared folder /var/wired/data
dan menerapkan beberapa kebijakan akses tertentu pada user Alice, Mika, Eiri**
# 8
**Menganalisis sesi Wireshark ketika Knights mengupload file ke FTP server Chisa**
# 9
****
# 10
**Mencatat nilai ICMP Type dan Code untuk Echo Request vs Echo Reply, serta analisis packet loss dan RTT (min/avg/max) ketika Knights mengirimkan ping ke node Chisa**
# 11
**Membuktikan kelemahan protokol telnet dengan membuat akun baru pada layanan telnetd di node Chisa, lalu menunjukkan kredensial plain text**
- Membuat akun Phantom_user dan men-setting password nya wired_ghost
