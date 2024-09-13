import tkinter as tk
from tkinter import filedialog, messagebox
from PIL import Image
import pytesseract

def recognize_handwriting():
    # Membuka dialog untuk memilih gambar
    file_path = filedialog.askopenfilename(
        defaultextension=".png",
        filetypes=[("PNG files", "*.png"), ("All files", "*.*")]
    )
    if not file_path:
        return

    try:
        # Membaca gambar menggunakan PIL
        img = Image.open(file_path)

        # Melakukan pengenalan tulisan tangan menggunakan pytesseract
        text = pytesseract.image_to_string(img, lang='ind')  # Ganti 'ind' dengan kode bahasa yang sesuai jika diperlukan

        # Menampilkan hasil dalam jendela pop-up
        messagebox.showinfo("Hasil Pengenalan", text)

    except Exception as e:
        messagebox.showerror("Error", f"Terjadi kesalahan: {e}")

# Membuat jendela utama
window = tk.Tk()
window.title("Pengenalan Tulisan Tangan")

# Membuat tombol "Submit"
submit_button = tk.Button(window, text="Submit", command=recognize_handwriting)
submit_button.pack(pady=20)

window.mainloop()