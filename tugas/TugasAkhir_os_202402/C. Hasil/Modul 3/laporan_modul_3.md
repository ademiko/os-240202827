# 📝 Laporan Tugas Akhir

**Mata Kuliah**: Sistem Operasi
**Semester**: Genap / Tahun Ajaran 2024–2025
**Nama**: Ade Miko
**NIM**: 240202827
**Modul yang Dikerjakan**:
`(Modul 3 – Manajemen Memori Tingkat Lanjut)`

---

## 📌 Deskripsi Singkat Tugas

**Modul 3 – Manajemen Memori Tingkat Lanjut**
Tugas ini mencakup dua bagian utama dalam pengelolaan memori lanjutan di xv6:
*Implementasi Copy-on-Write Fork (CoW): Mekanisme fork() yang lebih efisien dengan membagikan halaman memori secara read-only dan hanya menyalin saat terjadi penulisan (write).
*Implementasi Shared Memory ala System V: Menyediakan dua system call baru (shmget dan shmrelease) agar antar proses dapat berbagi satu halaman memori dengan reference count.

## 🛠️ Rincian Implementasi

**A. Copy-on-Write Fork (CoW)**
*Menambahkan array ref_count[] di vm.c untuk tracking penggunaan halaman fisik.
*Menambahkan fungsi incref() dan decref() untuk manajemen reference count.
*Menambahkan flag PTE_COW di mmu.h.
*Mengganti copyuvm() menjadi cowuvm() di vm.c dan digunakan pada fork() di proc.c.
*Menangani page fault CoW di trap.c saat proses menulis ke halaman COW.
**B. Shared Memory ala System V**
*Menambahkan struktur shmtab[] di vm.c untuk menyimpan informasi shared memory (key, frame, refcount).
*Menambahkan system call shmget() dan shmrelease() di sysproc.c.
*Mendaftarkan syscall baru di syscall.c, syscall.h, usys.S, dan user.h.
---
## ✅ Uji Fungsionalitas

Program uji yang digunakan:
*cowtest: Menguji apakah fork() menggunakan mekanisme Copy-on-Write.
*shmtest: Menguji pembagian memori antar proses menggunakan shmget() dan shmrelease().
---

## 📷 Hasil Uji


### 📍 Contoh Output `cowtest`:

```
Child sees: Y
Parent sees: X
```

### 📍 Contoh Output `shmtest`:

```
Child reads: A
Parent reads: B
```
---

## ⚠️ Kendala yang Dihadapi

*Penanganan page fault untuk halaman yang bukan COW sempat menyebabkan kernel panic akibat validasi pte yang tidak tepat.
*Lupa menghapus flag PTE_COW saat menyalin halaman baru menyebabkan akses ilegal di proses child.
*Masalah mapping di shmget() karena alamat yang digunakan tidak konsisten menyebabkan crash.
*ref_count tidak decrement dengan benar saat proses selesai atau memanggil shmrelease().
---

## 📚 Referensi

Buku xv6 MIT: https://pdos.csail.mit.edu/6.828/2018/xv6/book-rev11.pdf

Repositori xv6-public: https://github.com/mit-pdos/xv6-public

---

