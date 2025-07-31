# 1 "usys.S"
# 1 "<built-in>"
# 1 "<command-line>"
# 31 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 32 "<command-line>" 2
# 1 "usys.S"
# 1 "syscall.h" 1
# 2 "usys.S" 2
# 1 "traps.h" 1
# 3 "usys.S" 2
# 11 "usys.S"
.globl fork; fork: movl $1, %eax; int $64; ret
.globl exit; exit: movl $2, %eax; int $64; ret
.globl wait; wait: movl $3, %eax; int $64; ret
.globl pipe; pipe: movl $4, %eax; int $64; ret
.globl read; read: movl $5, %eax; int $64; ret
.globl write; write: movl $16, %eax; int $64; ret
.globl close; close: movl $21, %eax; int $64; ret
.globl kill; kill: movl $6, %eax; int $64; ret
.globl exec; exec: movl $7, %eax; int $64; ret
.globl open; open: movl $15, %eax; int $64; ret
.globl mknod; mknod: movl $17, %eax; int $64; ret
.globl unlink; unlink: movl $18, %eax; int $64; ret
.globl fstat; fstat: movl $8, %eax; int $64; ret
.globl link; link: movl $19, %eax; int $64; ret
.globl mkdir; mkdir: movl $20, %eax; int $64; ret
.globl chdir; chdir: movl $9, %eax; int $64; ret
.globl dup; dup: movl $10, %eax; int $64; ret
.globl getpid; getpid: movl $11, %eax; int $64; ret
.globl sbrk; sbrk: movl $12, %eax; int $64; ret
.globl sleep; sleep: movl $13, %eax; int $64; ret
.globl uptime; uptime: movl $14, %eax; int $64; ret
.globl get_audit_log; get_audit_log: movl $22, %eax; int $64; ret
