
#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(void) {
  char buf[8];
  int fd = open("/random", 0);
  if(fd < 0){
    printf(1, "cannot open /dev/random\n");
    exit();
  }
int n = read(fd, buf, sizeof(buf));

 if (n <= 0) {
    printf(1, "failed to read from /random\n");
    close(fd);
    exit();
  }

  printf(1, "Random bytes: ");
  for (int i = 0; i < n; i++)
    printf(1, "%d ", (unsigned char)buf[i]);
  printf(1, "\n");

  close(fd);
  exit();
}
