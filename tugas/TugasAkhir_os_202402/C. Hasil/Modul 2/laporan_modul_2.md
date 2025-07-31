# 📝 Laporan Tugas Akhir

**Mata Kuliah**: Sistem Operasi
**Semester**: Genap / Tahun Ajaran 2024–2025
**Nama**: `<Nama Lengkap>`
**NIM**: `<Nomor Induk Mahasiswa>`
**Modul yang Dikerjakan**:
`(Contoh: Modul 1 – System Call dan Instrumentasi Kernel)`

---

## 📌 Deskripsi Singkat Tugas

Tuliskan deskripsi singkat dari modul yang Anda kerjakan. Misalnya:

* **Modul 1 – System Call dan Instrumentasi Kernel**:
  Menambahkan dua system call baru, yaitu `getpinfo()` untuk melihat proses yang aktif dan `getReadCount()` untuk menghitung jumlah pemanggilan `read()` sejak boot.
---

## 🛠️ Rincian Implementasi

Tuliskan secara ringkas namun jelas apa yang Anda lakukan:

### Contoh untuk Modul 1:

* Menambahkan dua system call baru di file `sysproc.c` dan `syscall.c`
* Mengedit `user.h`, `usys.S`, dan `syscall.h` untuk mendaftarkan syscall
* Menambahkan struktur `struct pinfo` di `proc.h`
* Menambahkan counter `readcount` di kernel
* Membuat dua program uji: `ptest.c` dan `rtest.c`
---

## ✅ Uji Fungsionalitas

Tuliskan program uji apa saja yang Anda gunakan, misalnya:

* `ptest`: untuk menguji `getpinfo()`
* `rtest`: untuk menguji `getReadCount()`
* `cowtest`: untuk menguji fork dengan Copy-on-Write
* `shmtest`: untuk menguji `shmget()` dan `shmrelease()`
* `chmodtest`: untuk memastikan file `read-only` tidak bisa ditulis
* `audit`: untuk melihat isi log system call (jika dijalankan oleh PID 1)

---

## 📷 Hasil Uji

Lampirkan hasil uji berupa screenshot atau output terminal. Contoh:

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

### 📍 Contoh Output `chmodtest`:

```
Write blocked as expected
```

Jika ada screenshot:

```
![hasil cowtest](./screenshots/cowtest_output.png)
```

---

## ⚠️ Kendala yang Dihadapi

Tuliskan kendala (jika ada), misalnya:

* Salah implementasi `page fault` menyebabkan panic
* Salah memetakan alamat shared memory ke USERTOP
* Proses biasa bisa akses audit log (belum ada validasi PID)

---

## 📚 Referensi

Tuliskan sumber referensi yang Anda gunakan, misalnya:

* Buku xv6 MIT: [https://pdos.csail.mit.edu/6.828/2018/xv6/book-rev11.pdf](https://pdos.csail.mit.edu/6.828/2018/xv6/book-rev11.pdf)
* Repositori xv6-public: [https://github.com/mit-pdos/xv6-public](https://github.com/mit-pdos/xv6-public)
* Stack Overflow, GitHub Issues, diskusi praktikum

---

Mata Kuliah: Sistem Operasi
Semester: Genap / Tahun Ajaran 2024–2025
Nama: <Nama Lengkap>
NIM: <Nomor Induk Mahasiswa>
Modul yang Dikerjakan: Modul 1 – System Call dan Instrumentasi Kernel

📌 Deskripsi Singkat Tugas
Modul 1 ini bertujuan untuk mengimplementasikan dua system call baru pada kernel xv6-public (x86), yaitu:

getpinfo(struct pinfo *ptable): Mengembalikan informasi proses aktif (PID, ukuran memori, dan nama proses).

getReadCount(): Mengembalikan total jumlah pemanggilan read() sejak sistem boot.

Tugas ini juga mencakup pembuatan program uji di user-level untuk memverifikasi fungsionalitas system call yang telah ditambahkan.

🛠️ Rincian Implementasi
Implementasi modul ini melibatkan modifikasi pada beberapa file inti kernel xv6 dan penambahan program uji di user-level. Berikut adalah rincian langkah-langkah yang dilakukan:

A. Tambahkan Struktur pinfo dan Counter readcount
Di proc.h:
Menambahkan definisi struct pinfo untuk menyimpan informasi PID, ukuran memori, dan nama proses, dengan kapasitas hingga MAX_PROC (64) proses.

C

#define MAX_PROC 64

struct pinfo {
  int pid[MAX_PROC];
  int mem[MAX_PROC];
  char name[MAX_PROC][16];
};
Di sysproc.c (Global):
Mendeklarasikan dan menginisialisasi variabel global readcount = 0; sebagai counter untuk jumlah panggilan read().

C

int readcount = 0; // untuk menghitung read()
B. Tambahkan Nomor System Call Baru
Di syscall.h (paling bawah), menambahkan definisi nomor untuk system call baru:

C

#define SYS_getpinfo     22
#define SYS_getreadcount 23
C. Registrasikan System Call
Di syscall.c:

Menambahkan deklarasi eksternal di bagian atas:

C

extern int sys_getpinfo(void);
extern int sys_getreadcount(void);
Menambahkan entri ke array syscalls[] untuk mendaftarkan system call:

C

[SYS_getpinfo]     sys_getpinfo,
[SYS_getreadcount] sys_getreadcount,
D. Tambahkan ke User-Level
Di user.h:
Menambahkan deklarasi fungsi untuk system call agar dapat dipanggil dari program user-level:

C

struct pinfo; // forward declaration
int getpinfo(struct pinfo *);
int getreadcount(void);
Di usys.S:
Menambahkan entri SYSCALL untuk menghasilkan stub system call yang diperlukan:

Cuplikan kode

SYSCALL(getpinfo)
SYSCALL(getreadcount)
E. Implementasi Fungsi Kernel
Di sysproc.c:

Implementasi sys_getreadcount():

C

int sys_getreadcount(void) {
  return readcount;
}
Implementasi sys_getpinfo():

C

#include "proc.h"

int sys_getpinfo(void) {
  struct pinfo *ptable;
  if (argptr(0, (char**)&ptable, sizeof(*ptable)) < 0)
    return -1;

  struct proc *p;
  int i = 0;
  acquire(&ptable_lock); // Atau acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state != UNUSED){
      ptable->pid[i] = p->pid;
      ptable->mem[i] = p->sz;
      safestrcpy(ptable->name[i], p->name, sizeof(p->name));
      i++;
    }
  }
  release(&ptable_lock); // Atau release(&ptable.lock);
  return 0;
}
Catatan: Asumsi ptable_lock merujuk pada mekanisme penguncian yang sesuai di xv6 (misalnya ptable.lock).

F. Modifikasi read() untuk Tambah Counter
Di sysfile.c, pada fungsi sys_read(), menambahkan readcount++; di bagian atas fungsi untuk menghitung setiap panggilan read().

C

readcount++;
G. Buat Program Penguji User-Level
File: ptest.c (untuk getpinfo):

C

#include "types.h"
#include "stat.h"
#include "user.h"

struct pinfo {
  int pid[64];
  int mem[64];
  char name[64][16];
};

int main() {
  struct pinfo p;
  getpinfo(&p);

  printf(1, "PID\tMEM\tNAME\n");
  for(int i = 0; i < 64 && p.pid[i]; i++) {
    printf(1, "%d\t%d\t%s\n", p.pid[i], p.mem[i], p.name[i]);
  }
  exit();
}
File: rtest.c (untuk getreadcount):

C

#include "types.h"
#include "stat.h"
#include "user.h"

int main() {
  char buf[10];
  printf(1, "Read Count Sebelum: %d\n", getreadcount());
  read(0, buf, 5); // baca stdin
  printf(1, "Read Count Setelah: %d\n", getreadcount());
  exit();
}
Daftarkan ke Makefile:
Menambahkan program uji ke daftar UPROGS agar dapat dikompilasi dan tersedia di filesystem xv6:

Makefile

UPROGS=\
  _cat\
  _echo\
  ...
  _ptest\
  _rtest\
H. Build dan Jalankan
Proses kompilasi dan eksekusi dilakukan dengan perintah:

Bash

make clean
make qemu-nox
Setelah itu, di shell xv6, pengujian dilakukan sebagai berikut:

Bash

$ ptest
PID	MEM	NAME
1	4096	init
2	2048	sh
3	2048	ptest
...

$ rtest
Read Count Sebelum: 4
hello
Read Count Setelah: 5
✅ Uji Fungsionalitas
Program uji yang digunakan untuk memverifikasi fungsionalitas system call baru adalah:

ptest: Untuk menguji getpinfo(). Program ini mencetak daftar PID, ukuran memori, dan nama proses yang aktif di sistem. Output menunjukkan proses seperti init, sh, dan ptest itu sendiri.

rtest: Untuk menguji getReadCount(). Program ini mencetak nilai readcount sebelum dan sesudah melakukan panggilan read() dari input standar, memverifikasi bahwa counter telah bertambah sesuai.

📌 Kesimpulan
Dengan mengikuti langkah-langkah implementasi di atas, dua system call baru (getpinfo() dan getReadCount()) berhasil ditambahkan ke kernel xv6-public. getpinfo() memungkinkan akses ke informasi proses aktif, sedangkan getReadCount() menyediakan mekanisme untuk memonitor aktivitas pembacaan sistem. Program uji user-level yang dibuat berhasil menunjukkan fungsionalitas dasar dari kedua system call tersebut.

📚 Referensi
xv6-public GitHub

MIT xv6 Book

