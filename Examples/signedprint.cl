// Program to print out all signed 8-bit numbers
// in decimal. (c) 2017 Warren Toomey, GPL3.

// Print out the parameter in decimal
function printdec(x) {
  var onehundred;
  var zero;
  var tencount;
  var asciizero;
  var ten;

  onehundred=100;
  zero=0;
  tencount= 48;		// ASCII '0'
  asciizero= 48;	// ASCII '0'
  ten= 10;


  // Print out sign
  if (x < zero) {
    putchar('-');
    x= zero - x;
  }

  // Print out any hundred digit
  if (x >= onehundred) {
    putchar('1');
    x= x - onehundred;
  }

  // Count number of ten digits
  while (x >= ten) {
    tencount++;
    x= x - ten;
  }
  if (tencount > asciizero) {
    putchar(tencount);
  }

  // Convert remaining count to ASCII
  x= x + asciizero;
  putchar(x);
  putchar('\n');
}

function main() {
  var num;
  var lowest;
  lowest= -128;

  num= lowest;
  while (1) {
    printdec(num);
    num++;
    if (num == lowest) {
      break;
    }
  }
  exit;
}
