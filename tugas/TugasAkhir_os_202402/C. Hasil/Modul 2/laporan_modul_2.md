# 📝 Laporan Tugas Akhir

Mata Kuliah: Sistem Operasi
Semester: Genap / Tahun Ajaran 2024–2025
Nama: Ade Miko
NIM: 240202827
Modul yang Dikerjakan: `Modul 2 – Penjadwalan CPU Lanjutan (Priority Scheduling Non-Preemptive)`

### 📌 Deskripsi Singkat Tugas
Modul 2 ini bertujuan untuk memodifikasi algoritma penjadwalan proses pada sistem operasi xv6-public. Algoritma penjadwalan diubah dari Round Robin standar menjadi Non-Preemptive Priority Scheduling. Implementasi melibatkan penambahan field prioritas pada struktur proses, pembuatan system call baru untuk mengatur prioritas, dan modifikasi scheduler kernel agar selalu menjalankan proses RUNNABLE dengan prioritas tertinggi (nilai numerik terkecil).

### 🛠️ Rincian Implementasi
mplementasi modul ini memerlukan perubahan pada beberapa file inti kernel xv6 serta penambahan program uji. Berikut adalah rincian langkah-langkah yang dilakukan:

**A. Penambahan priority ke struct proc**
Di file proc.h, field int priority; ditambahkan ke dalam struct proc. Prioritas didefinisikan dengan nilai 0 sebagai prioritas tertinggi dan 100 sebagai prioritas terendah.

```
// Dalam struct proc di proc.h
int priority; // nilai prioritas (0 = tertinggi, 100 = terendah)
```

**B. Inisialisasi priority saat Alokasi Proses**
Pada fungsi allocproc() di proc.c, setelah inisialisasi p->state = EMBRYO;, field priority diatur ke nilai default 60 untuk setiap proses baru yang dialokasikan.
```
// Dalam allocproc() di proc.c
p->priority = 60; // nilai default
```
C. Pembuatan System Call set_priority(int)
Penambahan Nomor System Call:
Di syscall.h, nomor SYS_set_priority (24) ditambahkan.
```
#define SYS_set_priority 24
```
Deklarasi di user.h:
Deklarasi fungsi int set_priority(int priority); ditambahkan di user.h agar system call ini dapat diakses dari user-level.
int set_priority(int priority);
Penambahan Entri di usys.S:
*Entri SYSCALL(set_priority) ditambahkan untuk menghasilkan stub yang diperlukan untuk panggilan system call.

SYSCALL(set_priority)
Registrasi System Call di syscall.c:

*Deklarasi fungsi extern int sys_set_priority(void); ditambahkan.
*Entri [SYS_set_priority] sys_set_priority, ditambahkan ke array syscalls[].

Implementasi di sysproc.c:
Fungsi sys_set_priority() diimplementasikan. Fungsi ini mengambil argumen prioritas dari user-space, memvalidasi nilainya (antara 0 dan 100), lalu mengatur prioritas proses yang sedang berjalan (myproc()->priority).

```

int sys_set_priority(void) {
  int prio;
  if (argint(0, &prio) < 0 || prio < 0 || prio > 100)
    return -1;

  myproc()->priority = prio;
  return 0;
}
```
**D. Modifikasi Fungsi scheduler() di proc.c**
Fungsi scheduler() dimodifikasi secara signifikan. Logika pencarian proses diubah untuk mengidentifikasi proses RUNNABLE dengan nilai priority terendah (prioritas tertinggi). Scheduler kini akan selalu memilih proses ini untuk dieksekusi, menciptakan perilaku penjadwalan non-preemptive berbasis prioritas.

```
void scheduler(void)
{
  struct proc *p;
  struct proc *highest = 0; // Pointer untuk proses dengan prioritas tertinggi

  for(;;){
    sti(); // Mengaktifkan interupsi

    acquire(&ptable.lock); // Mengunci tabel proses

    highest = 0; // Reset setiap iterasi

    // Mencari proses RUNNABLE dengan prioritas tertinggi (nilai terkecil)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue; // Lewati proses yang tidak RUNNABLE
      if(highest == 0 || p->priority < highest->priority)
        highest = p; // Menemukan proses dengan prioritas lebih tinggi
    }

    if(highest != 0){ // Jika ada proses RUNNABLE dengan prioritas tertinggi
      p = highest; // Pilih proses ini
      proc = p; // Atur proses saat ini di CPU
      switchuvm(p); // Beralih ke ruang alamat proses
      p->state = RUNNING; // Ubah status menjadi RUNNING
      swtch(&cpu->scheduler, proc->context); // Beralih konteks ke proses
      switchkvm(); // Kembali ke ruang alamat kernel
      proc = 0; // Reset pointer proses CPU
    }

    release(&ptable.lock); // Melepaskan kunci tabel proses
  }
}
Catatan: Implementasi ini menghasilkan scheduler yang non-preemptive berdasarkan prioritas numerik terkecil.
```
**E. Pembuatan Program Pengujian: ptest.c**
Sebuah program uji (ptest.c) dibuat untuk mendemonstrasikan perilaku penjadwalan. Program ini membuat dua proses anak yang masing-masing menjalankan fungsi busy() (simulasi kerja CPU) dan memiliki prioritas yang berbeda. Child 1 diberi prioritas rendah (90), sedangkan Child 2 diberi prioritas tinggi (10).
```

#include "types.h"
#include "stat.h"
#include "user.h"

void busy() {
  for (volatile int i = 0; i < 100000000; i++); // Loop untuk simulasi kerja
}

int main() {
  int pid1 = fork();
  if (pid1 == 0) {
    set_priority(90); // Prioritas rendah untuk Child 1
    busy();
    printf(1, "Child 1 selesai\n");
    exit();
  }

  int pid2 = fork();
  if (pid2 == 0) {
    set_priority(10); // Prioritas tinggi untuk Child 2
    busy();
    printf(1, "Child 2 selesai\n");
    exit();
  }

  wait(); wait(); // Menunggu kedua anak selesai
  printf(1, "Parent selesai\n");
  exit();
}
```
**F. Penambahan ptest ke Makefile**
Program _ptest ditambahkan ke daftar UPROGS di Makefile agar dikompilasi dan tersedia di filesystem xv6.

## Makefile
```
UPROGS=\
  _cat\
  _echo\
  ...
  _ptest\
```
**G. Jalankan dan Uji**
Setelah perubahan di atas, sistem dibangun kembali dan dijalankan di QEMU:
```
make clean
make qemu-nox
Di shell xv6, menjalankan ptest menghasilkan output sebagai berikut, menunjukkan bahwa proses dengan prioritas lebih tinggi (Child 2) selesai lebih dulu:
```
```

$ ptest
Child 2 selesai    // prioritas tinggi → selesai duluan
Child 1 selesai    // prioritas rendah
Parent selesai
```
### ✅ Validasi
Berdasarkan hasil pengujian, validasi fungsionalitas berjalan sesuai tujuan:

Prioritas Eksekusi: Proses dengan prioritas lebih tinggi (angka prioritas lebih kecil), yaitu Child 2 (prioritas 10), dieksekusi terlebih dahulu dan selesai sebelum Child 1 (prioritas 90), meskipun Child 1 mungkin sudah dalam kondisi RUNNABLE.

Perilaku Non-Preemptive: Proses yang sedang berjalan tidak dihentikan paksa oleh proses lain yang memiliki prioritas lebih tinggi. Proses akan terus berjalan hingga selesai atau memasuki state waiting sebelum scheduler memilih proses lain.

## ⚠️ Kendala yang Dihadapi

Prioritas tidak diatur dengan benar pada struct proc saat alokasi (allocproc()) atau saat system call set_priority() dipanggil. Pastikan nilai prioritas disalin dengan benar ke field p->priority dan validasi rentang prioritas (0-100) berfungsi.

---

### 📚 Referensi
MIT xv6 Book (x86)
xv6-public GitHub

### 📝 Kesimpulan
Melalui implementasi ini, algoritma penjadwalan Round Robin default xv6 berhasil dimodifikasi menjadi Priority Scheduling Non-Preemptive. Ini dicapai dengan:

Menambahkan satu field priority ke struktur proses kernel.

Mengimplementasikan satu system call baru set_priority() untuk pengaturan prioritas dari user-level.

Mengubah logika scheduler agar memilih proses RUNNABLE berdasarkan prioritas tertinggi.

Proyek ini memberikan pemahaman praktis tentang bagaimana manajemen proses dan penjadwalan CPU dapat diubah pada tingkat kernel, serta memahami trade-off antara keadilan (fairness) dan determinisme dalam algoritma penjadwalan.
