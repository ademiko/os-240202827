# 📝 Laporan Tugas Akhir

**Mata Kuliah**: Sistem Operasi
**Semester**: Genap / Tahun Ajaran 2024–2025
**Nama**: Ade Miko
**NIM**: 240202827
**Modul yang Dikerjakan**:
`(Modul 5 – Audit dan Keamanan Sistem)`

---

## 📌 Deskripsi Singkat Tugas

**Modul 5 – Audit dan Keamanan Sistem**
Tugas ini bertujuan untuk menambahkan kemampuan sistem untuk merekam semua system call yang dijalankan oleh proses dalam bentuk audit log, serta membatasi akses log hanya untuk proses khusus (PID 1). Modul ini juga melatih pemahaman terhadap integrasi fitur keamanan pada level kernel.

## 🛠️ Rincian Implementasi

Tuliskan secara ringkas namun jelas apa yang Anda lakukan:

### Contoh untuk Modul 1:

**A. Audit System Call**
* Menambahkan struktur audit_entry dan array audit_log[] di syscall.c untuk mencatat setiap system call.
* Mencatat system call yang valid di dalam fungsi syscall() berdasarkan pid, nomor syscall, dan waktu (tick).
* Implementasi syscall baru get_audit_log(void *buf, int max) di sysproc.c, hanya dapat diakses oleh proses dengan PID 1.
* Menambahkan deklarasi syscall di user.h, usys.S, syscall.h, dan mendaftarkannya di syscall.c.

**B. Program Uji dan Validasi Akses**
* Membuat program audit.c untuk mengambil log melalui get_audit_log() dan mencetak ke layar.
* Menambahkan audit ke dalam Makefile agar dapat dibangun secara otomatis.
* Untuk menjalankan audit sebagai proses PID 1, mengedit file init.c dan mengganti default shell dengan exec("audit", argv).
---

## ✅ Uji Fungsionalitas

Program uji yang digunakan:

audit: Menjalankan syscall get_audit_log() dan mencetak isi log.
---

## 📷 Hasil Uji

### 📍 Output jika dijalankan oleh proses biasa:
```
Access denied or error.
```
### 📍 Output jika dijalankan oleh PID 1:
```
=== Audit Log ===
[0] PID=1 SYSCALL=5 TICK=12
[1] PID=1 SYSCALL=6 TICK=13
[2] PID=1 SYSCALL=22 TICK=14
...
```
## ⚠️ Kendala yang Dihadapi

Tuliskan kendala (jika ada), misalnya:

* lupa memvalidasi bahwa hanya PID 1 yang boleh mengakses get_audit_log(), menyebabkan proses lain bisa membaca log.
* Alokasi buffer untuk argptr() perlu disesuaikan ukurannya dengan jumlah entri maksimum (MAX_AUDIT).
* Karena xv6 tidak mendukung file log permanen, semua data hanya tersimpan di memori dan hilang setelah reboot.
* Debugging PID 1 memerlukan mengganti default exec("sh", ...) di init.c, dan terkadang gagal karena program audit belum dibuat saat make.

---

## 📚 Referensi

Tuliskan sumber referensi yang Anda gunakan, misalnya:

* Buku xv6 MIT: [https://pdos.csail.mit.edu/6.828/2018/xv6/book-rev11.pdf](https://pdos.csail.mit.edu/6.828/2018/xv6/book-rev11.pdf)
* Repositori xv6-public: [https://github.com/mit-pdos/xv6-public](https://github.com/mit-pdos/xv6-public)
* Stack Overflow, GitHub Issues, diskusi praktikum

---

