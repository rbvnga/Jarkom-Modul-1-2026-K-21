
# mencoba akses
ftpget -u mika -p mika123 10.74.2.2 protocol7_manifesto.txt protocol7_manifesto.txt

# cek verivikasi
ls -la protocol7_manifesto.txt

cat protocol7_manifesto.txt

echo "Mika mencoba mengupload"
# mencoba upload
ftpput -u mika -p mika123 10.74.2.2 percobaan_mika.txt percobaan_mika.txt
