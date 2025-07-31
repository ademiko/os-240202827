#ifndef _AUDIT_COMMON_H_
#define _AUDIT_COMMON_H_

#define MAX_AUDIT 128

struct audit_entry {
  int pid;
  int syscall_num;
  int tick;
};

#endif
