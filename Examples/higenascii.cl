// Generate all the printable ASCII characters.
// This is a high-level equivalent of genascii.s
// (c) 2017 Warren Toomey, GPL3

function main() {
  var x;
  var sixtyfour;
  var ninetysix;
  var tilde;

  sixtyfour= 64;
  ninetysix= 96;
  tilde= 126;

  while (1) {
    x= 32;
    while (1) {
      if (x == sixtyfour) {
	putchar('\n');
      }
      if (x == ninetysix) {
	putchar('\n');
      }
      if (x == tilde) {
	putchar('\n');
	break;
      }
      putchar(x);
      x++;
    }
  }
}
