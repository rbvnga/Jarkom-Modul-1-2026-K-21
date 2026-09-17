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
  
# 13
**isi soal nya apa**
# 14
**Eiri melancarakan serangan bruce-force terhadap form login web Alice. Analisis file `wired_bruteforce.pcapng` untuk menidentifikasi bebrapa hal dan memvalidasi temuan tersebut pada socket server**
### 14.1. Memeriksa Ip Victim dan IP Attacker melalui Tab Statistics → Conversations → tab IPv4 
<img width="2856" height="1312" alt="image" src="https://github.com/user-attachments/assets/76cef8d2-70f1-49f6-a20f-0eb4f45def0a" />
Pada Tab ini diketahui ip server (Alice) = 172.26.7.100 — IP ini muncul sebagai "Address B" di semua baris, artinya dia yang menerima koneksi dari 5 IP berbeda. Sedangkan Penyerang (Eiri) = 172.26.7.50
- 104 packets, 23 kB, data ini jauh lebih besar dari baris lain yang cuma 1-2 packets/~88-230 bytes
Ini pola khas brute force dimana ratusan percobaan login berturut-turut ke server yang sama menghasilkan traffic jauh lebih besar dibanding koneksi normal
### 14.2 Mencari Port yang diserang melalui Tab Statistics → Conversations → tab TCP
<img width="2850" height="1702" alt="image" src="https://github.com/user-attachments/assets/5f65e6ff-c248-416a-9fcc-7390f9a588f7" />
### 14.3 Filtering
<img width="2878" height="1710" alt="image" src="https://github.com/user-attachments/assets/11bc1548-08d7-4faa-b090-afa5999de51d" />

### 14.4 HTTP STREAM
<img width="2876" height="1704" alt="image" src="https://github.com/user-attachments/assets/60da6239-81b9-4890-b657-73a3751854f8" />

### 14.5 LAIN ADMIN-HTTPSTREAM
<img width="2880" height="1706" alt="image" src="https://github.com/user-attachments/assets/75ad14d1-3736-473a-ab8a-7e949639ad4a" />
<img width="2856" height="1704" alt="image" src="https://github.com/user-attachments/assets/58ea5c28-d120-41f2-ba21-e3a61d1a3131" />
Hal-Hal yang ditemukan: 
| Keterangan | Isi | 
|----------|----------|
| IP Penyerang  | 172.26.7.50  | 
| IP Target  |  172.26.7.100 |
| Password `lain_admin`  |  wired_pr0tocol_7 | 
| Software & versi web server  |  Apache 2.6.62 + PHP/8.3.14 | 


### 14.6 Cek Validasi di console Client (Alice)
```
nc 10.4.89.246 3401
```
<img width="1626" height="864" alt="image" src="https://github.com/user-attachments/assets/bb33e32d-95dc-4a86-ab0c-dc39d3e75e51" />
Dari hasil analisis dan validasi ini di peroleh flag : ```KOMJAR26{W1r3d_Brut3_H0yZsExJta1BCs3ArnWVuPx21}``` 
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
 
| Kode Hex | Karakter | Kode Hex | Karakter |
|---|---|---|---|
| 0x04 | a | 0x13 | p |
| 0x06 | c | 0x15 | r |
| 0x07 | d | 0x16 | s |
| 0x08 | e | 0x17 | t |
| 0x0C | i | 0x19 | v |
| 0x0F | l | 0x1A | w |
| 0x12 | o | 0x1F–0x27 | 2, 3, ... 0 (angka) |
| 0x2D | - / _ (dengan Shift) | | |
 
Modifier byte `0x02` menandakan **Left Shift** ditekan bersamaan — mengubah huruf menjadi kapital dan mengubah tombol `0x2D` (`-`) menjadi karakter `_`.
 
Hasil decoding baris per baris (frame 26–85):
 
| Frame | Modifier | Key Code | Karakter |
|---|---|---|---|
| 26 | 02 | 1a | W |
| 28 | 00 | 0c | i |
| 30 | 00 | 15 | r |
| 32 | 00 | 08 | e |
| 34 | 00 | 07 | d |
| 36 | 02 | 2d | _ |
| 38 | 02 | 13 | P |
| 40 | 00 | 15 | r |
| 42 | 00 | 12 | o |
| 44 | 00 | 17 | t |
| 46 | 00 | 12 | o |
| 48 | 00 | 06 | c |
| 50 | 00 | 12 | o |
| 52 | 00 | 0f | l |
| 54 | 02 | 2d | _ |
| 56 | 00 | 24 | 7 |
| 58 | 02 | 2d | _ |
| 60 | 00 | 0c | i |
| 62 | 00 | 16 | s |
| 64 | 02 | 2d | _ |
| 66 | 00 | 04 | a |
| 68 | 00 | 0f | l |
| 70 | 00 | 0c | i |
| 72 | 00 | 19 | v |
| 74 | 00 | 08 | e |
| 76 | 02 | 2d | _ |
| 78 | 00 | 1f | 2 |
| 80 | 00 | 27 | 0 |
| 82 | 00 | 1f | 2 |
| 84 | 00 | 23 | 6 |

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
filter  `ftp.request.command == "RETR"` akan menemukan command download file yang spesifik menyasar file malware knights_payload.exe.

<img width="2880" height="1800" alt="image" src="https://github.com/user-attachments/assets/42c95936-cbf7-4305-b671-c4cd7d30ec43" />

<img width="1222" height="1354" alt="image" src="https://github.com/user-attachments/assets/76a6d265-273b-411e-ab8e-3d1543a620c4" />

Informasi yang diperoleh
| Temuan | Nilai | 
|----------|----------|
| IP FTP Sever  | 198.51.100.7  | 
|  Banner Software  | Wired FTP Server (vsftpd 3.0.5) | 
| Ukuran file knights_payload.exe  | 524288 bytes | 
| Kredensial Penyerang  | Username: knights_agent — Password: N4v1_s3cur3_2026 | 


### 16.3 Validasi Temuan 
<img width="1694" height="864" alt="image" src="https://github.com/user-attachments/assets/2c8b1604-dae0-4f9a-afba-39a2a1c4a87f" />

# 17

Pada nomor 17 ini, analisis dilakukan terhadap file capture wired_http_c2.pcap menggunakan Wireshark untuk mengidentifikasi aktivitas pengunduhan payload berbahaya oleh Eiri pada sistem Alice.

Dengan mengaplikasikan display filter ```http.request || http.response```, ditemukan aktivitas pengunduhan file malware pada paket No. 30 (permintaan GET) dan No. 31 (respons HTTP):
<img width="1470" height="956" alt="Tangkapan Layar 2026-09-17 pukul 14 18 05" src="https://github.com/user-attachments/assets/f2d09f41-3075-4078-8a4b-78c43f152ce7" />

- Nama Domain (Host): Berdasarkan baris Host: pada header HTTP Request paket No. 30,
nama domain tempat malware diunduh adalah wired-update.net. 
- Alamat IP Server Penyerang: Pada kolom Destination IP paket No. 30, lokasi server penyerang berada pada IP 203.0.113.42.
- Nama File Executable Malware: Berdasarkan Request URI pada paket No. 30, nama file executable yang diunduh adalah navi_agent.exe.
- Kode Status HTTP: Pada paket No. 31, server penyerang mengembalikan kode status 200 (200 OK), yang menandakan file malware berhasil diunduh ke sistem target.

Seluruh temuan parameter tersebut kemudian diinputkan dan divalidasi ke socket server menggunakan perintah nc [IP_Group] 3404 dan dinyatakan berhasil/valid.
<img width="1470" height="956" alt="Tangkapan Layar 2026-09-17 pukul 14 08 51" src="https://github.com/user-attachments/assets/51e66af9-f749-4614-97ea-65cf9112b2eb" />

# 18

Pada nomor ini, analisis dilakukan terhadap file captur ```e wired_smb_transfer.pcapng``` menggunakan Wireshark untuk mengidentifikasi aktivitas penanaman file malware menggunakan protokol file sharing SMB oleh Eiri.

<img width="1129" height="420" alt="Tangkapan Layar 2026-09-17 pukul 14 35 18" src="https://github.com/user-attachments/assets/5145199d-b13e-4bd1-8162-b3838bb5fa00" />

Dengan menerapkan display filter smb2, ditemukan aktivitas pemindahan file pada paket No. 16 (Create Request) dan No. 20 (Write Request):
- Nama Protokol Jaringan: Protokol yang dieksploitasi adalah SMB2 (Server Message Block version 2).
- IP Pengirim & Penerima: Paket dikirim dari IP penyerang 10.7.3.100 menuju IP korban 10.7.1.50.
- Folder Tujuan Penyimpanan: Berdasarkan path file pada paket Create Request, file diletakkan pada direktori System32 (melalui share folder ADMIN$).
- Nama File Executable Malware: File executable yang ditransfer adalah wired_trojan_payload.exe.

Seluruh temuan parameter tersebut telah diinputkan dan divalidasi ke socket server melalui perintah nc [IP_Group] 3405 dan terverifikasi berhasil/valid.

<img width="605" height="374" alt="Tangkapan Layar 2026-09-17 pukul 14 34 57" src="https://github.com/user-attachments/assets/006fff49-6988-45fb-af3c-266918d1a75f" />













  








  
