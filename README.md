# Pengenalan Tulisan Tangan (Handwriting Recognition)

## 1. Tujuan Proyek
Aplikasi ini adalah alat sederhana yang dibangun dengan Python untuk melakukan Pengenalan Karakter Optik (OCR) pada gambar tulisan tangan. Pengguna dapat memilih sebuah file gambar, dan aplikasi akan mencoba mengenali teks di dalamnya dan menampilkannya di layar.

## 2. Stack Teknologi
Proyek ini menggunakan beberapa teknologi inti:
- **Python**: Bahasa pemrograman utama yang digunakan.
- **Tkinter**: Pustaka standar Python untuk membuat antarmuka pengguna grafis (GUI).
- **Pillow**: Pustaka untuk manipulasi gambar (cabang dari PIL).
- **Pytesseract**: Pustaka Python yang berfungsi sebagai pembungkus untuk mesin OCR Tesseract Google.
- **Tesseract OCR**: Mesin OCR yang sebenarnya, yang perlu diinstal di sistem.
- **Docker**: Untuk membuat kontainer dan melakukan deployment aplikasi beserta lingkungannya.
- **VNC (Virtual Network Computing)**: Digunakan dalam konteks Docker untuk mengakses GUI aplikasi dari jarak jauh.

## 3. Cara Kerja Program
Alur kerja aplikasi ini sangat sederhana:
1.  Pengguna menjalankan aplikasi, dan sebuah jendela utama dengan tombol "Submit" akan muncul.
2.  Ketika pengguna mengklik tombol **Submit**, sebuah dialog file akan terbuka.
3.  Pengguna memilih file gambar (misalnya, `.png`, `.jpg`) yang berisi tulisan tangan.
4.  Aplikasi menggunakan pustaka Pillow untuk membuka gambar dan Pytesseract untuk mengirimkannya ke mesin Tesseract.
5.  Tesseract menganalisis gambar dan mengembalikan teks yang dikenali.
6.  Hasil teks tersebut kemudian ditampilkan dalam sebuah jendela pesan (pop-up).

## 4. Petunjuk Penggunaan (Lokal)
Untuk menjalankan aplikasi ini di komputer lokal Anda, ikuti langkah-langkah berikut:

### Prasyarat
1.  **Install Python 3**: Pastikan Python 3 sudah terinstal di sistem Anda.
2.  **Install Tesseract OCR**: Pytesseract memerlukan Tesseract untuk diinstal.
    -   **Untuk Ubuntu/Debian**:
        ```bash
        sudo apt update
        sudo apt install tesseract-ocr tesseract-ocr-ind
        ```
    -   **Untuk macOS**:
        ```bash
        brew install tesseract tesseract-lang
        ```
    -   **Untuk Windows**:
        Unduh installer dari [repositori Tesseract di UB Mannheim](https://github.com/UB-Mannheim/tesseract/wiki) dan pastikan untuk menambahkan direktori instalasi Tesseract ke `PATH` sistem Anda.

### Instalasi Pustaka Python
Buka terminal atau command prompt dan jalankan perintah berikut untuk menginstal pustaka yang diperlukan:
```bash
pip install pillow pytesseract
```

### Menjalankan Aplikasi
Simpan kode dari `handwriting_recognition.py` dan jalankan menggunakan perintah berikut:
```bash
python handwriting_recognition.py
```

## 5. Cara Deployment (Docker)
Metode deployment yang disarankan adalah menggunakan Docker untuk mengemas aplikasi dan semua dependensinya ke dalam sebuah *image*. Karena ini adalah aplikasi GUI, kita akan menjalankannya di dalam server VNC di dalam kontainer, yang memungkinkan Anda untuk terhubung dan berinteraksi dengannya dari jarak jauh.

### `dockerfile` yang Diperbaiki
`dockerfile` yang ada di repositori ini tidak lengkap. Gunakan `dockerfile` berikut yang sudah diperbaiki:

```dockerfile
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

# Salin skrip aplikasi ke dalam image
COPY handwriting_recognition.py /app/

# Atur direktori kerja
WORKDIR /app

# Expose port VNC
EXPOSE 5901

# Atur kata sandi VNC (ganti 'password' dengan kata sandi yang aman)
RUN mkdir -p ~/.vnc
RUN echo "password" | tightvncserver -passwd - > ~/.vnc/passwd_output 2>&1
RUN chmod 600 ~/.vnc/passwd

# Perintah untuk memulai VNC server dan aplikasi
CMD ["/bin/bash", "-c", "tightvncserver :1 -geometry 1280x800 -depth 24 && export DISPLAY=:1 && python3 handwriting_recognition.py"]
```

### Langkah-langkah Deployment
1.  **Build Docker Image**:
    Buka terminal di direktori proyek Anda (yang berisi `dockerfile` dan `handwriting_recognition.py`) dan jalankan:
    ```bash
    docker build -t handwriting-recognition .
    ```

2.  **Jalankan Docker Container**:
    Setelah *image* berhasil dibuat, jalankan kontainer dari *image* tersebut:
    ```bash
    docker run -p 5901:5901 -d --name ocr-app handwriting-recognition
    ```
    - `-p 5901:5901`: Memetakan port 5901 dari kontainer ke port 5901 di mesin host Anda.
    - `-d`: Menjalankan kontainer di mode *detached* (di latar belakang).
    - `--name ocr-app`: Memberi nama kontainer agar mudah dikelola.

3.  **Terhubung dengan VNC Viewer**:
    - Unduh dan instal VNC Viewer di komputer Anda (misalnya, [RealVNC](https://www.realvnc.com/en/connect/download/viewer/)).
    - Buka VNC Viewer dan hubungkan ke alamat: `localhost:5901`.
    - Masukkan kata sandi yang Anda atur di `dockerfile` (dalam contoh ini: `password`).
    - Anda sekarang akan melihat desktop di dalam kontainer, dengan aplikasi pengenalan tulisan tangan sudah berjalan.
