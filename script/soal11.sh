adduser phantom_user

# Command Untuk Mengubah Password
# passwd phantom_user

#Nyalakan dulu di Chisa 
telnetd -l /bin/login &
# Cek telnetd 
netstat -tulnp | grep 23
