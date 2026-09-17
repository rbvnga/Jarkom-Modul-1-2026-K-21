# Mendownload zip di dalam drive
wget --no-check-certificate \
  "https://drive.google.com/uc?export=download&id=1G9zIi20ofbOgfffor-i-e7QKU3Ihe42W" \
  -O traffic_protocol7.zip

# unzip 
unzip traffic_protocol7.zip

# Mengatur Eksekusi 
chmod +x traffic_protocol7.sh

# Menjalankan traffic untuk di analisis
./traffic_protocol7.sh