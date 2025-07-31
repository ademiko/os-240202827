# 📝 Laporan Tugas Akhir

**Mata Kuliah**: Sistem Operasi
**Semester**: Genap / Tahun Ajaran 2024–2025
**Nama**: Ade Miko
**NIM**: 240202827
**Modul yang Dikerjakan**:
`(: Modul 1 – System Call dan Instrumentasi Kernel — xv6-public (x86))`

---

## 📌 Deskripsi Singkat Tugas

* **Modul 1 – System Call dan Instrumentasi Kernel**:
  Modul 1 ini berfokus pada System Call dan Instrumentasi Kernel pada sistem operasi xv6. Tugas utama adalah menambahkan dua system call baru: getpinfo() untuk menampilkan informasi proses aktif (PID, ukuran memori, dan nama proses), serta getReadCount() untuk menghitung total panggilan fungsi read() sejak sistem booting.
---
## 🛠️ Rincian Implementasi

Implementasi modul ini melibatkan modifikasi pada beberapa file inti kernel xv6 dan penambahan program uji. Berikut adalah ringkasan langkah-langkah yang dilakukan:

**1. Penambahan Struktur pinfo dan Counter readcount:**
* Definisi struct pinfo ditambahkan pada proc.h untuk menyimpan PID, ukuran memori, dan nama proses. Struktur ini mampu menampung informasi hingga 64 proses.
* Variabel global readcount diinisialisasi ke 0 dalam sysproc.c untuk berfungsi sebagai penghitung panggilan read().
  
**2. Penambahan Nomor System Call Baru:**
* Dua nomor system call baru, SYS_getpinfo (22) dan SYS_getreadcount (23), didefinisikan di syscall.h.
  
**3. Registrasi System Call:**
* Deklarasi extern int sys_getpinfo(void); dan extern int sys_getreadcount(void); ditambahkan di bagian atas syscall.c.
* Entri untuk [SYS_getpinfo] sys_getpinfo, dan [SYS_getreadcount] sys_getreadcount, ditambahkan ke array syscalls[] di syscall.c untuk mendaftarkan system call baru ke tabel system call kernel.

**4. Penambahan ke User-Level:**

* Deklarasi fungsi int getpinfo(struct pinfo *); dan int getreadcount(void); ditambahkan ke user.h agar system call dapat dipanggil dari program user-level.
* Entri SYSCALL(getpinfo) dan SYSCALL(getreadcount) ditambahkan ke usys.S untuk menghasilkan stub system call yang diperlukan.
  
**5. Implementasi Fungsi Kernel:**
* Fungsi sys_getreadcount() diimplementasikan di sysproc.c untuk mengembalikan nilai readcount.
* Fungsi sys_getpinfo() diimplementasikan di sysproc.c. Fungsi ini mengiterasi melalui tabel proses kernel, mengisi struct pinfo dengan PID, ukuran memori, dan nama untuk setiap proses yang aktif, kemudian menyalinnya kembali ke ruang pengguna. Mekanisme penguncian (acquire(&ptable.lock) dan release(&ptable.lock)) digunakan untuk memastikan akses aman ke tabel proses.

**6. Modifikasi read() untuk Tambah Counter:**
* Variabel readcount diinkrementasi (readcount++;) di awal fungsi sys_read() dalam sysfile.c untuk mencatat setiap kali fungsi read() dipanggil.

**7. Pembuatan Program Penguji User-Level:**

* Dua program penguji dibuat: ptest.c untuk menguji getpinfo() dengan menampilkan daftar proses aktif, dan rtest.c untuk menguji getreadcount() dengan menampilkan nilai readcount sebelum dan sesudah panggilan read().
* Kedua program ini, _ptest dan _rtest, didaftarkan ke Makefile xv6 agar dapat dikompilasi dan dijalankan.
---
## ✅ Uji Fungsionalitas
Program uji yang digunakan untuk memverifikasi fungsionalitas system call baru adalah:

ptest: Digunakan untuk menguji fungsionalitas getpinfo(). Program ini mencetak daftar proses yang aktif, menunjukkan PID, ukuran memori, dan nama masing-masing proses.

rtest: Digunakan untuk menguji fungsionalitas getReadCount(). Program ini menampilkan nilai readcount sebelum dan sesudah melakukan operasi read() dari input standar, memverifikasi bahwa readcount bertambah sesuai.

## 📷 Hasil Uji

### 📍 Contoh Output `ptest`:

```
$ ptest
PID	MEM	NAME
1	4096	init
2	2048	sh
3	2048	ptest
...
```

### 📍 Contoh Output `rtest`:

```
read count sebelum: 12
masukan sesuatau (maksimal 5 karakter): 
```
---

## ⚠️ Kendala yang Dihadapi

* Kesalahan Implementasi System Call di Kernel: Ada masalah pada kode sys_getpinfo() di kernel, baik saat mengambil data proses maupun saat menyalinnya ke program ptest di ruang pengguna.
* Masalah Registrasi & Build: Terdapat kesalahan dalam pendaftaran system call (syscall.h, syscall.c, user.h, usys.S) atau build yang tidak bersih (make clean).
* perbedaan output dari rtest

---

## 📚 Referensi

Tuliskan sumber referensi yang Anda gunakan, misalnya:

* Buku xv6 MIT: [https://pdos.csail.mit.edu/6.828/2018/xv6/book-rev11.pdf](https://pdos.csail.mit.edu/6.828/2018/xv6/book-rev11.pdf)
* Repositori xv6-public: [https://github.com/mit-pdos/xv6-public](https://github.com/mit-pdos/xv6-public)
* Stack Overflow, GitHub Issues, diskusi praktikum

---

