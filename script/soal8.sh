# Jalankan dari Console Knights
wget --no-check-certificate \
  "https://drive.google.com/uc?export=download&id=1lFepK4wFmx55PnRki3NsHW-ivudSR0vg" \
  -O knights_report.zip

unzip knights_report.zip

ftpput -u alice -p alice123 10.74.2.2 knights_report.txt knights_report.txt