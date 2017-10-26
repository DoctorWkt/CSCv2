// Generate all the printable ASCII characters.
// This is a high-level equivalent of genascii.s
// (c) 2017 Warren Toomey, GPL3

function main() {
  var x;

  while (1) {
    x= 32;
    while (1) {
      if (x == 64) {
	putchar('\n');
      }
      if (x == 96) {
	putchar('\n');
      }
      if (x == 126) {	// Is it a '~' ?
	putchar('\n');
	break;
      }
      putchar(x);
      x++;
    }
  }
}
