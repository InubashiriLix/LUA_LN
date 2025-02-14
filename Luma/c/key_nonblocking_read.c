#include <fcntl.h>
#include <stdio.h>
#include <termios.h>
#include <unistd.h>

#define UNUSED_PARAMTER(X) (void)(X)

char nonblocking_input(void) {
  char input_ch;
  struct termios newt, oldt;

  int tty = open("/dev/tty", O_RDONLY); // Open control terminal

  tcgetattr(tty, &oldt); // Get terminal properties
  newt = oldt;

  // Set characters are not buffered(~ICANON) and do not echo(~ECHO).
  // You can also choose only one of them.
  newt.c_lflag &= ~(ICANON | ECHO);
  tcsetattr(tty, TCSANOW, &newt);

  read(tty, &input_ch, 1);
  tcsetattr(tty, TCSANOW, &oldt); // Restore terminal properties

  return input_ch;
}
