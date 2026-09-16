# Jarkom-Modul-1-2026-K-21

| Nama | NRP | 
|----------|----------|
| Revalinda Bunga Nayla Laksono  | 5027251011  | 
| Najla Tufailah  | 5027251078  | 

# 1 2 - Membangun The Wired
**Membuat 3 Switch/Gateway dimana,kelima entitas ini di konfigurasi sebagai client di GNS3, lalu mengkonfigurasi router lain agar daoat tersembung ke internet publik NAT/DHCP pada interface eth0**
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
- `auto eth0` → interface eth0 otomatis diaktifkan saat sistem boot/network service jalan.
- `iface eth0 inet dhcp` → interface ini pakai DHCP (dapat IP otomatis dari luar).
- iface eth1 inet static → interface ini pakai IP statis (ditentukan manual, bukan DHCP).
address 10.10.1.1 → IP address untuk interface ini.
netmask 255.255.255.0 → subnet mask-nya (sama dengan /24).
Ini biasanya dipakai untuk interface router yang jadi gateway ke satu segmen/switch tertentu.
Sama seperti eth1, tapi untuk segmen/switch yang berbeda (10.10.2.0/24).
Kesimpulannya:

Router di contoh ini punya:

eth0 → ke arah internet/NAT (dinamis, DHCP)
eth1 → gateway segmen 1 (statis, 10.10.1.1)
eth2 → gateway segmen 2 (statis, 10.10.2.1)
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
# 3
**Memastikan selukurh entitas (client) di bawah Switch 1, Switch 2, Switch 3 dapat saling terhubung dan berkomunikasi satu sama lain**


# 4 
**** 
