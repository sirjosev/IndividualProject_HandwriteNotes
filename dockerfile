# Gunakan base image Ubuntu
FROM ubuntu:20.04

# Hindari prompt interaktif selama build
ENV DEBIAN_FRONTEND=noninteractive

# Update, install Tesseract, Python, pip, dan dependensi GUI
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    tesseract-ocr-ind \
    python3 \
    python3-pip \
    python3-tk \
    tightvncserver \
    && rm -rf /var/lib/apt/lists/*

# Install pustaka Python
RUN pip3 install pillow pytesseract

# Buat dan atur direktori kerja
WORKDIR /app

# Salin skrip aplikasi ke dalam image
COPY handwriting_recognition.py .

# Expose port VNC
EXPOSE 5901

# Atur kata sandi VNC
RUN mkdir -p /root/.vnc
RUN echo "password" | tightvncserver -passwd - > /root/.vnc/passwd_output 2>&1
RUN chmod 600 /root/.vnc/passwd

# Perintah untuk memulai VNC server dan aplikasi
CMD ["/bin/bash", "-c", "tightvncserver :1 -geometry 1280x800 -depth 24 && export DISPLAY=:1 && python3 handwriting_recognition.py"]
