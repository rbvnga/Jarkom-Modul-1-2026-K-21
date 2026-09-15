# Jarkom-Modul-1-2026-K-21

| Nama | NRP | 
|----------|----------|
| Revalinda Bunga Nayla Laksono  | 5027251011  | 
| Najla Tufailah  | 5027251078  | 

# 1 2 - Membangun The Wired
## Membuat 3 Switch/Gateway dimana,kelima entitas ini di konfigurasi sebagai client di GNS3, lalu mengkonfigurasi router lain agar daoat tersembung ke internet publik NAT/DHCP pada interface eth0
- Switch 1 menuju Alice dan Mika
- Switch 2 menuju Chisa
- Switch 3 menuju Knights dan Eiri

<img width="1864" height="1402" alt="image" src="https://github.com/user-attachments/assets/e8639d4e-0fd6-428b-ac60-5742fabf3c76" />

### Konfigurasi Router
'''bash
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
'''
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
