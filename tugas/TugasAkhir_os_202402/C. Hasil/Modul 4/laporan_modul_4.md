# 📝 Laporan Tugas Akhir

**Mata Kuliah**: Sistem Operasi
**Semester**: Genap / Tahun Ajaran 2024–2025
**Nama**: Ade Miko 
**NIM**: 240202827
**Modul yang Dikerjakan**:
`(Modul 4 – Subsistem Kernel Alternatif)`

---

## 📌 Deskripsi Singkat Tugas

Modul 4 – Subsistem Kernel Alternatif
Modul ini terdiri dari dua bagian:

**System Call chmod(path, mode)**: Menambahkan kemampuan untuk mengubah mode file (read-only atau read-write) pada sistem file xv6.
**Driver /dev/random**: Menambahkan pseudo-device baru untuk menghasilkan data acak, yang dapat dibaca oleh proses pengguna melalui device file /dev/random.

## 🛠️ Rincian Implementasi

**A. System Call chmod(path, mode)**
8* Menambahkan field mode ke struktur inode di fs.h untuk menyimpan status read-only.
* Implementasi syscall chmod() di sysfile.c.
* Mendaftarkan syscall baru di syscall.c, syscall.h, user.h, dan usys.S.
* Menambahkan validasi mode file di fungsi filewrite() pada file.c.
* Menambahkan program uji chmodtest.c untuk memastikan file read-only tidak bisa ditulis kembali.

**B. Pseudo-Device /dev/random**
* Membuat file baru random.c yang berisi fungsi randomread() sebagai generator byte acak.
* Mendaftarkan fungsi randomread() ke array devsw[] di file.c pada indeks 3.
* Membuat device file /dev/random menggunakan mknod() di file init.c.
* Membuat program uji randomtest.c untuk membaca dan menampilkan byte acak dari /dev/random.

## ✅ Uji Fungsionalitas

Program uji yang digunakan:
* chmodtest: Menguji apakah file dengan mode read-only memblokir operasi tulis.
* randomtest: Menguji apakah /dev/random dapat menghasilkan byte acak.



## 📷 Hasil Uji

Lampirkan hasil uji berupa screenshot atau output terminal. Contoh:

### 📍 Contoh Output `chmodtest`:

```
Write blocked as expected
```

### 📍 Contoh Output `randomtest`:

```
166 231 148 61 50 131 0 57
```

## ⚠️ Kendala yang Dihadapi

* Field mode tidak bisa disimpan permanen karena tidak dimasukkan ke dalam layout disk inode — bersifat volatile.
* Lupa mendaftarkan device /dev/random dengan mknod() menyebabkan open("/dev/random") gagal.
* Validasi di filewrite() awalnya tidak mengecek pointer f->ip, menyebabkan kernel panic pada file tanpa inode.

---

## 📚 Referensi

Tuliskan sumber referensi yang Anda gunakan, misalnya:

* Buku xv6 MIT: [https://pdos.csail.mit.edu/6.828/2018/xv6/book-rev11.pdf](https://pdos.csail.mit.edu/6.828/2018/xv6/book-rev11.pdf)
* Repositori xv6-public: [https://github.com/mit-pdos/xv6-public](https://github.com/mit-pdos/xv6-public)
* Stack Overflow, GitHub Issues, diskusi praktikum

---

