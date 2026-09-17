Eksekusi Pemindaian Port di Node Alice
```bash
# Pemindaian Port Terbuka (SSH & HTTP)
nc -zv 10.74.3.2 22 80

# Pemindaian Port Tertutup (Port 7777)
nc -zv 10.74.3.2 7777

# Untuk filter di wireshark
ip.addr == 10.74.3.2 && tcp
